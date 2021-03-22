// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;

import "./EthDKGLibrary.sol";

contract EthDKGCompletionFacet {

    // Successful_Completion should be called at the completion of the DKG algorithm.
    //
    // -- The bool returned indicates whether we should start over immediately.
    function Successful_Completion() public returns (bool) {

        EthDKGLibrary.EthDKGStorage storage es = EthDKGLibrary.ethDKGStorage();

        require(
            (es.T_GPKJ_DISPUTE_END < block.number) && (block.number <= es.T_DKG_COMPLETE),
            "successful completion is only after window for accusations has closed"
        );

        bool reinitialize = false; // Just being explicit

        // Check current state; will only be run on first call
        if (!es.completion_check) {
            bool isValid = true;
            for (uint256 idx; idx<es.addresses.length; idx++) {
                address addr = es.addresses[idx];
                if (es.gpkj_submissions[addr][0] == 0 && es.gpkj_submissions[addr][1] == 0 &&
                        es.gpkj_submissions[addr][2] == 0 && es.gpkj_submissions[addr][3] == 0) {
                    if (es.is_malicious[addr]) {
                        // Someone was malicious and had gpkj deleted;
                        // should receive a major fine.
                        es.validators.majorFine(addr);
                    }
                    else {
                        // Someone did not submit gpkj;
                        // should receive a minor fine.
                        es.validators.minorFine(addr);
                    }
                    isValid = false;
                }
            }

            if (!isValid) {
                // Restart process; fines should be handled above
                reinitialize = true; // initializeState();
            } else {
                // Everything is valid and we do not need to perform this check again
                es.completion_check = true;

                uint32 epoch = uint32(es.validators.epoch()) - 1; // validators is always set to the _next_ epoch
                uint32 ethHeight = uint32(es.validators.getHeightFromSnapshot(epoch));
                uint32 madHeight = uint32(es.validators.getMadHeightFromSnapshot(epoch));

                emit EthDKGLibrary.ValidatorSet(
                    uint8(es.addresses.length),
                    es.validators.epoch(),
                    ethHeight,
                    madHeight,
                    es.master_public_key[0],
                    es.master_public_key[1],
                    es.master_public_key[2],
                    es.master_public_key[3]
                );

                for (uint256 idx; idx<es.addresses.length; idx++) {
                    address addr = es.addresses[idx];

                    emit EthDKGLibrary.ValidatorMember(
                        addr,
                        es.validators.epoch(),
                        idx+1,
                        es.gpkj_submissions[addr][0],
                        es.gpkj_submissions[addr][1],
                        es.gpkj_submissions[addr][2],
                        es.gpkj_submissions[addr][3]
                    );
                }
            }
        }

        if (reinitialize) {
		EthDKGLibrary.initializeState();
	}
    }
}
