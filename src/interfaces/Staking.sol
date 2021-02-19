// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;

import "./StakingEvents.sol";

import "../Registry.sol";

interface Staking is StakingEvents {

    function initializeStaking(Registry registry) external;

    function burn(address who) external;

    function majorFine(address who) external;

    function minorFine(address who) external;

    function minimumStake() external view returns (uint256);

    function setMinimumStake(uint256 _minimumStake) external;

    // Major Stake Fine getter/setter
    function majorStakeFine() external view returns (uint256);

    function setMajorStakeFine(uint256 _majorStakeFine) external;

    // Minor Stake Fine getter/setter
    function minorStakeFine() external view returns (uint256);

    function setMinorStakeFine(uint256 _minorStakeFine) external;

    // Reward Amount getter/setter
    function rewardAmount() external view returns (uint256);

    function setRewardAmount(uint256 _rewardAmount) external;

    // Reward Bonus getter/setter
    function rewardBonus() external view returns (uint256);

    function setRewardBonus(uint256 _rewardBonus) external;


    function lockStake(uint256 amount) external returns (bool);

    // Called by Validators contract on behalf of validator
    function lockStakeFor(address who, uint256 amount) external returns (bool);

    function balanceReward() external view returns (uint256);

    function balanceRewardFor(address who) external view returns (uint256);

    function balanceStake() external view returns (uint256);

    function balanceStakeFor(address who) external view returns (uint256);


    function balanceUnlocked() external view returns (uint256);

    function balanceUnlockedFor(address who) external view returns (uint256);

    function balanceUnlockedReward() external view returns (uint256);

    function balanceUnlockedRewardFor(address who) external view returns (uint256);

    function lockRewardFor(address who, uint256 amountReward, uint256 unlockEpoch) external returns (bool);

    // Called by ETHDKG + Validation contracts to burn all stake of a malicious validator
    function burnStake(address who, uint256 amount) external returns (bool);

    function fine(address who, uint256 amount) external returns (bool);

    function unlockReward() external returns (bool);

    function unlockRewardFor(address who) external returns (bool);

    //
    function requestUnlockStake() external;

    function requestUnlockStakeFor(address who) external;

    //
    function unlockStake(uint256 amount) external returns (bool);

    function unlockStakeFor(address who, uint256 amount) external returns (bool);

    function withdrawReward(uint256 amount) external returns (bool);

    function withdraw(uint256 amount) external returns (bool);

    function withdrawFor(address who, uint256 amount) external returns (bool);

    function setEpochDelay(uint256 _epochDelay) external;
}