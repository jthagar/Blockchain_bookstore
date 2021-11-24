//var bookstore = artifacts.require("./bookstore.sol");
var Escrow = artifacts.require("../contracts/Escrow.sol");
var BookArbiter = artifacts.require("../contracts/BookArbiter.sol");
// var BookArbiter = artifacts.require("../test/TestBookArbiter.sol");

module.exports = async function (deployer, network, accounts) {
  // deployment steps
  await deployer.deploy(Escrow);
  await deployer.deploy(BookArbiter);
  //deployer.deploy(TestBookArbiter);
};
