// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;
pragma abicoder v2;

import "./ValidatorLocationsEvents.sol";
import "../../Registry.sol";

interface ValidatorLocations is ValidatorLocationsEvents {
    function setMyLocation(string calldata ip) external;
    function getMyLocation() external view returns(string memory);
    function getLocation(address a) external view returns(string memory);
    function getLocations(address[] calldata a) external view returns(string[] memory);
}