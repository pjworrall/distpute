pragma solidity ^0.4.22;

import 'openzeppelin-solidity/contracts/token/ERC20/IERC20.sol';


/**
 * @title Escrow
 * @author Paul Worrall
 * @notice This is an Escrow Contract to hold a Token balance for the period of an Agreement
 * An agreement will create an instance of this for a Counterparty to commit tokens against. The agreement can then release the
 * tokens to a specified beneficiary
 * @dev very much in development
 */

contract Escrow {

    address private _agreement;
    IERC20 private _erc20;

    /**
    * @notice event to report an Agreement has released the escrow to a specified Address
    * @param agreement that release the escrow
    * @param beneficiary that received the tokens
    * @param amount of tokens released
    */
    event Released(address indexed agreement, address beneficiary, uint256 amount);

    /**
    * @notice Constructor to be used by an Agreement contract to hold a counter parties stake
    * @param erc20 address of the ERC20 Token Contract
    */
    constructor(address erc20) public {
        _agreement = msg.sender;
        _erc20 = IERC20(erc20);
    }

    /**
    * @notice Release tokens
    */
    function release(address beneficiary) public {
        require(msg.sender == _agreement);

        uint256 balance = _erc20.balanceOf(this);

        _erc20.transfer(beneficiary,balance);

        emit Released(_agreement, beneficiary, balance);
    }

}