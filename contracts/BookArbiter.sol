// SPDX-License-Identifier: MIT
pragma solidity >=0.8.3 <0.9.0;
import "./Book.sol";

// contract to handle an entire transaction and to execute the escrow
contract BookArbiter{

    // allow contract to use ETH
    fallback() external payable {
        // do nothing
        emit TransactionCreated(block.timestamp);
    }

    // allow contract to hold ETH
    receive() external payable {
        // do nothing
        emit TransactionFunded(block.timestamp);
    }

    // event
    event TransactionCreated(uint _timestamp);
    event TransactionFunded(uint _amount);
    event NewOwnership(uint _timestamp);
    event ContractCreated(address newAddress);
    
    /*
    //Model a Book
    struct Book{
        address payable seller; //seller wallet id
        string title; //book Title
        bool physical; // 0 = no, 1 = yes
        string hash;
        uint price; // price of the book
    }
    */

    ////////////////////////////
    //////////////////////////
    // two one-to-one maps to hold books and their prices
    mapping(uint => address payable) private books; // mapping of book id to book

    uint[] private emptyIds; // array of book prices for easy iteration

    uint private bookCount; // number of books in the contract

    constructor() public {
        // make stuff happen
        bookCount = 0;
    }

    function checkEmptyIds() private view returns (bool) {
        return emptyIds.length > 0;
    }

    function getEmptyId() private returns (uint) {
        uint temp = emptyIds[emptyIds.length - 1];
        emptyIds.pop();
        return temp;
    }

    function addBook(address payable _seller, string memory _bookTitle, bool ePfd, string memory _hash, uint _price) public {
        // construct and initialize new book
        Book newBook = new Book(_seller, _bookTitle, ePfd, _hash, _price);

        // check existing mapping to find any empty indexes for use before pushing
        if (checkEmptyIds()) {
            uint temp = getEmptyId(); // get empty ID index and remove it from array
            // Use index to set place for a new book
            books[temp] = payable(address(newBook));
        } else { // if no new spots, then add fresh book to the mappings
            books[bookCount] = payable(address(newBook));
            bookCount ++; //increment amount of books in the contract
        }
    }

    // returns a book struct object
    function getBook(uint _id) public view returns (address payable) {
        return books[_id];
    }

    // returns amount of books in list
    function getCount() external view returns (uint) {
        return bookCount;
    }

    function removeBook(uint _id) public {
        delete books[_id]; // zero out index in mapping
        emptyIds.push(_id);  // add index to emptyIds array
    }

    ///// TRANSACTION FXNS /////
    ////////////////////////////
    function createTxn(uint _id, address _buyer) public payable returns (bool){
        // create escrow contract
        Book tome = Book(books[_id]); // get contract from address list
        emit TransactionCreated(block.timestamp);
        emit ContractCreated(address(tome));

        // set price in Gwei and check requirements
        require(msg.sender != tome.getSeller()); // make sure that the seller is the one who is sending the funds
        // initialize txn contract extras
        tome.setBuyer(payable(_buyer));
        tome.setArbiter(payable(address(this)));

         return true;
    }

    function fundTxn(uint _id) external payable {
        Book tome = Book(books[_id]); // get contract from address list
        require(msg.value == tome.getPrice());
        tome.fund();
        emit TransactionFunded(tome.getPrice());
    }

    function validateTxn(uint _id) external payable {
        Book tome = Book(books[_id]); // get contract from
        tome.validate();
        tome.setSeller(payable(msg.sender)); // change ownership of book item
        emit NewOwnership(block.timestamp);
    }
    ///////////////////////////////
    //////////////////////////////

}

// It may be possible to use Django and cut out book arbiter
// create a basice website that would handle transactions
// and carry out contracts with their ID's
// it would technically be centralized though, so unpreferred