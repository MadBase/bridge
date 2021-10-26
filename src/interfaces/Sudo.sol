// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

interface Sudo {
    function modifyDiamondStorage(address _callback) external returns (bool);
}