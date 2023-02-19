var storage = artifacts.require("Storage");

module.exports = function(deployer) {
    deployer.deploy(storage);
}