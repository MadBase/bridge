// SPDX-License-Identifier: MIT-open-group
pragma solidity >= 0.5.15;

import "./MerkleProofLibrary.sol";
import "./ChainStatusLibrary.sol";
import "./ParticipantsLibrary.sol";
import "./SnapshotsLibrary.sol";
import "../../parsers/PClaimsParserLibrary.sol";
import "../../parsers/RCertParserLibrary.sol";
import "../../parsers/MerkleProofParserLibrary.sol";
import "../../parsers/TXInPreImageParserLibrary.sol";
import "../../CryptoLibrary.sol";

library ValidatorLocationsLibrary {

    /// @dev Storage code to support diamond pattern
    bytes32 constant STORAGE_LOCATION = keccak256("validatorLocations.storage");

    struct ValidatorLocationsStorage {
        mapping(address => string) locations;
    }

    /// @dev function to support the diamond pattern
    function validatorLocationsStorage() internal pure returns (ValidatorLocationsStorage storage s) {
        bytes32 position = STORAGE_LOCATION;
        assembly { // solium-disable-line
            s.slot := position
        }
    }

    function setMyLocation(string calldata ip) internal {
        require(ParticipantsLibrary.isValidator(msg.sender), "only fully staked participants allowed");
        ValidatorLocationsStorage storage s = validatorLocationsStorage();
        s.locations[msg.sender] = ip;
    }
    function getMyLocation() internal view returns(string memory) {
        ValidatorLocationsStorage storage s = validatorLocationsStorage();
        return s.locations[msg.sender];
    }
    function getLocation(address a) internal view returns(string memory) {
        ValidatorLocationsStorage storage s = validatorLocationsStorage();
        return s.locations[a];
    }
    function getLocations(address[] calldata a) internal view returns(string[] memory) {
        ValidatorLocationsStorage storage s = validatorLocationsStorage();
        string[] memory ret = new string[](a.length);
        for (uint i = 0; i < a.length; i++) {
            ret[i] = s.locations[a[i]];
        }
        return ret;
    }
}