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
import "./ValidatorsSnapshot.sol";

contract ValidatorsSnapshotTest is Constants, DSTest {

    uint constant INITIAL_AMOUNT = 1_000_000_000_000_000_000_000_000;

    uint constant VALIDATOR_COUNT = 6;

    ETHDKG ethdkg;
    Registry reg;
    Staking staking;

    BasicERC20 stakingToken;
    BasicERC20 utilityToken;

    ValidatorsSnapshot validators;

    uint256[2] madID;

    function setUp() public {
        validators = new ValidatorsSnapshot();
    }

    function testExtractUint32() public {
        bytes memory b = hex"01020400";

        uint expected = 262657;
        uint32 actual = validators.extractUint32(b, 0);

        assertEq(actual, expected);
    }

    function testExtractUint256() public {
        bytes memory b = 
            hex"10d7b2c2f196fceb52d546ea33816bdcf2fa5dcc79bcbcf0ce34ca1128b0d6d8"
            hex"2d8652a0c5193001a55c0c43b5e0450297d3824a039d924b08d46520b354251f"
            hex"105a55d55c282005a5813480b48ee1efd61046d06b6084bafcf3c10dac57584b"
            hex"0f0bb886f1f1e04bcfa575020e3f47cceb3c11cd5cba496e5aedddc3a04d5b5c";

        uint256 expected = 0xd8d6b02811ca34cef0bcbc79cc5dfaf2dc6b8133ea46d552ebfc96f1c2b2d710;
        uint256 actual = validators.extractUint256(b, 0);

        assertEq(actual, expected);
    }

}
