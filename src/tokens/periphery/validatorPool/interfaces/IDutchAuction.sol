// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.11;

interface IDutchAuction {
    event AuctionStarted(uint256 blockNumber);

    function setAuctionDecayRate(uint256 decayRate) external;

    function setAuctionBasePrice(uint256 basePrice) external;

    function setAuctionPhaseLength(uint256 phaseLength) external;

    function startAuction() external;

    function getAuctionPhaseLength() external view returns (uint256);

    function getAuctionStartBlock() external view returns (uint256);

    function getAuctionEndBlock() external view returns (uint256);

    function getAuctionPrice() external view returns (uint256);

    function isAuctionRunning() external view returns (bool);
}
