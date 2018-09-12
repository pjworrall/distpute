var Token = artifacts.require("Token");

contract('Token', function(accounts) {
    it("should report total supply is 1e+22", function() {
        return Token.deployed().then(function(instance) {

            console.log("Token Address: " + instance.address);

            return instance.totalSupply({from: accounts[0]});

        }).then(function(supply) {

            console.log("Total supply: " + supply);

            assert.equal(supply,10000000000000000000000,'Total supply not 1e22');

        });
    });

    it("should report balance of account[0] is 1e22", function() {
        return Token.deployed().then(function(instance) {

            return instance.balanceOf(accounts[0],{from: accounts[0]});

        }).then(function(balance) {

            console.log("Balance of account[0]: " + balance);

            assert.equal(balance,10000000000000000000000,'Balance of account[0] not 1e22');

        });
    });

    it("should be able to transfer to another owner", function() {
        return Token.deployed().then(function(instance) {

            return instance.transfer(accounts[1],10000,{from: accounts[0]});

        }).then(function(receipt) {

            let from = receipt.logs[0].args.from;
            let to = receipt.logs[0].args.to;
            let value =receipt.logs[0].args.value;

            console.log("transfer event reported from: " + from + ", to: " + to + ", value: " + value );

            assert.equal(to,accounts[1],'event did not report transfer was to account[1]');

        });
    });

    it("should report account[1] has 10000 tokens", function() {
        return Token.deployed().then(function(instance) {

            return instance.balanceOf(accounts[1],{from: accounts[0]});

        }).then(function(balance) {

            console.log("Balance of account[1]: " + balance);

            assert.equal(balance,10000,'Balance of account[1] not 10000');

        });
    });

});
