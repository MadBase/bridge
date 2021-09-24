// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

//import "../lib/openzeppelin//token/ERC721/ERC721.sol";
//import "../lib/openzeppelin//token/ERC20/ERC20.sol";


interface IMagicEthTransfer {
    function depositEth(uint8 magic_) external payable;
}