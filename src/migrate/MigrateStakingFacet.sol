// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.6.4;
pragma experimental ABIEncoderV2;

import "../interfaces/StakingEvents.sol";

import "../facets/AccessControlLibrary.sol";
import "../facets/SnapshotsLibrary.sol";
import "../facets/StakingLibrary.sol";
import "../facets/StopLibrary.sol";

import "../Constants.sol";
import "../Registry.sol";

contract MigrateStakingFacet is AccessControlled, Constants, Stoppable {

    function lockStakeFor(address who, uint256 amount) external onlyOperator stoppable returns (bool) {
        return StakingLibrary.lockStakeFor(who, amount);
    }

}