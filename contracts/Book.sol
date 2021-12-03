// SPDX-License-Identifier: MIT
pragma solidity >=0.8.3 <0.9.0;
import "./Escrow.sol";

// need to create javascript to interface with the IPFS daemon 
contract Book is Escrow{ // Books are all contracts, whether or not they're completed yet
    //Model a Book
    string private title; //book Title
    bool private physical; // 0 = no, 1 = yes
    string private hash;

    //variables and functions to set an amount an item is for sale

    //rewrite addBook as constructor for a single book
    constructor(address payable _arbiter, address payable _seller, string memory _bookTitle, bool ePfd, string memory _hash, uint _price) public {
        arbiter = _arbiter;
        seller = _seller;
        title = _bookTitle;
        physical = ePfd;
        hash = _hash; // if the book is a pdf or ebook
        amountInEth = _price * (1 ether / 100); // EXPENSIVE, but necessary for quick ganache testing
    }

    //Set-Get fxns

    // Set title variable
    function setTitle(string memory _title) external{
        require (msg.sender == arbiter || msg.sender == seller);
        title = _title;
    }

    // Set title variable
    function getTitle() external view returns(string memory){
        return title;
    }

    // Set Hash variable
    function setHash(string memory _hash) external{
        require (msg.sender == arbiter || msg.sender == seller);
        hash = _hash;
    }

    // Get physical variable
    function getHash() external view returns(string memory){
        return hash;
    }

    // Set physical variable
    function setPhysical(bool _phys) external{
        require (msg.sender == arbiter || msg.sender == seller);
        physical = _phys;
    }

    // Set physical variable
    function getPhysical() external view returns (bool){
        return physical;
    }

}