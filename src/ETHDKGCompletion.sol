pragma solidity >=0.5.15;

import "./ETHDKGStorage.sol";

contract ETHDKGCompletion is ETHDKGStorage {

    // Successful_Completion should be called at the completion of the DKG algorithm.
    //
    // -- The bool returned indicates whether we should start over immediately.
    function Successful_Completion() public returns (bool) {
        require(
            (T_GPKJ_DISPUTE_END < block.number) && (block.number <= T_DKG_COMPLETE),
            "successful completion is only after window for accusations has closed"
        );

        bool reinitialize = false; // Just being explicit

        // Check current state; will only be run on first call
        if (!completion_check) {
            bool isValid = true;
            for (uint256 idx; idx<addresses.length; idx++) {
                address addr = addresses[idx];
                if (gpkj_submissions[addr][0] == 0 && gpkj_submissions[addr][1] == 0 &&
                        gpkj_submissions[addr][2] == 0 && gpkj_submissions[addr][3] == 0) {
                    if (is_malicious[addr]) {
                        // Someone was malicious and had gpkj deleted;
                        // should receive a major fine.
                        validators.majorFine(addr);
                    }
                    else {
                        // Someone did not submit gpkj;
                        // should receive a minor fine.
                        validators.minorFine(addr);
                    }
                    isValid = false;
                }
            }

            if (!isValid) {
                // Restart process; fines should be handled above
                reinitialize = true; // initializeState();
            } else {
                // Everything is valid and we do not need to perform this check again
                completion_check = true;

                uint32 epoch = uint32(validators.epoch()) - 1; // validators is always set to the _next_ epoch
                uint32 ethHeight = uint32(validators.getHeightFromSnapshot(epoch));
                uint32 madHeight = uint32(validators.getMadHeightFromSnapshot(epoch));

                emit ValidatorSet(
                    uint8(addresses.length),
                    validators.epoch(),
                    ethHeight,
                    madHeight,
                    master_public_key[0],
                    master_public_key[1],
                    master_public_key[2],
                    master_public_key[3]
                );

                for (uint256 idx; idx<addresses.length; idx++) {
                    address addr = addresses[idx];

                    emit ValidatorMember(
                        addr,
                        validators.epoch(),
                        idx+1,
                        gpkj_submissions[addr][0],
                        gpkj_submissions[addr][1],
                        gpkj_submissions[addr][2],
                        gpkj_submissions[addr][3]
                    );
                }
            }
        }

        return reinitialize;
    }
}