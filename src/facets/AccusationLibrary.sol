// SPDX-License-Identifier: MIT-open-group
pragma solidity >= 0.5.15;

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
        bytes calldata _signatureGroup0,
        bytes calldata _pClaims0,
        bytes calldata _signatureGroup1,
        bytes calldata _pClaims1
    ) internal {
        
    }

    //
    //
    //
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

}