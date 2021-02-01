// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.6.4;
pragma experimental ABIEncoderV2;

import "./AccessControlLibrary.sol";
import "./StakingValuesLibrary.sol";

import "../Constants.sol";

contract StakingValuesFacet is AccessControlled, Constants {

    // Minimum Stake getter/setter
    function minimumStake() external view returns (uint256) {
        StakingValuesLibrary.StakingValuesStorage storage ss = StakingValuesLibrary.stakingValuesStorage();

        return ss.minimumStake;
    }

    function setMinimumStake(uint256 _minimumStake) external onlyOperator {
        StakingValuesLibrary.StakingValuesStorage storage ss = StakingValuesLibrary.stakingValuesStorage();

        ss.minimumStake = _minimumStake;
    }

    // Major Stake Fine getter/setter
    function majorStakeFine() external view returns (uint256) {
        StakingValuesLibrary.StakingValuesStorage storage ss = StakingValuesLibrary.stakingValuesStorage();

        return ss.majorStakeFine;
    }

    function setMajorStakeFine(uint256 _majorStakeFine) external onlyOperator {
        StakingValuesLibrary.StakingValuesStorage storage ss = StakingValuesLibrary.stakingValuesStorage();

        ss.majorStakeFine = _majorStakeFine;
    }

    // Minor Stake Fine getter/setter
    function minorStakeFine() external view returns (uint256) {
        StakingValuesLibrary.StakingValuesStorage storage ss = StakingValuesLibrary.stakingValuesStorage();

        return ss.minorStakeFine;
    }

    function setMinorStakeFine(uint256 _minorStakeFine) external onlyOperator {
        StakingValuesLibrary.StakingValuesStorage storage ss = StakingValuesLibrary.stakingValuesStorage();

        ss.minorStakeFine = _minorStakeFine;
    }

    // Reward Amount getter/setter
    function rewardAmount() external view returns (uint256) {
        StakingValuesLibrary.StakingValuesStorage storage ss = StakingValuesLibrary.stakingValuesStorage();

        return ss.rewardAmount;
    }

    function setRewardAmount(uint256 _rewardAmount) external onlyOperator {
        StakingValuesLibrary.StakingValuesStorage storage ss = StakingValuesLibrary.stakingValuesStorage();

        ss.rewardAmount = _rewardAmount;
    }

    // Reward Bonus getter/setter
    function rewardBonus() external view returns (uint256) {
        StakingValuesLibrary.StakingValuesStorage storage ss = StakingValuesLibrary.stakingValuesStorage();

        return ss.rewardBonus;
    }
    function setRewardBonus(uint256 _rewardBonus) external onlyOperator {
        StakingValuesLibrary.StakingValuesStorage storage ss = StakingValuesLibrary.stakingValuesStorage();

        ss.rewardBonus = _rewardBonus;
    }

}