// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.11;

interface IValidatorPoolEvents {
    event ValidatorJoined(address indexed account, uint256 validatorNFT);
    event ValidatorLeft(address indexed account, uint256 stakeNFT);
    event ValidatorMinorSlashed(address indexed account, uint256 stakeNFT);
    event ValidatorMajorSlashed(address indexed account);
    event MaintenanceScheduled();
}
