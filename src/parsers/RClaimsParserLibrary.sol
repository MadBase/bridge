// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

import "./BaseParserLibrary.sol";

library RClaimsParserLibrary {

    struct RClaims {
        uint32 chainID;
        uint32 height;
        uint32 round;
        bytes prevBlock;
    }

    // Returns the rclaims.chainID out of a capn proto data frame (~875 gas)
    function extract_chainID(bytes memory src) internal pure returns(uint32) {
        return BaseParserLibrary.extract_uint32(src, 8);
    }

    // Returns the rclaims.height out of a capn proto data frame (~787 gas)
    function extract_height(bytes memory src) internal pure returns(uint32) {
        return BaseParserLibrary.extract_uint32(src, 12);
    }

    // Returns the rclaims.round out of a capn proto data frame (~809 gas)
    function extract_round(bytes memory src) internal pure returns(uint32) {
        return BaseParserLibrary.extract_uint32(src, 16);
    }

    // Returns the rclaims.prevBlock out of a capn proto data frame (~7754 gas)
    function extract_prevBlock(bytes memory src) internal pure returns(bytes memory) {
        return BaseParserLibrary.extract_bytes(src, 32, 32);
    }

    // Returns the rclaim out of a capn proto data frame (~9852 gas)
    function extract_rclaims(bytes memory src) internal pure returns(RClaims memory rclaims) {
        rclaims.chainID = extract_chainID(src);
        rclaims.height = extract_height(src);
        rclaims.round = extract_round(src);
        rclaims.prevBlock = extract_prevBlock(src);
    }

}