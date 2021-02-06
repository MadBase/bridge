// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;


/// @notice  Collection of all events that are considered for public use of system
interface ValidatorsEvents {

    /// @notice Event emitted when a deposit is received
    event DepositReceived(uint256 depositID, address depositor, uint256 amount);

    /// @notice Event emmitted after taking a snapshot
    event SnapshotTaken(uint32 chainId, uint256 indexed epoch, uint32 height, address indexed validator, bool startingETHDKG);

    /// @notice Events used directly by Validators
    event ValidatorCreated(address indexed validator, address indexed signer, uint256[2] madID);
    event ValidatorJoined(address indexed validator, uint256[2] madID);
    event ValidatorLeft(address indexed validator, uint256[2] pkHash);
    event ValidatorQueued(address indexed validator, uint256[2] pkHash);

    /// @notice Events used by Staking
    event LockedStake(address indexed who, uint256 amount);
    event LockedReward(address indexed who, uint256 amount);
    event UnlockedStake(address indexed who, uint256 amount);
    event UnlockedReward(address indexed who, uint256 amount);
    event BurntStake(address indexed who, uint256 amount);
    event Fined(address indexed who, uint256 amount);
    event RequestedUnlockStake(address indexed who);

    /// @notice Events used by ETHDKG
    event KeyShareSubmission(
        address issuer,
        uint256[2] key_share_G1,
        uint256[2] key_share_G1_correctness_proof,
        uint256[4] key_share_G2
    );

    event RegistrationOpen(
        uint256 dkgStarts,
        uint256 registrationEnds,
        uint256 shareDistributionEnds,
        uint256 disputeEnds,
        uint256 keyShareSubmissionEnds,
        uint256 mpkSubmissionEnds,
        uint256 gpkjSubmissionEnds,
        uint256 gpkjDisputeEnds,
        uint256 dkgComplete);

    event ShareDistribution(
        address issuer,
        uint256 index,
        uint256[] encrypted_shares,
        uint256[2][] commitments
    );

    event ValidatorSet(
        uint8 validatorCount,
        uint256 epoch,
        uint32 ethHeight,
        uint32 madHeight,
        uint256 groupKey0, uint256 groupKey1, uint256 groupKey2, uint256 groupKey3
    );

    event ValidatorMember(
        address account,
        uint256 epoch,
        uint256 index,
        uint256 share0, uint256 share1, uint256 share2, uint256 share3
    );
}