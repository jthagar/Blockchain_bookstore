// SPDX-License-Identifier: MIT
pragma solidity >=0.8.3 <0.9.0;

// the base outline for the escrow contract was taken from github
// need to edit and change it to fit the needs of the project
contract Escrow {    // think about adding a USD => WEI converter for easier purchase legibility
    //state variables
    address payable buyer;
    address payable seller;
    address payable arbiter;
    uint public amountInWei;

    // variables for time tracking
    uint private limit = 259200; // 3 days
    uint private begin = 0; // variable for beginning of contract
    uint public end_time = 0; // variable for end of contract
    
    
    //solidity events
    event FundingReceived(uint _timestamp);
    event SellerPaid(uint _timestamp);
    event BuyerRefunded(uint _timestamp);

    //function that confirms/validates success of transaction
    function validate() public payable {
        //if the buyer has paid
        if (msg.value > 0) {
            //if the buyer has paid more than the amount in the contract
            if (msg.value > amountInWei) {
                //refund the buyer
                buyer.transfer(amountInWei);
                //emit the event
                emit BuyerRefunded(block.timestamp);
            }
            //if the buyer has paid less than the amount in the contract
            else {
                //set the buyer as the seller
                seller = buyer;
                //set the amount in the contract to the amount in the transaction
                amountInWei = msg.value;
                //emit the event
                emit SellerPaid(block.timestamp);
            }
        }
    }

    //function for buyer to fund; payable keyword must be used
    function fund() public payable {
        require(msg.sender == buyer &&  //conditional checks to make sure only the buyer's address
                msg.value == amountInWei//can send the correcr amount to the contract
                );
        emit FundingReceived(block.timestamp); //emit FundingReceived() event
    }
    
    //function for buyer to payout seller
    function payoutToSeller() public {
        require(msg.sender == buyer || msg.sender == arbiter); //only buyer or arbiter can execute this function
        seller.transfer(address(this).balance); //using the solidity's built in transfer function, the funds are sent to the seller
        emit SellerPaid(block.timestamp); //emit SellerPaid() event
    }
    
    //function for seller to refund the buyer
    function refundBuyer() public {
        require(msg.sender == seller || msg.sender == arbiter);//only buyer or arbiter can execute this function
        buyer.transfer(address(this).balance); //using the solidity's built in transfer function, the funds are returned to the buyer
        emit BuyerRefunded(block.timestamp);//emit BuyerRefunded() event
    }


    //function that creates and holds a time limit for the escrow using validator
    function timeLimit() public payable {
        //require(msg.sender == buyer); //only buyer can execute this function
        
        //if the buyer has paid more than the amount in the contract
        if (msg.value > amountInWei) {
            //refund the buyer
            buyer.transfer(amountInWei);
            //emit the event
            refundBuyer(); // returns remaining amount of wei
            emit BuyerRefunded(block.timestamp);
        }
        //if the buyer has paid less than the amount in the contract
        else {
            //set the buyer as the seller
            seller = buyer;
            //set the amount in the contract to the amount in the transaction
            amountInWei = (msg.value); 
            //emit the event
            emit SellerPaid(block.timestamp); // emit current paird amount
        }
        //set the arbiter as the seller
        seller = arbiter;
        //set the amount in the contract to the amount in the transaction
        amountInWei = msg.value;
        //emit the event
        emit SellerPaid(block.timestamp);
    }

    // function checkTime() to check time status of the contract
    // would need to be used by an exteranl script/service as ethereum does not have internal scheduling functions
    function checkTime() public returns (bool) {
        //if the time limit has not been reached
        if (block.timestamp < begin + limit) {
            return true;
        }
        //if the time limit has been reached
        else {
            refundBuyer();
            return false;
        }
    }
    
    //constructor function; used to set initial state of contract
    constructor(address payable _seller, address payable _buyer, address payable _arbiter, uint _amountInWei) public {
        seller = _seller;
        buyer = _buyer;
        arbiter = _arbiter;
        amountInWei = _amountInWei;

        begin = block.timestamp; // set beginning of contract
        end_time = begin + limit; // set contract limit at 3 days
    }
}