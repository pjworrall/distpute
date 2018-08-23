pragma solidity ^0.4.22;


contract Agreement {

    address private _PlacingCounterParty;
    address private _AcceptingCounterParty;

    string private _subject;
    bool private _accepted = false;

    event Accepted(address indexed acceptingCounterParty, string subject);

    constructor(string subject, address acceptingCounterParty) public {
        _PlacingCounterParty = msg.sender;
        _subject = subject;
        _AcceptingCounterParty = acceptingCounterParty;
    }

    function accept() public {
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


}