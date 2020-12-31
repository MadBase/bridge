// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.15;

import "ds-test/test.sol";

import "./Crypto.sol";
import "./ETHDKG.sol";
import "./ETHDKGCompletion.sol";
import "./ETHDKGGroupAccusation.sol";
import "./ETHDKGSubmitMPK.sol";
import "./Persistence.sol";
import "./QueueLibrary.sol";
import "./Registry.sol";
import "./Staking.sol";
import "./Token.sol";
import "./Validators.sol";

contract StakingTest is Constants, DSTest {
    ETHDKG ethdkg;
    ETHDKGCompletion ethdkgCompletion;
    ETHDKGGroupAccusation ethdkgGroupAccusation;
    ETHDKGSubmitMPK ethdkgSubmitMPK;
    Registry reg;
    Staking staking;

    BasicERC20 stakingToken;
    BasicERC20 utilityToken;

    Validators validators;
    address me = address(this);

    uint constant INITIAL_AMOUNT = 1_000_000_000_000_000_000_000_000;

    function setUp() public {
        reg = new Registry();
        staking = new Staking(reg);

        stakingToken = new Token("STK", "MadNet Staking");
        stakingToken.approve(address(staking), INITIAL_AMOUNT);

        utilityToken = new Token("UTL", "MadNet Utility");
        utilityToken.approve(address(staking), INITIAL_AMOUNT);

        ethdkg = new ETHDKG(reg);
        ethdkgCompletion = new ETHDKGCompletion();
        ethdkgGroupAccusation = new ETHDKGGroupAccusation();
        ethdkgSubmitMPK = new ETHDKGSubmitMPK();
        validators = new Validators(10, reg);

        reg.register(ETHDKG_CONTRACT, address(ethdkg));
        reg.register(ETHDKG_COMPLETION_CONTRACT, address(ethdkgCompletion));
        reg.register(ETHDKG_GROUPACCUSATION_CONTRACT, address(ethdkgGroupAccusation));
        reg.register(ETHDKG_SUBMITMPK_CONTRACT, address(ethdkgSubmitMPK));
        reg.register(CRYPTO_CONTRACT, address(new Crypto()));
        reg.register(STAKING_CONTRACT, address(staking));
        
        reg.register(STAKING_TOKEN, address(stakingToken));
        reg.register(UTILITY_TOKEN, address(utilityToken));
        reg.register(VALIDATORS_CONTRACT, address(validators));
        
        staking.reloadRegistry();

        stakingToken.approve(address(staking), INITIAL_AMOUNT);
        utilityToken.approve(address(staking), INITIAL_AMOUNT);
    }

    function testUtilityBalance() public {
        assertEq(utilityToken.balanceOf(address(staking)), 0);
    }

    function testLockStake() public {
        assertEq(staking.balanceStakeFor(me), 0);
        staking.lockStakeFor(me, 1_000_000);
        assertEq(staking.balanceStakeFor(me), 1_000_000);
    }

    function testLockReward() public {
        assertEq(staking.balanceRewardFor(me), 0);

        staking.lockRewardFor(me, 10, 1);
        staking.lockRewardFor(me, 10, 2);
        staking.lockRewardFor(me, 10, 3);

        assertEq(staking.balanceRewardFor(me), 30);
    }

    function testSimpleLockReward() public {
        for (uint idx; idx < 20; idx++) {
            staking.lockRewardFor(address(idx+1), 10, 1);
        }
    }

    function testUnlockRewardFor2() public {
        assertEq(staking.balanceUnlockedFor(me), 0);

        staking.lockRewardFor(me, 10, 1);
        staking.lockRewardFor(me, 10, 2);
        staking.lockRewardFor(me, 10, 3);
        assertEq(staking.balanceRewardFor(me), 30);

        staking.setCurrentEpoch(2);
        staking.unlockRewardFor(me);
        assertEq(staking.balanceUnlockedRewardFor(me), 20); // first 2 rewards have been unlocked
        assertEq(staking.balanceRewardFor(me), 10); // only one reward is left
    }

    function testUnlockRewardFor3() public {
        staking.lockRewardFor(me, 10, 1);
        staking.lockRewardFor(me, 10, 2);
        staking.lockRewardFor(me, 10, 3);
        assertEq(staking.balanceRewardFor(me), 30);

        staking.setCurrentEpoch(3);
        staking.unlockRewardFor(me);
        assertEq(staking.balanceUnlockedRewardFor(me), 30); // all rewards are unlocked
        assertEq(staking.balanceRewardFor(me), 0); // no reward is still locked
    }

}