var Agreement = artifacts.require("Agreement");

contract('Agreement', function(accounts) {
    it("should be TBD for the agreement subject", function() {
        return Agreement.deployed().then(function(instance) {
            return instance.getSubject.call();
        }).then(function(subject) {
            assert.equal(subject, "TBD", "subject was not TBD");
        });
    });
});
