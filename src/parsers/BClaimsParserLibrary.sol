pragma solidity >=0.7.4;
pragma abicoder v2;

import "./BaseParserLibrary.sol";

library BClaimsParserLibrary {
    struct BClaims {
        uint32 chainID;
        uint32 height;
        bytes prevBlock;
        uint32 txCount;
        bytes txRoot;
        bytes stateRoot;
        bytes headerRoot;
    }

}