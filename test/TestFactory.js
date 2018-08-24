var Factory = artifacts.require("Factory");

contract('Factory', function(accounts) {
    it("should be able to request an Agreement", function() {
        return Factory.deployed().then(function(instance) {
            return instance.newAgreement("Dry on Sunday",accounts[1],accounts[1],{from: accounts[0]});
        }).then(function(receipt) {
            console.log(JSON.stringify(receipt));

            /// watch for events to catch a report fo the contract being created

        });
    });

});
