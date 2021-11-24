const BookArbiter = artifacts.require("BookArbiter");
const Escrow = artifacts.require("Escrow");

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
      let escrow; // holds an escrow instance
      let balance; // balance of an account for testing

      // return successfull deployment of contract
      return BookArbiter.deployed()
      .then( instance => { // with the returned BookArbiter instance
        arbiter = instance;
        // enter contract instance and create a book
        const temp = accounts[8]; // borrow a ganache account
        const hashA = "0F934A56E45343GH4"; // fake a hash for testing

        // test functions
        return arbiter.addBook(temp, "Siddhartha", true, hashA, 20);
      })
      .then(() => { // after creating a book and using the updated instance
        return arbiter.getCount(); // return amount of books
      })
      .then(index => { // using the returned uint
        assert.isTrue(index >= 0); // check that it exists
        return arbiter.getTitle(index - 1); // get title of new book
      })
      .then(title => { // with the returned title string from the contract function
        assert.equal( // check that it is equal to the input value
          title,
          "Siddhartha",
          "correct book was added to book list"
          ); // if true then the test was a success!
      });
    });
    // next, check and test a transaction if possible
    it("conduct transaction and transfer book ownership", () => {
      let arbiter;
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
        return arbiter.getPrice(index - 1);
      })
      .then(price => {
        bookPrice = price;
        // test a transaction and if it proceeds
      // get current balance of a ganache account
        balance = web3.eth.getBalance(accounts[1]);

        // test funding of the transaction
        // convert book price to Gwei
        const adjust = Math.ceil(web3.utils.toWei(bookPrice) * 1000000000);
        // create the escrow contract and initialize it
        return arbiter.createTxn(bookMark,{ from: accounts[1], value: ((adjust | 0)) }); // OR 0 returns an INT
      })
      /*
      .then( index => { //index in list of escrow txns

        return Escrow.at(index) // check contract deployment
      })
      .then( instance => { // return the contract instance
        escrow = instance;
        // test if the escrow creation is successful
        assert.isTrue(web3.eth.getBalance(escrow) >= 0);

      })
      */
      .then(() => {
        // check that balance has changed in the buyer's account
        assert.isTrue(web3.getBalance(accounts[1]) < balance);
        arbiter.getSeller(bookMark);
      })
      .then(_seller => { // check that ownership has transferred in the book
        assert.equal(_seller, account[1], "check that ownership is transferred");
      })
    });
  });

