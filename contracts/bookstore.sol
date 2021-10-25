// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract bookstore {
  //Model a Book
  struct Book {
    address seller; //seller wallet id
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

  // there are plans for User and Transaction
  // currently, they may not be necessary until later

  //Create map to store books added to contract
  //stores wallet address => Book added
  mapping(uint => Book) private bookList;
  uint public bookSize;
  
  // create an array to mark which book indexes are empty/null
  // so that they can be re-filled later
  uint[] emptyIndexes;

  // IDK what to do with this
  // constructor() public {
  // }

  // book events

  //event for user selling a book
  event bookAdd ();
  // event for successful user purchase
  event bookBuy ();
  
  // function for user to add a book to contract
  // users ID and the book title are given
  function addBook(string memory _bookTitle, bool _phys, uint _hash) public {
      
    uint i = 0;
    // check for previously empty ID's for re-use
    if (emptyIndexes.length != 0) { // if there are entries
        for (i; i < emptyIndexes.length; i++) { // check entries
            if (emptyIndexes[i] != 0) { // if there is a valid entry
            
                // use entry and place new book into bookList under said entry
                bookList[emptyIndexes[i]] = (Book(msg.sender, bookSize, _bookTitle, _phys, _hash));
                emptyIndexes[i] = 0;
                return; //  exit if success
            }
        }   
    }
    
    // this end is only reached if there are no valid entries in emptyIndexes
    //add book to book list
    bookList[bookSize] = (Book(msg.sender, bookSize, _bookTitle, _phys, _hash));
    bookSize ++; //increment uint to handle new entry size
    
  }


  // function for a user to purchase a book
  // book ID is necessary, but will be implemented in frontend
  function purchase(uint _bookID) public {
    // require book exists
    require(_bookID >= 0 && _bookID < bookSize);
    
    // require that user isn't the seller
    require(msg.sender != bookList[_bookID].seller);
    
    // process transaction
    // TRANSACTION CODE HERE //
    
    
    // update book list
    uint i = 0;
    if(bookList[_bookID].physical == true) {
        delete bookList[_bookID]; // remove book from repository
        
        // if-stack to handle storing ID index for a new book in the future
        if (emptyIndexes.length != 0) { // if there are entries
            for (i; i < emptyIndexes.length; i++) { // check entries
                if (emptyIndexes[i] == 0) { // if there is a valid entry
                    emptyIndexes[i] = _bookID;
                    return; // exit if success
                }
            }   
        }
        // reach this end only if all indexes already have entries
        emptyIndexes.push(_bookID); //add new empty index to list of indexes
    }
  }
  
  //need functions for escrow, or an entire separate contract
}