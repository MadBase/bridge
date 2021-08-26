// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

import "./BaseParserLibrary.sol";

library RClaimsParserLibrary {

    struct RClaims {
        uint32 chainID;
        uint32 height;
        uint32 round;
        bytes32 prevBlock;
    }

    function extract_chainId(bytes memory src) internal pure returns(uint32) {
        return BaseParserLibrary.extract_uint32(src, 8);
    }

    function extract_height(bytes memory src) internal pure returns(uint32) {
        return BaseParserLibrary.extract_uint32(src, 12);
    }

    function extract_round(bytes memory src) internal pure returns(uint32) {
        return BaseParserLibrary.extract_uint32(src, 16);
    }

    // Returns the rclaims.prevBlock out of a capn proto data frame (~482 gas)
    function extract_prevBlock(bytes memory src) internal pure returns(bytes32) {
        return BaseParserLibrary.extract_bytes32(src, 32);
    }

    // Returns the rclaim out of a capn proto data frame (~2613 gas)
    function extract_rclaims(bytes memory src) internal pure returns(RClaims memory rclaims) {
        // todo measure gas cost of this 4 extract_* abstractions. We can call
        // the BaseParserLibrary directly
        rclaims.chainID = extract_chainId(src);
        rclaims.height = extract_height(src);
        rclaims.round = extract_round(src);
        rclaims.prevBlock = extract_prevBlock(src);
        return rclaims;
    }
}