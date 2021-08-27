// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

import "./BaseParserLibrary.sol";

library RClaimsParserLibrary {
    //size in bytes of a RCLAIMS cap'npro structure without the cap'n proto
    //header bytes
    uint256 internal constant RCLAIMS_SIZE = 56;
    // Number of bytes of a capnproto header, the data starts after the header
    uint256 internal constant CAPNPROTO_HEADER_SIZE = 8;

    struct RClaims {
        uint32 chainId;
        uint32 height;
        uint32 round;
        bytes32 prevBlock;
    }

    // This function is for serializing data directly from capnproto RClaim
    function extractRClaims(bytes memory src)
        internal
        pure
        returns (RClaims memory rClaims)
    {
        return extractRClaims(src, CAPNPROTO_HEADER_SIZE);
    }

    // todo: add docs
    function extractRClaims(bytes memory src, uint256 dataOffset)
        internal
        pure
        returns (RClaims memory rClaims)
    {
        require(
            dataOffset + RCLAIMS_SIZE > dataOffset,
            "RClaimsParserLibrary: Overflow on the dataOffset parameter"
        );
        require(
            src.length >= dataOffset + RCLAIMS_SIZE,
            "RClaimsParserLibrary: Not enought bytes to extract RClaims"
        );
        rClaims.chainId = BaseParserLibrary.extractUInt32(src, dataOffset);
        rClaims.height = BaseParserLibrary.extractUInt32(src, dataOffset + 4);
        rClaims.round = BaseParserLibrary.extractUInt32(src, dataOffset + 8);
        rClaims.prevBlock = BaseParserLibrary.extractBytes32(
            src,
            dataOffset + 24
        );
    }
}
