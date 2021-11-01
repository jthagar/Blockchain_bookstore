// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

//IPFS contract to hold any pdf's and ebooks
// need to create javascript to interface with the IPFS daemon 
contract IPFS {
    // struct to hold hash location and size of the file
    struct File {
        string fileHash;
        uint256 fileSize;
    }

    // creates new file to interface with IPFS from uploader
    function uploadFile(string fileHash, uint256 fileSize) public {
        File newFile;
    }

    // gets file struct
    function getFile(string fileHash) public view returns (File) {
        File file;
    }

    // gets file size variable from struct
    function getFileSize(string fileHash) public view returns (uint256) {
        uint256 fileSize;
    }

    // gets file hash variable from struct
    function getFileHash(uint256 fileSize) public view returns (string) {
        string fileHash;
    }


}

// the base outline for the escrow contract was taken from github
// need to edit and change it to fit the needs of the project
contract Escrow {    
    //state variables
    address payable buyer;
    address payable seller;
    address arbiter;
    uint public amountInWei;
    
    
    //solidity events
    event FundingReceived(uint _timestamp);
    event SellerPaid(uint _timestamp);
    event BuyerRefunded(uint _timestamp);
    
    
    //constructor function; used to set initial state of contract
    constructor(address payable _seller, address payable _buyer, address _arbiter, uint _amountInWei) public {
        seller = _seller;
        buyer = _buyer;
        arbiter = _arbiter;
        amountInWei = _amountInWei;
    }
    
    //function for buyer to fund; payable keyword must be used
    function fund() public payable {
        require(msg.sender == buyer &&  //conditional checks to make sure only the buyer's address
                msg.value == amountInWei//can send the correcr amount to the contract
                );
        emit FundingReceived(now); //emit FundingReceived() event
    }
    
    //function for buyer to payout seller
    function payoutToSeller() public {
        require(msg.sender == buyer || msg.sender == arbiter); //only buyer or arbiter can execute this function
        seller.transfer(address(this).balance); //using the solidity's built in transfer function, the funds are sent to the seller
        emit SellerPaid(now); //emit SellerPaid() event
    }
    
    //function for seller to refund the buyer
    function refundBuyer() public {
        require(msg.sender == seller || msg.sender == arbiter);//only buyer or arbiter can execute this function
        buyer.transfer(address(this).balance); //using the solidity's built in transfer function, the funds are returned to the buyer
        emit BuyerRefunded(now);//emit BuyerRefunded() event
    }
}

contract Book {
    //Model a Book
    struct Book {
        address payable seller; //seller wallet id
        uint id; //book ID
        string title; //book Title
        bool physical; // 0 = no, 1 = yes
        uint hashValue; //PDF hash if needed
    }

    //state variables
    Book item;
    IPFS ipfs;

    //variables and functions to set an amount an item is for sale

    //rewrite addBook as constructor for a single book
    constructor(address payable _seller, uint _bookId, string _bookTitle, bool ePfd, uint hashVal) public {
        item.seller = _seller;
        item.id = _bookId;
        item.title = _bookTitle;
        item.physical = ePfd;
        item.hashValue = hashVal;
    }

    //rewrite purchase to use Escrow and complete the contract
    function purchase(uint _amountInWei) public payable {
        require(msg.sender != item.seller);
        Escrow escrow( item.seller, msg.sender, address(this).balance, _amountInWei);
        // need to create a way to set amount the item is for sale
        escrow.fund();
        escrow.payoutToSeller();
    }

    //the book contract could handle the IPFS transfers and security if needed


    // check for how to do security

}

// contract to handle an entire transaction and to execute the escrow
contract BookArbiter {

}

// It may be possible to use Django and cut out book arbiter
// create a basice website that would handle transactions
// and carry out contracts with their ID's
// it would technically be centralized though, so unpreferred