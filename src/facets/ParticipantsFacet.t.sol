// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.6.4;
pragma abicoder v2;

import "ds-test/test.sol";

import "./Setup.t.sol";
import "./DiamondUpdateFacet.sol";
import "./ParticipantsFacet.sol";
import "./StakingFacet.sol";

import "../interfaces/Staking.sol";
import "../interfaces/Token.sol";
import "../interfaces/Validators.sol";

import "../Token.sol";
import "../ValidatorsDiamond.sol";

contract ParticipantsFacetTest is Constants, DSTest, Setup {

    uint representativeNumber;

    function testAddValidator() public {

        // Create 4 validators
        Representative[] memory reps = new Representative[](4);
        for (uint256 i; i<4;i++) {
            reps[i] = createRepresentative();
        }
        uint n = participants.validatorCount();
        assertEq(n, 4);

        // Add 1 more
        Representative rep = createRepresentative();
        n = participants.validatorCount();
        assertEq(n, 5);
    }

    function testRemoveValidator() public {
        // Create validator
        Representative rep = createRepresentative();

        assertTrue(participants.isValidator(address(rep)));

        staking.requestUnlockStakeFor(address(rep));
        staking.unlockStakeFor(address(rep), MINIMUM_STAKE);

        // Try to leave without requesting unstake
        rep.remove();
    }

    function testFailRemoveValidatorDelay() public {
        // Create validator
        Representative rep = createRepresentative();

        // This means 2 snapshots must occur between request unlock and unlock
        staking.setEpochDelay(2);

        assertTrue(participants.isValidator(address(rep)));

        staking.requestUnlockStakeFor(address(rep));
        staking.unlockStakeFor(address(rep), MINIMUM_STAKE);

        // Try to leave without requesting unstake
        rep.remove();
    }

    function testRemoveValidatorDelay() public {
       

        // Create validator
        Representative rep = createRepresentative();

        // This means 2 snapshots must occur between request unlock and unlock
        staking.setEpochDelay(2);

        assertTrue(participants.isValidator(address(rep)));

        staking.requestUnlockStakeFor(address(rep));

        goodSnapshots(2);

        staking.unlockStakeFor(address(rep), MINIMUM_STAKE);

        // Try to leave without requesting unstake
        rep.remove();
    }

    function testFailRemoveValidatorRequest() public {
        // Create validator
        Representative rep = createRepresentative();

        assertTrue(participants.isValidator(address(rep)));

        // Try to leave without requesting unstake
        rep.remove();
    }


    function testIsValidator() public {

        uint256[2] memory representativeID = generateMadID(representativeNumber++);
        Representative rep = new Representative(participants, representativeID, stakingToken, staking, MINIMUM_STAKE);

        stakingToken.transfer(address(rep), MINIMUM_STAKE);

        bool v = participants.isValidator(address(rep));
        assertTrue(!v);

        rep.add();

        v = participants.isValidator(address(rep));
        assertTrue(v);
    }

    function testGetValidators() public {
        // Create 4 validators
        Representative[] memory reps = new Representative[](4);
        for (uint256 i; i<4;i++) {
            reps[i] = createRepresentative();
        }

        // Retrieve validators and confirm we have 4
        address[] memory validatorAddresses = participants.getValidators();

        assertEq(validatorAddresses.length, 4);
    }

    function createRepresentative() internal returns (Representative) {
        uint256[2] memory representativeID = generateMadID(representativeNumber++);
        Representative rep = new Representative(participants, representativeID, stakingToken, staking, MINIMUM_STAKE);

        stakingToken.transfer(address(rep), MINIMUM_STAKE);

        uint256 b = stakingToken.balanceOf(address(rep));
        assertEq(b, MINIMUM_STAKE);

        rep.add();

        return rep;
    }

    function generateMadID(uint256 id) internal pure returns (uint256[2] memory madID) {
        madID[0] = id;
        madID[1] = id;
    }

    function goodSnapshots(uint number) internal {
        bytes memory bclaims = 
            hex"00000000010004002a000000050000000d000000020100001900000002010000"
            hex"250000000201000031000000020100007565a2d7195f43727e1141f00228fd60"
            hex"da3ca7ada3fc0a5a34ea537e0cb82e8dc5d2460186f7233c927e7db2dcc703c0"
            hex"e500b653ca82273b7bfad8045d85a47000000000000000000000000000000000"
            hex"00000000000000000000000000000000ede353f57b9e2599f9165fde4ec80b60"
            hex"0e9c20418aa3f4d3d6aabee6981abff6";
            
        bytes memory signatureGroup = 
            hex"2ee01ec6218252b7e263cb1d86e6082f7e05e0c86b17607c5490cd2a73ac14f6"
            hex"2cc0679acd5fb16c0c983806d13127354423e908fec273db1fc62c38fcee59d5"
            hex"2570a1763029316ee5cb6e44a74039f15935f110898ad495ffe837335ced059d"
            hex"0d426710c8a650cf96de6462406c3b707d4d1ae2231f3206c57b6551e12f593c"
            hex"1b3c547d051cc268a996a7494df22da5afc31650ba0963e1ee39a2404c4f6cd1"
            hex"22d313f80eb31f8cac30cd98686f815d38b8ea2d46748e9f8971db83f5311a24";

        for(uint count=0; count<number; count++) {
            snapshots.snapshot(signatureGroup, bclaims);
        }
    }

}

contract Representative {

    Participants pf;
    uint256[2] madID;
    BasicERC20 token;
    uint256 stakingAmount;
    Staking staking;

    constructor(Participants _pf, uint256[2] memory _madID, BasicERC20 _token, Staking _staking, uint256 _amount) {
        madID[0] = _madID[0];
        madID[1] = _madID[1];

        pf = _pf;
        token = _token;
        staking = _staking;
        stakingAmount = _amount;
    }

    function add() external returns (uint8) {
        token.approve(address(staking), stakingAmount);
        staking.lockStake(stakingAmount);
        return pf.addValidator(address(this), madID);
    }

    function remove() external returns (uint8) {
        return pf.removeValidator(address(this), madID);
    }
}