// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.6.4;
pragma experimental ABIEncoderV2;

import "../facets/AccessControlLibrary.sol";
import "../facets/ParticipantsLibrary.sol";
import "../facets/StakingLibrary.sol";
import "../facets/StopLibrary.sol";

import "../Constants.sol";
import "../Registry.sol";

contract MigrateParticipantsFacet is AccessControlled, Constants, Stoppable {

    function addValidator(address _validator, uint256[2] calldata _madID) external onlyOperator returns (uint8) {
        return ParticipantsLibrary.addValidator(_validator, _madID);
    }

    function removeValidator(address _validator, uint256[2] calldata _madID) external onlyOperator returns (uint8) {
        return ParticipantsLibrary.removeValidator(_validator, _madID);
    }

}