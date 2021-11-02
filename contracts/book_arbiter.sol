// SPDX-License-Identifier: MIT
pragma solidity >=0.8.3 <0.9.0;
import "./Escrow.sol";
import "./Book.sol";

// contract to handle an entire transaction and to execute the escrow
contract BookArbiter is Book, Escrow, IPFS{
    // two one-to-one maps to hold books and their prices
    mapping(uint => Book) private books; // mapping of book id to book

    uint[] private emptyIds; // array of book prices for easy iteration

    uint private bookCount; // number of books in the contract

    constructor () public {
        // make stuff happen
        bookCount = 0;
    }

    function checkEmptyIds() private pure returns (bool) {
        return emptyIds.length > 0;
    }

    function getEmptyId() private pure returns (uint) {
        uint temp = emptyIds[emptyIds.length - 1];
        emptyIds.pop();
        return temp;
    }

    function addBook(address payable _seller, string memory _bookTitle, bool ePfd, string memory _hash, uint _price) public {
        // construct and initialize new book
        Book memory book;
        book.seller = _seller;
        book.title = _bookTitle;
        book.physical = ePfd;
        book.hash = _hash;
        book.price = _price;

        uploadBook(_hash, 0); // get fil from given hash, will need to be integrated with js to upload to IPFS

        // check existing mapping to find any empty indexes for use before pushing
        if (checkEmptyIds()) {
            uint temp = getEmptyId(); // get empty ID index and remove it from array
            // Use index to set place for a new book
            books[temp] = book;
        } else { // if no new spots, then add fresh book to the mappings
            books[bookCount] = book;
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
        require(msg.sender == books[_id].seller); // make sure that the seller is the one who is sending the funds

        // create escrow contract, books[_id].price is the price of the book for the transaction
        Escrow escrow = Escrow(books[_id].seller, msg.sender, address(this).balance, books[_id].price); // create escrow contract
        escrow.fund(); // fund contract for item amount
        escrow.payoutToSeller(); // pay item to seller
        books[_id].seller = msg.sender; // change ownership of book item

        //remove book from item list
        removeBook(_id);
    }

}

// It may be possible to use Django and cut out book arbiter
// create a basice website that would handle transactions
// and carry out contracts with their ID's
// it would technically be centralized though, so unpreferred