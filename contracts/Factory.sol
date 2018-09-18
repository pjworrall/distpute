pragma solidity ^0.4.22;

import "./Agreement.sol";

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
     * @param escrow contract for the originator
    */
    event AgreementCreated(address indexed from, Agreement agreement, address escrow);

    /**
    * @notice This is the Factory for Agreements in the DistPute Smart Contract framework.
    * @dev It ensures Agreements are not vulnerable to compromise because they have to be
    * created from blockchain protected code.
    * @dev The subject at some point will become a more sophisticated object but should still produce a binary determination
    * @param subject is just a string describing what the parties are taking positions on
    * @param taker is the address of the counter party
    * @param adjudicator is the address of the contract or person who will settle a dispute
    * @param token is the address of the ERC20 token being exchanged
    */

    function newAgreement(string subject, address taker, address adjudicator, address token) public
    {
        /// @todo need to pick a list of adjudicators from the Register and pass as array argument once supported

        Agreement agreement = new Agreement(subject,msg.sender,taker,adjudicator,token);
        agreements.push(agreement);

        emit AgreementCreated(msg.sender, agreement,agreement.getOriginatorEscrow());

    }

    function getAgreementCount() public view returns(uint agreementCount)
    {
        return agreements.length;
    }


}