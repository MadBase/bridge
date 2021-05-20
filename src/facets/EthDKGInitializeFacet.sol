// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;

import "../Constants.sol";
import "../Registry.sol";

import "./AccessControlLibrary.sol";
import "./EthDKGLibrary.sol";

contract EthDKGInitializeFacet is AccessControlled, Constants {

    function initializeState() external onlyOperator {
        EthDKGLibrary.initializeState();
    }

    function initializeEthDKG(Registry registry) external onlyOperator {

        address validatorsAddr = registry.lookup(VALIDATORS_CONTRACT);
        require(validatorsAddr != address(0), "missing validators address");

        EthDKGLibrary.EthDKGStorage storage es = EthDKGLibrary.ethDKGStorage();

        es.initial_message = abi.encodePacked("Cryptography is great");
        es.validators = Validators(validatorsAddr);
        es.DELTA_INCLUDE = 40;
        es.DELTA_CONFIRM = 6;
        es.MINIMUM_REGISTRATION = 4;
    }

    function updatePhaseLength(uint256 phaseLength) external onlyOperator {
        EthDKGLibrary.ethDKGStorage().DELTA_INCLUDE = phaseLength;
    }

}