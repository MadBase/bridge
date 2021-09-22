// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

//import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
//import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


interface IMagicTokenTransfer {
    function depositToken(uint8 magic_, uint256 amount_) external payable;
}