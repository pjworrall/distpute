pragma solidity ^0.4.22;

import "./Agreement.sol";
import "./Escrow.sol";

/**
 * @title Factory
 * @author Paul Worrall
 * @notice This is part of the DistPute Smart Contract framework
 * @dev First stab at a Factory for instantiating Agreements
 */

contract Factory {

    /// this won't necessarily be used in a production version
    address[] public agreements;

    //mapping(_KeyType => _ValueType) public escrows;

    /**
     * event to report the new agreement creation
     * @param from the creator of the Agreement
     * @param agreement address
    */
    event AgreementCreated(address indexed from, Agreement agreement);

    /**
    * event to report an escrow account was created
    * @param originator who requested the Agreement
    * @param escrow contract for the originator
    */
    event EscrowCreated(address indexed agreement, address indexed originator, address indexed escrow);

    function getAgreementCount() public view returns(uint agreementCount)
    {
        return agreements.length;
    }

    /**
    * @notice This is the Factory for Agreements in the DistPute Smart Contract framework.
    * @dev It ensures Agreements are not vulnerable to compromise because they have to be
    * @dev created from blockchain protected code. The Factory will also allocate the first set
    * @dev of Adjudicators picked from the Register. Note: no Adjudicator skill categories yet.
    */

    function newAgreement(string subject, address taker, address adjudicator, address token) public
    {
        /// @todo need to pick a list of adjudicators from the Register and pass as array argument once supported

        Agreement agreement = new Agreement(subject,msg.sender,taker,adjudicator,token);
        agreements.push(agreement);

        emit AgreementCreated(msg.sender, agreement);

        Escrow escrow = new Escrow(token);

        emit EscrowCreated(agreement,msg.sender,escrow);
    }

}