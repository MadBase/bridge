// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

import "ds-test/test.sol";
import "./RCertParserLibrary.sol";

contract RCertParserLibraryTest is DSTest {
    function exampleRCert() private pure returns (bytes memory) {
        bytes memory rCertCapnProto = hex"00000000"
        hex"00000200"
        hex"04000000"
        hex"02000100"
        hex"1d000000"
        hex"02060000"
        hex"01000000"
        hex"02000000"
        hex"01000000"
        hex"00000000"
        hex"01000000"
        hex"02010000"
        hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16"
        hex"258aa89365a642358d92db67a13cb25d73e6eedf0d25100d8d91566882fac54b"
        hex"1ccedfb0425434b54999a88cd7d993e05411955955c0cfec9dd33066605bd4a6"
        hex"0f6bbfbab37349aaa762c23281b5749932c514f3b8723cf9bb05f9841a7f2d0e"
        hex"0f75e42fd6c8e9f0edadac3dcfb7416c2d4b2470f4210f2afa93138615b1deb1"
        hex"1ff56a9538b079e16dd77a8ef81318497b195ad81b8cd1c5ea5d48b0c160f599"
        hex"12387b5ab69538ef4cda0f7a879982f9b4943291b1e6d998abefe7bb4ebb6993";
        return rCertCapnProto;
    }

    function exampleRCertWithAdditionalData() private pure returns (bytes memory) {
        bytes memory rCertCapnProto = hex"00000000"
        hex"00000200"
        hex"04000000"
        hex"02000100"
        hex"1d000000"
        hex"02060000"
        hex"01000000"
        hex"02000000"
        hex"01000000"
        hex"00000000"
        hex"01000000"
        hex"02010000"
        hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16"
        hex"258aa89365a642358d92db67a13cb25d73e6eedf0d25100d8d91566882fac54b"
        hex"1ccedfb0425434b54999a88cd7d993e05411955955c0cfec9dd33066605bd4a6"
        hex"0f6bbfbab37349aaa762c23281b5749932c514f3b8723cf9bb05f9841a7f2d0e"
        hex"0f75e42fd6c8e9f0edadac3dcfb7416c2d4b2470f4210f2afa93138615b1deb1"
        hex"1ff56a9538b079e16dd77a8ef81318497b195ad81b8cd1c5ea5d48b0c160f599"
        hex"12387b5ab69538ef4cda0f7a879982f9b4943291b1e6d998abefe7bb4ebb6993"
        hex"beefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdead"
        hex"beefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdead"
        hex"beefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdead";
        return rCertCapnProto;
    }

    function exampleRCertWithRandomData() private pure returns (bytes memory) {
        bytes memory rCertCapnProto =
        hex"deadbeef"
        hex"beefdead"
        hex"abcdef"
        hex"0000000000000200"
        hex"04000000"
        hex"02000100"
        hex"1d000000"
        hex"02060000"
        hex"01000000"
        hex"02000000"
        hex"01000000"
        hex"00000000"
        hex"01000000"
        hex"02010000"
        hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16"
        hex"258aa89365a642358d92db67a13cb25d73e6eedf0d25100d8d91566882fac54b"
        hex"1ccedfb0425434b54999a88cd7d993e05411955955c0cfec9dd33066605bd4a6"
        hex"0f6bbfbab37349aaa762c23281b5749932c514f3b8723cf9bb05f9841a7f2d0e"
        hex"0f75e42fd6c8e9f0edadac3dcfb7416c2d4b2470f4210f2afa93138615b1deb1"
        hex"1ff56a9538b079e16dd77a8ef81318497b195ad81b8cd1c5ea5d48b0c160f599"
        hex"12387b5ab69538ef4cda0f7a879982f9b4943291b1e6d998abefe7bb4ebb6993"
        hex"beefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdead"
        hex"beefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdead"
        hex"beefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdead";
        return rCertCapnProto;
    }

    function exampleRCertWithMissingData() private pure returns (bytes memory) {
        bytes memory rCertCapnProto = hex"00000000"
        hex"00000200"
        hex"04000000"
        hex"02000100"
        hex"1d000000"
        hex"02060000"
        hex"01000000"
        hex"020000"
        hex"01000000"
        hex"00000000"
        hex"01000000"
        hex"02010000"
        hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16"
        hex"258aa89365a642358d92db67a13cb25d73e6eedf0d25100d8d91566882fac54b"
        hex"1ccedfb0425434b54999a88cd7d993e05411955955c0cfec9dd33066605bd4a6"
        hex"0f6bbfbab37349aaa762c23281749932c514f3b8723cf9bb05f9841a7f2d0e"
        hex"0f75e42fd6c8e9f0edadac3dcfb7416c2d4b2470f4210f2afa93138615b1deb1"
        hex"1ff56a9538b079e16dd77a8ef81318497b195ad81b8cd1c5ea5d48b0c160f599"
        hex"12387b5ab69538ef4cda0f7a879982f9b4943291b1e6d998abefe7bb4ebb6993";
        return rCertCapnProto;
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

    function testExtractRCert() public {
        uint256 startGas = gasleft();
        RCertParserLibrary.RCert memory actual = RCertParserLibrary.extractRCert(exampleRCert());
        uint256 endGas = gasleft();
        emit log_named_uint("Rcert gas", startGas - endGas);
        RCertParserLibrary.RCert memory expected = createExpectedRCert();
        assertEqRCert(actual, expected);
    }

    function testExtractRCertWithAdditionalData() public {
        RCertParserLibrary.RCert memory actual = RCertParserLibrary.extractRCert(exampleRCertWithAdditionalData());
        RCertParserLibrary.RCert memory expected = createExpectedRCert();
        assertEqRCert(actual, expected);
    }

    function testExtractRCertFromArbitraryLocation() public {
        uint256 startGas = gasleft();
        RCertParserLibrary.RCert memory actual = RCertParserLibrary.extractInnerRCert(exampleRCertWithRandomData(), 19);
        uint256 endGas = gasleft();
        emit log_named_uint("Rcert gas", startGas - endGas);
        RCertParserLibrary.RCert memory expected = createExpectedRCert();
        assertEqRCert(actual, expected);
    }

    function testFail_ExtractingRCertWithOutSideData() public {
        RCertParserLibrary.extractInnerRCert(exampleRCertWithAdditionalData(), 10000000000);
    }

    function testFail_ExtractingRCertWithOverflow() public {
        uint256 bigValue = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
        RCertParserLibrary.extractInnerRCert(exampleRCertWithAdditionalData(), bigValue);
    }

    function testFail_ExtractingRCertWithoutHavingEnoughData() public {
        RCertParserLibrary.extractInnerRCert(exampleRCertWithMissingData(), RCertParserLibrary.CAPNPROTO_HEADER_SIZE);
    }
}
