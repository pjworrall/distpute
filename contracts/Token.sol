pragma solidity ^0.4.23;

import 'openzeppelin-solidity/contracts/token/ERC20/ERC20.sol';

contract Token is ERC20 {
    string public name = "Distpute Token";
    string public symbol = "DSP";
    uint8 public decimals = 18; // this is the recommended decimals


    uint256 public constant INITIAL_SUPPLY = 10000000000000000000000;

    /**
     * @dev Constructor that gives the 'wallet' supplied in the constructor all of the tokens.
     */
    constructor(address wallet) public {
        _mint(wallet, INITIAL_SUPPLY);
    }


}
