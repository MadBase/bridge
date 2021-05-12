// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;

import "../Constants.sol";
import "../CryptoLibrary.sol";
import "../EthDKGConstants.sol";
import "../Registry.sol";
import "./EthDKGLibrary.sol";

contract EthDKGInformationFacet is Constants, EthDKGConstants {

    //
    // Informational
    //
    function master_public_key(uint256 idx) external view returns (uint256) {
        return EthDKGLibrary.ethDKGStorage().master_public_key[idx];
    }

    function gpkj_submissions(address addr, uint256 idx) external view returns (uint256) {
        return EthDKGLibrary.ethDKGStorage().gpkj_submissions[addr][idx];
    }

    function T_REGISTRATION_END() external view returns (uint256) {
        return EthDKGLibrary.ethDKGStorage().T_REGISTRATION_END;
    }

    function T_SHARE_DISTRIBUTION_END() external view returns (uint256) {
        return EthDKGLibrary.ethDKGStorage().T_SHARE_DISTRIBUTION_END;
    }

    function T_DISPUTE_END() external view returns (uint256) {
        return EthDKGLibrary.ethDKGStorage().T_DISPUTE_END;
    }

    function T_KEY_SHARE_SUBMISSION_END() external view returns (uint256) {
        return EthDKGLibrary.ethDKGStorage().T_KEY_SHARE_SUBMISSION_END;
    }

    function T_MPK_SUBMISSION_END() external view returns (uint256) {
        return EthDKGLibrary.ethDKGStorage().T_MPK_SUBMISSION_END;
    }

    function T_GPKJ_SUBMISSION_END() external view returns (uint256) {
        return EthDKGLibrary.ethDKGStorage().T_GPKJ_SUBMISSION_END;
    }

    function T_GPKJDISPUTE_END() external view returns (uint256) {
        return EthDKGLibrary.ethDKGStorage().T_GPKJ_DISPUTE_END;
    }

    function T_DKG_COMPLETE() external view returns (uint256) {
        return EthDKGLibrary.ethDKGStorage().T_DKG_COMPLETE;
    }

    function addresses(uint256 idx) external view returns (address) {
        return EthDKGLibrary.ethDKGStorage().addresses[idx];
    }

    function publicKeys(address addr, uint256 idx) external view returns (uint256) {
        return EthDKGLibrary.ethDKGStorage().public_keys[addr][idx];
    }

    function keyShares(address addr, uint256 idx) external view returns (uint256) {
        return EthDKGLibrary.ethDKGStorage().key_shares[addr][idx];
    }

     function numberOfRegistrations() external view returns (uint256) {
        return EthDKGLibrary.ethDKGStorage().addresses.length;
     }

     function isMalicious(address addr) external view returns (bool) {
        return EthDKGLibrary.ethDKGStorage().is_malicious[addr];
     }

     function initialMessage() external view returns (bytes memory) {
        return EthDKGLibrary.ethDKGStorage().initial_message;
     }

     function initialSignatures(address addr, uint256 idx) external view returns (uint256) {
        return EthDKGLibrary.ethDKGStorage().initial_signatures[addr][idx];
     }

    function shareDistributionHashes(address addr) external view returns (bytes32) {
        return EthDKGLibrary.ethDKGStorage().share_distribution_hashes[addr];
    }

    function commitments_1st_coefficient(address addr, uint256 idx) external view returns (uint256) {
        return EthDKGLibrary.ethDKGStorage().commitments_1st_coefficient[addr][idx];
    }

    function getPhaseLength() external view returns (uint256) {
        return EthDKGLibrary.ethDKGStorage().DELTA_INCLUDE;
    }
}