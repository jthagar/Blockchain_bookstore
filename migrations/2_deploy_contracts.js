//var bookstore = artifacts.require("./bookstore.sol");
var Escrow = artifacts.require("../contracts/Escrow.sol");
var BookArbiter = artifacts.require("../contracts/BookArbiter.sol");


module.exports = function(deployer) {
  deployer.deploy(Escrow);
  //deployer.deploy(Bookstore);
  deployer.deploy(BookArbiter);
};
