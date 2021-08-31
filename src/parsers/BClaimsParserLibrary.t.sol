// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

import "ds-test/test.sol";
import "./BClaimsParserLibrary.sol";

/// @dev Aux contract to test unit test that must fail!
contract TestsThatMustFail {
    function extractBClaims(bytes memory src, uint256 dataOffset) public pure returns (BClaimsParserLibrary.BClaims memory) {
        return BClaimsParserLibrary.extractBClaims(src, dataOffset);
    }
}

contract BClaimsParserLibraryTest is DSTest {

    function exampleBClaims() private pure returns(bytes memory) {
        bytes memory bClaimsCapnProto =
            hex"0000000002000400" // struct definition capn proto https://capnproto.org/encoding.html

            hex"01000000" // chainId
            hex"02000000" // height
            hex"01000000" // txCount
            hex"00000000"
            hex"0d000000"
            hex"02010000"
            hex"19000000"
            hex"02010000"
            hex"25000000"
            hex"02010000"
            hex"31000000"
            hex"02010000" //48
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16" // prevBlock
            hex"de8b68a6643fa528a513f99a1ea30379927197a097ca86d9108e4c29d684b1ec" // txRoot
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470" // stateRoot
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470"; // headerRoot
        return bClaimsCapnProto;
    }

    function exampleBClaimsWithRandomData() private pure returns(bytes memory) {
        bytes memory bClaimsCapnProto =
            hex"0000000002000400" // struct definition capn proto https://capnproto.org/encoding.html

            hex"deadbeef"
            hex"beefbeef"
            hex"ffffbeef"
            hex"deadbe"
            hex"01000000" // chainId
            hex"02000000" // height
            hex"01000000" // txCount
            hex"00000000"
            hex"0d000000"
            hex"02010000"
            hex"19000000"
            hex"02010000"
            hex"25000000"
            hex"02010000"
            hex"31000000"
            hex"02010000" //48
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16" // prevBlock
            hex"de8b68a6643fa528a513f99a1ea30379927197a097ca86d9108e4c29d684b1ec" // txRoot
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470" // stateRoot
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470" // headerRoot
            hex"deadbeefbeefbeefafdeafdeffff0000deadbeefbeefaaaabbbbccccddddeeef"
            hex"deadbeefbeefbeefafdeafdeffff0000deadbeefbeefaaaabbbbccccddddeeef"
            hex"deadbeefbeefbeefafdeafdeffff0000deadbeefbeefaaaabbbbccccddddeeef"
            hex"deadbeefbeefbeefafdeafdeffff0000deadbeefbeefaaaabbbbccccddddeeef";
        return bClaimsCapnProto;
    }

    function exampleBClaimsWithAdditionalData() private pure returns(bytes memory) {
        bytes memory bClaimsCapnProto =
            hex"0000000002000400" // struct definition capn proto https://capnproto.org/encoding.html
            hex"01000000" // chainId
            hex"02000000" // height
            hex"01000000" // txCount
            hex"00000000"
            hex"0d000000"
            hex"02010000"
            hex"19000000"
            hex"02010000"
            hex"25000000"
            hex"02010000"
            hex"31000000"
            hex"02010000" //48
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16" // prevBlock
            hex"de8b68a6643fa528a513f99a1ea30379927197a097ca86d9108e4c29d684b1ec" // txRoot
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470" // stateRoot
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470" // headerRoot
            hex"deadbeefbeefbeefafdeafdeffff0000deadbeefbeefaaaabbbbccccddddeeef"
            hex"deadbeefbeefbeefafdeafdeffff0000deadbeefbeefaaaabbbbccccddddeeef"
            hex"deadbeefbeefbeefafdeafdeffff0000deadbeefbeefaaaabbbbccccddddeeef"
            hex"deadbeefbeefbeefafdeafdeffff0000deadbeefbeefaaaabbbbccccddddeeef";
        return bClaimsCapnProto;
    }

    function exampleBClaimsWithMissingData() private pure returns(bytes memory) {
        bytes memory bClaimsCapnProto =
            hex"0000000002000400" // struct definition capn proto https://capnproto.org/encoding.html

            hex"01000000" // chainId
            hex"02000000" // height
            hex"01000000" // txCount
            hex"00000000"
            hex"0d000000"
            hex"020100"
            hex"19000000"
            hex"02010000"
            hex"25000000"
            hex"02010000"
            hex"31000000"
            hex"02010000" //48
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16" // prevBlock
            hex"de8b68a6643fa528a513f99a1ea30379927197a097ca86d9108e4c29d684b1ec" // txRoot
            hex"c5d2460186f7233c9e7db2dcc703c0e500b653ca82273b7bfad8045d85a470" // stateRoot
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470"; // headerRoot
        return bClaimsCapnProto;
    }

    function assertEqBClaims(BClaimsParserLibrary.BClaims memory actual, BClaimsParserLibrary.BClaims memory expected) internal {
        assertEq(uint256(actual.chainId), uint256(expected.chainId));
        assertEq(uint256(actual.height), uint256(expected.height));
        assertEq(uint256(actual.txCount), uint256(expected.txCount));
        assertEq(actual.prevBlock, expected.prevBlock);
        assertEq(actual.txRoot, expected.txRoot);
        assertEq(actual.stateRoot, expected.stateRoot);
        assertEq(actual.headerRoot, expected.headerRoot);
    }

    function createExpectedBClaims() internal pure returns(BClaimsParserLibrary.BClaims memory){
        return BClaimsParserLibrary.BClaims(
                1,
                2,
                hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16",
                1,
                hex"de8b68a6643fa528a513f99a1ea30379927197a097ca86d9108e4c29d684b1ec",
                hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470",
                hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470"
        );
    }

    function testDecodingBClaims() public {
        uint256 startGas = gasleft();
        BClaimsParserLibrary.BClaims memory actual = BClaimsParserLibrary.extractBClaims(exampleBClaims());
        uint256 endGas = gasleft();
        emit log_named_uint("BClaims gas", startGas - endGas);
        BClaimsParserLibrary.BClaims memory expected = createExpectedBClaims();
        assertEqBClaims(actual, expected);
    }

    function testDecodingBClaimsWithAdditionalRandomData() public {
        BClaimsParserLibrary.BClaims memory actual = BClaimsParserLibrary.extractBClaims(exampleBClaimsWithAdditionalData());
        BClaimsParserLibrary.BClaims memory expected = createExpectedBClaims();
        assertEqBClaims(actual, expected);
    }

    function testDecodingBClaimsFromArbitraryLocation() public {
        uint256 startGas = gasleft();
        BClaimsParserLibrary.BClaims memory actual = BClaimsParserLibrary.extractBClaims(exampleBClaimsWithRandomData(), 23);
        uint256 endGas = gasleft();
        emit log_named_uint("BClaims gas", startGas - endGas);
        BClaimsParserLibrary.BClaims memory expected = createExpectedBClaims();
        assertEqBClaims(actual, expected);
    }

    function testExtractingBClaimsWithIncorrectData() public {
        // Testing unit tests that must fail
        TestsThatMustFail lib = new TestsThatMustFail();
        bool ok;
        // Trying to read memory outside our BClaims data
        (ok, ) = address(lib).delegatecall(abi.encodeWithSignature("extractBClaims(bytes,uint256)", exampleBClaimsWithRandomData(), 10000000000));
        assertTrue(!ok, "Function call succeed! The function was supposed to fail when trying to read data outside its bounds!");

        // Trying to force and overflow to manipulate data
        uint256 bigValue = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
        (ok, ) = address(lib).delegatecall(abi.encodeWithSignature("extractBClaims(bytes,uint256)", exampleBClaimsWithRandomData(), bigValue));
        assertTrue(!ok, "Function call succeed! The function was supposed to be fail safe against offset overflow");

        // Trying to decode BClaims without having enough Data
        (ok, ) = address(lib).delegatecall(abi.encodeWithSignature("extractBClaims(bytes,uint256)", exampleBClaimsWithMissingData(), BClaimsParserLibrary.CAPNPROTO_HEADER_SIZE));
        assertTrue(!ok, "Function call succeed! The function was not supposed to deserialize BClaims if the data is incomplete");

    }


}