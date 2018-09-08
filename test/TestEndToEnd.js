var Factory = artifacts.require("Factory");

var Agreement = artifacts.require("Agreement");

contract('Factory', function(accounts) {
    it("should be able to request an Agreement", function() {
        return Factory.deployed().then(function(instance) {

            console.log("Distpute Factory Address: " + instance.address);

            return instance.newAgreement("Dry on Sunday",accounts[1],accounts[1],{from: accounts[0]});
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

    // Taker should be able to accept the agreement

    // Only the Taker should be able to accept the agreement

    // Placer should be able to set themselves as Beneficiary

    // Taker should know if Beneficiary has been set on agreement

    // Taker should be able to set themselves as Beneficiary

    // Placer should know if Beneficiary has been set on agreement

    // Settlement must not be possible for a defined time after setting Beneficiary

    // Placer should be able to set a Dispute

    // Taker should know if Placer has set Dispute

    // Taker should be able to set a Dispute

    // Placer should know if Taker has set a Dispute

    // Only Take or Placer should be able to set a Dispute

    // Adjudicator should know an Agreement is in Dispute

    // Adjudicator should be able to set favour

    // Only the Adjudicator should be able to set favour

    // Placer can request settlement

    // Taker can request settlement

    // Disputed agreements must pay Adjudicators fees

    // Settlement must not happen if in Dispute

    // NEED A METHOD FOR DETERMINE CORRECT LOGIC FLOW



});
