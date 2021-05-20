// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.6.4;
pragma abicoder v2;

import "../interfaces/StakingEvents.sol";

import "../facets/AccessControlLibrary.sol";
import "../facets/SnapshotsLibrary.sol";
import "../facets/StakingLibrary.sol";
import "../facets/StopLibrary.sol";

import "../Constants.sol";
import "../Registry.sol";

contract MigrateStakingFacet is AccessControlled, Constants, Stoppable {

    using SafeMath for uint256;

    function setBalancesFor(
        address who,
        uint256 lockedStake,
        uint256 unlockedStake,
        uint256 unlockedReward
    ) external onlyOperator stoppable {

        StakingLibrary.StakingStorage storage ss = StakingLibrary.stakingStorage();

        // If there are already tokens staked, we mint or return the difference
        // -- locked stake
        uint256 originalLockedStake = ss.details[who].amountStaked;
        if (lockedStake > originalLockedStake) {
            uint256 additionalRequired = lockedStake.sub(originalLockedStake);
            MintableERC20 token = MintableERC20(address(ss.stakingToken));
            token.mint(address(this), additionalRequired);

        } else if (lockedStake < originalLockedStake) {
            uint256 surplus = originalLockedStake.sub(lockedStake);
            ss.stakingToken.transfer(msg.sender, surplus);
        }
        ss.details[who].amountStaked = lockedStake;

        // If there are already tokens staked, we mint or return the difference
        // -- unlocked stake
        uint256 originalUnlockedStake = ss.details[who].unlockedStake;
        if (unlockedStake > originalUnlockedStake) {
            uint256 additionalRequired = unlockedStake.sub(originalUnlockedStake);
            MintableERC20 token = MintableERC20(address(ss.stakingToken));
            token.mint(address(this), additionalRequired);

        } else if (unlockedStake < originalUnlockedStake) {
            uint256 surplus = originalUnlockedStake.sub(unlockedStake);
            ss.stakingToken.transfer(msg.sender, surplus);
        }
        ss.details[who].unlockedStake = unlockedStake;

        // If there are already tokens staked, we mint or return the difference
        // -- unlocked reward
        uint256 originalUnlockedReward = ss.details[who].unlockedReward;
        if (unlockedReward > originalUnlockedReward) {
            uint256 additionalRequired = unlockedReward.sub(originalUnlockedReward);
            ss.utilityToken.mint(address(this), additionalRequired);

        } else if (unlockedReward < originalUnlockedReward) {
            uint256 surplus = originalUnlockedReward.sub(unlockedReward);
            ss.utilityToken.transfer(msg.sender, surplus);
        }
        ss.details[who].unlockedReward = unlockedReward;
    }

}