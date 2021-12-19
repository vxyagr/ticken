const Ticken = artifacts.require("Ticken");

module.exports = function(deployer) {
    deployer.deploy(Ticken);
};
