// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;

import "./AccessControlLibrary.sol";

library StopLibrary {

    bytes32 constant STORAGE_LOCATION = keccak256("stop.storage");

    struct StopStorage {
        bool stopped;
    }

    function stopStorage() internal pure returns (StopStorage storage ss) {
        bytes32 position = STORAGE_LOCATION;
        assembly { // solium-disable-line
            ss.slot := position
        }
    }

}

contract Stoppable is AccessControlled {

    function stop() external onlyOperator {
        
    }

    function start() external onlyOperator {
       
    }

    modifier stoppable {
        StopLibrary.StopStorage storage ss = StopLibrary.stopStorage();

        require(!ss.stopped, "is stopped");
        _;
    }

}