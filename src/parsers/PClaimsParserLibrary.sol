pragma solidity >=0.7.4;
pragma abicoder v2;

import "./BaseParserLibrary.sol";
import "./BClaimsParserLibrary.sol";
import "./RCertParserLibrary.sol";

library PClaimsParserLibrary {
    struct PClaims {
        BClaimsParserLibrary.BClaims bClaims;
        RCertParserLibrary.RCert rCert;
    }
}