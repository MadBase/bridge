// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;

import "./ValidatorLocationsLibrary.sol";
import "../interfaces/ValidatorLocationsEvents.sol";
import "../SafeMath.sol";


contract ValidatorLocationsFacet is ValidatorLocationsEvents {

    using SafeMath for uint256;

    
    function setMyLocation(string calldata ip) public {
        ValidatorLocationsLibrary.setMyLocation(ip);
        emit MyLocation(ip);
    }
    function getMyLocation() public view returns(string memory) {
        return ValidatorLocationsLibrary.getMyLocation();
    }
    function getLocation(address a) public view returns(string memory) {
        return ValidatorLocationsLibrary.getLocation(a);
    }
    function getLocations(address[] calldata a) public view returns(string[] memory) {
        return ValidatorLocationsLibrary.getLocations(a);
    }

}
