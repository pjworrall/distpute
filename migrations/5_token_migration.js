var Token = artifacts.require("./Token.sol");

module.exports = function (deployer, network, accounts) {
    // the wallet that gets all the tokens assigned to it for testing purposes
    const wallet = accounts[0];

    deployer.deploy(Token, wallet);

};