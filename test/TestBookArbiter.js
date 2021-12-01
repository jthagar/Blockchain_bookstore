const BookArbiter = artifacts.require("BookArbiter");
const Book = artifacts.require("Book");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */

  const accounts = web3.eth.accounts;
  contract("TestBookArbiter", accounts => {
    // test contract deployment successful
    it("contract deployment should assert true", () =>
      BookArbiter.deployed()
      .then( instance => {
        assert.isTrue(true);
    }));
    // try and check book creation
    it("create book in contract should assert true", () => {
      let arbiter; // holds contract instance
      let tome; // holds an escrow instance

      // return successfull deployment of contract
      return BookArbiter.deployed()
      .then( instance => { // with the returned BookArbiter instance
        arbiter = instance;
        // enter contract instance and create a book
        const temp = accounts[8]; // borrow a ganache account
        const hashA = "0F934A56E45343GH4"; // fake a hash for testing

        // test functions
        arbiter.addBook(temp, "Siddhartha", true, hashA, 0);
      })
      .then(() => { // after creating a book and using the updated instance
        return arbiter.getCount(); // return amount of books
      })
      .then(index => { // using the returned uint
        assert.isTrue(index >= 0); // check that it exists
        
        return arbiter.getBook(0); // get title of new book
      })
      .then(book => { // with the returned title string from the contract function
        return Book.at(book); // get address and contract from the creation
      })
      .then(instance => { // with the returned Book instance
        tome = instance; // save the instance
      })
      .then(() => { // after getting the book instance
        return tome.getTitle(); // get the title of the book
      })
      .then(title => { // using the returned string
        assert.equal( // check that it is equal to the input value
          title,
          "Siddhartha",
          "correct book was added to book list"
          ); // if true then the test was a success!
      });
    });
    // next, check and test a transaction if possible
    it("conduct transaction and create a book escrow contract", () => {
      let arbiter;
      let tome;
      let bookMark;

      return BookArbiter.deployed() // return the contract instance
      .then( instance => { // return
        arbiter = instance;
        // get size of current book list
        return arbiter.getCount();
      })
      .then(index => {
        //get last book in the list and its price
        bookMark = index - 1;

        // test a transaction and if it proceeds
        // create the escrow contract and initialize it

        return arbiter.getBook(0); // get title of new book
      })
      .then(book => { // with the returned title string from the contract function
        return Book.at(book); // get address and contract from the creation
      })
      .then(instance => { // with the returned Book instance
        tome = instance; // save the instance for an assert
      })
      .then(() => { // after getting the book instance
        // create transaction for the book
        return arbiter.createTxn(bookMark, accounts[1]); // OR 0 returns an INT
      })
      .then(() => {
        // get the current balance of the account after the transaction creation
        assert.isTrue(web3.utils.isAddress(tome.address), "Txn created succesfully");
      });
    });
    it("test funding of escrow account", () => {
      let arbiter;
      let tome;
      let addr;
      let bookPrice;
      let bookMark;

      return BookArbiter.deployed() // return the contract instance
      .then( instance => { // return
        arbiter = instance;
        // get size of current book list
        return arbiter.getCount();
      })
      .then(index => {
        //get last book in the list and its price
        bookMark = index - 1;
        return arbiter.getBook(index - 1);
      })
      .then(book => {
        return Book.at(book); //get book from previous test
      })
      .then(instance => {
        tome = instance; // contract from the creation
        addr = instance.address; // get address of contract

        return tome.getPrice(); //get book price
      })
      .then(price => {
        bookPrice = price;
        // test a transaction and if it proceeds
        // get current balance of a ganache account
        balance = web3.eth.getBalance(accounts[1]);

        // test funding of the transaction
        arbiter.fundTxn(bookMark, { from: accounts[1], value: ((bookPrice | 0)) }); // OR 0 returns an INT
      })
      .then(() => {
        // get the current balance of the account after the transaction
        assert.isTrue(web3.eth.getBalance(addr) >= bookPrice, "Txn funded succesfully");
      });
    });
    it("test funding of escrow account", () => {
      let arbiter;
      let tome;
      let bookSeller;
      let bookMark;

      return BookArbiter.deployed() // return the contract instance
      .then( instance => { // return
        arbiter = instance;
        // get size of current book list
        return arbiter.getCount();
      })
      .then(index => {
        //get last book in the list and its price
        bookMark = index - 1;
        return arbiter.getBook(index - 1);
      })
      .then(book => {
        return Book.at(book); //get book from previous test
      })
      .then(book => {
        tome = book; // get address and contract from the creation
        return tome.getSeller(); //get book price
      })
      .then(seller => {
        bookSeller = seller;
        // test a transaction and if it proceeds
        // get current balance of a ganache account
        balance = web3.eth.getBalance(seller);

        // create the escrow contract and initialize it
        return arbiter.validateTxn(bookMark); // OR 0 returns an INT
      })
      .then(() => {
        return tome.getSeller(); //get new owner
      })
      .then(newSeller => {
        // get the current balance of the account after the transaction
        assert.isFalse(newSeller === bookSeller, "ownership transferred");
        assert.isTrue(web3.eth.getBalance(newSeller) >= balance, "correct balance transferred");
      });
    });
  });

