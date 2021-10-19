// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract bookstore {
  //Model a Book
  struct Book {
    uint id; //book ID
    string title; //book Title
    bool physical; // 0 = no, 1 = yes
    uint hashValue; //PDF hash if needed
  }

  //Model multiple books in a purchase
  struct Books {
    Book[] cart;
    uint size;
  }

  // there are plans fro User and Transaction
  // currently, they may not be necessary until later

  //Create map to store books added to contract
  //stores wallet address => Book added
  mapping(address => Book) private bookList;

  // IDK what to do with this
  constructor() public {
  }

  // book events

  //event for user selling a book
  event bookAdd ();
  // event for successful user purchase
  event bookBuy ();

  // function for user to add a book to contract
  // users ID and the book title are given
  function addBook (string _bookTitle) public {
    //add book to book list
  }


  // function for a user to purchase a book
  // book ID is necessary, but will be implemented in frontend
  function purchase (uint _bookID) public {
    // require book exists
    // require that user isn't the seller
    // record purchase
    // update book list
  }
}
