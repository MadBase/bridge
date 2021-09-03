// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

import "./BaseParserLibrary.sol";

/// @title Library to parse the BClaims structure from a blob of capnproto data
library BClaimsParserLibrary {
    /** @dev size in bytes of a BCLAIMS cap'npro structure without the cap'n
      proto header bytes*/
    uint256 internal constant BCLAIMS_SIZE = 176;
    /** @dev Number of bytes of a capnproto header, the data starts after the
      header */
    uint256 internal constant CAPNPROTO_HEADER_SIZE = 8;

    struct BClaims {
        uint32 chainId;
        uint32 height;
        bytes32 prevBlock;
        uint32 txCount;
        bytes32 txRoot;
        bytes32 stateRoot;
        bytes32 headerRoot;
    }

    /**
    @notice This function is for serializing data directly from capnproto
            BClaims. It will skip the first 8 bytes (capnproto headers) and
            deserialize the BClaims Data. If BClaims is being extracted from
            inside of other structure (E.g PClaims capnproto) use the
            `extractBClaims(bytes, uint)` instead.
    */
    /// @param src Blob of binary data with a capnproto serialization
    /// @dev Execution cost: 2167 gas
    function extractBClaims(bytes memory src)
        internal
        pure
        returns (BClaims memory bClaims)
    {
        return extractBClaims(src, CAPNPROTO_HEADER_SIZE);
    }

    /**
    @notice This function is for serializing the BClaims struct from an defined
            location inside a binary blob. E.G Extract BClaims from inside of
            other structure (E.g PClaims capnproto) or skipping the capnproto
            headers.
    */
    /// @param src Blob of binary data with a capnproto serialization
    /// @param dataOffset offset to start reading the BClaims data from inside src
    /// @dev Execution cost: 1930 gas
    function extractBClaims(bytes memory src, uint256 dataOffset)
        internal
        pure
        returns (BClaims memory bClaims)
    {
        require(
            dataOffset + BCLAIMS_SIZE > dataOffset,
            "BClaimsParserLibrary: Overflow on the dataOffset parameter"
        );
        require(
            src.length >= dataOffset + BCLAIMS_SIZE,
            "BClaimsParserLibrary: Not enough bytes to extract BClaims"
        );
        bClaims.chainId = BaseParserLibrary.extractUInt32(src, dataOffset);
        bClaims.height = BaseParserLibrary.extractUInt32(src, dataOffset + 4);
        bClaims.prevBlock = BaseParserLibrary.extractBytes32(
            src,
            dataOffset + 48
        );
        bClaims.txCount = BaseParserLibrary.extractUInt32(src, dataOffset + 8);
        bClaims.txRoot = BaseParserLibrary.extractBytes32(src, dataOffset + 80);
        bClaims.stateRoot = BaseParserLibrary.extractBytes32(
            src,
            dataOffset + 112
        );
        bClaims.headerRoot = BaseParserLibrary.extractBytes32(
            src,
            dataOffset + 144
        );
    }
}
