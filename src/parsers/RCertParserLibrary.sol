pragma solidity >=0.7.4;
pragma abicoder v2;

import "./BaseParserLibrary.sol";
import "./RClaimsParserLibrary.sol";

library RCertParserLibrary {
    //size in bytes of a RCLAIMS cap'npro structure without the cap'n proto
    //header bytes
    uint256 internal constant RCERT_SIZE = 56;
    // Number of bytes of a capnproto header, the data starts after the header
    uint256 internal constant CAPNPROTO_HEADER_SIZE = 8;
    // Number of Bytes of the sig group array
    uint256 internal constant SIG_GROUP_SIZE = 192;

    struct RCert {
        RClaimsParserLibrary.RClaims rClaims;
        bytes32[6] sigGroup;
    }

    function extractSigGroup(bytes memory src, uint256 dataOffset)
        internal
        pure
        returns (bytes32[6] memory sigGroup)
    {
        require(
            dataOffset + SIG_GROUP_SIZE > dataOffset,
            "RClaimsParserLibrary: Overflow on the dataOffset parameter"
        );
        require(
            src.length >= dataOffset + SIG_GROUP_SIZE,
            "RCertParserLibrary: Not enough bytes to extract"
        );
        // SIG_GROUP_SIZE = 192 bytes -> size in bytes of 6 bytes32 elements (6*32)
        for (uint256 idx = 0; idx < sigGroup.length; idx++) {
            sigGroup[idx] = BaseParserLibrary.extractBytes32(
                src,
                dataOffset + (idx * 32)
            );
        }
    }

    // Gas cost: 4012
    function extractRCert(bytes memory src)
        internal
        pure
        returns (RCert memory)
    {
        return extractRCert(src, CAPNPROTO_HEADER_SIZE);
    }

    function extractRCert(bytes memory src, uint256 dataOffset)
        internal
        pure
        returns (RCert memory rCert)
    {
        rCert.rClaims = RClaimsParserLibrary.extractRClaims(
            src,
            dataOffset + 16
        );
        rCert.sigGroup = extractSigGroup(src, dataOffset + 72);
    }
}
