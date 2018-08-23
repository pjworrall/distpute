pragma solidity ^0.4.22;

/**
 * @title Register
 * @author Paul Worrall
 * @notice This is part of the DistPute Smart Contract framework
 * @dev First stab at a Register for KYC'd Adjudicators
 */

contract Register {

    address private _owner;

    /// this could be a set of valid KYC Providers in future
    address private _KYCProvider;

    address[] adjudicators;

    /* Function modifiers */
    modifier onlyOwner {
        require (msg.sender == _owner);
        _;
    }

    modifier onlyKYCProvider {
        require (msg.sender == _KYCProvider);
        _;
    }


    /**
     * event to report an Adjudicator being added to the Register
     * @param adjudicator address
    */
    event Registered(address indexed adjudicator);

    constructor() public {
        _owner = msg.sender;
    }

    /**
     * add a KYC'd adjudicator to the Register
     * @param adjudicator address
    */
    function setAdjudicator(address adjudicator) onlyKYCProvider  public {

        adjudicators.push(adjudicator);

        emit Registered(adjudicator);
    }

    function setKYCProvider(address provider) onlyOwner public {
        _KYCProvider = provider;
    }

    /// @return _KYCProvider
    function getKYCProvider() public view returns(address) {
        return _KYCProvider;
    }


}
