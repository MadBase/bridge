// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

import "./GovernanceStorage.sol";
import "./interfaces/INFTStake.sol";

contract GovernanceManager is GovernanceStorage {
    
    constructor(address Stake_, address MinerStake_) {
        _Stake = INFTStake(Stake_);
        _MinerStake = INFTStake(MinerStake_);
        _threshold = 220000000/2 + 220000000/100;
    }
    
    function propose(address logic_) public {
        Proposal memory proposal = Proposal(true, logic_, 0, block.number + _maxGovernanceLock);
        _proposals[_increment()] = proposal;
    }
    
    function getProposal(uint256 proposalID_) public view returns(Proposal memory) {
        return _proposals[proposalID_];
    }
    
    function execute(uint256 proposalID_) public {
        require(_getCount() >= proposalID_);
        Proposal memory proposal = _proposals[proposalID_];
        require(proposal.voteCount >= _threshold);
        require(proposal.notExecuted == true);
        proposal.notExecuted = false;
        _proposals[proposalID_] = proposal;
        (bool success, ) = proposal.logic.delegatecall(abi.encodeWithSignature("execute()"));
        require(!success, "CALL FAILED");
    }
    
    function _vote(INFTStake staking_, uint256 proposalID_, uint256 tokenID_) internal {
        require(_getCount() >= proposalID_);
        Proposal memory proposal = _proposals[proposalID_];
        require(proposal.blockEndVote >= block.number);
        require(proposal.notExecuted == true);
        require(_votemap[proposalID_][address(staking_)][tokenID_] == false);
        _votemap[proposalID_][address(staking_)][tokenID_] = true;
        uint256 numberShares = staking_.lockPosition(msg.sender, tokenID_, proposal.blockEndVote - block.number + 1);
        proposal.voteCount += numberShares;
        _proposals[proposalID_] = proposal;
    }
    
    function voteAsMiner(uint256 proposalID_, uint256 tokenID_) public {
        INFTStake staking = _MinerStake;
        _vote(staking, proposalID_, tokenID_);
    }
    
    function voteAsStaker(uint256 proposalID_, uint256 tokenID_) public {
        INFTStake staking = _Stake;
        _vote(staking, proposalID_, tokenID_);
    }
}
