// SPDX-License-Identifier: UNLICENSED
pragma Solidity >=0.5.0 <0.9.0

contract voting{

    struct Candidate{
        string name;
        uint256 voteCount;
    }

    Candidate[] public candidates;
    address owner;

    mapping(address=>bool) public voters;

    uint256 public votingStart;
    uint256 public votingEnd;

    constructor(string[] memory _name,uint256 durationInMinutes){
        owner=msg.sender;
        votingStart=block.timeStamp;
        votingEnd=block.timestamp+(durationInMinutes *1 minutes);

        for(uint256 i=0;i<_name.length;i++){
            candidates,push(Candidate({
                name:_name[i];
                voteCount:0;
            }))
        }
    }

    modifier onlyOwner{
        require(msg.sender==owner);
        _;
    }


    function addCandidate(string memory name) public onlyOwner{
        candidates.push(Candidate({
            name:name;
            voteCount:0
        }))
    }

    function vote(uint256 _candidateIndex) public{
        require(!voters[msg.sender],"you have already voted");
        require(_candidateIndex<candidates.length,"invalid index");

        candidates[_candidateIndex].voteCount++;
        voters[msg.sender]=true;
    }

    function getAllVotesOfCandidates() public view returns(Candidate[] memory){
        return candidates;
    }

    function getVotingStatus() public view returns(bool){
        return(block.timestamp>=votingStart && block.timestamp<votingEnd);
    }

    function getRemainingTime() public view returns(uint256){
        require(block.timestamp>=votingStart,"voting has not started yet");

        if(block.timestamp>=votingEnd){
            return 0;
        }

        return votingEnd-block.timestamp;
    }
}