// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;

import "../CryptoLibrary.sol";
import "../EthDKGConstants.sol";
import "./EthDKGLibrary.sol";

contract EthDKGSubmitMPKFacet is EthDKGConstants {

    function submit_master_public_key(
        uint256[4] memory _master_public_key
    )
    public returns (bool)
    {

        EthDKGLibrary.EthDKGStorage storage es = EthDKGLibrary.ethDKGStorage();

        require(
            (es.T_KEY_SHARE_SUBMISSION_END < block.number) && (block.number <= es.T_MPK_SUBMISSION_END),
            "master key submission failed (contract is not in mpk derivation phase)"
        );

        // Check current state; will only be run on first call
        if (!es.key_share_submission_check) {
            bool isValid = true;
            for (uint256 idx; idx<es.addresses.length; idx++) {
                address vaddr = es.addresses[idx];
                if (es.key_shares[vaddr][0] == 0) {
                    // Someone did not submit shares;
                    // should receive a minor fine.
                    isValid = false;
                    es.validators.minorFine(vaddr);
                }
            }
            if (!isValid) {
                // Restart process; fines should be handled above
                return true; // initializeState();
            }
            else {
                // Everything is valid and we do not need to perform this check again
                es.key_share_submission_check = true;
            }
        }

        if ((es.master_public_key[0] != 0) || (es.master_public_key[1] != 0) ||
            (es.master_public_key[2] != 0) || (es.master_public_key[3] != 0)) {
            return false;
        }

        uint256 n = es.addresses.length;

        // find first (i.e. lowest index) node contributing to the final key
        uint256 i = 0;
        address addr;

        do {
            addr = es.addresses[i];
            i += 1;
        } while(i < n && es.share_distribution_hashes[addr] == 0);

        uint256[2] memory tmp = es.key_shares[addr];
        require(tmp[0] != 0, "master key submission failed (key share missing)");
        uint256[2] memory mpk_G1 = es.key_shares[addr];

        for (; i < n; i += 1) {
            addr = es.addresses[i];
            if (es.share_distribution_hashes[addr] == 0) {
                continue;
            }
            tmp = es.key_shares[addr];
            require(tmp[0] != 0, "master key submission failed (key share missing)");
            mpk_G1 = CryptoLibrary.bn128_add([mpk_G1[0], mpk_G1[1], tmp[0], tmp[1]]);
        }
        require(
            CryptoLibrary.bn128_check_pairing([
                mpk_G1[0], mpk_G1[1],
                H2xi, H2x, H2yi, H2y,
                H1x, H1y,
                _master_public_key[0], _master_public_key[1],
                _master_public_key[2], _master_public_key[3]
            ]),
            "master key submission failed (pairing check failed)"
        );

        es.master_public_key = _master_public_key;

        return false;
    }
}