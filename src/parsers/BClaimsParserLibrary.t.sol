// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

import "ds-test/test.sol";
import "./BClaimsParserLibrary.sol";


contract BClaimsParserLibraryTest is DSTest {

    function example_bclaim() private returns(bytes memory) {
        bytes memory bclaimCapnProto =
            hex"00000000"
            hex"02000400"
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
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470";
        return bclaimCapnProto;
    }
}