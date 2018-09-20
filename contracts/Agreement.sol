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

    uint256 private _minimumStake = 1;

    /// for testing the subject is a trivial text statement but will be a Contract adhering to an Interface standard
    string public _Subject;
    bool public _Accepted = false;

    // these are the escrow contracts
    Escrow public _OriginatorEscrow;
    Escrow public _TakerEscrow;

    /**
    * @notice ensures only parties to the contract can effect change on the Agreement
    */

    modifier isParty {
        require(msg.sender == _Originator || msg.sender == _Taker);
        _;
    }

    /**
    * @notice ensures Escrow has been staked before doing anything
    * @dev the Originator has to have staked greater than _minimumStake and, initially, the Taker stake has to be the equal
    */

    modifier isStaked {
        require(_token.balanceOf(address(_OriginatorEscrow)) > _minimumStake );

        require(_token.balanceOf(address(_TakerEscrow)) >= _token.balanceOf(address(_OriginatorEscrow)) );

        _;
    }

    /**
    * @notice ensures only isAdjudicator role can call a function
    */

    modifier isAdjudicator {
        require(msg.sender == _Adjudicator);
        _;
    }




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
     * @param agreement address that emitted the event
     * @param disputingParty who has raised the dispute
    */
    event Dispute(address indexed agreement, address indexed disputingParty);

    /**
     * @notice event to notify who the Adjudicator has favoured in the dispute
     * @param agreement address that emitted the event
     * @param adjudicator that determined the beneficiary
     * @param originator of the agreement
     * @param favouredParty party settled as beneficiary
    */
    event Favoured(address indexed agreement, address adjudicator,address originator, address favouredParty);

    /**
     * @notice event to notify that the Agreement has been settled
     * @param agreement address that emitted the event
     * @param beneficiary who received the proceeds
    */
    event Settled(address indexed agreement, address beneficiary);

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

        _TakerEscrow = new Escrow(token);

    }


    /**
     * @notice Originators escrow contact
     * @return address of the originator escrow contract
     */
    function getOriginatorEscrow() public view returns (address) {
        return _OriginatorEscrow;
    }

    /**
     * @notice Taker escrow contact
     * @return address of the taker escrow contract
    */
    function getTakerEscrow() public view returns (address) {
        return _TakerEscrow;
    }

    /**
     * @notice Taker role will Accept the agreement and must match the Token balance staked by the Originator
     * @notice see Escrow Pattern (url)
     * @dev hmm..does "require" consume gas because that might be undesirable if this function reverts/throws due to the Originator escrow not being staked ?
    */
    function setAccepted() isStaked public {
        require(msg.sender == _Taker);

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

    function setBeneficiary() isParty public {

        require(_Determined == false);

        _Beneficiary = msg.sender;

        _Determined = true;

        emit Determined(msg.sender);
    }

    function getBeneficiary() public view returns (address) {
        return _Beneficiary;
    }

    /// either the placer or the taker can raise a dispute

    function setDispute() isParty public {

        require(_Disputed == false);

        _Determined = false;
        _Disputed = true;

        emit Dispute(this,msg.sender);
    }

    /// adjudicator settles the contract in one parties favour
    /// if Adjudicator is multi-sig wallet/Adjudicator registry Contract this will be called from that
    function setFavour(address favoured) isAdjudicator public {

        _Beneficiary = favoured;
        _Determined = true;

        emit Favoured(this,_Adjudicator, _Originator, _Beneficiary);

    }

    /**
    * @notice This release the escrow to the beneficiary. The logic needs review but it should only release on certain conditions:
    * - todo 48 hours after a beneficiary has been set
    * - a determination is outstanding
    * @dev critical to get the flow and logic right and independently audited or some form of formal verification
    * @dev payment for adjudication service not modelled into this yet
    */

    function settle() public isParty {

        // how do we count blocks and how do we related blocks to time?

//        if (_Disputed == true) {
//            /// fees payable to adjudicator
//        }

        /// After satisfying all criteria go ahead and pay fees and settle to the beneficiary


        if( _Determined == true) {

            _OriginatorEscrow.release(_Beneficiary);

            _TakerEscrow.release(_Beneficiary);

            // todo need a pattern on the client side to monitor events from called contracts

            emit Settled(this, _Beneficiary);

        }


    }

    /// cancellation needs to be agreed by both parties and, if an adjudicator was used, will still pay their fees

    function cancel() isParty public view {

        /// add sender to list

        /// if list has both parties ...

        if (_Disputed == true) {
            /// fees payable to adjudicator
        }

        /// return balance to parties. get balance of each escrow and use token transfer to move both to the beneficiary



        /// kill contract
    }


}