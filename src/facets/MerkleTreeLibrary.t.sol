// SPDX-License-Identifier: MIT-open-group
pragma solidity >= 0.5.15;

import "ds-test/test.sol";
import "./MerkleTreeLibrary.sol";

contract TestMerkleTreeLibrary is DSTest {

    //Successful case
    function testIsKeyInsideMerkleTree() public {
        bytes memory proofValue = hex"c6136f4517a635e3e56d0011b93c95a03922694646a8d902a4ec2ccfdfaa75dbed37516ea28daa4edc94a63b91d9e63645f4b7a04e3d9739d76b7e2efbb3ab20";
        bytes32 root = hex"51f16d008cec2409af8104a0bca9facec585e02c12d2fa5221707672410dc692";
        bytes32 keyHash = hex"82f8a0dcf79808641766767fd284413ffc6a7ccc3e170001c5d5acae0ff65a8a";
        uint256 key = 0x7a6315f5d19bf3f3bed9ef4e6002ebf76d4d05a7f7e84547e20b40fde2c34411;
        uint256 bitset = 0x3;
        uint256 height = 2;
        bool included = true;
        uint256 proofKey = 0;

        emit log_named_uint("key:", key);
        uint256 startGas = gasleft();
        bool isInside = MerkleTreeLibrary.checkProof(proofValue, root, keyHash, key, bitset, height, included, proofKey);
        uint256 endGas = gasleft();
        assertTrue(isInside, "The key should be inside");
        emit log_named_uint("AccuseMultipleProposal gas", startGas - endGas);
    }

    //Successful case
    function testIsKeyInsideMerkleTree2() public {
        bytes memory proofValue = hex"066c7a6ef776fbae26f10eabcc5f0eb72b0f527c4cad8c4037940a28c2fe31596974f1d60877fdff3125a5c1adb630afe3aa899820a0531cea8ee6a85eb1150925fc463686d6201f9c3973a9ebeabe4375d5a76d935bbec6cbb9d18bffe67216";
        bytes32 root = hex"51f16d008cec2409af8104a0bca9facec585e02c12d2fa5221707672410dc692";
        bytes32 keyHash = hex"a53ec428ed37200bcb4944a99107b738c1a58ef76287b130583095c58b0f45e4";
        uint256 key = 0x80ab269d23d84721a53f9f3accb024a1947bcf5e4910a152f38d55d7d644c908;
        uint256 bitset = 0xD;
        uint256 height = 4;
        bool included = true;
        uint256 proofKey = 0;

        emit log_named_uint("key:", key);
        uint256 startGas = gasleft();
        bool isInside = MerkleTreeLibrary.checkProof(proofValue, root, keyHash, key, bitset, height, included, proofKey);
        uint256 endGas = gasleft();
        assertTrue(isInside, "The key should be inside");
        emit log_named_uint("Merkle proof gas", startGas - endGas);
    }

    function testIsKeyInsideMerkleTree3() public {
        bytes memory proofValue = hex"066c7a6ef776fbae26f10eabcc5f0eb72b0f527c4cad8c4037940a28c2fe31596974f1d60877fdff3125a5c1adb630afe3aa899820a0531cea8ee6a85eb1150925fc463686d6201f9c3973a9ebeabe4375d5a76d935bbec6cbb9d18bffe67216";
        bytes32 root = hex"51f16d008cec2409af8104a0bca9facec585e02c12d2fa5221707672410dc692";
        bytes32 keyHash = hex"a53ec428ed37200bcb4944a99107b738c1a58ef76287b130583095c58b0f45e4";
        bytes memory key = hex"80ab269d23d84721a53f9f3accb024a1947bcf5e4910a152f38d55d7d644c995"; // utxoID
        bytes memory bitset = hex"b0";
        uint16 height = 0x4;
        bool included = true;
        bytes memory proofKey = hex"0000000000000000000000000000000000000000000000000000000000000000";

        //emit log_named_uint("key:", key);
        uint256 startGas = gasleft();
        bool isInside = MerkleTreeLibrary.checkProof2(proofValue, root, keyHash, key, bitset, height, included, proofKey);
        uint256 endGas = gasleft();
        assertTrue(isInside, "The key should be inside");
        emit log_named_uint("Merkle proof gas", startGas - endGas);
    }

    function testIsKeyInsideMerkleTree4() public {
        bytes memory proofValue = hex"066c7a6ef776fbae26f10eabcc5f0eb72b0f527c4cad8c4037940a28c2fe31596974f1d60877fdff3125a5c1adb630afe3aa899820a0531cea8ee6a85eb1150925fc463686d6201f9c3973a9ebeabe4375d5a76d935bbec6cbb9d18bffe67216";
        bytes32 root = hex"51f16d008cec2409af8104a0bca9facec585e02c12d2fa5221707672410dc692";
        bytes32 keyHash = hex"a53ec428ed37200bcb4944a99107b738c1a58ef76287b130583095c58b0f45e4";
        bytes32 key = hex"80ab269d23d84721a53f9f3accb024a1947bcf5e4910a152f38d55d7d644c995"; // utxoID
        bytes memory bitset = hex"b0";
        uint16 height = 0x4;
        bool included = true;
        bytes32 proofKey = hex"0391f56ce9575815216c9c0fcffa1d50767adb008c1491b7da2dbc323b8c1fb5";

        //emit log_named_uint("key:", key);
        uint256 startGas = gasleft();
        bool isInside = MerkleTreeLibrary.checkProof3(proofValue, root, keyHash, key, bitset, height, included, proofKey);
        uint256 endGas = gasleft();
        assertTrue(isInside, "The key should be inside");
        emit log_named_uint("Merkle proof gas", startGas - endGas);
    }

    function testIsKeyNotInsideMerkleTree() public {
        bytes memory proofValue = hex"066c7a6ef776fbae26f10eabcc5f0eb72b0f527c4cad8c4037940a28c2fe31596974f1d60877fdff3125a5c1adb630afe3aa899820a0531cea8ee6a85eb1150925fc463686d6201f9c3973a9ebeabe4375d5a76d935bbec6cbb9d18bffe67216";
        bytes32 root = hex"51f16d008cec2409af8104a0bca9facec585e02c12d2fa5221707672410dc692";
        bytes32 keyHash = hex"a53ec428ed37200bcb4944a99107b738c1a58ef76287b130583095c58b0f45e4";
        bytes32 key = hex"80ab269d23d84721a53f9f3accb024a1947bcf5e4910a152f38d55d7d644c996"; // utxoID
        bytes memory bitset = hex"b0";
        uint16 height = 0x4;
        bool included = false;
        bytes32 proofKey = hex"80ab269d23d84721a53f9f3accb024a1947bcf5e4910a152f38d55d7d644c995";

        //emit log_named_uint("key:", key);
        uint256 startGas = gasleft();
        bool isInside = MerkleTreeLibrary.checkProof3(proofValue, root, keyHash, key, bitset, height, included, proofKey);
        uint256 endGas = gasleft();
        assertTrue(!isInside, "Should not be inside");
        emit log_named_uint("Merkle proof gas", startGas - endGas);
    }

    function testIsKeyNotInsideMerkleTree2() public {
        bytes memory proofValue = hex"ae68be4a30b6e4158f672298af814ce905ec1d486c0705f3a964859610eaef45";
        bytes32 root = hex"6cfa7a7076fd4b09b8dd9bb1d0737254f200c794bc46394b01b0b43f9de67090";
        bytes32 keyHash = hex"2523d60a7147bf655acde840dd1dc6e901fcd31d7cd221e00854f971e38fab60";
        bytes32 key = hex"80ab269d23d84721a53f9f3accb024a1947bcf5e4910a152f38d55d7d644c996"; // utxoID
        bytes memory bitset = hex"80";
        uint16 height = 0x1;
        bool included = false;
        bytes32 proofKey = hex"80ab269d23d84721a53f9f3accb024a1947bcf5e4910a152f38d55d7d644c995";

        //emit log_named_uint("key:", key);
        uint256 startGas = gasleft();
        bool isInside = MerkleTreeLibrary.checkProof3(proofValue, root, keyHash, key, bitset, height, included, proofKey);
        uint256 endGas = gasleft();
        assertTrue(!isInside, "Should not be inside");
        emit log_named_uint("Merkle proof gas", startGas - endGas);
    }

    // should not be inside, but it is if `included` is set to true
    function testIsKeyNotInsideMerkleTree3() public {
        bytes memory proofValue = hex"066c7a6ef776fbae26f10eabcc5f0eb72b0f527c4cad8c4037940a28c2fe31596974f1d60877fdff3125a5c1adb630afe3aa899820a0531cea8ee6a85eb1150925fc463686d6201f9c3973a9ebeabe4375d5a76d935bbec6cbb9d18bffe67216";
        bytes32 root = hex"51f16d008cec2409af8104a0bca9facec585e02c12d2fa5221707672410dc692";
        bytes32 keyHash = hex"a53ec428ed37200bcb4944a99107b738c1a58ef76287b130583095c58b0f45e4";
        bytes32 key = hex"80ab269d23d84721a53f9f3accb024a1947bcf5e4910a152f38d55d7d644c996"; // utxoID
        bytes memory bitset = hex"b0";
        uint16 height = 0x4;
        bool included = true;
        bytes32 proofKey = hex"80ab269d23d84721a53f9f3accb024a1947bcf5e4910a152f38d55d7d644c995";

        //emit log_named_uint("key:", key);
        uint256 startGas = gasleft();
        bool isInside = MerkleTreeLibrary.checkProof3(proofValue, root, keyHash, key, bitset, height, included, proofKey);
        uint256 endGas = gasleft();
        assertTrue(!isInside, "The key should not be inside");
        emit log_named_uint("Merkle proof gas", startGas - endGas);
    }
    
    function testIsKeyNotInsideMerkleTree4() public {
        bytes memory proofValue = hex"ae68be4a30b6e4158f672298af814ce905ec1d486c0705f3a964859610eaef45";
        bytes32 root = hex"6cfa7a7076fd4b09b8dd9bb1d0737254f200c794bc46394b01b0b43f9de67090";
        bytes32 keyHash = hex"2523d60a7147bf655acde840dd1dc6e901fcd31d7cd221e00854f971e38fab60";
        bytes32 key = hex"80ab269d23d84721a53f9f3accb024a1947bcf5e4910a152f38d55d7d644c996"; // utxoID
        bytes memory bitset = hex"80";
        uint16 height = 0x1;
        bool included = false;
        bytes32 proofKey = hex"80ab269d23d84721a53f9f3accb024a1947bcf5e4910a152f38d55d7d644c995";

        //emit log_named_uint("key:", key);
        uint256 startGas = gasleft();
        bool isInside = MerkleTreeLibrary.checkProof3(proofValue, root, keyHash, key, bitset, height, included, proofKey);
        uint256 endGas = gasleft();
        assertTrue(!isInside, "The key should not be inside");
        emit log_named_uint("Merkle proof gas", startGas - endGas);
    }

}
