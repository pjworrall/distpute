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

    /**
     * event to report the new agreement creation
     * @param from the creator of the Agreement
     * @param agreement address
    */
    event AgreementCreated(address indexed from, Agreement agreement);

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

        Agreement a = new Agreement(subject,msg.sender,taker,adjudicator,token);
        agreements.push(a);
        emit AgreementCreated(msg.sender, a);
    }

}