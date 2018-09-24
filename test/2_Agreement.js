var Agreement = artifacts.require("Agreement");

var Token = artifacts.require("Token");

// @todo check that there isn't a better pattern for making variables available across promises
let _takerEscrowAddress = undefined;
let _originatorEscrowAddress = undefined;
let _originatorEscrowAmount = 10000;
let _takerEscrowAmount = _originatorEscrowAmount; // the same for this bootstrap version


// @todo tests are having state dependencies on previous tests - is that an ok pattern?

// @todo should all the test have a catch statement to collect a JVM error? see pattern for checking JVM reverts are thrown when expected.

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

    it("should provide Taker with escrow account", function() {
        return Agreement.deployed().then(function(instance) {
            return instance.getTakerEscrow();
        }).then(function(address) {
            console.log("Taker escrow address: " + JSON.stringify(address));
            // @todo: this test should really check that the address is formatted as a Ethereum Address
            assert(address, "address was not provided");
        });
    });


    it("should be able to credit the Taker escrow account with tokens", function() {
        return Agreement.deployed().then(function(instance) {
            return instance.getTakerEscrow();
        }).then(function(address) {

            _takerEscrowAddress = address;

            // @todo need a helper to get the correct token contract address for the test suite instance!!!!

            return Token.at("0x7c21f56495fc1e8cccf850cb3d6d05b74200ac37");
        }).then(function(token) {

            // @todo test might be more coherent if a Taker account is used that has been provided with a token balance
            // using accounts[0] here as source of Tokens which inconsistent because it plays the role of Originator

            return token.transfer(_takerEscrowAddress,_takerEscrowAmount,{from: accounts[0]});
        }).then(function(result) {

            // @todo we need some kind of helper function because this pattern is repeated in a lot of tests

            // checking the Transfer event

            let event = undefined;

            for (var i = 0; i < result.logs.length; i++) {
                var log = result.logs[i];

                if (log.event === "Transfer") {
                    event = log;
                    break;
                }
            }

            let from = log.args.from;
            let to = log.args.to;
            let value = log.args.value;

            assert.equal(from,accounts[0],"Failed to credit Taker escrow account, from address wrong");
            assert.equal(to,_takerEscrowAddress,"Failed to credit Taker escrow account, to address wrong");
            assert.equal(value,_takerEscrowAmount,"Failed to credit Taker escrow account, value wrong");

        });
    });

    it("should not allow Taker to accept without escrow being staked by Originator", function() {
        return Agreement.deployed().then(function(instance) {
            return instance.setAccepted({from: accounts[1]});
        }).then(function () {
            assert(false,"should have error with throw or revert");
        }).catch(function (err) {
            assert.equal(err, "Error: VM Exception while processing transaction: revert", "did not throw or revert as expected");
        });
    });

    it("should be able to credit the Originator escrow account with tokens", function() {
        return Agreement.deployed().then(function(instance) {
            return instance.getOriginatorEscrow();
        }).then(function(address) {

            _originatorEscrowAddress = address;

            // @todo need a helper to get the correct token contract address for the test suite instance!!!!

            return Token.at("0x7c21f56495fc1e8cccf850cb3d6d05b74200ac37");
        }).then(function(token) {

            // @todo test might be more coherent if a Taker account is used that has been provided with a token balance
            // using accounts[0] here as source of Tokens which inconsistent because it plays the role of Originator

            return token.transfer(_originatorEscrowAddress,_originatorEscrowAmount,{from: accounts[0]});
        }).then(function(result) {

            // @todo we need some kind of helper function because this pattern is repeated in a lot of tests

            // checking the Transfer event

            let event = undefined;

            for (var i = 0; i < result.logs.length; i++) {
                var log = result.logs[i];

                if (log.event === "Transfer") {
                    event = log;
                    break;
                }
            }

            let from = log.args.from;
            let to = log.args.to;
            let value = log.args.value;

            assert.equal(from,accounts[0],"Failed to credit Originator escrow account, from address wrong");
            assert.equal(to,_originatorEscrowAddress,"Failed to credit Originator escrow account, to address wrong");
            assert.equal(value,_originatorEscrowAmount,"Failed to credit Originator escrow account, value wrong");

        });
    });



    // todo this needs revising in the context of previous test
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

    it("should only allow Originator and Taker to set Beneficiary", function() {
        return Agreement.deployed().then(function(instance) {
            return instance.setBeneficiary({from: accounts[2]});
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

    // @todo Need to confirm pattern for handling throws/reverts.
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

    it("should not be in dispute", function() {
        return Agreement.deployed().then(function(instance) {

            return instance.isDisputed();

        }).then(function (result) {

            assert(!result,"Agreement not in dispute");

        });
    });

    it("should only allow Originator and Taker to set dispute", function() {
        return Agreement.deployed().then(function(instance) {
            return instance.setDispute({from: accounts[2]});
        }).then(function () {
            assert(false,"should have error with throw or revert");
        }).catch(function (err) {
            assert.equal(err, "Error: VM Exception while processing transaction: revert", "did not throw or revert as expected");
        });
    });

    it("should allow Taker to set dispute", function() {
        return Agreement.deployed().then(function(instance) {

            return instance.setDispute({from: accounts[1]});

        }).then(function (result) {

            let event = undefined;

            for (var i = 0; i < result.logs.length; i++) {
                var log = result.logs[i];

                if (log.event === "Dispute") {
                    event = log;
                    break;
                }
            }

            console.log("Taker set dispute on: " + event.args.agreement);

            assert(event,"Dispute event not received");

        });
    });

    it("should be in dispute", function() {
        return Agreement.deployed().then(function(instance) {

            return instance.isDisputed();

        }).then(function (result) {

            assert(result,"Agreement should be in dispute");

        });
    });


    // Only the Adjudicator can set Favour

    it("should only allow Adjudicator to settle dispute", function() {
        return Agreement.deployed().then(function(instance) {
            return instance.setDispute({from: accounts[2]});
        }).then(function () {
            assert(false,"should have error with throw or revert");
        }).catch(function (err) {
            assert.equal(err, "Error: VM Exception while processing transaction: revert", "did not throw or revert as expected");
        });
    });



    // Adjudicator can only Favour the parties to the Contract

    it("should allow Adjudicator to provide favour in dispute", function() {
        return Agreement.deployed().then(function(instance) {

            return instance.setFavour(accounts[1],{from: accounts[9]});

        }).then(function (result) {

            let event = undefined;

            for (var i = 0; i < result.logs.length; i++) {
                var log = result.logs[i];

                if (log.event === "Favoured") {
                    event = log;
                    break;
                }
            }

            console.log("Adjudicator set favour on: " + event.args.agreement);

            assert(event,"Favoured event not received");

        });
    });

    it("Should be able to settle agreement in favour of beneficiary", function() {

        var agreement;
        var erc20;
        var previousBalance;

        return Agreement.deployed().then(function(instance) {
            agreement = instance;
            // get the token
            return Token.at("0x7c21f56495fc1e8cccf850cb3d6d05b74200ac37");
        }).then(function (token) {
            erc20 = token;
            // get the token balance of the Beneficiary
            return token.balanceOf(accounts[1]);
        }).then(function (balance) {
            previousBalance = balance;

            // settle the account

            return agreement.settle({from: accounts[0]});

        }).then(function (result) {

            let event = undefined;

            for (var i = 0; i < result.logs.length; i++) {
                var log = result.logs[i];

                if (log.event === "Settled") {
                    event = log;
                    break;
                }
            }

            console.log("Settled to Beneficiary: " + event.args.beneficiary);

            assert(event,"Favoured event not received");

            // but we need to go on to check balance of beneficiary

            return erc20.balanceOf(accounts[1]);

        }).then(function (balance) {

            console.log("Taker balance was: " + previousBalance + ", now it is " + balance);

            // todo maybe should test an exact expected balance
            assert.notEqual(previousBalance,balance,"balance was not increased as expected");

        });
    });


    // test that a balance can be correctly returned

    // need to test the isStaked guard on the state changing functions

    // set favour should not be possible if the Agreement is not in Dispute


});
