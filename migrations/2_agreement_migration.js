let Agreement = artifacts.require("Agreement");

// Granache public MNEMONIC for testing
// dog double video above tuna afford almost jazz exclude rural level flag

module.exports = function(deployer, network, accounts) {
    // constructor arguments
    // const subject = "I bet ten pounds GBP that rain falls on St. Paul's Cathedral in London anytime during August 31st 2018";
    const subject = "TBD";
    const taker = "0x87b72560F4eb8B418A82C8c287962B05243144F0"; // 2nd
    const adjudicator = "0xDb0a1A2a8366e113A2627C816151B0865BD2bE1B"; // 3rd
    deployer.deploy(Agreement,subject,taker,adjudicator);
};
