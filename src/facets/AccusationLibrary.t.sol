// SPDX-License-Identifier: MIT-open-group
pragma solidity >= 0.5.15;

import "ds-test/test.sol";

// import "./AccusationLibrary.sol";
import "./AccusationMultipleProposalFacet.sol";

contract Foo {
    function bomb(bool b) public {
        require(b == false);
    }
}

contract TestAccusationLibrary is DSTest {



    function testFoo() public {
        Foo b = new Foo();

        bool ok;

        // this invocation of bomb() is successful
        (ok, ) = address(b).delegatecall(abi.encodeWithSignature("bomb(bool)", false));
        assertTrue(ok, "function successful");

        // this invocation of bomb() reverts
        (ok, ) = address(b).delegatecall(abi.encodeWithSignature("bomb(bool)", true));

        assertTrue(!ok, "function reverted");
    }

    function testAccuseMultipleProposal() public {
        AccusationMultipleProposalFacet f = new AccusationMultipleProposalFacet();

        // bytes memory sig0 = hex"e9be13c2658fcc1769b5e85e6e238a906fbf0d37c52a4ad5f4c69ff18156f3cb093a78ec7e848ab0649cfd1de13cfa4f2b215e42596f9c415541ec813b4626b401";
        bytes memory sig0 = hex"cba766e2ba024aad86db556635cec9f104e76644b235f77759ff80bfefc990c5774d2d5ff3069a5099e4f9fadc9b08ab20472e2ef432fba94498d93c10cc584b00";

        bytes memory message0 = hex"54686520717569636b2062726f776e20666f782064696420736f6d657468696e67";

        address who = recoverSigner(sig0, message0);

        assertEq(who, 0x38e959391dD8598aE80d5d6D114a7822A09d313A);
    }



    function recoverSigner(bytes memory signature, bytes memory message) internal pure returns (address) {

        // bytes32 prefixedMessage = keccak256(
        //     abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(message))
        // );
        bytes32 hashedMessage = keccak256(message);

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

        // return ecrecover(prefixedMessage, v, r, s);
        return ecrecover(hashedMessage, v, r, s);
    }

}