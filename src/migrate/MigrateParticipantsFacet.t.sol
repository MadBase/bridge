// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.6.4;
pragma abicoder v2;

import "ds-test/test.sol";

import "./MigrateParticipantsFacet.sol";

import "../facets/Setup.t.sol";

import "../Constants.sol";
import "../Registry.sol";

contract User {
    function approve(BasicERC20 token, address who, uint256 amount) public {
        token.approve(who, amount);
    }
}

contract MigrateParticipantsFacetTest is Constants, DSTest, Setup {

    function testAddRemoveValidatorImmediate() public {

        address diamond = address(validators);
        DiamondUpdateFacet update = DiamondUpdateFacet(diamond);

        // We need a surrogate user with tokens
        User user = new User();
        stakingToken.transfer(address(user), MINIMUM_STAKE);
        user.approve(stakingToken, address(staking), MINIMUM_STAKE);
        address who = address(user);
        uint256[2] memory madID = [uint256(1), 2];

        // Confirm assumptions
        assertEq(uint256(validators.validatorCount()), 0, "no validators");

        // Setup migrator
        address mpf = address(new MigrateParticipantsFacet());
        update.addFacet(MigrateParticipantsFacet.addValidatorImmediate.selector, mpf);
        update.addFacet(MigrateParticipantsFacet.removeValidatorImmediate.selector, mpf);

        // Let's add someone
        MigrateParticipantsFacet migrator = MigrateParticipantsFacet(diamond);
        migrator.addValidatorImmediate(who, madID);

        // Confirm add worked, but didn't bypass staking requirements
        assertEq(uint256(validators.validatorCount()), 1, "we're in");
        assertTrue(!validators.isValidator(who));

        // Now we actually lock some stake
        staking.lockStakeFor(who, MINIMUM_STAKE);

        assertEq(staking.balanceStakeFor(who), MINIMUM_STAKE, "stake locked");
        assertEq(staking.balanceUnlockedFor(who), 0, "no unlocked stake");
        assertTrue(validators.isValidator(who));

        // Now we remove them
        migrator.removeValidatorImmediate(who, madID);

        // Confirm remove worked, and stake is unlocked
        assertEq(uint256(validators.validatorCount()), 0, "no validators");
        assertEq(staking.balanceStakeFor(who), 0, "nothing locked");
        assertEq(staking.balanceUnlockedFor(who), MINIMUM_STAKE, "stake unlocked");
    }

}