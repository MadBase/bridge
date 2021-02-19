// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.6.4;
pragma experimental ABIEncoderV2;

import "ds-test/test.sol";

import "./DiamondSetup.t.sol";
import "./ParticipantsFacet.sol";
import "./StakingFacet.sol";
import "./ValidatorsUpdateFacet.sol";

import "../interfaces/Staking.sol";
import "../interfaces/Token.sol";
import "../interfaces/Validators.sol";

import "../Token.sol";
import "../ValidatorsDiamond.sol";

contract ParticipantsFacetTest is Constants, DSTest, DiamondSetup {

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

        // Create 4 validators
        Representative[] memory reps = new Representative[](4);
        for (uint256 i; i<4;i++) {
            reps[i] = createRepresentative();
        }

        uint n = participants.validatorCount();
        assertEq(n, 4);

        reps[1].remove(participants);
        n = participants.validatorCount();
        assertEq(n, 3);
    }


    function testIsValidator() public {

        // Create 4 validators
        Representative[] memory reps = new Representative[](4);
        for (uint256 i; i<4;i++) {
            reps[i] = createRepresentative();
        }

        uint n = participants.validatorCount();
        assertEq(n, 4);

        address madAddress = address(this);

        bool valid = participants.isValidator(madAddress);
        assertTrue(!valid); // Not added yet

        uint256[2] memory madID = generateMadID(10);
        n = participants.addValidator(madAddress, madID);
        assertTrue(n == 5);

        valid = participants.isValidator(madAddress);
        assertTrue(!valid); // Added but not staked

        staking.lockStakeFor(madAddress, staking.minimumStake());
        valid = participants.isValidator(madAddress);
        assertTrue(valid); // Added and staked
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
        Representative rep = new Representative(representativeID);

        rep.add(participants);

        return rep;
    }

    function generateMadID(uint256 id) internal pure returns (uint256[2] memory madID) {
        madID[0] = id;
        madID[1] = id;
    }

}

contract Representative {

    uint256[2] madID;

    constructor(uint256[2] memory _madID) {
        madID[0] = _madID[0];
        madID[1] = _madID[1];
    }

    function add(Participants pf) external returns (uint8) {
        return pf.addValidator(address(this), madID);
    }

    function remove(Participants pf) external returns (uint8) {
        return pf.removeValidator(address(this), madID);
    }
}