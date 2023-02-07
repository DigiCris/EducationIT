var MyContract = artifacts.require("APIConsumer");

module.exports = function(deployer) {
  // deployment steps
  deployer.deploy(MyContract);
}
