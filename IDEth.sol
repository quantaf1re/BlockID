pragma solidity ^0.4.23;
contract IDEth {

    Person[] public persons;
    uint256 count = 0;

    function getCount() public view returns (uint256){
        return count;
    }

    struct Person{
        address addr;
        string ipfsHash;
        uint256 endorsementsNum;
        uint256 revokedEndorsNum;
        mapping(uint256 => Endorsement) endorsements;
    }

    //Endorsements should carry a signed message stating the nature of endorsement and the address used
    struct Endorsement{
        string message;
        address addr;
    }

    //Function to add new user - returns false if user already exists
    function makeUser(string _ipfsHash) public returns (bool) {
        for (uint256 i = 0; i < persons.length; i++) {
            if(msg.sender == persons[i].addr){
                return false;
            }
        }
        count = persons.push(Person({addr: msg.sender, ipfsHash: _ipfsHash, endorsementsNum: 0, revokedEndorsNum: 0}));
        return true;
    }

    //Return data tied to msg.sender
    function fetchIpfs() public view returns (string) {
        for(uint256 i; i < persons.length; i++){
            if(msg.sender == persons[i].addr){
                return persons[i].ipfsHash;
            }
        }
        return "User not found";
    }

    //Add an endorsement with a signed message
    function addEndorsement(address _addr, string str) public returns (bool) {
        for (uint256 i = 0; i < persons.length; i++) {
            if (persons[i].addr == _addr) {
                persons[i].endorsements[persons[i].endorsementsNum].addr = msg.sender;
                persons[i].endorsements[persons[i].endorsementsNum].message = str;
                persons[i].endorsementsNum++;
                return true;
            }
        }
        return false;
    }


    function getEndorsementNum(address _addr) public view returns (uint256) {
        for (uint256 i = 0; i < persons.length; i++) {
            if (persons[i].addr == _addr) {
                return persons[i].endorsementsNum;
            }
        }
        return 0;
    }

    function getEndorsementMessage(address _addr) public view returns (string) {
        for (uint256 i = 0; i < persons.length; i++) {
            if (persons[i].addr == _addr) {
                for (uint j = 0; j < persons[i].endorsementsNum; j++) {
                    if (_addr == persons[i].endorsements[j].addr) {
                        return persons[i].endorsements[j].message;
                    }
                }

            }
        }
        return "User not found";
    }
}
