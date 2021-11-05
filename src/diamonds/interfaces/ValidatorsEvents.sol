// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;

import "./StakingEvents.sol";

/// @notice  Collection of all events that are considered for public use of system
interface ValidatorsEvents {

    /// @notice Events used directly by Validators


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