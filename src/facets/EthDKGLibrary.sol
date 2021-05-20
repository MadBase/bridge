// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

import "../interfaces/Validators.sol";

library EthDKGLibrary {
    bytes32 constant STORAGE_LOCATION = keccak256("ethdkg.storage");

    struct EthDKGStorage {

        // State of key generation
        address[] addresses;
        mapping (address => uint256[2]) public_keys;
        mapping (address => bytes32) share_distribution_hashes;
        mapping (address => uint256[2]) commitments_1st_coefficient;
        mapping (address => uint256[2]) key_shares;
        mapping (address => uint256[4]) gpkj_submissions;
        mapping (address => uint256[2]) initial_signatures;
        mapping (address => uint256) indices;
        mapping (address => bool) is_malicious;
        uint256[4] master_public_key;
        Validators validators;
        
        // Configurable settings
        bytes initial_message;
        uint256 DELTA_CONFIRM;
        uint256 DELTA_INCLUDE;
        uint256 MINIMUM_REGISTRATION;

        // Phase completion flags
        bool registration_check;
        bool share_distribution_check;
        bool key_share_submission_check;
        bool mpk_submission_check;
        bool completion_check;

        // Phase block schedule
        uint256 T_REGISTRATION_END;
        uint256 T_SHARE_DISTRIBUTION_END;
        uint256 T_DISPUTE_END;
        uint256 T_KEY_SHARE_SUBMISSION_END;
        uint256 T_MPK_SUBMISSION_END;
        uint256 T_GPKJ_SUBMISSION_END;
        uint256 T_GPKJ_DISPUTE_END;
        uint256 T_DKG_COMPLETE;
    }

    function ethDKGStorage() internal pure returns (EthDKGStorage storage es) {
        bytes32 position = STORAGE_LOCATION;
        assembly { // solium-disable-line
            es.slot := position
        }
    }

    //
    //
    //
    event RegistrationOpen(
        uint256 dkgStarts,
        uint256 registrationEnds,
        uint256 shareDistributionEnds,
        uint256 disputeEnds,
        uint256 keyShareSubmissionEnds,
        uint256 mpkSubmissionEnds,
        uint256 gpkjSubmissionEnds,
        uint256 gpkjDisputeEnds,
        uint256 dkgComplete
    );

    event KeyShareSubmission(
        address issuer,
        uint256[2] key_share_G1,
        uint256[2] key_share_G1_correctness_proof,
        uint256[4] key_share_G2
    );

    event ShareDistribution(
        address issuer,
        uint256 index,
        uint256[] encrypted_shares,
        uint256[2][] commitments
    );

    event ValidatorSet(
        uint8 validatorCount,
        uint256 epoch,
        uint32 ethHeight,
        uint32 madHeight,
        uint256 groupKey0, uint256 groupKey1, uint256 groupKey2, uint256 groupKey3
    );

    event ValidatorMember(
        address account,
        uint256 epoch,
        uint256 index,
        uint256 share0, uint256 share1, uint256 share2, uint256 share3
    );

    //
    //
    //
    function initializeState() internal {
        EthDKGStorage storage es = ethDKGStorage();

        uint256 T_CONTRACT_CREATION = block.number;
        es.T_REGISTRATION_END = T_CONTRACT_CREATION + es.DELTA_INCLUDE;
        es.T_SHARE_DISTRIBUTION_END = es.T_REGISTRATION_END + es.DELTA_CONFIRM + es.DELTA_INCLUDE;
        es.T_DISPUTE_END = es.T_SHARE_DISTRIBUTION_END + es.DELTA_CONFIRM + es.DELTA_INCLUDE;
        es.T_KEY_SHARE_SUBMISSION_END = es.T_DISPUTE_END + es.DELTA_CONFIRM + es.DELTA_INCLUDE;
        es.T_MPK_SUBMISSION_END = es.T_KEY_SHARE_SUBMISSION_END + es.DELTA_CONFIRM + es.DELTA_INCLUDE;
        es.T_GPKJ_SUBMISSION_END = es.T_MPK_SUBMISSION_END + es.DELTA_CONFIRM + es.DELTA_INCLUDE;
        es.T_GPKJ_DISPUTE_END = es.T_GPKJ_SUBMISSION_END + es.DELTA_CONFIRM + es.DELTA_INCLUDE;
        es.T_DKG_COMPLETE = es.T_GPKJ_DISPUTE_END + es.DELTA_CONFIRM + es.DELTA_INCLUDE;

        emit RegistrationOpen(
            T_CONTRACT_CREATION, es.T_REGISTRATION_END, es.T_SHARE_DISTRIBUTION_END, es.T_DISPUTE_END,
            es.T_KEY_SHARE_SUBMISSION_END, es.T_MPK_SUBMISSION_END, es.T_GPKJ_SUBMISSION_END,
            es.T_GPKJ_DISPUTE_END, es.T_DKG_COMPLETE);

        es.registration_check = false;
        es.share_distribution_check = false;
        es.key_share_submission_check = false;
        es.mpk_submission_check = false;
        es.completion_check = false;

        delete es.master_public_key;

        while (es.addresses.length > 0) {
            address addr = es.addresses[es.addresses.length-1];

            delete es.public_keys[addr];
            delete es.share_distribution_hashes[addr];
            delete es.commitments_1st_coefficient[addr];
            delete es.key_shares[addr];
            delete es.gpkj_submissions[addr];
            delete es.initial_signatures[addr];
            delete es.is_malicious[addr];
            delete es.indices[addr];

            es.addresses.pop();
        }
    }

}