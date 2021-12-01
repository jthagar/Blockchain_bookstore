var Escrow = artifacts.require("../contracts/Escrow.sol");
var Book = artifacts.require("../contracts/Book.sol");
var BookArbiter = artifacts.require("../contracts/BookArbiter.sol");
// var BookArbiter = artifacts.require("../test/TestBookArbiter.sol");

module.exports = async function (deployer, network, accounts) {
  // deployment steps
  // await deployer.deploy(Escrow);
  // await deployer.deploy(Book);
  await deployer.deploy(BookArbiter);
  //deployer.deploy(TestBookArbiter);
};
