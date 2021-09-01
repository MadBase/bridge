// SPDX-License-Identifier: MIT-open-group
pragma solidity >= 0.5.15;

import "ds-test/test.sol";

import "./AccusationLibrary.sol";
import "./AccusationMultipleProposalFacet.sol";

contract TestAccusationLibrary is DSTest {

    function testSignNoPrefix() public {
        AccusationMultipleProposalFacet f = new AccusationMultipleProposalFacet();

        bytes memory sig = hex"cba766e2ba024aad86db556635cec9f104e76644b235f77759ff80bfefc990c5774d2d5ff3069a5099e4f9fadc9b08ab20472e2ef432fba94498d93c10cc584b00";
        bytes memory prefix = "";
        bytes memory message = hex"54686520717569636b2062726f776e20666f782064696420736f6d657468696e67";

        address who = AccusationLibrary.recoverSigner(sig, prefix, message);

        assertEq(who, 0x38e959391dD8598aE80d5d6D114a7822A09d313A);
    }

    function testSignedPClaims() public {
        bytes memory message = hex"000000000000020004000000020004005800000000000200010000000200000001000000000000000d00000002010000190000000201000025000000020100003100000002010000f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16de8b68a6643fa528a513f99a1ea30379927197a097ca86d9108e4c29d684b1ecc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a47004000000020001001d00000002060000010000000200000001000000000000000100000002010000f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16258aa89365a642358d92db67a13cb25d73e6eedf0d25100d8d91566882fac54b1ccedfb0425434b54999a88cd7d993e05411955955c0cfec9dd33066605bd4a60f6bbfbab37349aaa762c23281b5749932c514f3b8723cf9bb05f9841a7f2d0e0f75e42fd6c8e9f0edadac3dcfb7416c2d4b2470f4210f2afa93138615b1deb11ff56a9538b079e16dd77a8ef81318497b195ad81b8cd1c5ea5d48b0c160f59912387b5ab69538ef4cda0f7a879982f9b4943291b1e6d998abefe7bb4ebb6993";
        bytes memory prefix = "Proposal";
        bytes memory sig = hex"05d08b3bfd0fcb21e00a1468a9013fb023aa5eb86d714600dd69675ef9acce8c3247fe575e3d16a3e32d1e0ea10a30474744e7aab3166daea7c591776c1e942500";

        address who = AccusationLibrary.recoverSigner(sig, prefix, message);

        assertEq(who, 0x38e959391dD8598aE80d5d6D114a7822A09d313A);
    }

}