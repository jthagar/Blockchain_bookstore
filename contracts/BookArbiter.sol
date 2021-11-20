// SPDX-License-Identifier: MIT
pragma solidity >=0.8.3 <0.9.0;
import "./Escrow.sol";
// import "./Book.sol";

// contract to handle an entire transaction and to execute the escrow
contract BookArbiter{
    
    //Model a Book
    struct Book{
        address payable seller; //seller wallet id
        string title; //book Title
        bool physical; // 0 = no, 1 = yes
        string hash;
        uint price; // price of the book
    }

    ///////////////////////
    // Set-Get Fxns for book
        // Set seller variable
    function setSeller(uint index, address payable _seller) external{
        books[index].seller = _seller;
    }

    function getSeller(uint index) external view returns(address payable){
        return books[index].seller;
    }

    // Set title variable
    function setTitle(uint index, string memory _title) external{
        books[index].title = _title;
    }

    // Set Hash variable
    function setHash(uint index, string memory _hash) external{
        books[index].hash = _hash;
    }


    // Get physical variable
    function getHash(uint index) external view returns(string memory){
        return books[index].hash;
    }

    // Set physical variable
    function setPhysical(uint index, bool _phys) external{
        books[index].physical = _phys;
    }

    // Set price variables
    function setPrice(uint index, uint _price) external{
        books[index].price = _price;
    }

    function getPrice(uint index) external view returns(uint){
        return books[index].price;
    }

    ///////////////////////

    // two one-to-one maps to hold books and their prices
    mapping(uint => Book) private books; // mapping of book id to book

    uint[] private emptyIds; // array of book prices for easy iteration

    uint private bookCount = 0; // number of books in the contract

    constructor () public {
        // make stuff happen
        //bookCount = 0;
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
        Book memory newBook;
        
        // use set fxns to fill out struct object
        newBook.seller = _seller;
        newBook.title = _bookTitle;
        newBook.physical = ePfd;
        newBook.hash = _hash;
        newBook.price = _price;

        // newBook.uploadBook(_hash, 0); // get fil from given hash, will need to be integrated with js to upload to IPFS

        // check existing mapping to find any empty indexes for use before pushing
        if (checkEmptyIds()) {
            uint temp = getEmptyId(); // get empty ID index and remove it from array
            // Use index to set place for a new book
            books[temp] = newBook;
        } else { // if no new spots, then add fresh book to the mappings
            books[bookCount] = newBook;
            bookCount ++; //increment amount of books in the contract
        }
    }

    // returns a book struct object
    function getBook(uint _id) public view returns (Book memory) {
        return books[_id];
    }

    // returns amount of books in list
    function getAmount() external view returns (uint) {
        return bookCount;
    }

    function removeBook(uint _id) public {
        delete books[_id]; // zero out index in mapping
        emptyIds.push(_id);  // add index to emptyIds array
    }

    // check age of a contract, use to push command to and from the Escrow contract of a purchase

    function Transaction(uint _id) public payable {
        require(msg.sender != books[_id].seller); // make sure that the seller is the one who is sending the funds

        // create escrow contract, books[_id].price is the price of the book for the transaction
        Escrow escrow; // create escrow contract

        // initialize escrow contract
        escrow.setSeller(books[_id].seller);
        escrow.setBuyer(payable(msg.sender));
        escrow.setArbiter(payable(address(this)));
        escrow.setPrice(books[_id].price);

        // send funds to escrow contract and begin execution
        // escrow.init();
        escrow.fund();
        escrow.payoutToSeller(); // pay item to seller
        books[_id].seller = payable(msg.sender); // change ownership of book item

        //remove book from item list
        removeBook(_id);
    }

}

// It may be possible to use Django and cut out book arbiter
// create a basice website that would handle transactions
// and carry out contracts with their ID's
// it would technically be centralized though, so unpreferred