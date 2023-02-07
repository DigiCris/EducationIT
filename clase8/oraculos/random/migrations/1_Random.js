var MyContract = artifacts.require("Random");

module.exports = function(deployer) {
  // deployment steps
  deployer.deploy(MyContract);
}