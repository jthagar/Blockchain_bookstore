// SPDX-License-Identifier: MIT
pragma solidity >=0.8.3 <0.9.0;

// the base outline for the escrow contract was taken from github
// need to edit and change it to fit the needs of the project
contract Escrow {    // think about adding a USD => WEI converter for easier purchase legibility
    //state variables
    address payable buyer;
    address payable seller;
    address payable arbiter;
    uint public amountInEth;
    uint public balance;
    uint Gwei = 1000000000; // 1 ETH = 1000000000 GWEI;
    uint Wei = 1000000000; // 1 Gwei = 1000000000 WEI;

    // variables for time tracking
    // 259200 is 3 days
    uint private limit = 1; //  1 second
    uint private begin = 0; // variable for beginning of contract
    uint public end_time = 0; // variable for end of contract

    // Define a function 'kill' if required to cancel contract
    function kill() external {
        if (msg.sender == arbiter) {
            selfdestruct(payable(address(this)));
        }
    }

    //solidity events
    event FundingReceived(uint _timestamp);
    event SellerPaid(uint _timestamp);
    event BuyerRefunded(uint _timestamp);
    event ContractNull(uint _timestamp);

    // allow contract to use ETH
    fallback() external payable {
        // do nothing
        emit FundingReceived(block.timestamp);
    }

    // allow contract to hold ETH
    receive() external payable {
        // do nothing
        emit FundingReceived(block.timestamp);
    }
    
    

    //function that confirms/validates success of transaction
    function validate() public payable {
        //if the buyer has paid
        if (balance >= 0) {
            //if the buyer has paid more than the amount in the contract
            if (balance > amountInEth) {
                //refund the buyer
                uint difference = balance - amountInEth;
                buyer.transfer(difference);

                // re-adjust balance and pay seller
                balance -= difference;
                payoutToSeller(balance);

                //emit the event
                emit SellerPaid(block.timestamp);
                emit BuyerRefunded(block.timestamp);

                //selfdestruct(payable(address(this))); // kill the contract
            }
            else if (balance == amountInEth)
            { // if correct amount has been input
                payoutToSeller(balance);
                balance = 0;
                emit SellerPaid(block.timestamp);
                //selfdestruct(payable(address(this))); // kill the contract
            }
            //if the buyer has paid less than the amount in the contract
            else{ // INVALID CONTRACT
                // refund to the buyer and cancel the contract
                buyer.transfer(balance);
                balance = 0;
                //emit the event
                emit BuyerRefunded(block.timestamp);
                emit ContractNull(block.timestamp); // emit voided contract
                //selfdestruct(payable(address(this))); // kill the contract

            }
        }
    }

    function convertAmount(uint256 _amount) public pure returns (uint) {
        return _amount * (1 ether / 1000); // return ETH amount converted roughly down to dollars
    }

    //function for buyer to fund; payable keyword must be used
    function fund() public payable {
        require(msg.sender == arbiter && msg.value == amountInEth);  //conditional checks to make sure only the buyer's address);
        balance += msg.value;
        emit FundingReceived(block.timestamp); //emit FundingReceived() event
    }
    
    //function for buyer to payout seller
    function payoutToSeller(uint _amount) public {
        require(msg.sender == buyer || msg.sender == arbiter); //only buyer or arbiter can execute this function
        seller.transfer(_amount); //using the solidity's built in transfer function, the funds are sent to the seller
        emit SellerPaid(block.timestamp); //emit SellerPaid() event
    }
    
    //function for seller to refund the buyer
    function refundBuyer() public {
        require(msg.sender == seller || msg.sender == arbiter);//only buyer or arbiter can execute this function
        buyer.transfer(address(this).balance); //using the solidity's built in transfer function, the funds are returned to the buyer
        emit BuyerRefunded(block.timestamp);//emit BuyerRefunded() event
    }

    /*
    //function that creates and holds a time limit for the escrow using validator
    function timeLimit() external payable {
        if(checkTime())
        {
        }
        else
        {
        }
    }
    */

    // function checkTime() to check time status of the contract
    // would need to be used by an exteranl script/service as ethereum does not have internal scheduling functions
    function checkTime() public returns (bool) {
        //if the time limit has not been reached
        if (block.timestamp < (begin + limit)) {
            return true;
        }
        //if the time limit has been reached
        else {
            refundBuyer();
            return false;
        }
    }
    
    //constructor function; used to set initial state of contract
    /*
    constructor() public {
        begin = block.timestamp; // set beginning of contract
        end_time = begin + limit; // set contract limit at 3 days
    }
    */

    //////////////////////
    // GET-SET FXNS /////
    function setSeller(address payable _seller) external {
        seller = _seller;
    }

    function getSeller() external view returns (address){
        return seller;
    }

    function setBuyer(address payable _buyer) external {
        buyer = _buyer;
    }

    function getbuyer() external view returns (address){
        return buyer;
    }

    function setArbiter(address payable _arbiter) external {
        arbiter = _arbiter;
    }

    function setPrice(uint _amountInWei) external {
        amountInEth = _amountInWei;
    }

    function getPrice() external view returns(uint) {
        return amountInEth;
    }
    ///////////////////////

}