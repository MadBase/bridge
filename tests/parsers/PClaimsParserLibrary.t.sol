// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

import "lib/ds-test/test.sol";
import "src/parsers/PClaimsParserLibrary.sol";
import "src/parsers/BClaimsParserLibrary.sol";
import "src/parsers/RCertParserLibrary.sol";

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

    function examplePClaimsWithTxCount0() private pure returns(bytes memory) {
        bytes memory pClaimsCapnProto =
            hex"0000000000000200" // struct definition capn proto https://capnproto.org/encoding.html
            hex"0400000001000400" // BClaims struct definition
            hex"5400000000000200" // RCert struct definition
            hex"01000000" // chainId NOTE: BClaim starts here
            hex"02000000" // height
            hex"0d00000002010000" //list(uint8) definition for prevBlock
            hex"1900000002010000" //list(uint8) definition for txRoot
            hex"2500000002010000" //list(uint8) definition for stateRoot
            hex"3100000002010000" //list(uint8) definition for headerRoot
            hex"41b1a0649752af1b28b3dc29a1556eee781e4a4c3a1f7f53f90fa834de098c4d" //prevBlock
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470" //txRoot
            hex"b58904fe94d4dca4102566c56402dfa153037d18263b3f6d5574fd9e622e5627" //stateRoot
            hex"3e9768bd0513722b012b99bccc3f9ccbff35302f7ec7d75439178e5a80b45800" //headerRoot
            hex"0400000002000100" //RClaims struct definition NOTE:RCert starts here
            hex"1d00000002060000" //list(uint8) definition for sigGroup
            hex"01000000" // chainID
            hex"02000000" // Height
            hex"01000000" // round
            hex"00000000" // zeros pads for the round (capnproto operates using 8 bytes word)
            hex"0100000002010000" //list(uint8) definition for prevBlock
            hex"41b1a0649752af1b28b3dc29a1556eee781e4a4c3a1f7f53f90fa834de098c4d" //prevBlock
            hex"258aa89365a642358d92db67a13cb25d73e6eedf0d25100d8d91566882fac54b"
            hex"1ccedfb0425434b54999a88cd7d993e05411955955c0cfec9dd33066605bd4a6"
            hex"0f6bbfbab37349aaa762c23281b5749932c514f3b8723cf9bb05f9841a7f2d0e"
            hex"0f75e42fd6c8e9f0edadac3dcfb7416c2d4b2470f4210f2afa93138615b1deb1"
            hex"06f5308b02f59062b735d0021ba93b1b9c09f3e168384b96b1eccfed65935714"
            hex"2a7bd3532dc054cb5be81e9d559128229d61a00474b983a3569f538eb03d07ce";
        return pClaimsCapnProto;
    }

    function examplePClaimsWithAdditionalData() private pure returns(bytes memory) {
        bytes memory pClaimsCapnProto =
            hex"deadbeef"
            hex"beefbeef"
            hex"ffffbeef"
            hex"deadbe"
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
        for (uint256 idx = 0; idx < 4; idx++) {
            assertEq(actual.sigGroupPublicKey[idx], expected.sigGroupPublicKey[idx]);
        }
        for (uint256 idx = 0; idx < 2; idx++) {
            assertEq(actual.sigGroupSignature[idx], expected.sigGroupSignature[idx]);
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
        uint256[4] memory expectedSigGroupPublicKey = [
            uint256(
                0x258aa89365a642358d92db67a13cb25d73e6eedf0d25100d8d91566882fac54b
            ),
            uint256(
                0x1ccedfb0425434b54999a88cd7d993e05411955955c0cfec9dd33066605bd4a6
            ),
            uint256(
                0x0f6bbfbab37349aaa762c23281b5749932c514f3b8723cf9bb05f9841a7f2d0e
            ),
            uint256(
                0x0f75e42fd6c8e9f0edadac3dcfb7416c2d4b2470f4210f2afa93138615b1deb1
            )
        ];
        uint256[2] memory expectedSigGroupSignature = [
            uint256(
                0x1ff56a9538b079e16dd77a8ef81318497b195ad81b8cd1c5ea5d48b0c160f599
            ),
            uint256(
                0x12387b5ab69538ef4cda0f7a879982f9b4943291b1e6d998abefe7bb4ebb6993
            )
        ];
        return RCertParserLibrary.RCert(
            expectedRClaims,
            expectedSigGroupPublicKey,
            expectedSigGroupSignature
        );
    }

    function createExpectedBClaims() internal pure returns(BClaimsParserLibrary.BClaims memory){
        return BClaimsParserLibrary.BClaims(
                1,
                2,
                1,
                hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16",
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

    function createExpectedBClaimsTxCount0() internal pure returns(BClaimsParserLibrary.BClaims memory){
        return BClaimsParserLibrary.BClaims(
                1,
                2,
                0,
                hex"41b1a0649752af1b28b3dc29a1556eee781e4a4c3a1f7f53f90fa834de098c4d",
                hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470",
                hex"b58904fe94d4dca4102566c56402dfa153037d18263b3f6d5574fd9e622e5627",
                hex"3e9768bd0513722b012b99bccc3f9ccbff35302f7ec7d75439178e5a80b45800"
        );
    }

    function createExpectedRCertTxCount0() internal pure returns(RCertParserLibrary.RCert memory){
        RClaimsParserLibrary.RClaims
            memory expectedRClaims = RClaimsParserLibrary.RClaims(
                1,
                2,
                1,
                hex"41b1a0649752af1b28b3dc29a1556eee781e4a4c3a1f7f53f90fa834de098c4d"
            );
        uint256[4] memory expectedSigGroupPublicKey = [
            uint256(
                0x258aa89365a642358d92db67a13cb25d73e6eedf0d25100d8d91566882fac54b
            ),
            uint256(
                0x1ccedfb0425434b54999a88cd7d993e05411955955c0cfec9dd33066605bd4a6
            ),
            uint256(
                0x0f6bbfbab37349aaa762c23281b5749932c514f3b8723cf9bb05f9841a7f2d0e
            ),
            uint256(
                0x0f75e42fd6c8e9f0edadac3dcfb7416c2d4b2470f4210f2afa93138615b1deb1
            )
        ];
        uint256[2] memory expectedSigGroupSignature = [
            uint256(
                0x06f5308b02f59062b735d0021ba93b1b9c09f3e168384b96b1eccfed65935714
            ),
            uint256(
                0x2a7bd3532dc054cb5be81e9d559128229d61a00474b983a3569f538eb03d07ce
            )
        ];
        return RCertParserLibrary.RCert(
            expectedRClaims,
            expectedSigGroupPublicKey,
            expectedSigGroupSignature
        );
    }

    function createExpectedPClaimsTxCount0() internal pure returns(PClaimsParserLibrary.PClaims memory pClaims){
        pClaims = PClaimsParserLibrary.PClaims(
                createExpectedBClaimsTxCount0(),
                createExpectedRCertTxCount0()
        );
    }

    function testExtractingPClaims() public {
        PClaimsParserLibrary.PClaims memory actual = PClaimsParserLibrary.extractPClaims(examplePClaims());
        PClaimsParserLibrary.PClaims memory expected = createExpectedPClaims();
        assertEqPClaims(actual, expected);
    }

    function testExtractingPClaimsFromArbitraryLocation() public {
        (PClaimsParserLibrary.PClaims memory actual, uint256 pclaimSize) = PClaimsParserLibrary.extractInnerPClaims(examplePClaimsWithAdditionalData(), 23);
        PClaimsParserLibrary.PClaims memory expected = createExpectedPClaims();
        assertEqPClaims(actual, expected);
        assertEq(pclaimSize, PClaimsParserLibrary.PCLAIMS_SIZE);
    }

    function testExtractingPClaimsTxCount0() public {
        PClaimsParserLibrary.PClaims memory actual = PClaimsParserLibrary.extractPClaims(examplePClaimsWithTxCount0());
        PClaimsParserLibrary.PClaims memory expected = createExpectedPClaimsTxCount0();
        assertEqPClaims(actual, expected);
    }

    function testExtractingPClaimsFromArbitraryLocationWithTxCount0() public {
        (PClaimsParserLibrary.PClaims memory actual, uint256 pclaimSize) = PClaimsParserLibrary.extractInnerPClaims(examplePClaimsWithTxCount0(), PClaimsParserLibrary.CAPNPROTO_HEADER_SIZE);
        PClaimsParserLibrary.PClaims memory expected = createExpectedPClaimsTxCount0();
        assertEqPClaims(actual, expected);
        assertEq(pclaimSize, PClaimsParserLibrary.PCLAIMS_SIZE - 8);
    }

    function testFail_ExtractingPClaimsWithOutSideData() public {
        PClaimsParserLibrary.extractInnerPClaims(examplePClaimsWithAdditionalData(), 10000000000);
    }

    function testFail_ExtractingPClaimsWithOverflow() public {
        uint256 bigValue = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
        PClaimsParserLibrary.extractInnerPClaims(examplePClaimsWithAdditionalData(), bigValue);
    }

    function testFail_ExtractingPClaimsWithoutHavingEnoughData() public {
        PClaimsParserLibrary.extractPClaims(examplePClaimsWithMissingData());
    }

}