// SPDX-License-Identifier: MIT-open-group
pragma solidity >= 0.5.15;

library SignatureLibrary {

    function recoverSigner(bytes memory signature, bytes memory message) internal pure returns (address) {

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
}