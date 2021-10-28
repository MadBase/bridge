// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

interface Sudo {

    function setGovernance(address governance_) external;

    function modifyDiamondStorage(address callback_) external returns (bool);
}