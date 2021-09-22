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

    function exampleMerkleProofHeight0() private pure returns(bytes memory){
        bytes memory merkleProofCapnProto =
            hex"01"
            hex"0000"
            hex"7b802d223569d7b75cec992b1b028b0c2092d950d992b11187f11ee568c469bd"
            hex"0000000000000000000000000000000000000000000000000000000000000000"
            hex"6b5c11c9ed7bc16231e80c801decf57a31fbde8394e58d943477328a6e0da533"
            hex"0001"
            hex"00"
            hex"0000";
        return merkleProofCapnProto;
    }

    function exampleMerkleProofHeight256() private pure returns(bytes memory){
        bytes memory merkleProofCapnProto =
            hex"01"
            hex"0100"
            hex"0000000000000000000000000000000000000000000000000000000000000030"
            hex"0000000000000000000000000000000000000000000000000000000000000000"
            hex"0be3ba01ddd6fb3d58ff1e8b79b7db6db5ef6376d877f7ca88e0c78e141da9fa"
            hex"0021"
            hex"0006"
            hex"e00000000000000000000000000000000000000000000000000000000000002300"
            hex"166eacf747876e3a8eb60fdd36cfac41e9ae27098cf605d90a019a895e98af17"
            hex"1ddb3652b5ecb0881027ca462000d3614fd7735855db004c598622855e9190c4"
            hex"9bd43690efe794fff0a9790fc9c3f694e251cd15dbf06a5217005cffc23943c2"
            hex"54ec9d782b8991251f91af85390450ad21fc2befaf8f473367a30d579c36e221"
            hex"480543d6cc63a90d7c121e5219495ebc0091dd7355763da9d97931997f52260b"
            hex"1c925246c3b9255ebd67fc7daf4769f556b5eaefbd62d31daf7f6c43da4ffe2c";
        return merkleProofCapnProto;
    }

    function exampleMerkleProofWithAdditionalData() private pure returns(bytes memory) {
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
            hex"25fc463686d6201f9c3973a9ebeabe4375d5a76d935bbec6cbb9d18bffe67216"
            hex"deadbeefffffff0000000beefdeadbeefdeadbeefdeadbeefdeadbeefdead000"
            hex"deadbeefffffff0000000beefdeadbeefdeadbeefdeadbeefdeadbeefdead000";

        return merkleProofCapnProto;
    }

    function exampleMerkleProofWithMissingData() private pure returns(bytes memory) {
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
            hex"6974f1d60877fdff3125a5c1adb630afe3aa899820a0531cea8ee6a85e09"
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

    function createExpectedMerkleProofHeight0() internal pure returns(MerkleProofParserLibrary.MerkleProof memory){
        return MerkleProofParserLibrary.MerkleProof(
                true,
                0,
                hex"7b802d223569d7b75cec992b1b028b0c2092d950d992b11187f11ee568c469bd",
                hex"0000000000000000000000000000000000000000000000000000000000000000",
                hex"6b5c11c9ed7bc16231e80c801decf57a31fbde8394e58d943477328a6e0da533",
                hex"00",
                hex""
        );
    }

    function createExpectedMerkleProofHeight256() internal pure returns(MerkleProofParserLibrary.MerkleProof memory){
        return MerkleProofParserLibrary.MerkleProof(
                true,
                256,
                hex"0000000000000000000000000000000000000000000000000000000000000030",
                hex"0000000000000000000000000000000000000000000000000000000000000000",
                hex"0be3ba01ddd6fb3d58ff1e8b79b7db6db5ef6376d877f7ca88e0c78e141da9fa",
                hex"e00000000000000000000000000000000000000000000000000000000000002300",
                hex"166eacf747876e3a8eb60fdd36cfac41e9ae27098cf605d90a019a895e98af17"
                hex"1ddb3652b5ecb0881027ca462000d3614fd7735855db004c598622855e9190c4"
                hex"9bd43690efe794fff0a9790fc9c3f694e251cd15dbf06a5217005cffc23943c2"
                hex"54ec9d782b8991251f91af85390450ad21fc2befaf8f473367a30d579c36e221"
                hex"480543d6cc63a90d7c121e5219495ebc0091dd7355763da9d97931997f52260b"
                hex"1c925246c3b9255ebd67fc7daf4769f556b5eaefbd62d31daf7f6c43da4ffe2c"
        );
    }

    function testDecodingMerkleProof() public {
        MerkleProofParserLibrary.MerkleProof memory actual = MerkleProofParserLibrary.extractMerkleProof(exampleMerkleProof());
        MerkleProofParserLibrary.MerkleProof memory expected = createExpectedMerkleProof();
        assertEqMerkleProof(actual, expected);
    }

    function testDecodingMerkleProofWithAdditionalData() public {
        MerkleProofParserLibrary.MerkleProof memory actual = MerkleProofParserLibrary.extractMerkleProof(exampleMerkleProofWithAdditionalData());
        MerkleProofParserLibrary.MerkleProof memory expected = createExpectedMerkleProof();
        assertEqMerkleProof(actual, expected);
    }

    function testDecodingMerkleProofHeight0() public {
        MerkleProofParserLibrary.MerkleProof memory actual = MerkleProofParserLibrary.extractMerkleProof(exampleMerkleProofHeight0());
        MerkleProofParserLibrary.MerkleProof memory expected = createExpectedMerkleProofHeight0();
        assertEqMerkleProof(actual, expected);
    }

    function testDecodingMerkleProofHeight256() public {
        MerkleProofParserLibrary.MerkleProof memory actual = MerkleProofParserLibrary.extractMerkleProof(exampleMerkleProofHeight256());
        MerkleProofParserLibrary.MerkleProof memory expected = createExpectedMerkleProofHeight256();
        assertEqMerkleProof(actual, expected);
    }

    function testFail_ExtractingMerkleProofWithOutSideData() public {
        bytes memory merkleProof =
            hex"01"
            hex"0000"
            hex"7b802d223569d7b75cec992b1b028b0c2092d950d992b11187f11ee568c469bd"
            hex"0000000000000000000000000000000000000000000000000000000000000000"
            hex"6b5c11c9ed7bc16231e80c801decf57a31fbde8394e58d943477328a6e0da533"
            hex"ffff"
            hex"00000000"
            hex"ffff";
        MerkleProofParserLibrary.extractMerkleProof(merkleProof);
    }

    function testFail_ExtractingMerkleProofHeightGreatThan256() public {
        bytes memory merkleProof =
            hex"01"
            hex"ffff"
            hex"7b802d223569d7b75cec992b1b028b0c2092d950d992b11187f11ee568c469bd"
            hex"0000000000000000000000000000000000000000000000000000000000000000"
            hex"6b5c11c9ed7bc16231e80c801decf57a31fbde8394e58d943477328a6e0da533"
            hex"0000"
            hex"00"
            hex"0000";
        MerkleProofParserLibrary.extractMerkleProof(merkleProof);
    }

    function testFail_ExtractingMerkleProofWithoutHavingEnoughData() public {
        MerkleProofParserLibrary.extractMerkleProof(exampleMerkleProofWithMissingData());
    }

}