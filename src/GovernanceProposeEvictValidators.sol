// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

import "./GovernanceProposal.sol";
import "./facets/ParticipantsLibrary.sol";

contract GovernanceProposeEvictValidators is GovernanceProposal {

    // PROPOSALS MUST NOT HAVE ANY STATE VARIABLE TO AVOID POTENTIAL STORAGE
    // COLLISION!

    /// @dev function that is called when a proposal is executed. It's only
    /// meant to be called by the Governance Manager contract. See the
    /// GovernanceProposal.sol file fore more details.
    function execute(address self) public override returns(bool) {
        // Replace the following line with the address of the Validators Diamond.
        address target = address(0x0);
        (bool success, ) = target.call(abi.encodeWithSignature("modifyDiamondStorage(address)", self));
        require(success, "GovernanceProposeModifySnapshot: CALL FAILED!");
        return success;
    }

    /// @dev function that is called back by another contract with DELEGATE CALL
    /// rights! See the GovernanceProposal.sol file fore more details. PLACE THE
    /// LOGIC To REMOVE VALIDATORS IN HERE!
    function callback() public override returns(bool) {
        // This function is called back by the Validators Diamond. Inside this
        // function, we have fully access to all the Validators Diamond Storage
        // including the participants storage.
        //
        // Example removing a validator:
        // removeValidator();
        //
        // Example removing a set known bad validators:
        // removeSetOfValidators();
        //
        // Removing all validators:
        // removeAllValidators();
        return true;
    }

    function removeValidator() internal {
        // todo: unstake the validators prior removal?
        // Change the variables _validator and _madID to match the address and
        // madId of the validator that should be evicted!
        address _validator = address(0x0);
        uint256[2] memory _madID = [uint256(0), uint256(0)];
        ParticipantsLibrary.removeValidator(_validator, _madID);
    }

    function removeSetOfValidators() internal {
        function removeSetOfValidators() internal {
        // todo: unstake the validators prior removal?

        // Change the variables _validatorX and _madIDX to match the addresses and
        // madIds of the validators that should be evicted!
        address _validator1 = address(0x0);
        uint256[2] memory _madID1 = [uint256(0), uint256(0)];
        ParticipantsLibrary.removeValidator(_validator1, _madID1);
        address _validator2 = address(0x1);
        uint256[2] memory _madID2 = [uint256(5), uint256(5)];
        ParticipantsLibrary.removeValidator(_validator2, _madID2);
        address _validator3 = address(0x2);
        uint256[2] memory _madID3 = [uint256(8), uint256(8)];
        ParticipantsLibrary.removeValidator(_validator3, _madID3);
    }
    }

    function removeAllValidators() internal {
        // todo: unstake the validators prior removal?
        ParticipantsLibrary.ParticipantsStorage storage ps = ParticipantsLibrary.participantsStorage();
        uint256 count = ps.validatorCount;
        while (count > 0) {
            count = ParticipantsLibrary.removeValidator(ps.validators[0], ParticipantsLibrary.getValidatorPublicKey(ps.validators[0]));
        }
    }
}