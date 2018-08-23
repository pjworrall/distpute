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
});
