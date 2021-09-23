// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;


interface INFTStake {
    function lockPosition(address caller_, uint256 tokenID_, uint256 lockDuration_) external returns(uint256 numberShares);
}