// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

import "ds-test/test.sol";
import "./RClaimsParserLibrary.sol";

/// @dev Aux contract to test unit test that must fail!
contract TestThatMustFail {
    function extractRClaims(bytes memory src, uint256 dataOffset) public pure returns (RClaimsParserLibrary.RClaims memory) {
        return RClaimsParserLibrary.extractRClaims(src, dataOffset);
    }
}

contract RClaimsParserLibraryTest is DSTest {

    function exampleRClaim() private pure returns(bytes memory) {
        bytes memory rClaimCapnProto =
            hex"0000000002000100" // struct definition capn proto https://capnproto.org/encoding.html
            hex"01000000" //chainId
            hex"02000000" //height
            hex"01000000" //round
            hex"00000000"
            hex"01000000"
            hex"02010000"
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16"; // PrevBlock

        return rClaimCapnProto;
    }

    function exampleRClaimWithRandomData() private pure returns(bytes memory) {
        bytes memory rClaimCapnProto =
            hex"0000000002000100" // struct definition capn proto https://capnproto.org/encoding.html
            hex"deadbeef"
            hex"beefde"
            hex"01000000" //chainId
            hex"02000000" //height
            hex"01000000" //round
            hex"00000000"
            hex"01000000"
            hex"02010000"
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16" // PrevBlock
            hex"deadbeefffffff0000000beefdeadbeefdeadbeefdeadbeefdeadbeefdead000";
        return rClaimCapnProto;
    }

    function exampleRClaimWithAdditionalData() private pure returns(bytes memory) {
        bytes memory rClaimCapnProto =
            hex"0000000002000100" // struct definition capn proto https://capnproto.org/encoding.html
            hex"01000000" //chainId
            hex"02000000" //height
            hex"01000000" //round
            hex"00000000"
            hex"01000000"
            hex"02010000"
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16" // PrevBlock
            hex"deadbeefffffff0000000beefdeadbeefdeadbeefdeadbeefdeadbeefdead000"
            hex"deadbeefffffff0000000beefdeadbeefdeadbeefdeadbeefdeadbeefdead000"
            hex"deadbeefffffff0000000beefdeadbeefdeadbeefdeadbeefdeadbeefdead000"
            hex"deadbeefffffff0000000beefdeadbeefdeadbeefdeadbeefdeadbeefdead000";
        return rClaimCapnProto;
    }

    function exampleRClaimWithMissingData() private pure returns(bytes memory) {
        bytes memory rClaimCapnProto =
            hex"0000000002000100" // struct definition capn proto https://capnproto.org/encoding.html
            hex"01000000" //chainId
            hex"02000000" //height
            hex"01000000" //round
            hex"00000000"
            hex"02010000"
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16";
        return rClaimCapnProto;
    }

    function assertEqRClaims(RClaimsParserLibrary.RClaims memory actual, RClaimsParserLibrary.RClaims memory expected) internal {
        assertEq(uint256(actual.chainId), uint256(expected.chainId));
        assertEq(uint256(actual.height), uint256(expected.height));
        assertEq(uint256(actual.round), uint256(expected.round));
        assertEq(actual.prevBlock, expected.prevBlock);
    }

    function testDecodingRClaims() public {
        uint256 startGas = gasleft();
        RClaimsParserLibrary.RClaims memory actual = RClaimsParserLibrary.extractRClaims(exampleRClaim());
        uint256 endGas = gasleft();
        emit log_named_uint("RClaims gas", startGas - endGas);
        RClaimsParserLibrary.RClaims memory expected = RClaimsParserLibrary.RClaims(1, 2, 1, hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16");
        assertEqRClaims(actual, expected);
    }

    function testDecodingRClaimsWithAdditionalRandomData() public {
        RClaimsParserLibrary.RClaims memory actual = RClaimsParserLibrary.extractRClaims(exampleRClaimWithAdditionalData());
        RClaimsParserLibrary.RClaims memory expected = RClaimsParserLibrary.RClaims(1, 2, 1, hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16");
        assertEqRClaims(actual, expected);
    }

    function testDecodingRClaimsFromArbitraryLocation() public {
        uint256 startGas = gasleft();
        RClaimsParserLibrary.RClaims memory actual = RClaimsParserLibrary.extractRClaims(exampleRClaimWithRandomData(), 15);
        uint256 endGas = gasleft();
        emit log_named_uint("RClaims gas", startGas - endGas);
        RClaimsParserLibrary.RClaims memory expected = RClaimsParserLibrary.RClaims(1, 2, 1, hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16");
        assertEqRClaims(actual, expected);
    }

    function testExtractingRClaimsWithIncorrectData() public {
        // Testing unit tests that must fail
        TestThatMustFail lib = new TestThatMustFail();
        bool ok;
        // Trying to read memory outside our RClaims data
        (ok, ) = address(lib).delegatecall(abi.encodeWithSignature("extractRClaims(bytes,uint256)", exampleRClaimWithRandomData(), 10000000000));
        assertTrue(!ok, "Function call succeed! The function was supposed to fail when trying to read data outside its bounds!");

        // Trying to force and overflow to manipulate data
        uint256 bigValue = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
        (ok, ) = address(lib).delegatecall(abi.encodeWithSignature("extractRClaims(bytes,uint256)", exampleRClaimWithRandomData(), bigValue));
        assertTrue(!ok, "Function call succeed! The function was supposed to be fail safe against offset overflow");

        // Trying to decode RClaims without having enough Data
        (ok, ) = address(lib).delegatecall(abi.encodeWithSignature("extractRClaims(bytes,uint256)", exampleRClaimWithMissingData(), RClaimsParserLibrary.CAPNPROTO_HEADER_SIZE));
        assertTrue(!ok, "Function call succeed! The function was not supposed to serialize RClaims if the data is incomplete");

    }

}
