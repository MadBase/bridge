// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

library ChainStatusLibrary {
    bytes32 constant STORAGE_LOCATION = keccak256("chainstatus.storage");

    struct ChainStatusStorage {
        uint32 chainId;
        uint256 epoch;
        uint32 epochSize;
    }

    function chainStatusStorage() internal pure returns (ChainStatusStorage storage ss) {
        bytes32 position = STORAGE_LOCATION;
        assembly { // solium-disable-line
            ss.slot := position
        }
    }

    //
    //
    //
    function setChainId(uint32 _chainId) internal {
        chainStatusStorage().chainId = _chainId;
    }

    function chainId() internal view returns (uint32) {
        return chainStatusStorage().chainId;
    }

    //
    //
    //
    function setEpoch(uint256 _epoch) internal {
        chainStatusStorage().epoch = _epoch;
    }

    function epoch() internal view returns (uint256) {
        return chainStatusStorage().epoch;
    }

    //
    //
    //
    function setEpochSize(uint32 _epochSize) internal {
        chainStatusStorage().epochSize = _epochSize;
    }

    function epochSize() internal view returns (uint32) {
        return chainStatusStorage().epochSize;
    }

}
