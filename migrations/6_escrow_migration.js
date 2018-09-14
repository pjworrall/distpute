var Escrow = artifacts.require("./Escrow.sol");

module.exports = function (deployer, network, accounts) {

    //this is going to break because you can't expect this address to be the erc20 all the time
    const erc20 = "0x7c21f56495fc1e8cccf850cb3d6d05b74200ac37";

    deployer.deploy(Escrow, erc20 );

};