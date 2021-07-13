// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;

contract AccusationEvents {
    event InvalidProposer(address indexed validator);
    event MultipleProposals(address indexed validator);
    event MultiplePreVotes(address indexed validator);
    event ContradictoryPreVotes(address indexed validator);
    event ContradictoryPreCommits(address indexed validator);
    event ContradictoryPreVotePreCommits(address indexed validator);
    event InvalidStateTransition(address indexed validator);
    event ConsensusBrokenBlock(address indexed validator);
}

contract AccusationManager is AccusationEvents {

    function AccuseInvalidProposer(bytes calldata proposal) external {
        require(proposal.length > 0, "Empty proposal");
        emit InvalidProposer(msg.sender);
    }

	function AccuseMultipleProposals(bytes calldata proposalA, bytes calldata proposalB) external {
        require(proposalA.length != proposalB.length, "");
        emit MultipleProposals(msg.sender);
    }

	function AccuseMultiplePreVotes(bytes calldata preVoteA, bytes calldata preVoteB) external {
        require(preVoteA.length != preVoteB.length, "");
        emit MultiplePreVotes(msg.sender);
    }

	function AccuseContradictoryPreVotes(bytes calldata preVote, bytes calldata preVoteNil) external {
        require(preVote.length > 0, "");
        require(preVoteNil.length > 0, "");
        emit ContradictoryPreVotes(msg.sender);
    }

	function AccuseContradictoryPreCommits(bytes calldata preCommit, bytes calldata preCommitNil) external {
        require(preCommit.length > 0, "");
        require(preCommitNil.length > 0, "");
        emit ContradictoryPreCommits(msg.sender);
    }

	function AccuseContradictoryPreVotePreCommits(bytes calldata preVote, bytes calldata preCommit) external {
        require(preVote.length > 0, "");
        require(preCommit.length > 0, "");
        emit ContradictoryPreVotePreCommits(msg.sender);
    }

	function AccuseInvalidStateTransition(bytes calldata bclaims, bytes calldata foo) external {
        require(bclaims.length > 0, "");
        require(foo.length > 0, "");
        emit InvalidStateTransition(msg.sender);
    }

	function AccuseConsensusBrokenBlock(bytes calldata blockHeaderA, bytes calldata blockHeaderB) external {
        require(blockHeaderA.length != blockHeaderB.length, "");
        emit ConsensusBrokenBlock(msg.sender);
    }

}
