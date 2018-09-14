var Escrow = artifacts.require("Escrow");

var Token = artifacts.require("Token");

let address = undefined;

contract('Escrow', function(accounts) {
    it("should be able to transfer tokens to an Escrow contract", function() {
        return Escrow.deployed().then(function(instance) {

            // for use later
            address = instance.address;

            // transfer some tokens to this contract
            // note: got to figure out a better way of sharing address to contracts created during test runs
            let token = Token.at("0x7c21f56495fc1e8cccf850cb3d6d05b74200ac37");

            return token.transfer(address, 1000, {from: accounts[0]});

        }).then(function(receipt) {

            let token = Token.at("0x7c21f56495fc1e8cccf850cb3d6d05b74200ac37");

            return token.balanceOf(address);

        }).then(function(balance) {

            assert.equal(balance,1000,"escrow contract did not have expected balance");

        });
    });

    // NEXT!!!
    // should be able to release from Escrow if Agreement
    // // instance.release(accounts[5],{from: accounts[0]});

    // should not be able to release from Escrow if not Agreement


});
