// SPDX-License-Identifier: MIT-open-group
pragma solidity >= 0.5.15;

import "../parsers/PClaimsParserLibrary.sol";
import "./ParticipantsLibrary.sol";
import "./SnapshotsLibrary.sol";

library AccusationLibrary {

    //
    // Storage code to support diamond pattern
    //
    bytes32 constant STORAGE_LOCATION = keccak256("accusation.storage");

    struct AccusationStorage {
        // Not sure exactly what storage is needed yet
        mapping(address => int) accusations;
    }

    function accusationStorage() internal pure returns (AccusationStorage storage s) {
        bytes32 position = STORAGE_LOCATION;
        assembly { // solium-disable-line
            s.slot := position
        }
    }

    //
    //
    //
    function AccuseMultipleProposal(
        bytes calldata _signature0,
        bytes calldata _pClaims0,
        bytes calldata _signature1,
        bytes calldata _pClaims1
    ) internal {
        // ecrecover sig0/1 and ensure both are valid and accounts are equal
        // ensure the hashes of blob0/1 are different
        // ensure the height of blob0/1 are equal using RCert sub object of PClaims
        // ensure the round of blob0/1 are equal using RCert sub object of PClaims
        // ensure the chainid of blob0/1 are equal using RCert sub object of PClaims
        // ensure the chainid of blob0 is correct for this chain using RCert sub object of PClaims
        // ensure both accounts are applicable to a currently locked validator - Note<may be done in different layer?>

        address signerAccount0 = recoverMadNetSigner(_signature0, _pClaims0);
        address signerAccount1 = recoverMadNetSigner(_signature1, _pClaims1);

        require(signerAccount0 == signerAccount1, "Invalid multiple proposal accusation, the signers of the proposals are different!");
        require(keccak256(_pClaims0) != keccak256(_pClaims1), "Invalid multiple proposal accusation, the PClaims are equal!");

        PClaimsParserLibrary.PClaims memory pClaims0 = PClaimsParserLibrary.extractPClaims(_pClaims0, PClaimsParserLibrary.CAPNPROTO_HEADER_SIZE);
        PClaimsParserLibrary.PClaims memory pClaims1 = PClaimsParserLibrary.extractPClaims(_pClaims1, PClaimsParserLibrary.CAPNPROTO_HEADER_SIZE);
        require(pClaims0.rCert.rClaims.height == pClaims1.rCert.rClaims.height, "Invalid multiple proposal accusation, the block heights between the proposals are different!");
        require(pClaims0.rCert.rClaims.round == pClaims1.rCert.rClaims.round, "Invalid multiple proposal accusation, the round between the proposals are different!");
        require(pClaims0.rCert.rClaims.chainId == pClaims1.rCert.rClaims.chainId, "Invalid multiple proposal accusation, the chainId between the proposals are different!");

        uint32 chainId = SnapshotsLibrary.getChainIdFromSnapshot(SnapshotsLibrary.epoch());
        require(pClaims0.rCert.rClaims.chainId == chainId, "Invalid multiple proposal accusation, the chainId is invalid for this chain!");
        require(ParticipantsLibrary.isValidator(signerAccount0), "Invalid multiple proposal accusation, the signer of these proposals is not a valid validator!");
    }

    function recoverEthereumSigner(bytes memory signature, bytes memory message) internal pure returns (address) {

        bytes32 prefixedMessage = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(message))
        );

        require(signature.length==65, "Signature should be 65 bytes");

        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly { // solium-disable-line
            r := mload(add(signature, 32))
            s := mload(add(signature, 64))
            v := byte(0, mload(add(signature, 96)))
        }

        v = (v < 27) ? (v + 27) : v;

        require(v == 27 || v == 28, "Signature uses invalid version");

        return ecrecover(prefixedMessage, v, r, s);
    }

    function recoverMadNetSigner(bytes memory signature, bytes memory message) internal pure returns (address) {

        require(signature.length==65, "Signature should be 65 bytes");

        bytes32 prefixedMessage = keccak256(
            abi.encodePacked("Proposal", message)
        );

        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly { // solium-disable-line
            r := mload(add(signature, 32))
            s := mload(add(signature, 64))
            v := byte(0, mload(add(signature, 96)))
        }

        v = (v < 27) ? (v + 27) : v;

        require(v == 27 || v == 28, "Signature uses invalid version");

        return ecrecover(prefixedMessage, v, r, s);
    }

}