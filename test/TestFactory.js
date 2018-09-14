var Factory = artifacts.require("Factory");

var Agreement = artifacts.require("Agreement");

// todo: this is going to be fragile as it can change. need a solution for the environment
var ERC20Token = "0x7c21f56495fc1e8cccf850cb3d6d05b74200ac37";

contract('Factory', function(accounts) {
    it("should be able to request an Agreement", function() {
        return Factory.deployed().then(function(instance) {
            return instance.newAgreement("Dry on Sunday",accounts[1],accounts[1],ERC20Token,{from: accounts[0]});
        }).then(function(receipt) {

            // @todo I am referring to the logs in the receipt object but presuming the only
            // log object would be the one from the AgreementCreated event. A slightly
            // better test would find the log object with the "event" property on the log object
            // of "AgreementCreated"

            return Agreement.at(receipt.logs[0].args.agreement);
        }).then(function(agreement) {
            return agreement.getSubject.call();
        }).then(function(subject) {
            assert.equal(subject,"Dry on Sunday","agreement doesn't return subject");
        });
    });

});
