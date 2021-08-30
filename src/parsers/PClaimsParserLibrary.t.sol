// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

import "ds-test/test.sol";
import "./PClaimsParserLibrary.sol";
import "./BClaimsParserLibrary.sol";
import "./RCertParserLibrary.sol";

/// @dev Aux contract to test unit test that must fail!
contract TestsThatMustFail {
    function extractPClaims(bytes memory src, uint256 dataOffset) public pure returns (PClaimsParserLibrary.PClaims memory) {
        return PClaimsParserLibrary.extractPClaims(src, dataOffset);
    }
}

contract PClaimsParserLibraryTest is DSTest {

    function examplePClaims() private pure returns(bytes memory) {
        bytes memory pClaimsCapnProto =
            hex"0000000000000200" // struct definition capn proto https://capnproto.org/encoding.html

            hex"04000000"
            hex"02000400"
            hex"58000000"
            hex"00000200"

            hex"01000000"//BClaim
            hex"02000000"
            hex"01000000"
            hex"00000000"
            hex"0d000000"
            hex"02010000"
            hex"19000000"
            hex"02010000"
            hex"25000000"
            hex"02010000"
            hex"31000000"
            hex"02010000"
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16"
            hex"de8b68a6643fa528a513f99a1ea30379927197a097ca86d9108e4c29d684b1ec"
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470"
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470"


            hex"04000000"//Rcert
            hex"02000100"
            hex"1d000000"
            hex"02060000"

            hex"01000000" //RClaim
            hex"02000000"
            hex"01000000"
            hex"00000000"
            hex"01000000"
            hex"02010000"
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16"

            hex"258aa89365a642358d92db67a13cb25d73e6eedf0d25100d8d91566882fac54b" //SigGroup
            hex"1ccedfb0425434b54999a88cd7d993e05411955955c0cfec9dd33066605bd4a6"
            hex"0f6bbfbab37349aaa762c23281b5749932c514f3b8723cf9bb05f9841a7f2d0e"
            hex"0f75e42fd6c8e9f0edadac3dcfb7416c2d4b2470f4210f2afa93138615b1deb1"
            hex"1ff56a9538b079e16dd77a8ef81318497b195ad81b8cd1c5ea5d48b0c160f599"
            hex"12387b5ab69538ef4cda0f7a879982f9b4943291b1e6d998abefe7bb4ebb6993";
        return pClaimsCapnProto;
    }

    function examplePClaimsWithRandomData() private pure returns(bytes memory) {
        bytes memory pClaimsCapnProto =
            hex"0000000002000400" // struct definition capn proto https://capnproto.org/encoding.html

            hex"deadbeef"
            hex"beefbeef"
            hex"ffffbeef"
            hex"04000000"
            hex"02000400"
            hex"58000000"
            hex"00000200"
            hex"deadbe"

            hex"01000000"//BClaim
            hex"02000000"
            hex"01000000"
            hex"00000000"
            hex"0d000000"
            hex"02010000"
            hex"19000000"
            hex"02010000"
            hex"25000000"
            hex"02010000"
            hex"31000000"
            hex"02010000"
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16"
            hex"de8b68a6643fa528a513f99a1ea30379927197a097ca86d9108e4c29d684b1ec"
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470"
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470"


            hex"04000000"//Rcert
            hex"02000100"
            hex"1d000000"
            hex"02060000"

            hex"01000000" //RClaim
            hex"02000000"
            hex"01000000"
            hex"00000000"
            hex"01000000"
            hex"02010000"
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16"

            hex"258aa89365a642358d92db67a13cb25d73e6eedf0d25100d8d91566882fac54b" //SigGroup
            hex"1ccedfb0425434b54999a88cd7d993e05411955955c0cfec9dd33066605bd4a6"
            hex"0f6bbfbab37349aaa762c23281b5749932c514f3b8723cf9bb05f9841a7f2d0e"
            hex"0f75e42fd6c8e9f0edadac3dcfb7416c2d4b2470f4210f2afa93138615b1deb1"
            hex"1ff56a9538b079e16dd77a8ef81318497b195ad81b8cd1c5ea5d48b0c160f599"
            hex"12387b5ab69538ef4cda0f7a879982f9b4943291b1e6d998abefe7bb4ebb6993"
            hex"deadbeefbeefbeefafdeafdeffff0000deadbeefbeefaaaabbbbccccddddeeef"
            hex"deadbeefbeefbeefafdeafdeffff0000deadbeefbeefaaaabbbbccccddddeeef"
            hex"deadbeefbeefbeefafdeafdeffff0000deadbeefbeefaaaabbbbccccddddeeef"
            hex"deadbeefbeefbeefafdeafdeffff0000deadbeefbeefaaaabbbbccccddddeeef";
        return pClaimsCapnProto;
    }

    function examplePClaimsWithAdditionalData() private pure returns(bytes memory) {
        bytes memory pClaimsCapnProto =
            hex"0000000002000400" // struct definition capn proto https://capnproto.org/encoding.html
            hex"04000000"
            hex"02000400"
            hex"58000000"
            hex"00000200"

            hex"01000000"//BClaim
            hex"02000000"
            hex"01000000"
            hex"00000000"
            hex"0d000000"
            hex"02010000"
            hex"19000000"
            hex"02010000"
            hex"25000000"
            hex"02010000"
            hex"31000000"
            hex"02010000"
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16"
            hex"de8b68a6643fa528a513f99a1ea30379927197a097ca86d9108e4c29d684b1ec"
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470"
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470"


            hex"04000000"//Rcert
            hex"02000100"
            hex"1d000000"
            hex"02060000"

            hex"01000000" //RClaim
            hex"02000000"
            hex"01000000"
            hex"00000000"
            hex"01000000"
            hex"02010000"
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16"

            hex"258aa89365a642358d92db67a13cb25d73e6eedf0d25100d8d91566882fac54b" //SigGroup
            hex"1ccedfb0425434b54999a88cd7d993e05411955955c0cfec9dd33066605bd4a6"
            hex"0f6bbfbab37349aaa762c23281b5749932c514f3b8723cf9bb05f9841a7f2d0e"
            hex"0f75e42fd6c8e9f0edadac3dcfb7416c2d4b2470f4210f2afa93138615b1deb1"
            hex"1ff56a9538b079e16dd77a8ef81318497b195ad81b8cd1c5ea5d48b0c160f599"
            hex"12387b5ab69538ef4cda0f7a879982f9b4943291b1e6d998abefe7bb4ebb6993"
            hex"deadbeefbeefbeefafdeafdeffff0000deadbeefbeefaaaabbbbccccddddeeef"
            hex"deadbeefbeefbeefafdeafdeffff0000deadbeefbeefaaaabbbbccccddddeeef"
            hex"deadbeefbeefbeefafdeafdeffff0000deadbeefbeefaaaabbbbccccddddeeef"
            hex"deadbeefbeefbeefafdeafdeffff0000deadbeefbeefaaaabbbbccccddddeeef";
        return pClaimsCapnProto;
    }

    function examplePClaimsWithMissingData() private pure returns(bytes memory) {
        bytes memory pClaimsCapnProto =
            hex"0000000000000200" // struct definition capn proto https://capnproto.org/encoding.html

            hex"04000000"
            hex"02000400"
            hex"58000000"
            hex"00000200"

            hex"01000000"//BClaim
            hex"02000000"
            hex"01000000"
            hex"00000000"
            hex"0d000000"
            hex"02010000"
            hex"19000000"
            hex"02010000"
            hex"25000000"
            hex"02010000"
            hex"31000000"
            hex"02010000"
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16"
            hex"de8b68a6643fa528a513f99a1ea30379927197a097ca86d9108e4c29d684b1ec"
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470"
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470"


            hex"04000000"//Rcert
            hex"02000100"
            hex"1d000000"
            hex"02060000"

            hex"01000000" //RClaim
            hex"02000000"
            hex"01000000"
            hex"00000000"
            hex"01000000"
            hex"02010000"
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16"

            hex"258aa89365a642358d92db67a13cb25d73e6eedf0d25100d8d91566882fac54b" //SigGroup
            hex"1ccedfb0425434b54999a88cd7d993e054119555c0cfec9dd33066605bd4a6" // Missing data
            hex"0f6bbfbab37349aaa762c23281b5749932c514f3b8723cf9bb05f9841a7f2d0e"
            hex"0f75e42fd6c8e9f0edadac3dcfb7416c2d4b2470f4210f2afa93138615b1deb1"
            hex"1ff56a9538b079e16dd77a8ef81318497b195ad81b8cd1c5ea5d48b0c160f599"
            hex"12387b5ab69538ef4cda0f7a879982f9b4943291b1e6d998abefe7bb4ebb6993";
        return pClaimsCapnProto;
    }

    function assertEqRCert(RCertParserLibrary.RCert memory actual, RCertParserLibrary.RCert memory expected) internal {
        assertEq(
            uint256(actual.rClaims.chainId),
            uint256(expected.rClaims.chainId)
        );
        assertEq(
            uint256(actual.rClaims.height),
            uint256(expected.rClaims.height)
        );
        assertEq(
            uint256(actual.rClaims.round),
            uint256(expected.rClaims.round)
        );
        assertEq(actual.rClaims.prevBlock, expected.rClaims.prevBlock);
        for (uint256 idx = 0; idx < 6; idx++) {
            assertEq(actual.sigGroup[idx], expected.sigGroup[idx]);
        }
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

    function assertEqPClaims(PClaimsParserLibrary.PClaims memory actual, PClaimsParserLibrary.PClaims memory expected) internal {

        assertEqBClaims(actual.bClaims, expected.bClaims);
        assertEqRCert(actual.rCert, expected.rCert);
    }

    function createExpectedRCert() internal pure returns(RCertParserLibrary.RCert memory){
        RClaimsParserLibrary.RClaims
            memory expectedRClaims = RClaimsParserLibrary.RClaims(
                1,
                2,
                1,
                hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16"
            );
        bytes32[6] memory expectedSigGroup = [
            bytes32(
                hex"258aa89365a642358d92db67a13cb25d73e6eedf0d25100d8d91566882fac54b"
            ),
            bytes32(
                hex"1ccedfb0425434b54999a88cd7d993e05411955955c0cfec9dd33066605bd4a6"
            ),
            bytes32(
                hex"0f6bbfbab37349aaa762c23281b5749932c514f3b8723cf9bb05f9841a7f2d0e"
            ),
            bytes32(
                hex"0f75e42fd6c8e9f0edadac3dcfb7416c2d4b2470f4210f2afa93138615b1deb1"
            ),
            bytes32(
                hex"1ff56a9538b079e16dd77a8ef81318497b195ad81b8cd1c5ea5d48b0c160f599"
            ),
            bytes32(
                hex"12387b5ab69538ef4cda0f7a879982f9b4943291b1e6d998abefe7bb4ebb6993"
            )
        ];
        return RCertParserLibrary.RCert(
            expectedRClaims,
            expectedSigGroup
        );
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

    function createExpectedPClaims() internal pure returns(PClaimsParserLibrary.PClaims memory){
        return PClaimsParserLibrary.PClaims(
                createExpectedBClaims(),
                createExpectedRCert()
        );
    }

    function testDecodingPClaims() public {
        uint256 startGas = gasleft();
        PClaimsParserLibrary.PClaims memory actual = PClaimsParserLibrary.extractPClaims(examplePClaims());
        uint256 endGas = gasleft();
        emit log_named_uint("PClaims gas", startGas - endGas);
        PClaimsParserLibrary.PClaims memory expected = createExpectedPClaims();
        assertEqPClaims(actual, expected);
    }

    function testDecodingPClaimsWithAdditionalRandomData() public {
        PClaimsParserLibrary.PClaims memory actual = PClaimsParserLibrary.extractPClaims(examplePClaimsWithAdditionalData());
        PClaimsParserLibrary.PClaims memory expected = createExpectedPClaims();
        assertEqPClaims(actual, expected);
    }

    function testDecodingPClaimsFromArbitraryLocation() public {
        uint256 startGas = gasleft();
        PClaimsParserLibrary.PClaims memory actual = PClaimsParserLibrary.extractPClaims(examplePClaimsWithRandomData(), 39);
        uint256 endGas = gasleft();
        emit log_named_uint("PClaims gas", startGas - endGas);
        PClaimsParserLibrary.PClaims memory expected = createExpectedPClaims();
        assertEqPClaims(actual, expected);
    }

    function testExtractingPClaimsWithIncorrectData() public {
        // Testing unit tests that must fail
        TestsThatMustFail lib = new TestsThatMustFail();
        bool ok;
        // Trying to read memory outside our PClaims data
        (ok, ) = address(lib).delegatecall(abi.encodeWithSignature("extractPClaims(bytes,uint256)", examplePClaimsWithRandomData(), 10000000000));
        assertTrue(!ok, "Function call succeed! The function was supposed to fail when trying to read data outside its bounds!");

        // Trying to force and overflow to manipulate data
        uint256 bigValue = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
        (ok, ) = address(lib).delegatecall(abi.encodeWithSignature("extractPClaims(bytes,uint256)", examplePClaimsWithRandomData(), bigValue));
        assertTrue(!ok, "Function call succeed! The function was supposed to be fail safe against offset overflow");

        // Trying to decode PClaims without having enough Data
        (ok, ) = address(lib).delegatecall(abi.encodeWithSignature("extractPClaims(bytes,uint256)", examplePClaimsWithMissingData(), PClaimsParserLibrary.CAPNPROTO_HEADER_SIZE));
        assertTrue(!ok, "Function call succeed! The function was not supposed to deserialize PClaims if the data is incomplete");

    }


}