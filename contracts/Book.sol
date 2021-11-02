// SPDX-License-Identifier: MIT
pragma solidity >=0.8.3 <0.9.0;

//IPFS contract to hold any pdf's and ebooks
// need to create javascript to interface with the IPFS daemon 
contract IPFS {
    // struct to hold hash location and size of the file
    struct File {
        string fileHash;
        uint256 fileSize;
    }

    File file;

    // creates new file to interface with IPFS from uploader
    function uploadFile(string memory fileHash, uint256 fileSize) public {
        file.fileHash = fileHash;
        file.fileSize = fileSize;
    }

    // gets file struct
    // function getFile(string memory fileHash) public view returns (File) {
    //     return file;
    // }

    // gets file size variable from struct
    function getFileSize() public view returns (uint256) {
        return file.fileSize;
    }

    // gets file hash variable from struct
    function getFileHash() public view returns (string memory) {
        return file.fileHash;
    }
}

contract Book is IPFS{
    //Model a Book
    struct Book{
        address payable seller; //seller wallet id
        string title; //book Title
        bool physical; // 0 = no, 1 = yes
        string hash;
        uint price; // price of the book
    }

    //state variables/ contracts
    Book item;
    //variables and functions to set an amount an item is for sale

    //rewrite addBook as constructor for a single book
    //constructor(address payable _seller, string memory _bookTitle, bool ePfd, uint _price) public {
    //    item.seller = _seller;
    //    item.title = _bookTitle;
    //    item.physical = ePfd;
    //    item.price = _price;
    //}

    // correspond with external script to upload the book and file
    // use with an IPFS node
    function uploadBook(string memory _hash, uint _size) public {
        uploadFile(_hash, _size);
        item.hash = _hash;
    }

    function getFile() private view returns (string memory) {
        return item.hash;
    }

    //the book contract could handle the IPFS transfers and security if needed


    // check for how to do security
}