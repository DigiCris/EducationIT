var MyContract = artifacts.require("Store");

module.exports = function(deployer) {
  // deployment steps
  deployer.deploy(MyContract);
};