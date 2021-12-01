// SPDX-License-Identifier: MIT
pragma solidity >=0.8.3 <0.9.0;
import "./Escrow.sol";

//IPFS contract to hold any pdf's and ebooks
// need to create javascript to interface with the IPFS daemon 
contract Book is Escrow{ // Books are all contracts, whether or not they're completed yet
    //Model a Book
    struct book{
        string title; //book Title
        bool physical; // 0 = no, 1 = yes
        string hash;
    }

    //state variables/ contracts
    book item;
    //variables and functions to set an amount an item is for sale

    //rewrite addBook as constructor for a single book
    constructor(address payable _seller, string memory _bookTitle, bool ePfd, string memory _hash, uint _price) public {
        seller = _seller;
        item.title = _bookTitle;
        item.physical = ePfd;
        item.hash = _hash;
        amountInEth = _price * (1 ether / 1000);
    }

    //Set-Get fxns

    // Set title variable
    function setTitle(string memory _title) external{
        item.title = _title;
    }

    // Set title variable
    function getTitle() external view returns(string memory){
        return item.title;
    }

    // Set Hash variable
    function setHash(string memory _hash) external{
        item.hash = _hash;
    }

    // Get physical variable
    function getHash() external view returns(string memory){
        return item.hash;
    }

    // Set physical variable
    function setPhysical(bool _phys) external{
        item.physical = _phys;
    }

    // Set physical variable
    function getPhysical() external view returns (bool){
        return item.physical;
    }

    //the book contract could handle the IPFS transfers and security if needed


    // check for how to do security
}