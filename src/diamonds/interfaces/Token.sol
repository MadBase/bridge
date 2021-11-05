// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;

interface BasicERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address who) external view returns (uint);
    function allowance(address src, address who) external view returns (uint);
    function approve(address who, uint wad) external returns (bool);
    function transfer(address dst, uint wad) external returns (bool);
    function transferFrom(address src, address dst, uint wad) external returns (bool);
}

interface MintableERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address who) external view returns (uint);
    function allowance(address src, address who) external view returns (uint);
    function approve(address who, uint wad) external returns (bool);
    function transfer(address dst, uint wad) external returns (bool);
    function transferFrom(address src, address dst, uint wad) external returns (bool);
    function mint(address guy, uint wad) external;
    function grantOperator(address _operator) external;
}