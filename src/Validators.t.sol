// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.15;

import "ds-test/test.sol";

import "./Constants.sol";
import "./Crypto.sol";
import "./ETHDKG.sol";
import "./ETHDKGCompletion.sol";
import "./ETHDKGGroupAccusation.sol";
import "./ETHDKGSubmitMPK.sol";
import "./Registry.sol";
import "./Staking.sol";
import "./Token.sol";
import "./Validators.sol";
import "./ValidatorsSnapshot.sol";

contract ValidatorsTest is Constants, DSTest {

    uint constant INITIAL_AMOUNT = 1_000_000_000_000_000_000_000_000;

    uint constant VALIDATOR_COUNT = 6;

    ETHDKG ethdkg;
    Registry reg;
    Staking staking;

    BasicERC20 stakingToken;
    BasicERC20 utilityToken;

    Validators validators;
    ValidatorsSnapshot validatorsSnapshot;

    function setUp() public {
        reg = new Registry();
        staking = new Staking(reg);

        stakingToken = BasicERC20(address(new Token("STK", "MadNet Staking")));
        stakingToken.approve(address(staking), INITIAL_AMOUNT);

        utilityToken = BasicERC20(address(new Token("UTL", "MadNet Utility")));
        utilityToken.approve(address(staking), INITIAL_AMOUNT);

        ethdkg = new ETHDKG(reg);

        validators = new Validators(10, reg);
        assertTrue(10 == validators.validatorMaxCount());

        validatorsSnapshot = new ValidatorsSnapshot();

        reg.register(ETHDKG_CONTRACT, address(ethdkg));
        reg.register(ETHDKG_COMPLETION_CONTRACT, address(new ETHDKGCompletion()));
        reg.register(ETHDKG_GROUPACCUSATION_CONTRACT, address(new ETHDKGGroupAccusation()));
        reg.register(ETHDKG_SUBMITMPK_CONTRACT, address(new ETHDKGSubmitMPK()));
        reg.register(CRYPTO_CONTRACT, address(new Crypto()));

        reg.register(STAKING_CONTRACT, address(staking));
        
        reg.register(STAKING_TOKEN, address(stakingToken));
        reg.register(UTILITY_TOKEN, address(utilityToken));
        reg.register(VALIDATORS_CONTRACT, address(validators));
        reg.register(VALIDATORS_SNAPSHOT_CONTRACT, address(validatorsSnapshot));

        ethdkg.reloadRegistry();
        staking.reloadRegistry();
        validators.reloadRegistry();

        uint256[2] memory madID;
        for (uint256 i; i<VALIDATOR_COUNT;i++) {
            madID[0] = i;
            madID[1] = i;
            validators.addValidator(address(i+1), madID);
        }
    }

    function testFoo() public {
        assertTrue(true);
    }
    function testFailFoo() public {
        assertTrue(false);
    }

    function testSnapshot() public {
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

        assertEq(signatureGroup.length, 192);

        uint256 epoch = validators.epoch();
        assertEq(epoch, 1);

        validators.snapshot(signatureGroup, bclaims);

        uint256 newEpoch = validators.epoch();
        assertEq(newEpoch, 2);

        bytes memory rawSig = validators.getRawSignatureSnapshot(epoch);
        assertEq(rawSig.length, signatureGroup.length);

        uint32 madHeight = validators.getMadHeightFromSnapshot(epoch);
        assertEq(int(madHeight), 5);

        uint32 height = validators.getHeightFromSnapshot(epoch);
        assertEq(int(height), 0);

        uint32 chainId = validators.getChainIdFromSnapshot(epoch);
        assertEq(int(chainId), 42);
    }

    function testInitialization() public {
        assertEq(validators.validatorCount(), VALIDATOR_COUNT);
        assertEq(validators.epoch(), 1);
    }

    function testAddValidator() public {
        uint256[2] memory madID;
        uint8 n = validators.addValidator(address(VALIDATOR_COUNT+1), madID);
        assertEq(n, VALIDATOR_COUNT+1);
    }

    function testRemoveValidator() public {
        uint256 id = 1;
        uint256[2] memory madID;
        madID[0] = id;
        madID[1] = id;
        assertEq(validators.removeValidator(address(id+1), madID), VALIDATOR_COUNT-1);
    }

    function testIsValidator() public {
        uint n = validators.validatorCount();
        assertTrue(n == VALIDATOR_COUNT);

        bool valid;

        address madAddress = address(this);
        uint256[2] memory madID = generateMadID(10);

        valid = validators.isValidator(madAddress);
        assertTrue(!valid); // Not added yet

        n = validators.addValidator(madAddress, madID);
        assertTrue(n == VALIDATOR_COUNT+1);

        valid = validators.isValidator(madAddress);
        assertTrue(!valid); // Added but not staked

        staking.lockStakeFor(madAddress, validators.minimumStake());
        valid = validators.isValidator(madAddress);
        assertTrue(valid); // Added and staked
    }

    function testGetValidators() public {
        address[] memory validatorAddresses = validators.getValidators();

        assertEq(validatorAddresses.length, VALIDATOR_COUNT);
    }

    function generateMadID(uint256 id) internal pure returns (uint256[2] memory madID) {
        madID[0] = id;
        madID[1] = id;
    }

}