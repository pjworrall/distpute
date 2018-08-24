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

        /// set 10 Granache addresses as known test Adjudicators

        address account6 = 0xe925891Ca39125a0ad0eB61e9ad8DdF41bf99f68;
        adjudicators.push(account6);
        address account7 = 0x36Aa95084900D2c01514B0E0e9D0B901511c786C;
        adjudicators.push(account7);
        address account8 = 0xd8896446C92fA2E4E87939d52406FD1f0E9ee08d;
        adjudicators.push(account8);
        address account9 = 0x3557afe070B40a536FbE40F3086b6c021dfD7893;
        adjudicators.push(account9);
        address account10 = 0xB9ffcbbC14E081D2b54f01eF162c4C27e2f0438f;
        adjudicators.push(account10);

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

    /// @return adjudicators

    function getAllRegistered() public view returns(address[]) {
        return adjudicators;
    }
}
