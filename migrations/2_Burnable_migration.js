const BurnableTokenContract = artifacts.require("BurnableToken");

module.exports = function (deployer) {
  deployer.deploy(BurnableTokenContract);
};
