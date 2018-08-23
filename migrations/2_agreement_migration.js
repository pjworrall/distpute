let Agreement = artifacts.require("Agreement");

module.exports = function(deployer) {
    // constructor arguments
    // const subject = "I bet ten pounds GBP that rain falls on St. Paul's Cathedral in London anytime during August 31st 2018";
    const subject = "TBD";
    const counterpartyB = "0x87b72560F4eb8B418A82C8c287962B05243144F0";
    deployer.deploy(Agreement,subject,counterpartyB);
};
