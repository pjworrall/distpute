let Agreement = artifacts.require("Agreement");

// Granache public MNEMONIC for testing
// dog double video above tuna afford almost jazz exclude rural level flag

module.exports = function(deployer, network, accounts) {
    // constructor arguments
    // const subject = "I bet ten pounds GBP that rain falls on St. Paul's Cathedral in London anytime during August 31st 2018";
    const subject = "TBD";
    const originator = "0x30BA2478B37225eCfb32DC80f05278195C938995"; // [0]
    const taker = "0x87b72560F4eb8B418A82C8c287962B05243144F0"; // [1]
    const adjudicator = "0xB9ffcbbC14E081D2b54f01eF162c4C27e2f0438f"; // [9]
    const ERC20TokenAddress = "0x7c21f56495fc1e8cccf850cb3d6d05b74200ac37"; // todo how do we know this address is always the case ?
    deployer.deploy(Agreement,subject,originator,taker,adjudicator,ERC20TokenAddress);
};
