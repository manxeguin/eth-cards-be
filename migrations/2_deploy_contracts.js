const DBZCollectible = artifacts.require("DBZCollectible");

module.exports = function(deployer) {
  deployer.deploy(DBZCollectible);
};