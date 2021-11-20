// SPDX-License-Identifier: MIT
pragma solidity >=0.8.3 <0.9.0;

//assertions check for things like equality, inequality or emptiness
// in order to return a pass/fail for the test
import "truffle/Assert.sol";

// helps deploy a fresh instance of the contract to the blockchain for testing
import "truffle/DeployedAddresses.sol";

// the smart contract we wish to test
import "../contracts/BookArbiter.sol";

contract storeTest {
    
    // initialize a contract for testing
    BookArbiter store;
    uint priceCheck = 0;
    string hashCheck;
    
    // temp variables for creation and instantiation
    address payable temp = payable(0x851763A06A4f53f2f900C274208688Ed7112ef71);
    string title = "little red riding hood";
    bool pfd = true;
    
    // fake hash strings for testing
    string hashA = "0F934A56E45343GH4";
    string hashB = "06B5FD34EA482B31A";
    string hashC = "04B5FA56E4582B313";
    string hashD = "0B934A34B5FA56E16";

    uint price = 20;
    
    function beforeAll() public {
        store = new BookArbiter(); // initialize
    }
    
    /////////////////////
    ///////////////////////
    /// Test common functions of Book Arbiter contract
    
    function create_book() public {
        store.addBook(temp, title, pfd, hashA, price); // add book to test contract
            
        // set test variables for later assertions
        hashCheck = hashA;
        priceCheck = price;
        // temp = seller;

        Assert.equal(store.getHash(0), hashCheck, "hash should be equal and book is created"); // assert that the added book hash equals original hash
        
    }
    
    function testHashTransfer() public {
        
        store.setHash(0,hashB); // change hash to new value
        Assert.equal(store.getHash(0), hashB, "the hash should be valid after transfer to new value"); // assert that the added book hash equals original hash
    }
    
    // use preset address for local testnet
    // ganache address used above: 0x851763A06A4f53f2f900C274208688Ed7112ef71
    function transferOwner() public {
        address payable reset = payable(msg.sender);
        store.setSeller(0, reset);
        // assert and check that ownership has changed hands
        Assert.equal(store.getSeller(0), reset, "the new address should be the new owner of the book"); // assert that the seller has transferred
    
    }

    function multipleBooks() public { // test that ultiple books can be added
        store.addBook(temp, "Siddhartha", true, hashA, 10); // add book to test contract
        store.addBook(temp, "Idiocracy", false, hashB, 15); // add book to test contract
        store.addBook(temp, "Just Friends", true, hashD, 12); // add book to test contract

        Assert.equal(store.getHash(1), hashA, "second book added correctly");
        Assert.equal(store.getHash(2), hashB, "third book added correctly");
        Assert.equal(store.getHash(3), hashD, "fourth book added correctly");
    }

    function removeBook() public { // test functional book removal
        store.removeBook(0);

        // tests that one of the values is zeroed out, due to removal
        Assert.equal(store.getPrice(0), 0, "book removed correctly");
    }

    function reAddBook() public { // test that books will be added to empty indexes
        store.addBook(temp, "Atisha's Lamp", true, hashC, 10); // add book to test contract
        Assert.equal(store.getHash(0), hashC, "book added correctly");
    }
    
    /////////////////////////
    ///////////////////////
    ////////////////////////
    // Test Common functions of Escrow fxns
    
    //test escrow and transaction procedure
    function testEscrow() public {
        // test here
    }
    
    
    
    ////////////////////////
    /////////////////////
    
}