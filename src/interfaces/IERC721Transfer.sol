// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.7.6;

//import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
//import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


interface IERC721Transfer {
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;
}