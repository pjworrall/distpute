var Escrow = artifacts.require("Escrow");

var Token = artifacts.require("Token");

let escrowContract = undefined;


/**
 * Roles of test Addresses for these Escrow unit test
 * address[0] will be used for the address of an Agreement
 * Token contract is 0x7c21f56495fc1e8cccf850cb3d6d05b74200ac37
 * Release address for testing is account[6] - 0x36Aa95084900D2c01514B0E0e9D0B901511c786C
 *
 */

contract('Escrow', function (accounts) {
    it("should be able to transfer tokens to an Escrow contract", function () {
        return Escrow.deployed().then(function (instance) {

            // for use later
            escrowContract = instance.address;

            console.log("Escrow address: " + escrowContract);

            // transfer some tokens to this contract
            // note: got to figure out a better way of sharing escrow to contracts created during test runs
            let token = Token.at("0x7c21f56495fc1e8cccf850cb3d6d05b74200ac37");

            return token.transfer(escrowContract, 1000, {from: accounts[0]});

        }).then(function (receipt) {

            let token = Token.at("0x7c21f56495fc1e8cccf850cb3d6d05b74200ac37");

            return token.balanceOf(escrowContract);

        }).then(function (balance) {

            assert.equal(balance, 1000, "escrow contract did not have expected balance");

        });
    });

    it("should be able to release tokens to a specified address", function () {
        return Escrow.deployed().then(function (instance) {

            // release tokens to a specified Address
            return instance.release("0x36Aa95084900D2c01514B0E0e9D0B901511c786C", {from: accounts[0]});

        }).then(function (receipt) {

            // check the event
            let event = receipt.logs[0].event;

            assert.equal(event,"Released","Event was not Released");

            let params = receipt.logs[0].args; // need to understand if there is only one event instance in a receipt

            console.log("Escrow release event: " + receipt.logs[0].event + ", Agreement: " + params.agreement + ", beneficiary: " + params.beneficiary + ", amount: " + params.amount );

            // get the balance to check later

            let token = Token.at("0x7c21f56495fc1e8cccf850cb3d6d05b74200ac37");

            return token.balanceOf("0x36Aa95084900D2c01514B0E0e9D0B901511c786C");

        }).then(function (balance) {

            assert.equal(balance, 1000, "release address did not have expected balance");


        });
    });


    // should not be able to release from Escrow if not Agreement

    // should report an event for a release





});
