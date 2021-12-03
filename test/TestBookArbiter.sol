// SPDX-License-Identifier: MIT
pragma solidity >=0.8.3 <0.9.0;

//assertions check for things like equality, inequality or emptiness
// in order to return a pass/fail for the test
import "truffle/Assert.sol";
// helps deploy a fresh instance of the contract to the blockchain for testing
import "truffle/DeployedAddresses.sol";
// the smart contract we wish to test
import "../contracts/BookArbiter.sol";
import "../contracts/Book.sol";

contract TestBookArbiter {
    
    // the smart contract we wish to test
    BookArbiter store;
    Book tome; // get book contracts from address list
    uint index;

    function beforeAll() public {
        // initialize for testing
        store = BookArbiter(DeployedAddresses.BookArbiter());
    }
    address payable temp = payable(address(this));

    // fake hash strings for testing
    string hashA = "0F934A56E45343GH4";
    string hashB = "06B5FD34EA482B31A";
    string hashC = "04B5FA56E4582B313";
    string hashD = "0B934A34B5FA56E16";
    
    /////////////////////0xC6bae7b84BE3916F298dB197fc7011a78fc6065C
    // Ropsten address for testing: 0x2ad617ac13A61B251f340Fc5fBa9809D131ddf69
    ///////////////////////
    // create book test phrase: 0x2ad617ac13A61B251f340Fc5fBa9809D131ddf69, "Siddhartha", true,0F934A56E45343GH4 , 0

    /// Test common functions of Book Arbiter contract
    
    function testAddBook() public {
        store.addBook(temp, "little red riding hood", true, hashA, 2); // add book to test contract
        index = store.getCount() - 1; // get current index if contract is still deployed
        tome = Book(store.getBook(index)); // get contract from address list

        Assert.equal(tome.getHash(), hashA, "hash should be equal and book is created"); // assert that the added book hash equals original hash
    }
    
    function testHashTransfer() public {
        tome.setHash(hashB); // change hash to new value
        Assert.equal(tome.getHash(), hashB, "the hash should be valid after transfer to new value"); // assert that the added book hash equals original hash
    }
    
    // use preset address for local testnet
    // ganache address used above: 0x851763A06A4f53f2f900C274208688Ed7112ef71
    function testTransferOwner() public {
        address payable reset = payable(msg.sender);
        
        tome.setSeller(reset);
        // assert and check that ownership has changed hands
        Assert.equal(tome.getSeller(), reset, "the new address should be the new owner of the book"); // assert that the seller has transferred
    
    }

    function testMultipleBooks() public { // test that ultiple books can be added
        store.addBook(temp, "Siddhartha", true, hashA, 10); // add book to test contract
        store.addBook(temp, "Idiocracy", false, hashB, 15); // add book to test contract
        store.addBook(temp, "Just Friends", true, hashD, 12); // add book to test contract
        uint count = store.getCount();

        // test that the books were successfully added to the mapping
        tome = Book(store.getBook(count - 3)); // get contract for first book
        Assert.equal(tome.getHash(), hashA, "second book added correctly");

        tome = Book(store.getBook(count - 2)); // get contract for second book
        Assert.equal(tome.getHash(), hashB, "third book added correctly");

        tome = Book(store.getBook(count - 1)); // get contract for third book
        Assert.equal(tome.getHash(), hashD, "fourth book added correctly");
    }

    function testRemoveBook() public { // test functional book removal
        store.removeBook(0);
        //tome = Book(store.getBook(0)); // get contract for third book
        // tests that two of the values are zeroed out, due to removal
        address addr = store.getBook(0);
        Assert.isZero(addr, "book removed correctly");
    }

    function testBook() public { // test that books will be added to empty indexes
        store.addBook(temp, "Atisha's Lamp", true, hashC, 0); // add book to test contract

        tome = Book(store.getBook(0)); // get contract for third book
        Assert.equal(tome.getHash(), hashC, "book added correctly");
    }
    
    /////////////////////////
    ///////////////////////
    ////////////////////////
    // Test Common functions of Escrow fxns
    event VariablesCreated(uint _timestamp);
    event TransactionCompleted(uint _timestamp);

    // TEST IN JAVASCRIPT
    /*


    // test escrow and transaction procedure
    // will use the last added book from earlier so that the price is 0
    // will need to be partly done in javscript to test actual eth transfer
    function testEscrowCreate() public {
        // temporary variables to test escrow
        uint count = store.getCount();
        tome = Book(store.getBook(count - 1)); // get contract for third book

        // ganache account
        address buyer = 0xC6bae7b84BE3916F298dB197fc7011a78fc6065C;
        emit VariablesCreated(block.timestamp);

        // run escrow transaction
        store.createTxn(count - 1, buyer);
        emit TransactionCompleted(block.timestamp);

        // Assert.isTrue((uint(buyer.balance) + priceGwei) <= (balance), "correct balance transferred");
    }

    function testTransactionFunded() public {
        uint count = store.getCount();
        tome = Book(store.getBook(count - 1)); // get contract for third book

        // ganache account
        address buyer = 0xC6bae7b84BE3916F298dB197fc7011a78fc6065C;
        address seller = tome.getSeller();
        uint priceGwei = tome.getPrice();
        uint balance = buyer.balance;

        // run escrow transaction
        store.fundTxn(count - 1);
        Assert.isTrue(uint(buyer.balance) <= balance, "correct balance transferred");
    }

    function testTransactionCompleted() public {
        uint count = store.getCount();
        tome = Book(store.getBook(count - 1)); // get contract for third book

        address payable seller = payable(tome.getSeller());
        uint balance = seller.balance;

        store.validateTxn(count - 1);

        Assert.isTrue(tome.getSeller() == 0xC6bae7b84BE3916F298dB197fc7011a78fc6065C, "ownership transferred");
        Assert.isTrue(uint(seller.balance) >= balance, "correct balance transferred");


    }
    
    
    
    ////////////////////////
    /////////////////////

    */
    
}