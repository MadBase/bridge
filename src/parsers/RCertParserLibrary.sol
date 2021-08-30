pragma solidity >=0.7.4;
pragma abicoder v2;

import "./BaseParserLibrary.sol";
import "./RClaimsParserLibrary.sol";

/// @title Library to parse the RCert structure from a blob of capnproto data
library RCertParserLibrary {
    /** @dev size in bytes of a RCert cap'npro structure without the cap'n proto
      header bytes */
    uint256 internal constant RCERT_SIZE = 264;
    /** @dev Number of bytes of a capnproto header, the data starts after the
      header */
    uint256 internal constant CAPNPROTO_HEADER_SIZE = 8;
    /** @dev Number of Bytes of the sig group array */
    uint256 internal constant SIG_GROUP_SIZE = 192;

    struct RCert {
        RClaimsParserLibrary.RClaims rClaims;
        bytes32[6] sigGroup;
    }

    function extractSigGroup(bytes memory src, uint256 dataOffset)
        internal
        pure
        returns (bytes32[6] memory sigGroup)
    {
        require(
            dataOffset + SIG_GROUP_SIZE > dataOffset,
            "RClaimsParserLibrary: Overflow on the dataOffset parameter"
        );
        require(
            src.length >= dataOffset + SIG_GROUP_SIZE,
            "RCertParserLibrary: Not enough bytes to extract"
        );
        // SIG_GROUP_SIZE = 192 bytes -> size in bytes of 6 bytes32 elements (6*32)
        for (uint256 idx = 0; idx < sigGroup.length; idx++) {
            sigGroup[idx] = BaseParserLibrary.extractBytes32(
                src,
                dataOffset + (idx * 32)
            );
        }
    }

    /**
    @notice This function is for serializing data directly from capnproto
            RCert. It will skip the first 8 bytes (capnproto headers) and
            deserialize the RCert Data. If RCert is being extracted from
            inside of other structure (E.g PClaim capnproto) use the
            `extractRCert(bytes, uint)` instead.
    */
    /// @param src Blob of binary data with a capnproto serialization
    /// @dev Execution cost: 4076 gas
    function extractRCert(bytes memory src)
        internal
        pure
        returns (RCert memory)
    {
        return extractRCert(src, CAPNPROTO_HEADER_SIZE);
    }

    /**
    @notice This function is for serializing the RCert struct from an defined
            location inside a binary blob. E.G Extract RCert from inside of
            other structure (E.g RCert capnproto) or skipping the capnproto
            headers.
    */
    /// @param src Blob of binary data with a capnproto serialization
    /// @param dataOffset offset to start reading the RCert data from inside src
    /// @dev Execution cost: 3691 gas
    function extractRCert(bytes memory src, uint256 dataOffset)
        internal
        pure
        returns (RCert memory rCert)
    {
        require(
            dataOffset + RCERT_SIZE > dataOffset,
            "RCertParserLibrary: Overflow on the dataOffset parameter"
        );
        require(
            src.length >= dataOffset + RCERT_SIZE,
            "RCertParserLibrary: Not enough bytes to extract RCert"
        );
        rCert.rClaims = RClaimsParserLibrary.extractRClaims(
            src,
            dataOffset + 16
        );
        rCert.sigGroup = extractSigGroup(src, dataOffset + 72);
    }
}
