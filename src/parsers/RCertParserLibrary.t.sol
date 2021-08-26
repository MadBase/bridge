// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

import "ds-test/test.sol";
import "./RCertParserLibrary.sol";


contract RCertParserLibraryTest is DSTest {

    function example_rcert() private returns(bytes memory) {
        bytes memory rcertCapnProto =
            hex"00000000"
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
        return rcertCapnProto;
    }

}