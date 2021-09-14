// SPDX-License-Identifier: MIT-open-group
pragma solidity >= 0.5.15;

import "ds-test/test.sol";
import "./MerkleProofLibrary.sol";
import "../parsers/MerkleProofParserLibrary.sol";

contract TestMerkleProofLibrary is DSTest {

    // function testKeyIsValidMerkleTree() public {
    //     bytes memory auditPath =
    //         hex"066c7a6ef776fbae26f10eabcc5f0eb72b0f527c4cad8c4037940a28c2fe3159"
    //         hex"6974f1d60877fdff3125a5c1adb630afe3aa899820a0531cea8ee6a85eb11509"
    //         hex"25fc463686d6201f9c3973a9ebeabe4375d5a76d935bbec6cbb9d18bffe67216";
    //     bytes32 root = hex"51f16d008cec2409af8104a0bca9facec585e02c12d2fa5221707672410dc692";
    //     bytes32 keyHash = hex"a53ec428ed37200bcb4944a99107b738c1a58ef76287b130583095c58b0f45e4";
    //     bytes32 key = hex"80ab269d23d84721a53f9f3accb024a1947bcf5e4910a152f38d55d7d644c995"; // utxoID
    //     bytes memory bitset = hex"b0";
    //     uint16 height = 0x4;
    //     bool included = true;
    //     bytes32 proofKey = hex"0391f56ce9575815216c9c0fcffa1d50767adb008c1491b7da2dbc323b8c1fb5";

    //     bool isValid = MerkleProofLibrary.checkProof(auditPath, root, keyHash, key, bitset, height, included, proofKey);
    //     assertTrue(isValid, "The proof should be valid");
    // }

    // function testKeyIsNotInsideMerkleTree() public {
    //     bytes memory auditPath =
    //         hex"066c7a6ef776fbae26f10eabcc5f0eb72b0f527c4cad8c4037940a28c2fe3159"
    //         hex"6974f1d60877fdff3125a5c1adb630afe3aa899820a0531cea8ee6a85eb11509"
    //         hex"25fc463686d6201f9c3973a9ebeabe4375d5a76d935bbec6cbb9d18bffe67216";
    //     bytes32 root = hex"51f16d008cec2409af8104a0bca9facec585e02c12d2fa5221707672410dc692";
    //     bytes32 keyHash = hex"d2056ce8d2aca5dfebd7a2ee14e01d4beda84ba1c5968cd7f0717de28d89988c";
    //     bytes32 key = hex"80ab269d23d84721a53f9f3accb024a1947bcf5e4910a152f38d55d7d644c996"; // utxoID
    //     bytes memory bitset = hex"b0";
    //     uint16 height = 0x4;
    //     bool included = false;
    //     bytes32 proofKey = hex"80ab269d23d84721a53f9f3accb024a1947bcf5e4910a152f38d55d7d644c995";

    //     bool isValid = MerkleProofLibrary.checkProof(auditPath, root, keyHash, key, bitset, height, included, proofKey);
    //     assertTrue(!isValid, "Should not be inside");
    // }

    // function testKeyIsNotInsideMerkleTree2() public {
    //     bytes memory auditPath = hex"ae68be4a30b6e4158f672298af814ce905ec1d486c0705f3a964859610eaef45";
    //     bytes32 root = hex"6cfa7a7076fd4b09b8dd9bb1d0737254f200c794bc46394b01b0b43f9de67090";
    //     bytes32 keyHash = hex"9105f42f6c6392bfcd9ca1cf5c4556e2455554e5467348569d357a6e7874ca82";
    //     bytes32 key = hex"80ab269d23d84721a53f9f3accb024a1947bcf5e4910a152f38d55d7d644c996"; // utxoID
    //     bytes memory bitset = hex"80";
    //     uint16 height = 0x1;
    //     bool included = false;
    //     bytes32 proofKey = hex"80ab269d23d84721a53f9f3accb024a1947bcf5e4910a152f38d55d7d644c995";

    //     bool isValid = MerkleProofLibrary.checkProof(auditPath, root, keyHash, key, bitset, height, included, proofKey);
    //     assertTrue(!isValid, "Should not be inside");
    // }

    // function testExploitMerkleTree() public {
    //     bytes memory auditPath =
    //         hex"066c7a6ef776fbae26f10eabcc5f0eb72b0f527c4cad8c4037940a28c2fe3159"
    //         hex"6974f1d60877fdff3125a5c1adb630afe3aa899820a0531cea8ee6a85eb11509"
    //         hex"25fc463686d6201f9c3973a9ebeabe4375d5a76d935bbec6cbb9d18bffe67216";
    //     bytes32 root = hex"51f16d008cec2409af8104a0bca9facec585e02c12d2fa5221707672410dc692";
    //     bytes32 keyHash = hex"a53ec428ed37200bcb4944a99107b738c1a58ef76287b130583095c58b0f45e4";
    //     bytes32 key = hex"80ab269d23d84721a53f9f3accb024a1947bcf5e4910a152f38d55d7d644c995"; // utxoID
    //     bytes memory bitset = hex"b0";
    //     uint16 height = 0x4;
    //     bool included = false;
    //     bytes32 proofKey = hex"80ab269d23d84721a53f9f3accb024a1947bcf5e4910a152f38d55d7d644c995";

    //     bool isValid = MerkleProofLibrary.checkProof(auditPath, root, keyHash, key, bitset, height, included, proofKey);
    //     assertTrue(isValid, "The proof should be valid");
    // }

    function testComputeLeafHash() public {
        bytes32 key = hex"80ab269d23d84721a53f9f3accb024a1947bcf5e4910a152f38d55d7d644c995";
        bytes32 proofValue = hex"0391f56ce9575815216c9c0fcffa1d50767adb008c1491b7da2dbc323b8c1fb5";
        uint16 height = 0x4;
        bytes32 expectedKeyHash = hex"a53ec428ed37200bcb4944a99107b738c1a58ef76287b130583095c58b0f45e4";
        assertTrue(MerkleProofLibrary.computeLeafHash(key, proofValue, height) == expectedKeyHash, "The computed hashes should be equal");
    }

    //todo test with height greater than 256 and 0

    function testNonInclusionMerkleProof() public {
        bytes memory auditPath =
            hex"066c7a6ef776fbae26f10eabcc5f0eb72b0f527c4cad8c4037940a28c2fe3159"
            hex"6974f1d60877fdff3125a5c1adb630afe3aa899820a0531cea8ee6a85eb11509"
            hex"25fc463686d6201f9c3973a9ebeabe4375d5a76d935bbec6cbb9d18bffe67216";
        bytes32 root = hex"51f16d008cec2409af8104a0bca9facec585e02c12d2fa5221707672410dc692";
        bytes32 keyHash = hex"a53ec428ed37200bcb4944a99107b738c1a58ef76287b130583095c58b0f45e4";
        bytes32 key = hex"80ab269d23d84721a53f9f3accb024a1947bcf5e4910a152f38d55d7d644c995"; // utxoID
        bytes memory bitset = hex"b0";
        uint16 height = 0x4;
        bool included = false;
        bytes32 proofKey = hex"00";
        bytes32 proofValue = hex"0391f56ce9575815216c9c0fcffa1d50767adb008c1491b7da2dbc323b8c1fb5";

        MerkleProofParserLibrary.MerkleProof memory _proof =  MerkleProofParserLibrary.MerkleProof(included, height, key, proofKey, proofValue, bitset, auditPath);
        MerkleProofLibrary.checkProofAbs(_proof, root);
    }

    function testValidProofKeyButNotInTheKeyPath() public {
        bytes memory auditPath =
            hex"066c7a6ef776fbae26f10eabcc5f0eb72b0f527c4cad8c4037940a28c2fe3159"
            hex"6974f1d60877fdff3125a5c1adb630afe3aa899820a0531cea8ee6a85eb11509"
            hex"25fc463686d6201f9c3973a9ebeabe4375d5a76d935bbec6cbb9d18bffe67216";
        bytes32 root = hex"51f16d008cec2409af8104a0bca9facec585e02c12d2fa5221707672410dc692";
        bytes32 keyHash = hex"a53ec428ed37200bcb4944a99107b738c1a58ef76287b130583095c58b0f45e4";
        bytes32 key = hex"80ab269d23d84721a53f9f3accb024a1947bcf5e4910a152f38d55d7d644c995"; // utxoID
        bytes memory bitset = hex"b0";
        uint16 height = 0x4;
        bool included = true;
        // Proof key is inside the trie but is not in the path of our Key
        bytes32 proofKey = hex"7a6315f5d19bf3f3bed9ef4e6002ebf76d4d05a7f7e84547e20b40fde2c34411";
        bytes32 proofValue = hex"e10fbdbaa5b72d510af6dd5ebd08da8b2fbd2b06d4787ce15a6eaf518c2d97fc";

        MerkleProofParserLibrary.MerkleProof memory _proof =  MerkleProofParserLibrary.MerkleProof(included, height, key, proofKey, proofValue, bitset, auditPath);
        MerkleProofLibrary.checkProofAbs(_proof, root);
    }
    function testInvalidProofKey() public {
        bytes memory auditPath =
            hex"066c7a6ef776fbae26f10eabcc5f0eb72b0f527c4cad8c4037940a28c2fe3159"
            hex"6974f1d60877fdff3125a5c1adb630afe3aa899820a0531cea8ee6a85eb11509"
            hex"25fc463686d6201f9c3973a9ebeabe4375d5a76d935bbec6cbb9d18bffe67216";
        bytes32 root = hex"51f16d008cec2409af8104a0bca9facec585e02c12d2fa5221707672410dc692";
        bytes32 keyHash = hex"a53ec428ed37200bcb4944a99107b738c1a58ef76287b130583095c58b0f45e4";
        bytes32 key = hex"80ab269d23d84721a53f9f3accb024a1947bcf5e4910a152f38d55d7d644c995"; // utxoID
        bytes memory bitset = hex"b0";
        uint16 height = 0x4;
        bool included = true;
        // Proof key is inside the trie but is not in the path of our Key
        bytes32 proofKey = hex"7a6315f5d19bf3f3bed9ef4e6002ebf76d4d05a7f7e84547e20b40fde2c34416";
        bytes32 proofValue = hex"e10fbdbaa5b72d510af6dd5ebd08da8b2fbd2b06d4787ce15a6eaf518c2d97fc";

        MerkleProofParserLibrary.MerkleProof memory _proof =  MerkleProofParserLibrary.MerkleProof(included, height, key, proofKey, proofValue, bitset, auditPath);
        MerkleProofLibrary.checkProofAbs(_proof, root);
    }


}
