var SimpleStorage = artifacts.require("./book_arbiter.sol");

module.exports = function(deployer) {
  deployer.deploy(BookArbiter);
};
