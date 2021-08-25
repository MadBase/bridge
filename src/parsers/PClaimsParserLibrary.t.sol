// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

import "ds-test/test.sol";
import "./PClaimsParserLibrary.sol";


contract PClaimsParserLibraryTest is DSTest {

    function example_pclaims() private returns(bytes memory) {
        bytes memory pclaimsCapnProto =
            hex"00000000"
            hex"00000300"
            hex"08000000"
            hex"00000200"
            hex"e9000000"
            hex"0a020000"
            hex"09010000"
            hex"02010000"
            hex"04000000"
            hex"02000400"
            hex"58000000"
            hex"00000200"
            hex"01000000"
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
            hex"05d08b3bfd0fcb21e00a1468a9013fb023aa5eb86d714600dd69675ef9acce8c"
            hex"3247fe575e3d16a3e32d1e0ea10a30474744e7aab3166daea7c591776c1e9425"
            hex"00000000"
            hex"00000000"
            hex"c89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc6";
        return pclaimsCapnProto;
    }

}