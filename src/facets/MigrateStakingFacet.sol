// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.6.4;
pragma experimental ABIEncoderV2;

import "../interfaces/StakingEvents.sol";

import "./AccessControlLibrary.sol";
import "./SnapshotsLibrary.sol";
import "./StakingLibrary.sol";
import "./StopLibrary.sol";

import "../Constants.sol";
import "../Registry.sol";

contract StakingFacet is AccessControlled, Constants, StakingEvents, Stoppable {

    function lockStakeFor(address who, uint256 amount) external onlyOperator stoppable returns (bool) {
        return StakingLibrary.lockStakeFor(who, amount);
    }

    // function lockRewardFor(address who, uint256 amount) external onlyOperator stoppable returns (bool) {

    // }

}