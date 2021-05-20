// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;

import "../Constants.sol";
import "../CryptoLibrary.sol";
import "../Registry.sol";
import "./EthDKGLibrary.sol";

contract EthDKGMiscFacet is Constants {

    function register(uint256[2] memory public_key)
    external
    {
        EthDKGLibrary.EthDKGStorage storage es = EthDKGLibrary.ethDKGStorage();

        require(public_key[0] != 0, "registration failed (public key[0] == 0)");
        require(public_key[1] != 0, "registration failed (public key[1] == 0)");

        require(
            block.number <= es.T_REGISTRATION_END,
            "registration failed (contract is not in registration phase)"
        );
        require(
            es.public_keys[msg.sender][0] == 0,
            "registration failed (account already registered a public key)"
        );
        require(
            CryptoLibrary.bn128_is_on_curve(public_key),
            "registration failed (public key not on elliptic curve)"
        );

        es.validators.confirmValidators();

        require(
            es.validators.isValidator(msg.sender),
            "validator not allowed"
        );

        es.addresses.push(msg.sender);
        es.public_keys[msg.sender] = public_key;
        es.indices[msg.sender] = es.addresses.length - 1;
    }

    function distribute_shares(uint256[] memory encrypted_shares, uint256[2][] memory commitments)
    external
    {
        EthDKGLibrary.EthDKGStorage storage es = EthDKGLibrary.ethDKGStorage();

        require(
            (es.T_REGISTRATION_END < block.number) && (block.number <= es.T_SHARE_DISTRIBUTION_END),
            "share distribution failed (contract is not in share distribution phase)"
        );

        require(
            es.commitments_1st_coefficient[msg.sender][0] == 0 && es.commitments_1st_coefficient[msg.sender][1] == 0, "shares already distributed"
        );

        // Check current state; will only be run on first call
        if (!es.registration_check) {
            // Ensure we meet the minimum registration requirements
            if (es.addresses.length < es.MINIMUM_REGISTRATION) {
                // Failed to meet minimum registration requirements; must restart
                EthDKGLibrary.initializeState();
                return;
            }
            else {
                // Everything is valid and we do not need to perform this check again
                es.registration_check = true;
            }
        }

        // In our BFT consensus alg, we require t + 1 > 2*n/3.
        // There are 3 possibilities for n:
        //
        //  n == 3*k:
        //      We set
        //                          t = 2*k
        //      This implies
        //                      2*k     == t     <= 2*n/3 == 2*k
        //      and
        //                      2*k + 1 == t + 1  > 2*n/3 == 2*k
        //
        //  n == 3*k + 1:
        //      We set
        //                          t = 2*k
        //      This implies
        //                      2*k     == t     <= 2*n/3 == 2*k + 1/3
        //      and
        //                      2*k + 1 == t + 1  > 2*n/3 == 2*k + 1/3
        //
        //  n == 3*k + 2:
        //      We set
        //                          t = 2*k + 1
        //      This implies
        //                      2*k + 1 == t     <= 2*n/3 == 2*k + 4/3
        //      and
        //                      2*k + 2 == t + 1  > 2*n/3 == 2*k + 4/3
        uint256 n = es.addresses.length;
        uint256 k = n / 3;
        uint256 t = 2*k;
        if (2 == (n - 3*k)) {
            t = t + 1;
        }

        require(
            es.public_keys[msg.sender][0] != 0,
            "share distribution failed (ethereum account has not registered)"
        );
        require(
            encrypted_shares.length == n - 1,
            "share distribution failed (invalid number of encrypted shares provided)"
        );
        require(
            commitments.length == t + 1,
            "key sharing failed (invalid number of commitments provided)"
        );
        for (k = 0; k <= t; k += 1) {
            require(
                CryptoLibrary.bn128_is_on_curve(commitments[k]),
                "key sharing failed (commitment not on elliptic curve)"
            );
        }

        es.share_distribution_hashes[msg.sender] = keccak256(
            abi.encodePacked(encrypted_shares, commitments)
        );
        es.commitments_1st_coefficient[msg.sender] = commitments[0];

        emit EthDKGLibrary.ShareDistribution(msg.sender, es.indices[msg.sender] + 1, encrypted_shares, commitments);
    }

    function submit_key_share(
        address issuer,
        uint256[2] memory key_share_G1,
        uint256[2] memory key_share_G1_correctness_proof,
        uint256[4] memory key_share_G2
    )
    external
    {
        EthDKGLibrary.EthDKGStorage storage es = EthDKGLibrary.ethDKGStorage();

        require(
            (es.T_DISPUTE_END < block.number) && (block.number <= es.T_KEY_SHARE_SUBMISSION_END),
            "key share submission failed (contract is not in key derivation phase)"
        );

        // Check current state; will only be run on first call
        if (!es.share_distribution_check) {
            bool isValid = true;
            for (uint256 idx; idx<es.addresses.length; idx++) {
                address addr = es.addresses[idx];
                if (es.share_distribution_hashes[addr] == 0) {
                    if (es.is_malicious[addr]) {
                        // Someone was malicious and had shares deleted;
                        // should receive a major fine.
                        es.validators.majorFine(addr);
                    }
                    else {
                        // Someone did not submit shares;
                        // should receive a minor fine.
                        es.validators.minorFine(addr);
                    }
                    isValid = false;
                }
            }
            if (!isValid) {
                // Restart process; fines should be handled above
                EthDKGLibrary.initializeState();
                return;
            }
            else {
                // Everything is valid and we do not need to perform this check again
                es.share_distribution_check = true;
            }
        }

        if (es.key_shares[issuer][0] != 0) {
            return;
        }

        // With the above check, this can be removed;
        // everyone has nonzero hashes
        require(
            es.share_distribution_hashes[issuer] != 0,
            "key share submission failed (issuer not qualified)"
        );
        require(
            CryptoLibrary.dleq_verify(
                [CryptoLibrary.H1x, CryptoLibrary.H1y],
                key_share_G1,
                [CryptoLibrary.G1x, CryptoLibrary.G1y],
                es.commitments_1st_coefficient[issuer],
                key_share_G1_correctness_proof
            ),
            "key share submission failed (invalid key share (G1))"
        );
        require(
            CryptoLibrary.bn128_check_pairing([
                key_share_G1[0], key_share_G1[1],
                CryptoLibrary.H2xi, CryptoLibrary.H2x, CryptoLibrary.H2yi, CryptoLibrary.H2y,
                CryptoLibrary.H1x, CryptoLibrary.H1y,
                key_share_G2[0], key_share_G2[1], key_share_G2[2], key_share_G2[3]
            ]),
            "key share submission failed (invalid key share (G2))"
        );

        es.key_shares[issuer] = key_share_G1;
        emit EthDKGLibrary.KeyShareSubmission(issuer, key_share_G1, key_share_G1_correctness_proof, key_share_G2);
    }

    function Submit_GPKj(
        uint256[4] memory gpkj,
        uint256[2] memory sig
    )
    external
    {
        EthDKGLibrary.EthDKGStorage storage es = EthDKGLibrary.ethDKGStorage();

        require(
            (es.T_MPK_SUBMISSION_END < block.number) && (block.number <= es.T_GPKJ_SUBMISSION_END),
            "gpkj key submission failed (contract is not in gpkj derivation phase)"
        );

        // Check current state; will only be run on first call
        if (!es.mpk_submission_check) {
            if (es.master_public_key[0] == 0 && es.master_public_key[1] == 0 &&
                    es.master_public_key[2] == 0 && es.master_public_key[3] == 0) {
                // No one submitted mpk;
                // fine everyone;
                // restart process
                EthDKGLibrary.initializeState();
                return;
            }
            else {
                // Everything is valid and we do not need to perform this check again
                es.mpk_submission_check = true;
            }
        }

        require(
            es.gpkj_submissions[msg.sender][0] == 0 &&
            es.gpkj_submissions[msg.sender][1] == 0 &&
            es.gpkj_submissions[msg.sender][2] == 0 &&
            es.gpkj_submissions[msg.sender][3] == 0,
            "GPKj submission failed (already submitted gpkj)"
        );
        require(
            CryptoLibrary.bn128_is_on_curve(sig),
            "Invalid signature (not on curve)"
        );
        require(
            CryptoLibrary.Verify(es.initial_message, sig, gpkj),
            "GPKj submission failed (signature verification failed due to invalid gpkj)"
        );
        es.gpkj_submissions[msg.sender] = gpkj;
        es.initial_signatures[msg.sender] = sig;
    }
}