var Register = artifacts.require("Register");

contract('Register', function(accounts) {
    it("should be able to set a KYC Provider", function() {
        return Register.deployed().then(function(instance) {
            return instance.setKYCProvider(accounts[1],{from: accounts[0]});
        }).then(function(result) {
            //console.log(JSON.stringify(result));
            assert.isOk(result.receipt, "receipt was not provided");
        });
    });

    it("should return the correct KYC Provider", function() {
        return Register.deployed().then(function(instance) {
            return instance.getKYCProvider.call();
        }).then(function(address) {
            assert.equal(accounts[1],address, "was not the KYC Provider");
        });
    });

    it("should return all adjudicators", function() {
        return Register.deployed().then(function(instance) {
            return instance.getAllRegistered.call();
        }).then(function(adjudicators) {
            var n = adjudicators.length;
            assert.equal(n,5, "number of adjudicators incorrect");
        });
    });

    it("should allow KYCProvider to add Adjudicator", function() {
        return Register.deployed().then(function(instance) {
            return instance.setAdjudicator(accounts[5],{from: accounts[1]});
        }).then(function(receipt) {

            // @todo I am referring to the logs in the receipt object naughtily
            var adjudicator  = receipt.logs[0].args.adjudicator;

            assert.equal(adjudicator,accounts[5],"adjudicator address incorrect");

        });
    });

    //
    it("should only allow KYCProvider to add Adjudicator", function() {
        return Register.deployed().then(function (instance) {
            return instance.setAdjudicator(accounts[5],{from: accounts[3]});
        }).then(function () {
            assert(false,"should have error with throw or revert");
        }).catch(function (err) {
            assert.equal(err, "Error: VM Exception while processing transaction: revert", "did not throw or revert as expected");
        });
    });


});
