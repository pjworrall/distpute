pragma solidity ^0.4.22;


contract Agreement {

    address private _PlacingCounterParty;
    address private _AcceptingCounterParty;

    address private _Beneficiary;

    bool private _Determined;

    string private _subject;
    bool private _accepted = false;

    event Accepted(address indexed acceptingCounterParty, string subject);
    event Determined(address indexed determiningCounterParty);

    constructor(string subject, address acceptingCounterParty) public {
        _PlacingCounterParty = msg.sender;
        _subject = subject;
        _AcceptingCounterParty = acceptingCounterParty;
    }

    function setAccepted() public {
        require(msg.sender == _AcceptingCounterParty);
        _accepted = true;
        emit Accepted(msg.sender,_subject);
    }

    function getSubject() public view returns(string) {
        return _subject;
    }

    function isAccepted() public view returns(bool) {
        return _accepted;
    }

    function setBeneficiary() public {
        require( msg.sender == _PlacingCounterParty || msg.sender == _AcceptingCounterParty);

        require( _Determined == false );

        _Beneficiary = msg.sender;

        _Determined = true;

        emit Determined(msg.sender);
    }

    function getBeneficiary() public view returns(address) {
        return _Beneficiary;
    }



}