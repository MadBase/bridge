// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

import "ds-test/test.sol";
import "./MerkleProofParserLibrary.sol";


contract MerkleProofParserLibraryTest is DSTest {

    function exampleMerkleProof() private pure returns(bytes memory) {
        bytes memory merkleProofCapnProto =
            hex"01" // is included
            hex"0004" // height
            hex"80ab269d23d84721a53f9f3accb024a1947bcf5e4910a152f38d55d7d644c995" // Key
            hex"0000000000000000000000000000000000000000000000000000000000000000" // ProofKey
            hex"0391f56ce9575815216c9c0fcffa1d50767adb008c1491b7da2dbc323b8c1fb5" // ProofValue
            hex"0001" // Size in bytes of the bitset array
            hex"0003" // number of proofs (32 bytes long)
            hex"b0"  // bitset array
            hex"066c7a6ef776fbae26f10eabcc5f0eb72b0f527c4cad8c4037940a28c2fe3159" // audit path
            hex"6974f1d60877fdff3125a5c1adb630afe3aa899820a0531cea8ee6a85eb11509"
            hex"25fc463686d6201f9c3973a9ebeabe4375d5a76d935bbec6cbb9d18bffe67216";

        return merkleProofCapnProto;
    }

    function assertEqMerkleProof(MerkleProofParserLibrary.MerkleProof memory actual, MerkleProofParserLibrary.MerkleProof memory expected) internal {
        assertTrue(actual.included == expected.included);
        assertEq(uint256(actual.keyHeight), uint256(expected.keyHeight));
        assertEq(actual.key, expected.key);
        assertEq(actual.proofKey, expected.proofKey);
        assertEq(actual.proofValue, expected.proofValue);
        assertEq0(expected.bitmap, actual.bitmap);
        assertEq0(expected.auditPath, actual.auditPath);
    }

    function createExpectedMerkleProof() internal pure returns(MerkleProofParserLibrary.MerkleProof memory){
        return MerkleProofParserLibrary.MerkleProof(
                true,
                4,
                hex"80ab269d23d84721a53f9f3accb024a1947bcf5e4910a152f38d55d7d644c995",
                hex"0000000000000000000000000000000000000000000000000000000000000000",
                hex"0391f56ce9575815216c9c0fcffa1d50767adb008c1491b7da2dbc323b8c1fb5",
                hex"b0",
                hex"066c7a6ef776fbae26f10eabcc5f0eb72b0f527c4cad8c4037940a28c2fe31596974f1d60877fdff3125a5c1adb630afe3aa899820a0531cea8ee6a85eb1150925fc463686d6201f9c3973a9ebeabe4375d5a76d935bbec6cbb9d18bffe67216"
        );
    }

    function testDecodingMerkleProof() public {
        uint256 startGas = gasleft();
        MerkleProofParserLibrary.MerkleProof memory actual = MerkleProofParserLibrary.extractMerkleProof(exampleMerkleProof());
        uint256 endGas = gasleft();
        emit log_named_uint("MerkleProof gas", startGas - endGas);
        MerkleProofParserLibrary.MerkleProof memory expected = createExpectedMerkleProof();
        assertEqMerkleProof(actual, expected);
    }


}