// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

import "../tokens/utils/AtomicCounter.sol";
import "./GovernanceMaxLock.sol";
import "../tokens/interfaces/INFTStake.sol";

abstract contract GovernanceStorage is AtomicCounter, GovernanceMaxLock {

    struct Proposal {
        bool executed;
        address logic;
        uint256 voteCount;
        uint256 blockEndVote;
    }

    // Staking contract
    INFTStake _Stake;
    // MinerStaking contract
    INFTStake _MinerStake;
    // number of votes needed to enact a change
    uint256 _threshold;
    // proposalID to tokenID to bool
    mapping(uint256 => mapping(address => mapping(uint256 => bool))) _votemap;
    // proposalID to Proposal
    mapping(uint256 => Proposal) _proposals;
    // allowedProposal enables an arbitrary address/contract to call methods with governance role
    address public allowedProposal;
}