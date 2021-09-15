// SPDX-License-Identifier: MIT-open-group
pragma solidity >= 0.5.15;

import "ds-test/test.sol";
import "./Setup.t.sol";
import "../Constants.sol";
import "./AccusationLibrary.sol";

contract AccusationNonExistentUTXOConsumptionFacetTest is Constants, DSTest {

    function getTestData() internal pure returns(
        bytes memory pClaimsCapnProto,
        bytes memory pClaimsSig,
        bytes memory bClaimsCapnProto,
        bytes memory bClaimsSigGroup,
        bytes memory proofAgainstStateRootCapnProto,
        bytes memory proofInclusionTXRootCapnProto,
        bytes memory proofInclusionTXHashCapnProto,
        bytes memory txInPreImageCapnProto
    ) {
        pClaimsCapnProto = hex"000000000000020004000000020004005800000000000200010000000200000001000000000000000d00000002010000190000000201000025000000020100003100000002010000fb9caafb31a4d4cada31e5d20ef0952832d8f37a70aa40c7035a693199e964afa368ad44a1ae7ea22d0857c32da7e679fb29c4357e4de838394faf0bd57e14930d66a8a0babec3d38b67b5239c1683f15a57e087f3825fac3d70fd6a243ed30bc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a47004000000020001001d00000002060000010000000200000001000000000000000100000002010000fb9caafb31a4d4cada31e5d20ef0952832d8f37a70aa40c7035a693199e964af258aa89365a642358d92db67a13cb25d73e6eedf0d25100d8d91566882fac54b1ccedfb0425434b54999a88cd7d993e05411955955c0cfec9dd33066605bd4a60f6bbfbab37349aaa762c23281b5749932c514f3b8723cf9bb05f9841a7f2d0e0f75e42fd6c8e9f0edadac3dcfb7416c2d4b2470f4210f2afa93138615b1deb106f5308b02f59062b735d0021ba93b1b9c09f3e168384b96b1eccfed659357142a7bd3532dc054cb5be81e9d559128229d61a00474b983a3569f538eb03d07ce";

        pClaimsSig = hex"51cacd39457727591e75c61733f38447039d3bc7dd326fa946d2136ed14cacfe2f0a1421c17e26b644b0c3fca9b38907cd90de93b9a75e8cfccfad50b351ae3000";

        bClaimsCapnProto = hex"0000000002000400010000000100000005000000000000000d0000000201000019000000020100002500000002010000310000000201000041b1a0649752af1b28b3dc29a1556eee781e4a4c3a1f7f53f90fa834de098c4d3d9261b2bee4a635db058a9f13572c18c8d092182125ddd96ca58c3f405993f00d66a8a0babec3d38b67b5239c1683f15a57e087f3825fac3d70fd6a243ed30bc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470";

        bClaimsSigGroup = hex"258aa89365a642358d92db67a13cb25d73e6eedf0d25100d8d91566882fac54b1ccedfb0425434b54999a88cd7d993e05411955955c0cfec9dd33066605bd4a60f6bbfbab37349aaa762c23281b5749932c514f3b8723cf9bb05f9841a7f2d0e0f75e42fd6c8e9f0edadac3dcfb7416c2d4b2470f4210f2afa93138615b1deb106f5308b02f59062b735d0021ba93b1b9c09f3e168384b96b1eccfed659357142a7bd3532dc054cb5be81e9d559128229d61a00474b983a3569f538eb03d07ce";

        proofAgainstStateRootCapnProto = hex"000004da3dc36dc016d513fbac07ed6605c6157088d8c673df3b5bb09682b7937d52500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010003d0686741a9adaa231d9555e49c4a4c96bf30992aaaf2784df9ae047a21364ce138fb9eb5ced6edc2826e734abad6235c8cf638c812247fd38f04e7080d431933b9c6d6f24756341fde3e8055dd3a83743a94dddc122ab3f32a3db0c4749ff57bad";

        proofInclusionTXRootCapnProto = hex"0100006e286c26d8715685894787919c58c9aeee7dff73f88bf476dab1d282d535e5f200000000000000000000000000000000000000000000000000000000000000007015f14a90fd8c32ff946f17def605bccdee5f828a0dcd5c8e373346d41547a40001000000";

        proofInclusionTXHashCapnProto = hex"010005da3dc36dc016d513fbac07ed6605c6157088d8c673df3b5bb09682b7937d52500000000000000000000000000000000000000000000000000000000000000000059fb90cd9bd014b03f9967c7258b7fe11bb03415c0331926d5cbcaa3e89582300010002885bfe473b114836cb46eaac9f8dc3f250cac5f74e60f42419a180a419842a8291b3dc4df7060209ffb1efa66f693ed888c15034398312231b51894f86343c2421";

        txInPreImageCapnProto = hex"000000000100010001000000000000000100000002010000f172873c63909462ac4de545471fd3ad3e9eeadeec4608b92d16ce6b500704cc";

    }

    function testConsumptionOfNonExistentUTXO() public {
        bytes memory pClaims;
        bytes memory pClaimsSig;
        bytes memory bClaims;
        bytes memory bClaimsSigGroup;
        bytes memory proofAgainstStateRoot;
        bytes memory proofInclusionTXRoot;
        bytes memory proofInclusionTXHash;
        bytes memory txInPreImage;

        (
            pClaims,
            pClaimsSig,
            bClaims,
            bClaimsSigGroup,
            proofAgainstStateRoot,
            proofInclusionTXRoot,
            proofInclusionTXHash,
            txInPreImage
        ) = getTestData();

        AccusationLibrary.AccuseNonExistingUTXOConsumption(
            pClaims,
            pClaimsSig,
            bClaims,
            bClaimsSigGroup,
            proofAgainstStateRoot,
            proofInclusionTXRoot,
            proofInclusionTXHash,
            txInPreImage
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
