// SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.5.15;

import "ds-stop/stop.sol";

import "./Constants.sol";
import "./Registry.sol";
import "./SafeMath.sol";
import "./SimpleAuth.sol";
import "./Token.sol";
import "./Validators.sol";

interface StakeManager {

    // Set's the most recently completed epoch
    function setCurrentEpoch(uint256) external;

    // Stake related
    function lockStake(uint256) external returns (bool);
    function lockStakeFor(address, uint256) external returns (bool);

    function balanceStake() external view returns (uint256);
    function balanceStakeFor(address) external view returns (uint256);

    function unlockStake(uint256) external returns (bool);
    function unlockStakeFor(address, uint256) external returns (bool);

    // Reward related
    function lockRewardFor(address, uint256, uint256) external returns (bool);

    function balanceReward() external view returns (uint256);
    function balanceRewardFor(address) external view returns (uint256);

    function unlockReward() external returns (bool);
    function unlockRewardFor(address) external returns (bool);

    // Unlocked
    function balanceUnlocked() external view returns (uint256);
    function balanceUnlockedFor(address) external view returns (uint256);

    // Punishment
    function burnStake(address, uint256) external returns (bool);
    function fine(address, uint256) external returns (bool);

    // There is no distinction between unlocked stake and unlocked reward
    function withdraw(uint256) external returns (bool);
    function withdrawFor(address, uint256) external returns (bool);
}

contract StakingEvents {
    event LockedStake(address indexed who, uint256 amount);
    event LockedReward(address indexed who, uint256 amount);
    event UnlockedStake(address indexed who, uint256 amount);
    event UnlockedReward(address indexed who, uint256 amount);
    event BurntStake(address indexed who, uint256 amount);
    event Fined(address indexed who, uint256 amount);
    event RequestedUnlockStake(address indexed who);
}

contract Staking is Constants, RegistryClient, StakeManager, StakingEvents, SimpleAuth, DSStop {

    using SafeMath for uint256;

    Registry registry;
    BasicERC20 stakingToken;
    MintableERC20 utilityToken;
    Validators validators;

    uint256 utilityTokenBalance;

    uint256 public currentEpoch;
    uint256 public epochDelay = 2;

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
    mapping(address => StakeDetails) details;

    //
    constructor(Registry registry_) public {
        registry = registry_;
    }

    function reloadRegistry() public onlyOperator {

        address stakingTokenAddr = registry.lookup(STAKING_TOKEN);
        stakingToken = BasicERC20(stakingTokenAddr);
        require(stakingTokenAddr != address(0), "invalid address for stakingToken");

        address utilityTokenAddr = registry.lookup(UTILITY_TOKEN);
        utilityToken = MintableERC20(utilityTokenAddr);
        require(utilityTokenAddr != address(0), "invalid address for utilityToken");

        address validatorsAddr = registry.lookup(VALIDATORS_CONTRACT);
        validators = Validators(validatorsAddr);
        require(validatorsAddr != address(0), "invalid address for validators");

        grantOperator(address(validators));
    }

    // Used for unlocking
    function setCurrentEpoch(uint256 epoch) external onlyOperator stoppable {
        currentEpoch = epoch;
    }

    // Called directly by validator to initiate a stake
    function lockStake(uint256 amount) external stoppable returns (bool) {
        return _lockStakeFor(msg.sender, amount);
    }

    // Called by Validators contract on behalf of validator
    function lockStakeFor(address who, uint256 amount) external onlyOperator stoppable returns (bool) {
        return _lockStakeFor(who, amount);
    }

    function _lockStakeFor(address who, uint256 amount) private returns (bool) {
        StakeDetails storage detail = details[who];

        detail.amountStaked = detail.amountStaked.add(amount);

        emit LockedStake(who, amount);

        require(stakingToken.transferFrom(who, address(this), amount), "Transfer failed");

        return true;
    }

    function balanceReward() external view returns (uint256) {
        return _balanceRewardFor(msg.sender);
    }

    function balanceRewardFor(address who) external view returns (uint256) {
        return _balanceRewardFor(who);
    }

    function _balanceRewardFor(address who) private view returns (uint256) {
        uint256 rewardBalance;

        // TODO Avert your eyes
        RewardDetails[] storage rewards = details[who].rewards;
        for (uint256 idx; idx<rewards.length; idx++) {
            rewardBalance = rewardBalance.add(rewards[idx].amountReward);
        }

        return rewardBalance;
    }

    function balanceStake() external view returns (uint256) {
        return _balanceStakeFor(msg.sender);
    }

    function balanceStakeFor(address who) external view returns (uint256) {
        return _balanceStakeFor(who);
    }

    function _balanceStakeFor(address who) private view returns (uint256) {
        return details[who].amountStaked;
    }

    function balanceUnlocked() external view returns (uint256) {
        return _balanceUnlockedFor(msg.sender);
    }

    function balanceUnlockedFor(address who) external view returns (uint256) {
        return _balanceUnlockedFor(who);
    }

    function _balanceUnlockedFor(address who) private view returns (uint256) {
        return details[who].unlockedStake;
    }

    function balanceUnlockedReward() external view returns (uint256) {
        return _balanceUnlockedRewardFor(msg.sender);
    }

    function balanceUnlockedRewardFor(address who) external view returns (uint256) {
        return _balanceUnlockedRewardFor(who);
    }

    function _balanceUnlockedRewardFor(address who) private view returns (uint256) {
        return details[who].unlockedReward;
    }

    struct Reward {
        uint256 amount;
        bool defined;
    }

    // Alternative for rewards
    // mapping(uint256 => mapping(address => Reward)) recipientRewards; // mapping (lockUntilEpoch => mapping (address => amount & definied))
    // mapping(uint256 => address[]) recipients; // mapping (lockUntilEpoch => addresses of recipients)
    // uint256 public tokenBatchSize = 1_000_000_000; // must be larger than any single reward issuance

    // Called by Validation contract to reward validators during Epoch
    // function lockRewardFor(address who, uint256 amountReward, uint256) public onlyOperator stoppable returns (bool) {
    //     require(amountReward <= tokenBatchSize, "reward amount to larger than token batch size");

    //     uint256 unlockEpoch = currentEpoch + epochDelay;

    //     // Record all the reward info
    //     Reward storage reward = recipientRewards[unlockEpoch][who];
    //     if (!reward.defined) {
    //         recipients[unlockEpoch].push(who);
    //     }
    //     reward.defined = true;
    //     reward.amount += amountReward;

    //     // Make sure we have enough tokens to cover
    //     if (amountReward > utilityToken.balanceOf(address(this))) {
    //         utilityToken.mint(address(this), tokenBatchSize);
    //     }

    //     emit LockedReward(who, amountReward);

    //     return true;
    // }

    // must be larger than any single reward issuance
    // function setTokenBatchSize(uint256 _tokenBatchSize) external {
    //     tokenBatchSize = _tokenBatchSize;
    // }
    
    function lockRewardFor(address who, uint256 amountReward, uint256 unlockEpoch) public onlyOperator stoppable returns (bool) {
        StakeDetails storage detail = details[who];

        // TODO Should indicate what the reward is for to make sure we can't double reward

        RewardDetails memory reward;
        reward.amountReward = amountReward;
        reward.unlockEpoch = unlockEpoch;

        detail.rewards.push(reward);

        utilityToken.mint(address(this), amountReward); // TODO replace with a pooling mechanism so not every reward requires a mint

        emit LockedReward(who, amountReward);

        return detail.requestedStakeWithdrawal;
    }

    // Called by ETHDKG + Validation contracts to burn all stake of a malicious validator
    function burnStake(address who, uint256 amount) external onlyOperator stoppable returns (bool) {
        StakeDetails storage detail = details[who];
        detail.amountStaked = detail.amountStaked.sub(amount);

        emit BurntStake(who, amount);
        return true;
    }

    function fine(address who, uint256 amount) external onlyOperator stoppable returns (bool) {
        StakeDetails storage detail = details[who];
        detail.amountStaked = detail.amountStaked.sub(amount);

        emit Fined(who, amount);
        return true;
    }

    function unlockReward() external stoppable returns (bool) {
        return _unlockRewardFor(msg.sender);
    }

    function unlockRewardFor(address who) external onlyOperator stoppable returns (bool) {
        return _unlockRewardFor(who);
    }

    function _unlockRewardFor(address who) internal returns (bool) {
        StakeDetails storage detail = details[who];
        RewardDetails[] storage rewards = detail.rewards;

        uint256 rewardUnlocked;

        // TODO Optimize?
        // Filty filthy code. Loop over the rewards and unlock what is scheduled.
        for (uint256 idx; idx<rewards.length; idx++) {
            RewardDetails storage reward = rewards[idx];

            if (reward.unlockEpoch <= currentEpoch) {
                rewardUnlocked = rewardUnlocked.add(reward.amountReward);

                // copy last reward in array into this spot; toss old reward; don't move on yet
                rewards[idx] = rewards[rewards.length-1];
                rewards.pop();
                idx--;
            }
        }

        detail.unlockedReward = detail.unlockedReward.add(rewardUnlocked);

        return true;
    }
    

    //
    function requestUnlockStake() external stoppable {
        _requestUnlockStakeFor(msg.sender);
    }

    function requestUnlockStakeFor(address who) external onlyOperator stoppable {
        _requestUnlockStakeFor(who);
    }

    function _requestUnlockStakeFor(address who) private {
        require(details[who].amountStaked > 0, "No stake");

        details[who].requestedStakeWithdrawal = true;
        details[who].stakeWithdrawalEpoch = currentEpoch.add(epochDelay);

        emit RequestedUnlockStake(who);
    }

    //
    function unlockStake(uint256 amount) external stoppable returns (bool) {
        return _unlockStakeFor(msg.sender, amount);
    }

    function unlockStakeFor(address who, uint256 amount) external stoppable returns (bool) {
        return _unlockStakeFor(who, amount);
    }

    function _unlockStakeFor(address who, uint256 amount) private stoppable returns (bool) {
        StakeDetails storage detail = details[who];

        require(detail.requestedStakeWithdrawal, "Stake unlock not requested");
        require(detail.amountStaked >= amount, "Stake unlock requested greater than stake");
        require(detail.stakeWithdrawalEpoch <= currentEpoch, "Not ready");

        detail.unlockedStake = detail.unlockedStake.add(amount);
        detail.amountStaked = detail.amountStaked.sub(amount);

        emit UnlockedStake(who, amount);

        return true;
    }

    function withdrawReward(uint256 amount) external stoppable returns (bool) {
        StakeDetails storage detail = details[msg.sender];

        require(detail.unlockedReward >= amount, "Insufficient unlocked balance.");

        detail.unlockedReward = detail.unlockedReward.sub(amount);

        utilityToken.transfer(msg.sender, amount);

        return true;
    }

    function withdraw(uint256 amount) external stoppable returns (bool) {
        return _withdrawFor(msg.sender, amount);
    }

    function withdrawFor(address who, uint256 amount) external stoppable returns (bool) {
        return _withdrawFor(who, amount);
    }

    function _withdrawFor(address who, uint256 amount) private returns (bool) {
        StakeDetails storage detail = details[who];

        require(detail.unlockedStake >= amount, "Insufficient unlocked balance.");

        detail.unlockedStake = detail.unlockedStake.sub(amount);

        stakingToken.transfer(who, amount);

        return true;
    }

    function setEpochDelay(uint256 _epochDelay) external onlyOperator {
        epochDelay = _epochDelay;
    }

}