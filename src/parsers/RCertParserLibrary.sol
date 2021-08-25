pragma solidity >=0.7.4;
pragma abicoder v2;

import "./BaseParserLibrary.sol";
import "./RClaimsParserLibrary.sol";

library RCertParserLibrary {
    struct RCert {
        RClaimsParserLibrary.RClaims rClaims;
        bytes[] sigGroup;
    }
}