// SPDX-License-Identifier: MIT-open-group
pragma solidity >= 0.5.15;

import "../parsers/PClaimsParserLibrary.sol";
import "./ChainStatusLibrary.sol";
import "./ParticipantsLibrary.sol";
import "./SnapshotsLibrary.sol";

library AccusationLibrary {

    /// @dev Storage code to support diamond pattern
    bytes32 constant STORAGE_LOCATION = keccak256("accusation.storage");

    struct AccusationStorage {
        // Not sure exactly what storage is needed yet
        mapping(address => uint256) accusations;
    }

    /// @dev function to support the diamond pattern
    function accusationStorage() internal pure returns (AccusationStorage storage s) {
        bytes32 position = STORAGE_LOCATION;
        assembly { // solium-disable-line
            s.slot := position
        }
    }

    /// @notice This function validates an accusation of multiple proposals.
    /// @param _signature0 The signature of pclaims0
    /// @param _pClaims0 The PClaims of the accusation
    /// @param _signature1 The signature of pclaims1
    /// @param _pClaims1 The PClaims of the accusation
    /// @return the address of the signer
    function AccuseMultipleProposal(
        bytes calldata _signature0,
        bytes calldata _pClaims0,
        bytes calldata _signature1,
        bytes calldata _pClaims1
    ) internal view returns(address) {
        // ecrecover sig0/1 and ensure both are valid and accounts are equal
        address signerAccount0 = recoverMadNetSigner(_signature0, _pClaims0);
        address signerAccount1 = recoverMadNetSigner(_signature1, _pClaims1);

        require(signerAccount0 == signerAccount1, "Invalid multiple proposal accusation, the signers of the proposals are different!");

        // ensure the hashes of blob0/1 are different
        require(keccak256(_pClaims0) != keccak256(_pClaims1), "Invalid multiple proposal accusation, the PClaims are equal!");

        PClaimsParserLibrary.PClaims memory pClaims0 = PClaimsParserLibrary.extractPClaims(_pClaims0, PClaimsParserLibrary.CAPNPROTO_HEADER_SIZE);
        PClaimsParserLibrary.PClaims memory pClaims1 = PClaimsParserLibrary.extractPClaims(_pClaims1, PClaimsParserLibrary.CAPNPROTO_HEADER_SIZE);

        // ensure the height of blob0/1 are equal using RCert sub object of PClaims
        require(pClaims0.rCert.rClaims.height == pClaims1.rCert.rClaims.height, "Invalid multiple proposal accusation, the block heights between the proposals are different!");

        // ensure the round of blob0/1 are equal using RCert sub object of PClaims
        require(pClaims0.rCert.rClaims.round == pClaims1.rCert.rClaims.round, "Invalid multiple proposal accusation, the round between the proposals are different!");

        // ensure the chainid of blob0/1 are equal using RCert sub object of PClaims
        require(pClaims0.rCert.rClaims.chainId == pClaims1.rCert.rClaims.chainId, "Invalid multiple proposal accusation, the chainId between the proposals are different!");

        // ensure the chainid of blob0 is correct for this chain using RCert sub object of PClaims
        uint32 chainId = ChainStatusLibrary.chainId();
        require(pClaims0.rCert.rClaims.chainId == chainId, "Invalid multiple proposal accusation, the chainId is invalid for this chain!");

        // ensure both accounts are applicable to a currently locked validator - Note<may be done in different layer?>
        require(ParticipantsLibrary.isValidator(signerAccount0), "Invalid multiple proposal accusation, the signer of these proposals is not a valid validator!");

        return signerAccount0;
    }

    /// @notice Recovers the signer of a message
    /// @param signature The ECDSA signature
    /// @param prefix The prefix of the message
    /// @param message The message
    /// @return the address of the signer
    function recoverSigner(bytes memory signature, bytes memory prefix, bytes memory message) internal pure returns (address) {

        require(signature.length==65, "Signature should be 65 bytes");

        bytes32 hashedMessage = keccak256(abi.encodePacked(prefix, message));

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

        return ecrecover(hashedMessage, v, r, s);
    }


    /// @notice Recovers the signer of a message in MadNet
    /// @param signature The ECDSA signature
    /// @param message The message
    /// @return the address of the signer
    function recoverMadNetSigner(bytes memory signature, bytes memory message) internal pure returns (address) {
        return recoverSigner(signature, "Proposal" , message);
    }

}