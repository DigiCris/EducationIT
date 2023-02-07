var MyContract = artifacts.require("Ethprice");

module.exports = function(deployer) {
  // deployment steps
  deployer.deploy(MyContract);
}