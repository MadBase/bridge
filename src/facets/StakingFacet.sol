// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.6.4;
pragma experimental ABIEncoderV2;

import "../interfaces/StakingEvents.sol";

import "./AccessControlLibrary.sol";
import "./StakingStorageLibrary.sol";

import "../Constants.sol";

contract StakingFacet is AccessControlled, Constants, StakingEvents {

    // Minimum Stake getter/setter
    function minimumStake() external view returns (uint256) {
        StakingStorageLibrary.StakingStorage storage ss = StakingStorageLibrary.stakingStorage();

        return ss.minimumStake;
    }

    function setMinimumStake(uint256 _minimumStake) external onlyOperator {
        StakingStorageLibrary.StakingStorage storage ss = StakingStorageLibrary.stakingStorage();

        ss.minimumStake = _minimumStake;
    }

    // Major Stake Fine getter/setter
    function majorStakeFine() external view returns (uint256) {
        StakingStorageLibrary.StakingStorage storage ss = StakingStorageLibrary.stakingStorage();

        return ss.majorStakeFine;
    }

    function setMajorStakeFine(uint256 _majorStakeFine) external onlyOperator {
        StakingStorageLibrary.StakingStorage storage ss = StakingStorageLibrary.stakingStorage();

        ss.majorStakeFine = _majorStakeFine;
    }

    // Minor Stake Fine getter/setter
    function minorStakeFine() external view returns (uint256) {
        StakingStorageLibrary.StakingStorage storage ss = StakingStorageLibrary.stakingStorage();

        return ss.minorStakeFine;
    }

    function setMinorStakeFine(uint256 _minorStakeFine) external onlyOperator {
        StakingStorageLibrary.StakingStorage storage ss = StakingStorageLibrary.stakingStorage();

        ss.minorStakeFine = _minorStakeFine;
    }

    // Reward Amount getter/setter
    function rewardAmount() external view returns (uint256) {
        StakingStorageLibrary.StakingStorage storage ss = StakingStorageLibrary.stakingStorage();

        return ss.rewardAmount;
    }

    function setRewardAmount(uint256 _rewardAmount) external onlyOperator {
        StakingStorageLibrary.StakingStorage storage ss = StakingStorageLibrary.stakingStorage();

        ss.rewardAmount = _rewardAmount;
    }

    // Reward Bonus getter/setter
    function rewardBonus() external view returns (uint256) {
        StakingStorageLibrary.StakingStorage storage ss = StakingStorageLibrary.stakingStorage();

        return ss.rewardBonus;
    }
    function setRewardBonus(uint256 _rewardBonus) external onlyOperator {
        StakingStorageLibrary.StakingStorage storage ss = StakingStorageLibrary.stakingStorage();

        ss.rewardBonus = _rewardBonus;
    }

}