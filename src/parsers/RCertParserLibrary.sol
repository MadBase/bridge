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
        returns (bytes32[6] memory)
    {}

    function extractRClaims(bytes memory src)
        internal
        pure
        returns (RClaimsParserLibrary.RClaims memory rClaims)
    {}

    function parseRCert(bytes memory src)
        internal
        pure
        returns (RCert memory rCert)
    {
        rCert.rClaims = extractRClaims(src);
        rCert.sigGroup = extractSigGroup(src);
    }
}
