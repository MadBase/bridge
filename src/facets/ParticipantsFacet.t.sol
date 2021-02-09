// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.6.4;
pragma experimental ABIEncoderV2;

import "ds-test/test.sol";

import "./ParticipantsFacet.sol";
import "./StakingFacet.sol";
import "./ValidatorsUpdateFacet.sol";

import "../interfaces/Validators.sol";

import "../Staking.sol";
import "../ValidatorsDiamond.sol";

contract ParticipantsFacetTest is Constants, DSTest {

   uint constant INITIAL_AMOUNT = 1_000_000_000_000_000_000_000_000;

    uint constant VALIDATOR_COUNT = 6;
    Representative[VALIDATOR_COUNT] representatives;

    Validators validators;
    ParticipantsFacet pf;
    StakingFacet sf;

    Registry registry;
    Staking staking;
    Token stakingToken;
    Token utilityToken;

    function setUp() public {

        registry = new Registry();
        staking = new Staking(registry);
        
        stakingToken = new Token("STK", "MadNet Staking");
        stakingToken.approve(address(staking), INITIAL_AMOUNT);

        utilityToken = new Token("UTL", "MadNet Utility");

        address vd = address(new ValidatorsDiamond());
        validators = Validators(vd);
        pf = ParticipantsFacet(vd);
        sf = StakingFacet(vd);
        ValidatorsUpdateFacet vu = ValidatorsUpdateFacet(vd);

        registry.register(STAKING_CONTRACT, address(staking));
        registry.register(STAKING_TOKEN, address(stakingToken));
        registry.register(UTILITY_TOKEN, address(utilityToken));
        registry.register(VALIDATORS_CONTRACT, vd);

        staking.reloadRegistry();

        address basepf = address(new ParticipantsFacet());
        address basesf = address(new StakingFacet());

        vu.addFacet(Validators.validatorCount.selector, basepf);
        vu.addFacet(Validators.isValidator.selector, basepf);
        vu.addFacet(Validators.addValidator.selector, basepf);
        vu.addFacet(Validators.getValidators.selector, basepf);
        vu.addFacet(Validators.removeValidator.selector, basepf);
        vu.addFacet(Validators.setValidatorMaxCount.selector, basepf);
        vu.addFacet(Validators.validatorMaxCount.selector, basepf);

        vu.addFacet(StakingFacet.minimumStake.selector, basesf);
        vu.addFacet(StakingFacet.setMinimumStake.selector, basesf);

        vu.addFacet(ParticipantsFacet.initializeParticipants.selector, basepf);

        pf.initializeParticipants(registry);
        validators.setValidatorMaxCount(20);
        sf.setMinimumStake(999_999_999);

        // // Now actually build validators
        uint256[2] memory madID;
        for (uint256 i; i<VALIDATOR_COUNT;i++) {
            madID[0] = i;
            madID[1] = i;
            representatives[i] = new Representative(madID);
            representatives[i].add(pf);
        }
    }

    function testAddValidator() public {
        uint256[2] memory madID;

        Representative rep = new Representative(madID);
        uint8 n = rep.add(pf);

        assertEq(n, VALIDATOR_COUNT+1);
    }

    function testRemoveValidator() public {
        uint256[2] memory madID;

        Representative rep = new Representative(madID);

        uint8 n = rep.add(pf);
        assertEq(n, VALIDATOR_COUNT+1);

        n = rep.remove(pf);
        assertEq(n, VALIDATOR_COUNT);
    }

    function testIsValidator() public {
        uint n = pf.validatorCount();
        assertEq(n, VALIDATOR_COUNT);

        address madAddress = address(this);
        uint256[2] memory madID = generateMadID(10);

        bool valid = pf.isValidator(madAddress);
        assertTrue(!valid); // Not added yet

        n = pf.addValidator(madAddress, madID);
        assertTrue(n == VALIDATOR_COUNT+1);

        valid = pf.isValidator(madAddress);
        assertTrue(!valid); // Added but not staked

        staking.lockStakeFor(madAddress, sf.minimumStake());
        valid = pf.isValidator(madAddress);
        assertTrue(valid); // Added and staked
    }

    function testGetValidators() public {
        address[] memory validatorAddresses = pf.getValidators();

        assertEq(validatorAddresses.length, VALIDATOR_COUNT);
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

    function add(ParticipantsFacet pf) external returns (uint8) {
        return pf.addValidator(address(this), madID);
    }

    function remove(ParticipantsFacet pf) external returns (uint8) {
        return pf.removeValidator(address(this), madID);
    }
}