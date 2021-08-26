// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

import "./BaseParserLibrary.sol";

library RClaimsParserLibrary {
    struct RClaims {
        uint32 chainId;
        uint32 height;
        uint32 round;
        bytes32 prevBlock;
    }

    // Returns the rClaims.chainId out of a capn proto data frame (~875 gas)
    function extractChainId(bytes memory src)
        internal
        pure
        returns (uint32)
    {
        return BaseParserLibrary.extractUInt32(src, 8);
    }

    // Returns the rClaims.height out of a capn proto data frame (~787 gas)
    function extractHeight(bytes memory src)
        internal
        pure
        returns (uint32)
    {
        return BaseParserLibrary.extractUInt32(src, 12);
    }

    // Returns the rClaims.round out of a capn proto data frame (~809 gas)
    function extractRound(bytes memory src)
        internal
        pure
        returns (uint32)
    {
        return BaseParserLibrary.extractUInt32(src, 16);
    }

    // Returns the rClaims.prevBlock out of a capn proto data frame (~7754 gas)
    function extractPrevBlock(bytes memory src)
        internal
        pure
        returns (bytes32)
    {
        return BaseParserLibrary.extractBytes32(src, 32);
    }

    // Returns the rClaim out of a capn proto data frame (~9852 gas)
    function parseRClaims(bytes memory src)
        internal
        pure
        returns (RClaims memory rClaims)
    {
        rClaims.chainId = extractChainId(src);
        rClaims.height = extractHeight(src);
        rClaims.round = extractRound(src);
        rClaims.prevBlock = extractPrevBlock(src);
    }
}
