pragma solidity ^0.4.22;

/**
 * @title Agreement
 * @author Paul Worrall
 * @notice This is part of the DistPute Smart Contract framework. Escrow supported by checking the token balance
 * provided to the Agreement by the Originator.
 * @dev third generation that provides for some escrow
 */

import "./Escrow.sol";

import 'openzeppelin-solidity/contracts/token/ERC20/IERC20.sol';


contract Agreement {

    IERC20 _token ;

    // contract fields public for testing purposes (although technically they are always publicq)
    address public _Originator;
    address public _Taker;
    address public _Adjudicator;

    address public _Beneficiary;

    bool public _Determined = false;
    bool public _Disputed = false;

    /// for testing the subject is a trivial text statement but will be a Contract adhering to an Interface standard
    string public _Subject;
    bool public _Accepted = false;

    // this is the escrow contract
    Escrow public _OriginatorEscrow;

    /**
     * @notice event to report a Taker for the Agreement
     * @param taker who took the other side of the agreement
     * @param subject about which the parties are taking a view
    */
    event Accepted(address indexed taker, string subject);

    /**
     * @notice event to notify that a request for the outcome to be determined
     * @param determiningParty that made the determination request
    */
    event Determined(address indexed determiningParty);

    /**
     * @notice event to notify that the outcome is being disputed
     * @param disputingParty who as raised the dispute
    */
    event Dispute(address indexed disputingParty);

    /**
     * @notice event to notify who the Adjudicator has favoured in the dispute
     * @param favouredParty who has been determined to be the beneficiary after dispute resolution
    */
    event Favoured(address indexed adjudicator,address indexed originator, address indexed favouredParty);

    /**
     * @notice event to notify that the Agreement has been settled
     * @param beneficiary who received the proceeds
     * @param adjudicator Contract or Account that settled the dispute and took the fees
    */
    event Settled(address indexed beneficiary, address indexed adjudicator);


    /**
     * @notice Constructor to be used by a Factory contract. Note the msg.send is the Factory class and not the Originator.
     * @param subject text of the Binary Agreement that the parties commit to. Plain text but can be a Complex Type in future.
     * @param originator is the first party to the Agreement
     * @param taker is the counter party to the Agreement
     * @param token is the address of the ERC20 token used for escrow
     * @param adjudicator identifies who decides a Disputed outcome, which can be another Smart Contract Address.
    */
    constructor(string subject, address originator ,address taker, address adjudicator, address token) public {
        _Originator = originator;
        _Subject = subject;
        _Taker = taker;
        _Adjudicator = adjudicator;
        _token = IERC20(token);

        /**
        * Create an escrow contract for the Originator to place their tokens in escrow
        * This agreement will control the tokens provided to this Escrow contract
        */

        _OriginatorEscrow = new Escrow(token);

    }


    /**
     * @notice Originators escrow contact
     * @return address of the escrow contract
     */
    function getOriginatorEscrow() public view returns (address) {
        return _OriginatorEscrow;
    }


    /**
     * @notice Token balance that the agreement holds. Not necessarily used as any token credits cannot be
     * tracked in this contract
     * @return balance ,the token balance controlled by this agreement
     * @dev Obsolete because we cannot isolate escrow holdings if using the Agreement holds the tokens
     */
    function getTokenBalance() public view returns (uint256) {
        uint256 balance = _token.balanceOf(this);
        return balance;
    }

    /**
     * @notice Taker role will Accept the agreement and must match the Token balance staked by the Originator
     * @notice see Escrow Pattern (url)
    */
    function setAccepted() public {
        require(msg.sender == _Taker);

        // check the taker escrow address has a balance equal to the Originator


        _Accepted = true;
        emit Accepted(msg.sender, _Subject);
    }

    /// @return subject of agreement
    function getSubject() public view returns (string) {
        return _Subject;
    }

    function isAccepted() public view returns (bool) {
        return _Accepted;
    }

    function isDisputed() public view returns (bool) {
        return _Disputed;
    }

    /// either party may claim to be the beneficiary

    function setBeneficiary() public {

        require(_Determined == false);

        require(msg.sender == _Originator || msg.sender == _Taker);

        _Beneficiary = msg.sender;

        _Determined = true;

        emit Determined(msg.sender);
    }

    function getBeneficiary() public view returns (address) {
        return _Beneficiary;
    }

    /// either the placer or the taker can raise a dispute

    function setDispute() public {

        require(_Disputed == false);

        require(msg.sender == _Originator || msg.sender == _Taker);

        _Determined = false;
        _Disputed = true;

        emit Dispute(msg.sender);
    }

    /// adjudicator settles the contract in one parties favour
    /// if Adjudicator is multi-sig wallet/Adjudicator registry Contract this will be called from that
    function setFavour(address favoured) public {
        require(msg.sender == _Adjudicator);

        require(favoured == _Originator || favoured == _Taker);

        _Beneficiary = favoured;
        _Determined = true;

        emit Favoured(_Adjudicator, _Originator, _Beneficiary);

    }

    /// causes the settlement [separate set of contracts]

    function settle() public {

        require(msg.sender == _Originator || msg.sender == _Taker);

        if (_Disputed == true) {
            /// fees payable to adjudicator
        }

        /// After satisfying all criteria go ahead and pay fees and settle to the beneficiary

        /// settlement needs to come from the parties from their mutual agreement or from adjudication


        emit Settled(_Beneficiary, _Adjudicator);
        // although _Adjudicator might not have been used
    }

    /// cancellation needs to be agreed by both parties and, if an adjudicator was used, will still pay their fees

    function cancel() public view {

        require(msg.sender == _Originator || msg.sender == _Taker);

        /// add sender to list

        /// if list has both parties ...

        if (_Disputed == true) {
            /// fees payable to adjudicator
        }

        /// return balance to parties


        /// kill contract
    }


}