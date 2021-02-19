// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;

import "./Participants.sol";
import "./Snapshots.sol";
import "./Staking.sol";
import "./ValidatorsEvents.sol";

interface Validators is Participants, Snapshots, Staking, ValidatorsEvents {

}