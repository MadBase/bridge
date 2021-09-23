// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

import "../interfaces/Token.sol";

import "./SnapshotsLibrary.sol";

import "../Constants.sol";
import "../Registry.sol";
import "../SafeMath.sol";

library StakingLibrary {
    bytes32 constant STORAGE_LOCATION = keccak256("staking.storage");

    using SafeMath for uint256;

    struct RewardDetails {
        uint256 amountReward;
        uint256 unlockEpoch;
    }

    struct StakeDetails {
        uint256 amountStaked;
        bool requestedStakeWithdrawal;
        uint256 stakeWithdrawalEpoch;

        uint256 unlockedReward;
        uint256 unlockedStake;
        RewardDetails[] rewards;
    }

    struct StakingStorage {
        uint256 minimumStake;   // 1_000_000;
        uint256 majorStakeFine; // 200_000;
        uint256 minorStakeFine; // 50_000;
        uint256 rewardAmount;   // 1_000;
        uint256 rewardBonus;    // 1_000;
        uint256 epochDelay;     // 2

        // Actual staking functionality
        uint256 utilityTokenBalance;

        BasicERC20 stakingToken;
        MintableERC20 utilityToken;

        mapping(address => StakeDetails) details;

        address ethdkgAddress;
    }

    function stakingStorage() internal pure returns (StakingStorage storage sv) {
        bytes32 position = STORAGE_LOCATION;
        assembly { // solium-disable-line
            sv.slot := position
        }
    }

    /// @notice Events used by Staking
    event LockedStake(address indexed who, uint256 amount);
    event LockedReward(address indexed who, uint256 amount);
    event UnlockedStake(address indexed who, uint256 amount);
    event UnlockedReward(address indexed who, uint256 amount);
    event Burnt(address indexed who, uint256 amount);
    event Fined(address indexed who, bytes32 why, uint256 amount);
    event RequestedUnlockStake(address indexed who);

    // Staking token getter/setter
    function stakingToken() internal view returns (address) {
        return address(stakingStorage().stakingToken);
    }

    function setStakingToken(address _stakingToken) internal {
        stakingStorage().stakingToken = BasicERC20(_stakingToken);
    }

    // Utility token getter/setter
    function utilityToken() internal view returns (address) {
        return address(stakingStorage().utilityToken);
    }

    function setUtilityToken(address _utilityToken) internal {
        stakingStorage().utilityToken = MintableERC20(_utilityToken);
    }

    // Minimum Stake getter/setter
    function minimumStake() internal view returns (uint256) {
        return stakingStorage().minimumStake;
    }

    function setMinimumStake(uint256 _minimumStake) internal {
        stakingStorage().minimumStake = _minimumStake;
    }

    // Major Stake Fine getter/setter
    function majorStakeFine() internal view returns (uint256) {
        return stakingStorage().majorStakeFine;
    }

    function setMajorStakeFine(uint256 _majorStakeFine) internal {
        stakingStorage().majorStakeFine = _majorStakeFine;
    }

    // Reward Amount getter/setter
    function rewardAmount() internal view returns (uint256) {
        return stakingStorage().rewardAmount;
    }

    function setRewardAmount(uint256 _rewardAmount) internal {
        stakingStorage().rewardAmount = _rewardAmount;
    }

    // Reward Bonus getter/setter
    function rewardBonus() internal view returns (uint256) {
        return stakingStorage().rewardBonus;
    }

    function setRewardBonus(uint256 _rewardBonus) internal {
        stakingStorage().rewardBonus = _rewardBonus;
    }

    //
    //
    //

    function lockStakeFor(address who, uint256 amount) internal returns (bool) {
        StakingStorage storage ss = stakingStorage();
        StakeDetails storage detail = ss.details[who];

        detail.amountStaked = detail.amountStaked.add(amount);

        emit LockedStake(who, amount);

        require(ss.stakingToken.transferFrom(who, address(this), amount), "Transfer failed");

        return true;
    }

    function balanceRewardFor(address who) internal view returns (uint256 rewardBalance) {
        StakingStorage storage ss = stakingStorage();
        RewardDetails[] storage rewards = ss.details[who].rewards;

        for (uint256 idx; idx<rewards.length; idx++) {
            rewardBalance = rewardBalance.add(rewards[idx].amountReward);
        }
    }

    function balanceStakeFor(address who) internal view returns (uint256) {
        return stakingStorage().details[who].amountStaked;
    }

    function balanceUnlockedFor(address who) internal view returns (uint256) {
        return stakingStorage().details[who].unlockedStake;
    }

    function balanceUnlockedRewardFor(address who) internal view returns (uint256) {
        return stakingStorage().details[who].unlockedReward;
    }

    struct Reward {
        uint256 amount;
        bool defined;
    }

    function lockRewardFor(address who, uint256 amountReward, uint256 unlockEpoch) internal returns (bool) {
        StakingStorage storage ss = stakingStorage();
        StakeDetails storage detail = ss.details[who];

        // TODO Should indicate what the reward is for to make sure we can't double reward

        RewardDetails memory reward;
        reward.amountReward = amountReward;
        reward.unlockEpoch = unlockEpoch;

        detail.rewards.push(reward);

        ss.utilityToken.mint(address(this), amountReward); // TODO replace with a pooling mechanism so not every reward requires a mint

        emit LockedReward(who, amountReward);

        return detail.requestedStakeWithdrawal;
    }

    // Burns all tokens staked
    function burn(address who) internal returns (bool) {
        StakingStorage storage ss = stakingStorage();
        StakeDetails storage detail = ss.details[who];
        uint256 amount = detail.amountStaked;

        // TODO Don't burn, we want to send it somewhere
        detail.amountStaked = 0;

        emit Burnt(who, amount);

        return true;
    }

    // TODO We need to record the _why_ and make sure it isn't used again in either this or the 2 previous
    //      epochs.
    function fine(address who, bytes32 why, uint256 amount) internal returns (bool) {
        StakingStorage storage ss = stakingStorage();
        StakeDetails storage detail = ss.details[who];

        detail.amountStaked = detail.amountStaked.sub(amount);

        emit Fined(who, why, amount);

        return true;
    }

    function unlockRewardFor(address who) internal returns (bool) {

        StakingStorage storage ss = stakingStorage();
        StakeDetails storage detail = ss.details[who];

        RewardDetails[] storage rewards = detail.rewards;

        uint256 rewardUnlocked;

        // TODO Optimize?
        // Filty filthy code. Loop over the rewards and unlock what is scheduled.
        uint256 idx=0;
        while (idx<rewards.length) {
            RewardDetails storage reward = rewards[idx];

            if (reward.unlockEpoch <= ChainStatusLibrary.epoch()) {
                rewardUnlocked = rewardUnlocked + reward.amountReward;

                // copy last reward in array into this spot; toss old reward; don't move on yet
                rewards[idx] = rewards[rewards.length-1];
                rewards.pop();
                continue;
            }

            idx++;
        }

        detail.unlockedReward = detail.unlockedReward + rewardUnlocked;

        return true;
    }

    function requestUnlockStakeFor(address who) internal {
        StakingStorage storage ss = stakingStorage();
        StakeDetails storage detail = ss.details[who];

        require(detail.amountStaked > 0, "No stake");

        detail.requestedStakeWithdrawal = true;
        detail.stakeWithdrawalEpoch = ChainStatusLibrary.epoch() + ss.epochDelay;

        emit RequestedUnlockStake(who);
    }

    function unlockStakeFor(address who, uint256 amount) internal returns (bool) {
        StakingStorage storage ss = stakingStorage();
        StakeDetails storage detail = ss.details[who];

        require(detail.requestedStakeWithdrawal, "Stake unlock not requested");
        require(detail.amountStaked >= amount, "Stake unlock requested greater than stake");
        require(detail.stakeWithdrawalEpoch <= ChainStatusLibrary.epoch(), "Not ready");

        detail.unlockedStake = detail.unlockedStake.add(amount);
        detail.amountStaked = detail.amountStaked.sub(amount);
        detail.requestedStakeWithdrawal = false; // You get one unlock per request

        emit UnlockedStake(who, amount);

        return true;
    }

    function withdrawReward(uint256 amount) internal returns (bool) {
        StakingStorage storage ss = stakingStorage();
        StakeDetails storage detail = ss.details[msg.sender];

        require(detail.unlockedReward >= amount, "Insufficient unlocked balance.");

        detail.unlockedReward = detail.unlockedReward.sub(amount);

        ss.utilityToken.transfer(msg.sender, amount);

        return true;
    }

    function withdrawFor(address who, uint256 amount) internal returns (bool) {
        StakingStorage storage ss = stakingStorage();
        StakeDetails storage detail = ss.details[who];

        require(detail.unlockedStake >= amount, "Insufficient unlocked balance.");

        detail.unlockedStake = detail.unlockedStake.sub(amount);

        ss.stakingToken.transfer(who, amount);

        return true;
    }

    function setEpochDelay(uint256 _epochDelay) internal {
        StakingStorage storage ss = stakingStorage();

        ss.epochDelay = _epochDelay;
    }


}