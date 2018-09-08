var Agreement = artifacts.require("Agreement");

contract('Agreement', function(accounts) {
    it("should be TBD for the Agreement Subject", function() {
        return Agreement.deployed().then(function(instance) {
            return instance.getSubject.call();
        }).then(function(subject) {
            assert.equal(subject, "TBD", "subject was not TBD");
        });
    });

    it("should be 'not accepted' at Origination", function() {
        return Agreement.deployed().then(function(instance) {
            return instance.isAccepted.call();
        }).then(function(accepted) {
            assert.isFalse(accepted, "was accepted at origination");
        });
    });

    it("should provide a receipt after Taker accepts", function() {
        return Agreement.deployed().then(function(instance) {
            return instance.setAccepted({from: accounts[1]});
        }).then(function(result) {
            //console.log(JSON.stringify(result));
            assert.isOk(result.receipt, "receipt was not provided");
        });
    });


    it("should report Accepted as true when Taker has accepted", function() {
        return Agreement.deployed().then(function(instance) {
            return instance.isAccepted.call();
        }).then(function(accepted) {
            assert.isTrue(accepted, "did not report Taker had Accepted");
        })
    });

    // not sure how to test this behaviour properly because how do you handle a throw/revert
    it("should only allow Originator and Taker to Determine outcome", function() {
        return Agreement.deployed().then(function(instance) {
            return instance.setBeneficiary({from: accounts[3]});
        }).then(function () {
            assert(false,"should have error with throw or revert");
        }).catch(function (err) {
            assert.equal(err, "Error: VM Exception while processing transaction: revert", "did not throw or revert as expected");
        });
    });


    it("should provide a receipt when Originator sets as the Beneficiary", function() {
        return Agreement.deployed().then(function(instance) {
            return instance.setBeneficiary({from: accounts[0]});
        }).then(function(result) {
            assert.isOk(result.receipt, "receipt was not provided");
        })
    });

    it("should report that Originator is the Beneficiary", function() {
        return Agreement.deployed().then(function(instance) {
            return instance.getBeneficiary.call();
        }).then(function(address) {
            assert.equal(accounts[0],address, "Originator was not Beneficiary");
        })
    });

    // not sure how to test this behaviour properly because how do you handle a throw/revert
    it("should not be able to set Beneficiary if already set", function() {
        return Agreement.deployed().then(function (instance) {
            return instance.setBeneficiary({from: accounts[0]});
        }).then(function () {
           assert(false,"should have error with throw or revert");
        }).catch(function (err) {
            assert.equal(err, "Error: VM Exception while processing transaction: revert", "did not throw or revert as expected");
        });
    });

    // Only the Originator or the Taker can lodge a dispute

    // Only the Adjudicator can set Favour
    // Adjudicator can only Favour the parties to the Contract


});
