// SPDX-License-Identifier: MIT-open-group
pragma solidity >= 0.5.15;

import "ds-test/test.sol";
import "./Setup.t.sol";
import "../Constants.sol";
import "./SnapshotsLibrary.sol";

import "./AccusationMultipleProposalFacet.sol";
import "./AccusationLibrary.sol";

contract TestAccusationLibrary is Constants, DSTest, Setup {

    function generateSigAndPClaims0() private pure returns(bytes memory, bytes memory) {
        bytes memory pClaimsCapnProto =
            hex"0000000000000200" // struct definition capn proto https://capnproto.org/encoding.html

            hex"04000000"
            hex"02000400"
            hex"58000000"
            hex"00000200"

            hex"01000000"//BClaim
            hex"02000000"
            hex"01000000"
            hex"00000000"
            hex"0d000000"
            hex"02010000"
            hex"19000000"
            hex"02010000"
            hex"25000000"
            hex"02010000"
            hex"31000000"
            hex"02010000"
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16"
            hex"de8b68a6643fa528a513f99a1ea30379927197a097ca86d9108e4c29d684b1ec"
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470"
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470"


            hex"04000000"//Rcert
            hex"02000100"
            hex"1d000000"
            hex"02060000"

            hex"01000000" //RClaim
            hex"02000000"
            hex"01000000"
            hex"00000000"
            hex"01000000"
            hex"02010000"
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16"

            hex"258aa89365a642358d92db67a13cb25d73e6eedf0d25100d8d91566882fac54b" //SigGroup
            hex"1ccedfb0425434b54999a88cd7d993e05411955955c0cfec9dd33066605bd4a6"
            hex"0f6bbfbab37349aaa762c23281b5749932c514f3b8723cf9bb05f9841a7f2d0e"
            hex"0f75e42fd6c8e9f0edadac3dcfb7416c2d4b2470f4210f2afa93138615b1deb1"
            hex"1ff56a9538b079e16dd77a8ef81318497b195ad81b8cd1c5ea5d48b0c160f599"
            hex"12387b5ab69538ef4cda0f7a879982f9b4943291b1e6d998abefe7bb4ebb6993";
        bytes memory sig =
            hex"05d08b3bfd0fcb21e00a1468a9013fb023aa5eb86d714600dd69675ef9acce8c"
            hex"3247fe575e3d16a3e32d1e0ea10a30474744e7aab3166daea7c591776c1e942500";
        return (sig, pClaimsCapnProto);

    }

    function generateSigAndPClaims1() private pure returns(bytes memory, bytes memory) {
        //Second PClaims, this time containg 2 transactions instead of 1.
        bytes memory pClaimsCapnProto =
            hex"0000000000000200"
            hex"04000000"
            hex"02000400"
            hex"58000000"
            hex"00000200"
            hex"01000000"
            hex"02000000"
            hex"02000000" //txCount is different
            hex"00000000"
            hex"0d000000"
            hex"02010000"
            hex"19000000"
            hex"02010000"
            hex"25000000"
            hex"02010000"
            hex"31000000"
            hex"02010000"
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16"
            hex"8db49c526748abbf9eabf4b49e9edd6d91ca3c970791b027e815b628c148afd0" //txRoot is different
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470"
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470"
            hex"04000000"
            hex"02000100"
            hex"1d000000"
            hex"02060000"
            hex"01000000"
            hex"02000000"
            hex"01000000"
            hex"00000000"
            hex"01000000"
            hex"02010000"
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16"
            hex"258aa89365a642358d92db67a13cb25d73e6eedf0d25100d8d91566882fac54b"
            hex"1ccedfb0425434b54999a88cd7d993e05411955955c0cfec9dd33066605bd4a6"
            hex"0f6bbfbab37349aaa762c23281b5749932c514f3b8723cf9bb05f9841a7f2d0e"
            hex"0f75e42fd6c8e9f0edadac3dcfb7416c2d4b2470f4210f2afa93138615b1deb1"
            hex"1ff56a9538b079e16dd77a8ef81318497b195ad81b8cd1c5ea5d48b0c160f599"
            hex"12387b5ab69538ef4cda0f7a879982f9b4943291b1e6d998abefe7bb4ebb6993";

       bytes memory sig =
            hex"534ebe41176f66ffaaa3dd387e097b998b51576ed0a8fbc3f9c8a1b14699adb2"
            hex"0dc69ad5e32d78ccd4a964af065cfa76c23b6009ae877c1d748494776abfae6f00";
        return (sig, pClaimsCapnProto);
    }

    function generateSigAndPClaimsDifferentHeight() private pure returns(bytes memory, bytes memory) {
        bytes memory pClaimsCapnProto =
            hex"0000000000000200"
            hex"04000000"
            hex"02000400"
            hex"58000000"
            hex"00000200"
            hex"01000000"
            hex"03000000" //different height
            hex"01000000"
            hex"00000000"
            hex"0d000000"
            hex"02010000"
            hex"19000000"
            hex"02010000"
            hex"25000000"
            hex"02010000"
            hex"31000000"
            hex"02010000"
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16"
            hex"de8b68a6643fa528a513f99a1ea30379927197a097ca86d9108e4c29d684b1ec"
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470"
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470"
            hex"04000000"
            hex"02000100"
            hex"1d000000"
            hex"02060000"
            hex"01000000"
            hex"03000000" //different height
            hex"01000000"
            hex"00000000"
            hex"01000000"
            hex"02010000"
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16"
            hex"258aa89365a642358d92db67a13cb25d73e6eedf0d25100d8d91566882fac54b"
            hex"1ccedfb0425434b54999a88cd7d993e05411955955c0cfec9dd33066605bd4a6"
            hex"0f6bbfbab37349aaa762c23281b5749932c514f3b8723cf9bb05f9841a7f2d0e"
            hex"0f75e42fd6c8e9f0edadac3dcfb7416c2d4b2470f4210f2afa93138615b1deb1"
            hex"1ff56a9538b079e16dd77a8ef81318497b195ad81b8cd1c5ea5d48b0c160f599"
            hex"12387b5ab69538ef4cda0f7a879982f9b4943291b1e6d998abefe7bb4ebb6993";
        bytes memory sig =
            hex"b9c42c4e41a2df9040f061756dcd6ca47ec2042cbd9f22519309a553be6a1dcc"
            hex"69ab71d5d8b002b9d8814fb1fee17e071fe37cc052cced7f8a57354e9bb8956a01";
        return (sig, pClaimsCapnProto);
    }

    function generateSigAndPClaimsDifferentRound() private pure returns(bytes memory, bytes memory) {
        bytes memory pClaimsCapnProto =
            hex"0000000000000200"
            hex"04000000"
            hex"02000400"
            hex"58000000"
            hex"00000200"
            hex"01000000"
            hex"02000000"
            hex"01000000"
            hex"00000000"
            hex"0d000000"
            hex"02010000"
            hex"19000000"
            hex"02010000"
            hex"25000000"
            hex"02010000"
            hex"31000000"
            hex"02010000"
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16"
            hex"de8b68a6643fa528a513f99a1ea30379927197a097ca86d9108e4c29d684b1ec"
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470"
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470"
            hex"04000000"
            hex"02000100"
            hex"1d000000"
            hex"02060000"
            hex"01000000"
            hex"02000000"
            hex"02000000" // different round
            hex"00000000"
            hex"01000000"
            hex"02010000"
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16"
            hex"258aa89365a642358d92db67a13cb25d73e6eedf0d25100d8d91566882fac54b"
            hex"1ccedfb0425434b54999a88cd7d993e05411955955c0cfec9dd33066605bd4a6"
            hex"0f6bbfbab37349aaa762c23281b5749932c514f3b8723cf9bb05f9841a7f2d0e"
            hex"0f75e42fd6c8e9f0edadac3dcfb7416c2d4b2470f4210f2afa93138615b1deb1"
            hex"1ff56a9538b079e16dd77a8ef81318497b195ad81b8cd1c5ea5d48b0c160f599"
            hex"12387b5ab69538ef4cda0f7a879982f9b4943291b1e6d998abefe7bb4ebb6993";
        bytes memory sig =
            hex"2f8df0cad1b95c978d0feb132f777459c2efc8204ec79bd6d17d31e4d50611c8"
            hex"7c5a37d4f4a6838c9427b53749fda98970227dbd7364713abd24c2a14f5a36a601";
        return (sig, pClaimsCapnProto);
    }

    function generateSigAndPClaimsDifferentChainId() private pure returns(bytes memory, bytes memory) {
        bytes memory pClaimsCapnProto =
            hex"0000000000000200"
            hex"04000000"
            hex"02000400"
            hex"58000000"
            hex"00000200"
            hex"0b000000"
            hex"02000000"
            hex"01000000"
            hex"00000000"
            hex"0d000000"
            hex"02010000"
            hex"19000000"
            hex"02010000"
            hex"25000000"
            hex"02010000"
            hex"31000000"
            hex"02010000"
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16"
            hex"de8b68a6643fa528a513f99a1ea30379927197a097ca86d9108e4c29d684b1ec"
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470"
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470"
            hex"04000000"
            hex"02000100"
            hex"1d000000" // different chainId
            hex"02060000"
            hex"0b000000"
            hex"02000000"
            hex"01000000"
            hex"00000000"
            hex"01000000"
            hex"02010000"
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16"
            hex"258aa89365a642358d92db67a13cb25d73e6eedf0d25100d8d91566882fac54b"
            hex"1ccedfb0425434b54999a88cd7d993e05411955955c0cfec9dd33066605bd4a6"
            hex"0f6bbfbab37349aaa762c23281b5749932c514f3b8723cf9bb05f9841a7f2d0e"
            hex"0f75e42fd6c8e9f0edadac3dcfb7416c2d4b2470f4210f2afa93138615b1deb1"
            hex"1ff56a9538b079e16dd77a8ef81318497b195ad81b8cd1c5ea5d48b0c160f599"
            hex"12387b5ab69538ef4cda0f7a879982f9b4943291b1e6d998abefe7bb4ebb6993";

        bytes memory sig =
            hex"4343b877b15485ba84c8907cf982957f138466e2907572235d0ffe848b57c031"
            hex"577e854335594ef6c99efe01e18f3fa40093b4741a3fc67080da7c1ae8111b7a01";

        return (sig, pClaimsCapnProto);
    }


    function testAccuseMultipleProposal() public {
        AccusationMultipleProposalFacet f = new AccusationMultipleProposalFacet();
        address signer = 0x38e959391dD8598aE80d5d6D114a7822A09d313A;
        ParticipantsLibrary.ParticipantsStorage storage ps = ParticipantsLibrary.participantsStorage();
        StakingLibrary.StakingStorage storage sv = StakingLibrary.stakingStorage();
        ps.validatorPresent[signer] = true;
        sv.details[signer].amountStaked = StakingLibrary.minimumStake();
        SnapshotsLibrary.SnapshotsStorage storage ss = SnapshotsLibrary.snapshotsStorage();
        ss.snapshots[ss.nextSnapshot].chainId = 1;
        (bytes memory sig0, bytes memory pClaims0) = generateSigAndPClaims0();
        (bytes memory sig1, bytes memory pClaims1) = generateSigAndPClaims1();
        bool ok;
        AccusationLibrary.AccusationStorage storage s = AccusationLibrary.accusationStorage();
        assertTrue(s.accusations[signer] == 0, "Signer shouldn't have any accusation!");
        (ok, ) = address(f).delegatecall(abi.encodeWithSignature("AccuseMultipleProposal(bytes,bytes,bytes,bytes)", sig0, pClaims0, sig1, pClaims1));
        accusation.AccuseMultipleProposal(sig0, pClaims0, sig1, pClaims1);
        assertTrue(ok, "Function call didn't succeed!");
        assertEq(s.accusations[signer], 0);
    }

    function testInvalidAccuseMultipleProposal() public {
        AccusationMultipleProposalFacet f = new AccusationMultipleProposalFacet();
        (bytes memory sig0, bytes memory pClaims0) = generateSigAndPClaims0();
        (bytes memory sig1, bytes memory pClaims1) = generateSigAndPClaims1();
        (bytes memory sigWrongHeight, bytes memory pClaimsWrongHeight) = generateSigAndPClaimsDifferentHeight();
        (bytes memory sigWrongRound, bytes memory pClaimsWrongRound) = generateSigAndPClaimsDifferentRound();
        (bytes memory sigWrongChainId, bytes memory pClaimsWrongChainId) = generateSigAndPClaimsDifferentChainId();
        SnapshotsLibrary.SnapshotsStorage storage ss = SnapshotsLibrary.snapshotsStorage();
        ss.snapshots[ss.nextSnapshot].chainId = 1;
        bool ok;

        //Trying to accuse and signer that it's not a validator
        (ok, ) = address(f).delegatecall(abi.encodeWithSignature("AccuseMultipleProposal(bytes,bytes,bytes,bytes)", sig0, pClaims0, sig1, pClaims1));
        assertTrue(!ok, "Function call succeed! The function was supposed to fail when trying to call it for a signer that is not a validator!");

        // Trying to send the same sig and pclaims
        (ok, ) = address(f).delegatecall(abi.encodeWithSignature("AccuseMultipleProposal(bytes,bytes,bytes,bytes)", sig0, pClaims0, sig0, pClaims0));
        assertTrue(!ok, "Function call succeed! The function was supposed to fail when trying to call it with the signatures and PClaims that are equal!");

        // Trying to send same pclaims but different sigs
        (ok, ) = address(f).delegatecall(abi.encodeWithSignature("AccuseMultipleProposal(bytes,bytes,bytes,bytes)", sig0, pClaims0, sig1, pClaims0));
        assertTrue(!ok, "Function call succeed! The function was supposed to fail when trying to call it with the different signatures!");

        // Trying pclaims with different block heights
        (ok, ) = address(f).delegatecall(abi.encodeWithSignature("AccuseMultipleProposal(bytes,bytes,bytes,bytes)", sig0, pClaims0, sigWrongHeight, pClaimsWrongHeight));
        assertTrue(!ok, "Function call succeed! The function was supposed to fail when trying to call it with PClaims that have different heights!");

        // Trying pclaims with different round
        (ok, ) = address(f).delegatecall(abi.encodeWithSignature("AccuseMultipleProposal(bytes,bytes,bytes,bytes)", sig0, pClaims0, sigWrongRound, pClaimsWrongRound));
        assertTrue(!ok, "Function call succeed! The function was supposed to fail when trying to call it with PClaims that have different round numbers!");

        // Trying pclaims with different chainID
        (ok, ) = address(f).delegatecall(abi.encodeWithSignature("AccuseMultipleProposal(bytes,bytes,bytes,bytes)", sig0, pClaims0, sigWrongChainId, pClaimsWrongChainId));
        assertTrue(!ok, "Function call succeed! The function was supposed to fail when trying to call it with PClaims that have different ChainId!");

        // Trying pClaims that belongs to different ChainId
        ss.snapshots[ss.nextSnapshot].chainId = 0;
        (ok, ) = address(f).delegatecall(abi.encodeWithSignature("AccuseMultipleProposal(bytes,bytes,bytes,bytes)", sig0, pClaims0, sig1, pClaims1));
        assertTrue(!ok, "Function call succeed! The function was supposed to fail when trying to call it with PClaims that have a ChainId different from the snapshots!");
        emit log_named_uint("ChainId: ", SnapshotsLibrary.getChainIdFromSnapshot(SnapshotsLibrary.epoch()));
    }

    function testRecoverMadNetSigner() public {
        (bytes memory sig0, bytes memory pClaims0) = generateSigAndPClaims0();
        (bytes memory sig1, bytes memory pClaims1) = generateSigAndPClaims1();
        address expectedAddress = 0x38e959391dD8598aE80d5d6D114a7822A09d313A;
        address who0 = AccusationLibrary.recoverMadNetSigner(sig0, pClaims0);
        address who1 = AccusationLibrary.recoverMadNetSigner(sig1, pClaims1);
        assertEq(who0, expectedAddress);
        assertEq(who1, expectedAddress);
        emit log_named_address("who0: ", who0);
        emit log_named_address("who1: ", who1);
    }

}