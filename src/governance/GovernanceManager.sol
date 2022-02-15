// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.11;

import "./GovernanceStorage.sol";
import "./Governance.sol";
import "../tokens/interfaces/INFTStake.sol";

interface IGovernanceManager {
    function allowedProposal() external view returns(address);
}

contract GovernanceManager is GovernanceStorage {

    constructor(address Stake_, address MinerStake_) {
        _Stake = INFTStake(Stake_);
        _MinerStake = INFTStake(MinerStake_);
        _threshold = (220000000/2 + 220000000/100) * 10**18;
    }

    function propose(address logic_) public returns(uint256 proposalID) {
        require(logic_ != address(0), "GovernanceManager: Logic address must be different from the zero address!");
        Proposal memory proposal = Proposal(false, logic_, 0, block.number + _maxGovernanceLock);
        proposalID = _increment();
        _proposals[proposalID] = proposal;
    }

    function getProposal(uint256 proposalID_) public view returns(Proposal memory) {
        require(_getCount() >= proposalID_, "GovernanceManager: Invalid proposal ID");
        return _proposals[proposalID_];
    }

    function getStakeTokenAddress() public view returns(address) {
        return address(_Stake);
    }

    function getMinerStakeTokenAddress() public view returns(address) {
        return address(_MinerStake);
    }

    function isProposalExecuted(uint256 proposalID_) public view returns(bool) {
        require(_getCount() >= proposalID_, "GovernanceManager: Invalid proposal ID");
        return _proposals[proposalID_].executed;
    }

    function execute(uint256 proposalID_) public {
        require(_getCount() >= proposalID_, "GovernanceManager: Invalid proposal ID");
        Proposal memory proposal = _proposals[proposalID_];
        require(proposal.voteCount >= _threshold, "GovernanceManager: Proposal does not have enough votes");
        require(proposal.executed == false, "GovernanceManager: This proposal has been executed already");
        proposal.executed = true;
        _proposals[proposalID_] = proposal;
        (bool success, ) = proposal.logic.delegatecall(abi.encodeWithSignature("execute(address)", proposal.logic));
        require(success, "GovernanceManager: CALL FAILED to proposal execute()");
        // Cleaning the allowedProposal state in case it was set by the Proposal
        allowedProposal = address(0x0);
    }

    function voteAsMiner(uint256 proposalID_, uint256 tokenID_) public {
        INFTStake staking = _MinerStake;
        _vote(staking, proposalID_, tokenID_);
    }

    function voteAsStaker(uint256 proposalID_, uint256 tokenID_) public {
        INFTStake staking = _Stake;
        _vote(staking, proposalID_, tokenID_);
    }

    function _vote(INFTStake staking_, uint256 proposalID_, uint256 tokenID_) internal {
        require(_getCount() >= proposalID_, "GovernanceManager: Invalid proposal ID");
        Proposal memory proposal = _proposals[proposalID_];
        require(proposal.blockEndVote >= block.number, "GovernanceManager: Cannot vote on this proposal anymore");
        require(proposal.executed == false, "GovernanceManager: This proposal has been executed already");
        require(_votemap[proposalID_][address(staking_)][tokenID_] == false, "GovernanceManager: You already voted on this proposal");
        _votemap[proposalID_][address(staking_)][tokenID_] = true;
        uint256 numberShares = staking_.lockPosition(msg.sender, tokenID_, proposal.blockEndVote - block.number + 1);
        proposal.voteCount += numberShares;
        _proposals[proposalID_] = proposal;
    }
}
