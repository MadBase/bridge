// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.6.4;
pragma abicoder v2;

import "ds-test/test.sol";

import "./MigrateStakingFacet.sol";

import "../facets/Setup.t.sol";

import "../../Constants.sol";
import "../../Registry.sol";

contract MigrateStakingFacetTest is Constants, DSTest, Setup {

    function testSetBalancesFor() public {

        address diamond = address(validators);
        DiamondUpdateFacet update = DiamondUpdateFacet(diamond);

        // Remember my current token balances
        uint256 originalStakingBalance = stakingToken.balanceOf(address(this));
        uint256 originalUtilityBalance = utilityToken.balanceOf(address(this));

        // Check initial staking balances
        address who = address(614);
        assertEq(staking.balanceStakeFor(who), 0, "initial balance should be 0");
        assertEq(staking.balanceRewardFor(who), 0, "initial balance should be 0");
        assertEq(staking.balanceUnlockedFor(who), 0, "initial balance should be 0");
        assertEq(staking.balanceUnlockedRewardFor(who), 0, "initial balance should be 0");

        // Setup migrator
        address msf = address(new MigrateStakingFacet());
        update.addFacet(MigrateStakingFacet.setBalancesFor.selector, msf);

        // Let's set some balances
        MigrateStakingFacet migrator = MigrateStakingFacet(diamond);

        migrator.setBalancesFor(who, 5, 15, 20);

        // Check updated balances
        assertEq(staking.balanceStakeFor(who), 5, "locked stake");
        assertEq(staking.balanceRewardFor(who), 0, "locked reward");
        assertEq(staking.balanceUnlockedFor(who), 15, "unlocked stake");
        assertEq(staking.balanceUnlockedRewardFor(who), 20, "unlocked reward");

        // Drop the values to 1
        migrator.setBalancesFor(who, 1, 1, 1);

        // Check updated balances
        assertEq(staking.balanceStakeFor(who), 1, "locked stake");
        assertEq(staking.balanceRewardFor(who), 0, "locked reward");
        assertEq(staking.balanceUnlockedFor(who), 1, "unlocked stake");
        assertEq(staking.balanceUnlockedRewardFor(who), 1, "unlocked reward");

        // Make sure the excess tokens came back
        assertEq(stakingToken.balanceOf(address(this)) - originalStakingBalance, 18, "excess stake");
        assertEq(utilityToken.balanceOf(address(this)) - originalUtilityBalance, 19, "excess reward");
    }
}