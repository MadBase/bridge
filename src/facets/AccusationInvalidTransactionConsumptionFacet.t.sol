// SPDX-License-Identifier: MIT-open-group
pragma solidity >= 0.5.15;
pragma abicoder v2;

import "ds-test/test.sol";
import "./Setup.t.sol";
import "../Constants.sol";


contract StakingTokenMock is Token {

    constructor(bytes32 symbol, bytes32 name) Token(symbol, name) {}

    function approveFor(address owner, address who, uint wad) external returns (bool) {
        allowance[owner][who] = wad;

        emit Approval(owner, who, wad);

        return true;
    }

}

contract AccusationInvalidTransactionConsumptionFacetTest is Constants, DSTest, Setup {

    function setUp() public override {
        setUp(address(new StakingTokenMock("STK", "MadNet Staking")));
    }

    // Helper functions to create validators
    function generateMadID(uint256 id) internal pure returns (uint256[2] memory madID) {
        madID[0] = id;
        madID[1] = id;
    }

    function getValidAccusationData_NonExistentUTXO() internal pure returns(
        bytes memory pClaimsCapnProto,
        bytes memory pClaimsSig,
        bytes memory bClaimsCapnProto,
        bytes memory bClaimsSigGroup,
        bytes memory txInPreImageCapnProto,
        bytes[3] memory proofs
    ) {
        pClaimsCapnProto = hex"000000000000020004000000020004005800000000000200010000000200000001000000000000000d00000002010000190000000201000025000000020100003100000002010000fb9caafb31a4d4cada31e5d20ef0952832d8f37a70aa40c7035a693199e964afa368ad44a1ae7ea22d0857c32da7e679fb29c4357e4de838394faf0bd57e14930d66a8a0babec3d38b67b5239c1683f15a57e087f3825fac3d70fd6a243ed30bc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a47004000000020001001d00000002060000010000000200000001000000000000000100000002010000fb9caafb31a4d4cada31e5d20ef0952832d8f37a70aa40c7035a693199e964af258aa89365a642358d92db67a13cb25d73e6eedf0d25100d8d91566882fac54b1ccedfb0425434b54999a88cd7d993e05411955955c0cfec9dd33066605bd4a60f6bbfbab37349aaa762c23281b5749932c514f3b8723cf9bb05f9841a7f2d0e0f75e42fd6c8e9f0edadac3dcfb7416c2d4b2470f4210f2afa93138615b1deb106f5308b02f59062b735d0021ba93b1b9c09f3e168384b96b1eccfed659357142a7bd3532dc054cb5be81e9d559128229d61a00474b983a3569f538eb03d07ce";

        pClaimsSig = hex"51cacd39457727591e75c61733f38447039d3bc7dd326fa946d2136ed14cacfe2f0a1421c17e26b644b0c3fca9b38907cd90de93b9a75e8cfccfad50b351ae3000";

        bClaimsCapnProto = hex"0000000002000400010000000100000005000000000000000d0000000201000019000000020100002500000002010000310000000201000041b1a0649752af1b28b3dc29a1556eee781e4a4c3a1f7f53f90fa834de098c4d3d9261b2bee4a635db058a9f13572c18c8d092182125ddd96ca58c3f405993f00d66a8a0babec3d38b67b5239c1683f15a57e087f3825fac3d70fd6a243ed30bc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470";

        bClaimsSigGroup = hex"258aa89365a642358d92db67a13cb25d73e6eedf0d25100d8d91566882fac54b1ccedfb0425434b54999a88cd7d993e05411955955c0cfec9dd33066605bd4a60f6bbfbab37349aaa762c23281b5749932c514f3b8723cf9bb05f9841a7f2d0e0f75e42fd6c8e9f0edadac3dcfb7416c2d4b2470f4210f2afa93138615b1deb106f5308b02f59062b735d0021ba93b1b9c09f3e168384b96b1eccfed659357142a7bd3532dc054cb5be81e9d559128229d61a00474b983a3569f538eb03d07ce";

        // proofAgainstStateRootCapnProto
        proofs[0] = hex"000004da3dc36dc016d513fbac07ed6605c6157088d8c673df3b5bb09682b7937d52500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010003d0686741a9adaa231d9555e49c4a4c96bf30992aaaf2784df9ae047a21364ce138fb9eb5ced6edc2826e734abad6235c8cf638c812247fd38f04e7080d431933b9c6d6f24756341fde3e8055dd3a83743a94dddc122ab3f32a3db0c4749ff57bad";

        // proofInclusionTXRootCapnProto
        proofs[1] = hex"0100006e286c26d8715685894787919c58c9aeee7dff73f88bf476dab1d282d535e5f200000000000000000000000000000000000000000000000000000000000000007015f14a90fd8c32ff946f17def605bccdee5f828a0dcd5c8e373346d41547a40001000000";

        // proofInclusionTXHashCapnProto
        proofs[2] = hex"010005da3dc36dc016d513fbac07ed6605c6157088d8c673df3b5bb09682b7937d52500000000000000000000000000000000000000000000000000000000000000000059fb90cd9bd014b03f9967c7258b7fe11bb03415c0331926d5cbcaa3e89582300010002885bfe473b114836cb46eaac9f8dc3f250cac5f74e60f42419a180a419842a8291b3dc4df7060209ffb1efa66f693ed888c15034398312231b51894f86343c2421";

        txInPreImageCapnProto = hex"000000000100010001000000000000000100000002010000f172873c63909462ac4de545471fd3ad3e9eeadeec4608b92d16ce6b500704cc";
    }

    function getValidAccusationData_DoubleSpentDeposit() internal pure returns(
        bytes memory pClaimsCapnProto,
        bytes memory pClaimsSig,
        bytes memory bClaimsCapnProto,
        bytes memory bClaimsSigGroup,
        bytes memory txInPreImageCapnProto,
        bytes[3] memory proofs
    ) {
        pClaimsCapnProto = hex"000000000000020004000000020004005800000000000200010000000200000001000000000000000d00000002010000190000000201000025000000020100003100000002010000fb9caafb31a4d4cada31e5d20ef0952832d8f37a70aa40c7035a693199e964afe025b75676058e9ce45178a8462da70dac3ae495f342fe5e222614ccab7e4d720d66a8a0babec3d38b67b5239c1683f15a57e087f3825fac3d70fd6a243ed30bc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a47004000000020001001d00000002060000010000000200000001000000000000000100000002010000fb9caafb31a4d4cada31e5d20ef0952832d8f37a70aa40c7035a693199e964af258aa89365a642358d92db67a13cb25d73e6eedf0d25100d8d91566882fac54b1ccedfb0425434b54999a88cd7d993e05411955955c0cfec9dd33066605bd4a60f6bbfbab37349aaa762c23281b5749932c514f3b8723cf9bb05f9841a7f2d0e0f75e42fd6c8e9f0edadac3dcfb7416c2d4b2470f4210f2afa93138615b1deb106f5308b02f59062b735d0021ba93b1b9c09f3e168384b96b1eccfed659357142a7bd3532dc054cb5be81e9d559128229d61a00474b983a3569f538eb03d07ce";

        pClaimsSig = hex"72092a7de7ecb4faf7920c424cb656624695396aac14a0b1091eeb141eb584fb3a9b4335a8d1ab584bb823b90bb456eedc318175ac0f95857a0c5e93e7e5da3b01";

        bClaimsCapnProto = hex"0000000002000400010000000100000005000000000000000d0000000201000019000000020100002500000002010000310000000201000041b1a0649752af1b28b3dc29a1556eee781e4a4c3a1f7f53f90fa834de098c4d3d9261b2bee4a635db058a9f13572c18c8d092182125ddd96ca58c3f405993f00d66a8a0babec3d38b67b5239c1683f15a57e087f3825fac3d70fd6a243ed30bc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470";

        bClaimsSigGroup = hex"258aa89365a642358d92db67a13cb25d73e6eedf0d25100d8d91566882fac54b1ccedfb0425434b54999a88cd7d993e05411955955c0cfec9dd33066605bd4a60f6bbfbab37349aaa762c23281b5749932c514f3b8723cf9bb05f9841a7f2d0e0f75e42fd6c8e9f0edadac3dcfb7416c2d4b2470f4210f2afa93138615b1deb106f5308b02f59062b735d0021ba93b1b9c09f3e168384b96b1eccfed659357142a7bd3532dc054cb5be81e9d559128229d61a00474b983a3569f538eb03d07ce";

        // proofAgainstStateRootCapnProto
        proofs[0] = hex"010100000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000000000000000000be3ba01ddd6fb3d58ff1e8b79b7db6db5ef6376d877f7ca88e0c78e141da9fa00210006e00000000000000000000000000000000000000000000000000000000000002300166eacf747876e3a8eb60fdd36cfac41e9ae27098cf605d90a019a895e98af171ddb3652b5ecb0881027ca462000d3614fd7735855db004c598622855e9190c49bd43690efe794fff0a9790fc9c3f694e251cd15dbf06a5217005cffc23943c254ec9d782b8991251f91af85390450ad21fc2befaf8f473367a30d579c36e221480543d6cc63a90d7c121e5219495ebc0091dd7355763da9d97931997f52260b1c925246c3b9255ebd67fc7daf4769f556b5eaefbd62d31daf7f6c43da4ffe2c";

        // proofInclusionTXRootCapnProto
        proofs[1] = hex"0100007b802d223569d7b75cec992b1b028b0c2092d950d992b11187f11ee568c469bd00000000000000000000000000000000000000000000000000000000000000006b5c11c9ed7bc16231e80c801decf57a31fbde8394e58d943477328a6e0da5330001000000";

        // proofInclusionTXHashCapnProto
        proofs[2] = hex"010003000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000000000000000000be3ba01ddd6fb3d58ff1e8b79b7db6db5ef6376d877f7ca88e0c78e141da9fa00010001808214ecf817f6c48eb8dd9e602fe03cf9e1bd1e449108f6203785ff49852f2976";

        txInPreImageCapnProto = hex"000000000100010001000000ffffffff01000000020100000000000000000000000000000000000000000000000000000000000000000030";
    }


    function getInvalidAccusationData_SpendingValidDeposit() internal pure returns(
        bytes memory pClaimsCapnProto,
        bytes memory pClaimsSig,
        bytes memory bClaimsCapnProto,
        bytes memory bClaimsSigGroup,
        bytes memory txInPreImageCapnProto,
        bytes[3] memory proofs
    ) {
        pClaimsCapnProto = hex"000000000000020004000000020004005800000000000200010000000200000001000000000000000d00000002010000190000000201000025000000020100003100000002010000fb9caafb31a4d4cada31e5d20ef0952832d8f37a70aa40c7035a693199e964afb272723f931f12cc652801de2f17ec7bdcb9d07f278d9141627c0624b355860c0d66a8a0babec3d38b67b5239c1683f15a57e087f3825fac3d70fd6a243ed30bc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a47004000000020001001d00000002060000010000000200000001000000000000000100000002010000fb9caafb31a4d4cada31e5d20ef0952832d8f37a70aa40c7035a693199e964af258aa89365a642358d92db67a13cb25d73e6eedf0d25100d8d91566882fac54b1ccedfb0425434b54999a88cd7d993e05411955955c0cfec9dd33066605bd4a60f6bbfbab37349aaa762c23281b5749932c514f3b8723cf9bb05f9841a7f2d0e0f75e42fd6c8e9f0edadac3dcfb7416c2d4b2470f4210f2afa93138615b1deb106f5308b02f59062b735d0021ba93b1b9c09f3e168384b96b1eccfed659357142a7bd3532dc054cb5be81e9d559128229d61a00474b983a3569f538eb03d07ce";

        pClaimsSig = hex"7b31cfb72e13e8824cca1e3059f3c1c8d8fda42852f0564a98ac1ec0c6568df03e15af96eeb2882035d823167ed4a3ab2d9b5927fee27caaf78b7e89119b319001";

        bClaimsCapnProto = hex"0000000002000400010000000100000005000000000000000d0000000201000019000000020100002500000002010000310000000201000041b1a0649752af1b28b3dc29a1556eee781e4a4c3a1f7f53f90fa834de098c4d3d9261b2bee4a635db058a9f13572c18c8d092182125ddd96ca58c3f405993f00d66a8a0babec3d38b67b5239c1683f15a57e087f3825fac3d70fd6a243ed30bc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470";

        bClaimsSigGroup = hex"258aa89365a642358d92db67a13cb25d73e6eedf0d25100d8d91566882fac54b1ccedfb0425434b54999a88cd7d993e05411955955c0cfec9dd33066605bd4a60f6bbfbab37349aaa762c23281b5749932c514f3b8723cf9bb05f9841a7f2d0e0f75e42fd6c8e9f0edadac3dcfb7416c2d4b2470f4210f2afa93138615b1deb106f5308b02f59062b735d0021ba93b1b9c09f3e168384b96b1eccfed659357142a7bd3532dc054cb5be81e9d559128229d61a00474b983a3569f538eb03d07ce";

        // proofAgainstStateRootCapnProto
        proofs[0] = hex"010005cda80a6c60e1215c1882b25b4744bd9d95c1218a2fd17827ab809c68196fd9bf0000000000000000000000000000000000000000000000000000000000000000af469f3b9864a5132323df8bdd9cbd59ea728cd7525b65252133a5a02f1566ee00010003a8793650a7050ac58cf53ea792426b97212251673788bf0b4045d0bb5bdc3843aafb9eb5ced6edc2826e734abad6235c8cf638c812247fd38f04e7080d431933b9c6d6f24756341fde3e8055dd3a83743a94dddc122ab3f32a3db0c4749ff57bad";

        // proofInclusionTXRootCapnProto
        proofs[1] = hex"010000b4aec67f3220a8bcdee78d4aaec6ea419171e3db9c27c65d70cc85d60e07a3f70000000000000000000000000000000000000000000000000000000000000000111c8c4c333349644418902917e1a334a6f270b8b585661a91165298792437ed0001000000";

        // proofInclusionTXHashCapnProto
        proofs[2] = hex"010002cda80a6c60e1215c1882b25b4744bd9d95c1218a2fd17827ab809c68196fd9bf0000000000000000000000000000000000000000000000000000000000000000db3b45f6122fb536c80ace7701d8ade36fb508adf5296f12edfb1dfdbb242e0d00010002c042a165d6c097eb5ac77b72581c298f93375322fc57a03283891c2acc2ce66f8cb3dc4df7060209ffb1efa66f693ed888c15034398312231b51894f86343c2421";

        txInPreImageCapnProto = hex"0000000001000100010000000000000001000000020100007b802d223569d7b75cec992b1b028b0c2092d950d992b11187f11ee568c469bd";
    }

    function addValidator() private {
        // add validator
        StakingTokenMock mock = StakingTokenMock(registry.lookup(STAKING_TOKEN));
        address signer = 0x38e959391dD8598aE80d5d6D114a7822A09d313A;
        uint256[2] memory madID = generateMadID(987654321);
        stakingToken.transfer(signer, MINIMUM_STAKE);
        uint256 b = stakingToken.balanceOf(signer);
        assertEq(b, MINIMUM_STAKE);
        mock.approveFor(signer, address(staking), MINIMUM_STAKE);
        staking.lockStakeFor(signer, MINIMUM_STAKE);
        participants.addValidator(signer, madID);
        assertTrue(participants.isValidator(signer), "Not a validator");
    }

    function testConsumptionOfNonExistentUTXO() public {
        addValidator();

        bytes memory pClaims;
        bytes memory pClaimsSig;
        bytes memory bClaims;
        bytes memory bClaimsSigGroup;
        bytes memory txInPreImage;
        bytes[3] memory proofs;

        (
            pClaims,
            pClaimsSig,
            bClaims,
            bClaimsSigGroup,
            txInPreImage,
            proofs
        ) = getValidAccusationData_NonExistentUTXO();

        accusation.AccuseInvalidTransactionConsumption(
            pClaims,
            pClaimsSig,
            bClaims,
            bClaimsSigGroup,
            txInPreImage,
            proofs
        );
    }

    function testConsumptionOfDoubleSpentDeposit() public {
        addValidator();

        bytes memory pClaims;
        bytes memory pClaimsSig;
        bytes memory bClaims;
        bytes memory bClaimsSigGroup;
        bytes memory txInPreImage;
        bytes[3] memory proofs;

        (
            pClaims,
            pClaimsSig,
            bClaims,
            bClaimsSigGroup,
            txInPreImage,
            proofs
        ) = getValidAccusationData_DoubleSpentDeposit();

        accusation.AccuseInvalidTransactionConsumption(
            pClaims,
            pClaimsSig,
            bClaims,
            bClaimsSigGroup,
            txInPreImage,
            proofs
        );
    }

    function testFail_InvalidAccusation_ConsumptionOfValidDeposit() public {
        addValidator();

        bytes memory pClaims;
        bytes memory pClaimsSig;
        bytes memory bClaims;
        bytes memory bClaimsSigGroup;
        bytes memory txInPreImage;
        bytes[3] memory proofs;

        (
            pClaims,
            pClaimsSig,
            bClaims,
            bClaimsSigGroup,
            txInPreImage,
            proofs
        ) = getInvalidAccusationData_SpendingValidDeposit();

        accusation.AccuseInvalidTransactionConsumption(
            pClaims,
            pClaimsSig,
            bClaims,
            bClaimsSigGroup,
            txInPreImage,
            proofs
        );
    }

    function testFail_InvalidValidator() public {
        //addValidator();

        bytes memory pClaims;
        bytes memory pClaimsSig;
        bytes memory bClaims;
        bytes memory bClaimsSigGroup;
        bytes memory txInPreImage;
        bytes[3] memory proofs;

        (
            pClaims,
            pClaimsSig,
            bClaims,
            bClaimsSigGroup,
            txInPreImage,
            proofs
        ) = getValidAccusationData_NonExistentUTXO();

        accusation.AccuseInvalidTransactionConsumption(
            pClaims,
            pClaimsSig,
            bClaims,
            bClaimsSigGroup,
            txInPreImage,
            proofs
        );
    }

    function testFail_InvalidChainId() public {
        addValidator();

        bytes memory pClaims;
        bytes memory pClaimsSig;
        bytes memory bClaims;
        bytes memory bClaimsSigGroup;
        bytes memory txInPreImage;
        bytes[3] memory proofs;

        (
            pClaims,
            pClaimsSig,
            bClaims,
            bClaimsSigGroup,
            txInPreImage,
            proofs
        ) = getValidAccusationData_NonExistentUTXO();

        // inject another chainId on BClaims capn proto binary
        bClaims[9] = bytes1(uint8(0x2));

        accusation.AccuseInvalidTransactionConsumption(
            pClaims,
            pClaimsSig,
            bClaims,
            bClaimsSigGroup,
            txInPreImage,
            proofs
        );
    }

    function testFail_InvalidHeight() public {
        addValidator();

        bytes memory pClaims;
        bytes memory pClaimsSig;
        bytes memory bClaims;
        bytes memory bClaimsSigGroup;
        bytes memory txInPreImage;
        bytes[3] memory proofs;

        (
            pClaims,
            pClaimsSig,
            bClaims,
            bClaimsSigGroup,
            txInPreImage,
            proofs
        ) = getValidAccusationData_NonExistentUTXO();

        // inject another height on BClaims capn proto binary
        bClaims[13] = bytes1(uint8(0x4));

        accusation.AccuseInvalidTransactionConsumption(
            pClaims,
            pClaimsSig,
            bClaims,
            bClaimsSigGroup,
            txInPreImage,
            proofs
        );
    }

    function testFail_InvalidBClaimsGroupSig() public {
        addValidator();

        bytes memory pClaims;
        bytes memory pClaimsSig;
        bytes memory bClaims;
        bytes memory bClaimsSigGroup;
        bytes memory txInPreImage;
        bytes[3] memory proofs;

        (
            pClaims,
            pClaimsSig,
            bClaims,
            bClaimsSigGroup,
            txInPreImage,
            proofs
        ) = getValidAccusationData_NonExistentUTXO();

        // inject another bClaimsSigGroup
        bClaimsSigGroup[0] = bytes1(uint8(0x0));

        accusation.AccuseInvalidTransactionConsumption(
            pClaims,
            pClaimsSig,
            bClaims,
            bClaimsSigGroup,
            txInPreImage,
            proofs
        );
    }

    function testFail_InvalidBClaimsGroupSig2() public {
        addValidator();

        bytes memory pClaims;
        bytes memory pClaimsSig;
        bytes memory bClaims;
        bytes memory bClaimsSigGroup;
        bytes memory txInPreImage;
        bytes[3] memory proofs;

        (
            pClaims,
            pClaimsSig,
            bClaims,
            bClaimsSigGroup,
            txInPreImage,
            proofs
        ) = getValidAccusationData_NonExistentUTXO();

        // inject an invalid bClaimsSigGroup
        bClaimsSigGroup = hex"258aa89365a642358d92db67a13cb25d73e6eedf0d25100d8d91566882fac54b1ccedfb0425434b54999a88cd7d993e05411955955c0cfec9dd33066605bd4a60f6bbfbab37349aaa762c23281b5749932c514f3b8723cf9bb05f9841a7f2d0e0f75e42fd6c8e9f0edadac3dcfb7416c2d4b2470f4210f2afa93138615b1deb10cdc89f164e81cc49e06c4a7e1dcdcf7c0108e8cc9bb1032f9df6d4e834f1bb318accba7ae3f4b28bd9ba81695ba475f70d40a14b12ca3ef9764f2a6d9bfc53a";

        accusation.AccuseInvalidTransactionConsumption(
            pClaims,
            pClaimsSig,
            bClaims,
            bClaimsSigGroup,
            txInPreImage,
            proofs
        );
    }

     function testFail_InvalidBClaimsWithoutTransactions() public {
        bytes memory pClaims;
        bytes memory pClaimsSig;
        bytes memory bClaims;
        bytes memory bClaimsSigGroup;
        bytes memory txInPreImage;
        bytes[3] memory proofs;

        (
            pClaims,
            pClaimsSig,
            bClaims,
            bClaimsSigGroup,
            txInPreImage,
            proofs
        ) = getValidAccusationData_NonExistentUTXO();

        // inject an invalid pClaims that doesn't have transactions
        pClaims =
            hex"0000000000000200" // struct definition capn proto https://capnproto.org/encoding.html
            hex"0400000001000400" // BClaims struct definition
            hex"5400000000000200" // RCert struct definition
            hex"01000000" // chainId NOTE: BClaim starts here
            hex"02000000" // height
            hex"0d00000002010000" //list(uint8) definition for prevBlock
            hex"1900000002010000" //list(uint8) definition for txRoot
            hex"2500000002010000" //list(uint8) definition for stateRoot
            hex"3100000002010000" //list(uint8) definition for headerRoot
            hex"41b1a0649752af1b28b3dc29a1556eee781e4a4c3a1f7f53f90fa834de098c4d" //prevBlock
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470" //txRoot
            hex"b58904fe94d4dca4102566c56402dfa153037d18263b3f6d5574fd9e622e5627" //stateRoot
            hex"3e9768bd0513722b012b99bccc3f9ccbff35302f7ec7d75439178e5a80b45800" //headerRoot
            hex"0400000002000100" //RClaims struct definition NOTE:RCert starts here
            hex"1d00000002060000" //list(uint8) definition for sigGroup
            hex"01000000" // chainID
            hex"02000000" // Height
            hex"01000000" // round
            hex"00000000" // zeros pads for the round (capnproto operates using 8 bytes word)
            hex"0100000002010000" //list(uint8) definition for prevBlock
            hex"41b1a0649752af1b28b3dc29a1556eee781e4a4c3a1f7f53f90fa834de098c4d" //prevBlock
            hex"258aa89365a642358d92db67a13cb25d73e6eedf0d25100d8d91566882fac54b"
            hex"1ccedfb0425434b54999a88cd7d993e05411955955c0cfec9dd33066605bd4a6"
            hex"0f6bbfbab37349aaa762c23281b5749932c514f3b8723cf9bb05f9841a7f2d0e"
            hex"0f75e42fd6c8e9f0edadac3dcfb7416c2d4b2470f4210f2afa93138615b1deb1"
            hex"06f5308b02f59062b735d0021ba93b1b9c09f3e168384b96b1eccfed65935714"
            hex"2a7bd3532dc054cb5be81e9d559128229d61a00474b983a3569f538eb03d07ce";

        accusation.AccuseInvalidTransactionConsumption(
            pClaims,
            pClaimsSig,
            bClaims,
            bClaimsSigGroup,
            txInPreImage,
            proofs
        );

     }

    function test_ComputeUTXOID() public {
        bytes32 txHash = hex"f172873c63909462ac4de545471fd3ad3e9eeadeec4608b92d16ce6b500704cc";
        uint32 txIdx = 0;
        bytes32 expected = hex"da3dc36dc016d513fbac07ed6605c6157088d8c673df3b5bb09682b7937d5250";
        bytes32 actual = AccusationLibrary.computeUTXOID(txHash, txIdx);
        assertEq(actual, expected);

        bytes32 txHash2 = hex"b4aec67f3220a8bcdee78d4aaec6ea419171e3db9c27c65d70cc85d60e07a3f7";
        uint32 txIdx2 = 1;
        bytes32 expected2 = hex"4f6b55978f29b3eae295b96d213a58c4d69ef65f20b3c4463ff682aeb0407625";
        bytes32 actual2 = AccusationLibrary.computeUTXOID(txHash2, txIdx2);
        assertEq(actual2, expected2);
    }

}
