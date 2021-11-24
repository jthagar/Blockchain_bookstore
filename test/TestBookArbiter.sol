// SPDX-License-Identifier: MIT
pragma solidity >=0.8.3 <0.9.0;

//assertions check for things like equality, inequality or emptiness
// in order to return a pass/fail for the test
import "truffle/Assert.sol";
// helps deploy a fresh instance of the contract to the blockchain for testing
import "truffle/DeployedAddresses.sol";
// the smart contract we wish to test
import "../contracts/BookArbiter.sol";

contract TestBookArbiter {
    
    // the smart contract we wish to test
    BookArbiter store;
    uint index;

    function beforeAll() public {
        // initialize for testing
        store = BookArbiter(DeployedAddresses.BookArbiter());
    }
    address payable temp = payable(0x851763A06A4f53f2f900C274208688Ed7112ef71);

    // fake hash strings for testing
    string hashA = "0F934A56E45343GH4";
    string hashB = "06B5FD34EA482B31A";
    string hashC = "04B5FA56E4582B313";
    string hashD = "0B934A34B5FA56E16";
    
    /////////////////////0xC6bae7b84BE3916F298dB197fc7011a78fc6065C
    ///////////////////////
    /// Test common functions of Book Arbiter contract
    
    function testAddBook() public {
        store.addBook(temp, "little red riding hood", true, hashA, 20); // add book to test contract
        index = store.getCount() - 1; // get current index if contract is still deployed

        Assert.equal(store.getHash(index), hashA, "hash should be equal and book is created"); // assert that the added book hash equals original hash
    }
    
    function testHashTransfer() public {
        store.setHash(index,hashB); // change hash to new value
        Assert.equal(store.getHash(index), hashB, "the hash should be valid after transfer to new value"); // assert that the added book hash equals original hash
    }
    
    // use preset address for local testnet
    // ganache address used above: 0x851763A06A4f53f2f900C274208688Ed7112ef71
    function testtransferOwner() public {
        address payable reset = payable(msg.sender);
        store.setSeller(index, reset);
        // assert and check that ownership has changed hands
        Assert.equal(store.getSeller(index), reset, "the new address should be the new owner of the book"); // assert that the seller has transferred
    
    }

    function testMultipleBooks() public { // test that ultiple books can be added
        store.addBook(temp, "Siddhartha", true, hashA, 10); // add book to test contract
        store.addBook(temp, "Idiocracy", false, hashB, 15); // add book to test contract
        store.addBook(temp, "Just Friends", true, hashD, 12); // add book to test contract
        uint count = store.getCount();

        // test that the books were successfully added to the mapping
        Assert.equal(store.getHash(count - 3), hashA, "second book added correctly");
        Assert.equal(store.getHash(count - 2), hashB, "third book added correctly");
        Assert.equal(store.getHash(count - 1), hashD, "fourth book added correctly");
    }

    function testRemoveBook() public { // test functional book removal
        store.removeBook(0);

        // tests that two of the values are zeroed out, due to removal
        Assert.equal(store.getPrice(0), 0, "book removed correctly");
        Assert.equal(store.getHash(0), "", "book removed correctly");
    }

    function testBook() public { // test that books will be added to empty indexes
        store.addBook(temp, "Atisha's Lamp", true, hashC, 10); // add book to test contract
        Assert.equal(store.getHash(0), hashC, "book added correctly");
    }
    
    /////////////////////////
    ///////////////////////
    ////////////////////////
    // Test Common functions of Escrow fxns
    event VariablesCreated(uint _timestamp);
    event TransactionCompleted(uint _timestamp);


    //test escrow and transaction procedure
    /* might need to be completely done in javscript to test actual eth transfer
    function testEscrow() public {
        // temporary variables to test escrow
        uint count = store.getCount();

        address payable buyer = payable(0xC6bae7b84BE3916F298dB197fc7011a78fc6065C);
        uint balance = uint(buyer.balance);
        uint priceGwei = store.getPrice(count - 1) * 1000000000;
        emit VariablesCreated(block.timestamp);

        // run escrow transaction
        store.Transaction(count - 1, buyer);
        emit TransactionCompleted(block.timestamp);

        Assert.equal(store.getSeller(count -1), buyer, "successful escrow and ownership transfer");
        Assert.isTrue((uint(buyer.balance) + priceGwei) <= (balance), "correct balance transferred");

    }
    */
    
    
    
    ////////////////////////
    /////////////////////
    
}