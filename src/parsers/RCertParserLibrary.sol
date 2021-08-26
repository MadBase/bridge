pragma solidity >=0.7.4;
pragma abicoder v2;

import "./BaseParserLibrary.sol";
import "./RClaimsParserLibrary.sol";

library RCertParserLibrary {
    struct RCert {
        RClaimsParserLibrary.RClaims rClaims;
        bytes32[6] sigGroup;
    }

    function extractSigGroup(bytes memory src)
        internal
        pure
        returns (bytes32[6] memory sigGroup)
    {
        assembly{
            src := add(src, 76)
        }
        require(src.length >= 192, "RCertParserLibrary: Not enough bytes to extract");
        // 192 bytes = size in bytes of 6 bytes32 elements (6*32)
        for(uint256 idx=0; idx < sigGroup.length; idx++) {
            sigGroup[idx] = BaseParserLibrary.extractBytes32(src, idx*32);
        }
    }

    function extractRClaims(bytes memory src)
        internal
        pure
        returns (RClaimsParserLibrary.RClaims memory)
    {
        // adding the offset where the RClaims data begins inside the RCert
        // capnproto data
        bytes memory new_src;
        assembly{
            new_src := add(src, 24)
        }
        return RClaimsParserLibrary.parseRClaims(new_src);
    }

    function parseRCert(bytes memory src)
        internal
        pure
        returns (RCert memory rCert)
    {
        rCert.rClaims = extractRClaims(src);
        rCert.sigGroup = extractSigGroup(src);
    }
}
