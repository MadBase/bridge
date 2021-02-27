// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.6.4;
pragma experimental ABIEncoderV2;

import "../interfaces/StakingEvents.sol";

import "./AccessControlLibrary.sol";
import "./SnapshotsLibrary.sol";
import "./StakingLibrary.sol";
import "./StopLibrary.sol";

import "../Constants.sol";
import "../Registry.sol";

contract StakingFacet is AccessControlled, Constants, StakingEvents, Stoppable {

    function initializeStaking(Registry registry) external onlyOperator {
        require(address(registry) != address(0), "nil registry address");

        address ethdkgAddress = registry.lookup(ETHDKG_CONTRACT);
        require(ethdkgAddress != address(0), "nil ethdkg address");

        address stakingTokenAddress = registry.lookup(STAKING_TOKEN);
        require(stakingTokenAddress != address(0), "nil staking Token");

        address utilityTokenAddress = registry.lookup(UTILITY_TOKEN);
        require(utilityTokenAddress != address(0), "nil utility Token");

        StakingLibrary.StakingStorage storage ss = StakingLibrary.stakingStorage();

        ss.ethdkgAddress = ethdkgAddress;
        ss.stakingToken = BasicERC20(stakingTokenAddress);
        ss.utilityToken = MintableERC20(utilityTokenAddress);
    }

    // Minimum Stake getter/setter
    function minimumStake() external view returns (uint256) {
        return StakingLibrary.stakingStorage().minimumStake;
    }

    function setMinimumStake(uint256 _minimumStake) external onlyOperator {
        StakingLibrary.stakingStorage().minimumStake = _minimumStake;
    }

    function majorFine(address who) external {
        StakingLibrary.StakingStorage storage ss = StakingLibrary.stakingStorage();
        require(msg.sender == ss.ethdkgAddress, "only allowed from ethdkg");

        StakingLibrary.fine(who, ss.majorStakeFine);
    }

    function minorFine(address who) external {
        StakingLibrary.StakingStorage storage ss = StakingLibrary.stakingStorage();
        require(msg.sender == ss.ethdkgAddress, "only allowed from ethdkg");

        StakingLibrary.fine(who, ss.minorStakeFine);
    }

    // Major Stake Fine getter/setter
    function majorStakeFine() external view returns (uint256) {
        return StakingLibrary.stakingStorage().majorStakeFine;
    }

    function setMajorStakeFine(uint256 _majorStakeFine) external onlyOperator {
        StakingLibrary.stakingStorage().majorStakeFine = _majorStakeFine;
    }

    // Minor Stake Fine getter/setter
    function minorStakeFine() external view returns (uint256) {
        return StakingLibrary.stakingStorage().minorStakeFine;
    }

    function setMinorStakeFine(uint256 _minorStakeFine) external onlyOperator {
        StakingLibrary.stakingStorage().minorStakeFine = _minorStakeFine;
    }

    // Reward Amount getter/setter
    function rewardAmount() external view returns (uint256) {
        return StakingLibrary.stakingStorage().rewardAmount;
    }

    function setRewardAmount(uint256 _rewardAmount) external onlyOperator {
        StakingLibrary.stakingStorage().rewardAmount = _rewardAmount;
    }

    // Reward Bonus getter/setter
    function rewardBonus() external view returns (uint256) {
        return StakingLibrary.stakingStorage().rewardBonus;
    }
    function setRewardBonus(uint256 _rewardBonus) external onlyOperator {
        StakingLibrary.stakingStorage().rewardBonus = _rewardBonus;
    }

    // Setting and retrieving epoch / Snapshots "epoch()" is preferred method
    function currentEpoch() external view returns (uint256) {
        return SnapshotsLibrary.epoch();
    }

    function setCurrentEpoch(uint256 _epoch) external onlyOperator {
        SnapshotsLibrary.setEpoch(_epoch);
    }

    function lockStake(uint256 amount) external stoppable returns (bool) {
        return StakingLibrary.lockStakeFor(msg.sender, amount);
    }

    // Called by Validators contract on behalf of validator
    function lockStakeFor(address who, uint256 amount) external onlyOperator stoppable returns (bool) {
        return StakingLibrary.lockStakeFor(who, amount);
    }

    function balanceReward() external view returns (uint256) {
        return StakingLibrary.balanceRewardFor(msg.sender);
    }

    function balanceRewardFor(address who) external view returns (uint256) {
        return StakingLibrary.balanceRewardFor(who);
    }

    function balanceStake() external view returns (uint256) {
        return StakingLibrary.balanceStakeFor(msg.sender);
    }

    function balanceStakeFor(address who) external view returns (uint256) {
        return StakingLibrary.balanceStakeFor(who);
    }


    function balanceUnlocked() external view returns (uint256) {
        return StakingLibrary.balanceUnlockedFor(msg.sender);
    }

    function balanceUnlockedFor(address who) external view returns (uint256) {
        return StakingLibrary.balanceUnlockedFor(who);
    }

    function balanceUnlockedReward() external view returns (uint256) {
        return StakingLibrary.balanceUnlockedRewardFor(msg.sender);
    }

    function balanceUnlockedRewardFor(address who) external view returns (uint256) {
        return StakingLibrary.balanceUnlockedRewardFor(who);
    }

    function lockRewardFor(address who, uint256 amountReward, uint256 unlockEpoch) public onlyOperator stoppable returns (bool) {
        return StakingLibrary.lockRewardFor(who, amountReward, unlockEpoch);
    }

    // Called by ETHDKG + Validation contracts to burn all stake of a malicious validator
    function burnStake(address who, uint256 amount) external onlyOperator stoppable returns (bool) {
        return StakingLibrary.burnStake(who, amount);
    }

    function fine(address who, uint256 amount) external onlyOperator stoppable returns (bool) {
        return StakingLibrary.fine(who, amount);
    }

    function unlockReward() external stoppable returns (bool) {
        return StakingLibrary.unlockRewardFor(msg.sender);
    }

    function unlockRewardFor(address who) external onlyOperator stoppable returns (bool) {
        return StakingLibrary.unlockRewardFor(who);
    }

    //
    function requestUnlockStake() external stoppable {
        StakingLibrary.requestUnlockStakeFor(msg.sender);
    }

    function requestUnlockStakeFor(address who) external onlyOperator stoppable {
        StakingLibrary.requestUnlockStakeFor(who);
    }

    //
    function unlockStake(uint256 amount) external stoppable returns (bool) {
        return StakingLibrary.unlockStakeFor(msg.sender, amount);
    }

    function unlockStakeFor(address who, uint256 amount) external stoppable returns (bool) {
        return StakingLibrary.unlockStakeFor(who, amount);
    }

    function withdrawReward(uint256 amount) external stoppable returns (bool) {
        return StakingLibrary.withdrawReward(amount);
    }

    function withdraw(uint256 amount) external stoppable returns (bool) {
        return StakingLibrary.withdrawFor(msg.sender, amount);
    }

    function withdrawFor(address who, uint256 amount) external stoppable returns (bool) {
        return StakingLibrary.withdrawFor(who, amount);
    }

    function setEpochDelay(uint256 _epochDelay) external onlyOperator {
        StakingLibrary.setEpochDelay(_epochDelay);
    }

}