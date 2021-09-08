// SPDX-License-Identifier: MIT-open-group
pragma solidity >= 0.5.15;

import "ds-test/test.sol";
import "./MerkleTreeLibrary.sol";

contract TestMerkleTreeLibrary is DSTest {

    // Successful case
    function testIsKeyInsideMerkleTree() public {
        bytes memory proof = hex"c6136f4517a635e3e56d0011b93c95a03922694646a8d902a4ec2ccfdfaa75dbed37516ea28daa4edc94a63b91d9e63645f4b7a04e3d9739d76b7e2efbb3ab20";
        bytes32 root = hex"51f16d008cec2409af8104a0bca9facec585e02c12d2fa5221707672410dc692";
        bytes32 hash = hex"82f8a0dcf79808641766767fd284413ffc6a7ccc3e170001c5d5acae0ff65a8a";
        uint256 key = 0x7a6315f5d19bf3f3bed9ef4e6002ebf76d4d05a7f7e84547e20b40fde2c34411;
        uint256 bitset = 3;
        uint256 height = 2;
        bool included = true;
        uint256 proofKey = 0;

        emit log_named_uint("key:", key);
        //uint256 startGas = gasleft();
        bool isValid = MerkleTreeLibrary.checkProof(proof, root, hash, key, bitset, height, included, proofKey);
        //assertTrue(isValid, "The key should be inside the merkle tree");
        //uint256 endGas = gasleft();
        //emit log_named_uint("AccuseMultipleProposal gas", startGas - endGas);
    }

}
