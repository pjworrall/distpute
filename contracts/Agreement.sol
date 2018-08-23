pragma solidity ^0.4.22;


contract Agreement {

    address private _Placer;
    address private _Taker;
    address private _Adjudicator;

    address private _Beneficiary;

    bool private _Determined = false;
    bool private _Disputed = false;

    // for testing the subject is a trivial text statement but will be a Contract adhering to an Interface standard
    string private _Subject;
    bool private _Accepted = false;

    event Accepted(address indexed taker, string subject);
    event Determined(address indexed determiningParty);
    event Dispute(address indexed disputingParty);
    event Favoured(address indexed favouredParty);
    event Settled(address indexed beneficiary, address indexed adjudicator);

    // this Contract would be produced by a Factory that would ensure the Adjudicator address is safely supplied
    // the adjudicator could be a Contract address of a Multi-Sig wallet of course
    constructor(string subject, address taker, address adjudicator) public {
        _Placer = msg.sender;
        _Subject = subject;
        _Taker = taker;
        _Adjudicator = adjudicator;
    }

    function setAccepted() public {
        require(msg.sender == _Taker);
        _Accepted = true;
        emit Accepted(msg.sender,_Subject);
    }

    function getSubject() public view returns(string) {
        return _Subject;
    }

    function isAccepted() public view returns(bool) {
        return _Accepted;
    }

    function isDisputed() public view returns(bool) {
        return _Disputed;
    }

    // either party may claim to be the beneficiary

    function setBeneficiary() public {

        require( _Determined == false );

        require( msg.sender == _Placer || msg.sender == _Taker);

        _Beneficiary = msg.sender;

        _Determined = true;

        emit Determined(msg.sender);
    }

    function getBeneficiary() public view returns(address) {
        return _Beneficiary;
    }

    // either the placer or the taker can raise a dispute

    function setDispute() public {

        require( _Disputed == false );

        require( msg.sender == _Placer || msg.sender == _Taker);

        _Determined = false;
        _Disputed = true;

        emit Dispute(msg.sender);
    }

    // adjudicator settles the contract in one parties favour
    // if Adjudicator is multi-sig wallet/Adjudicator registry Contract this will be called from that
    function setFavour(address favoured) public {
        require( msg.sender == _Adjudicator );

        require(favoured == _Placer || favoured == _Taker);

        _Beneficiary = favoured;
        _Determined = true;

        emit Favoured(favoured);

    }

    // causes the settlement [separate set of contracts]

    function settle() public {

        require( msg.sender == _Placer || msg.sender == _Taker);

        if(_Disputed == true) {
            // fees payable to adjudicator
        }

        // After satisfying all criteria go ahead and pay fees and settle to the beneficiary

        // settlement needs to come from the parties from their mutual agreement or from adjudication


        emit Settled(_Beneficiary,_Adjudicator); // although _Adjudicator might not have been used
    }

    // cancellation needs to be agreed by both parties and, if an adjudicator was used, will still pay their fees

    function cancel() public view {

        require( msg.sender == _Placer || msg.sender == _Taker);

        if(_Disputed == true) {
            // fees payable to adjudicator
        }

        // balance returned to parties

        // kill contract
    }
    

}