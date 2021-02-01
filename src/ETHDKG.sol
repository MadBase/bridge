// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;

import "./Constants.sol";
import "./Crypto.sol";
import "./ETHDKGStorage.sol";
import "./Registry.sol";
import "./interfaces/Validators.sol";

/*
    Author: Philipp Schindler
    Source code and documentation available on Github: https://github.com/PhilippSchindler/ethdkg

    Copyright 2019 Philipp Schindler

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

contract ETHDKG is Constants, ETHDKGStorage, RegistryClient {

    constructor(Registry registry_) {
        registry = registry_;
        owner = msg.sender;
    }

    function reloadRegistry() public override {
        // The require()'s are commented out because they push us over the code size limit
        require(msg.sender == owner, "Not authorized");

        // Lookup Crypto
        crypto = Crypto(registry.lookup(CRYPTO_CONTRACT));
        // require(address(crypto) != address(0), "invalid address for crypto");

        // Lookup Validators
        validators = Validators(registry.lookup(VALIDATORS_CONTRACT));
        // require(address(validators) != address(0), "invalid address for validators");

        // Lookup ETHDKGCompletion
        ethdkgCompletion = registry.lookup(ETHDKG_COMPLETION_CONTRACT);
        // require(ethdkgCompletion != address(0), "invalid address for ethdkgCompletion");

        // Lookup ETHDKGGroupAccusation
        ethdkgGroupAccusation = registry.lookup(ETHDKG_GROUPACCUSATION_CONTRACT);
        // require(ethdkgGroupAccusation != address(0), "invalid address for ethdkgGroupAccusation");

        // Lookup ETHDKGSubmitMPK
        ethdkgSubmitMPK = registry.lookup(ETHDKG_SUBMITMPK_CONTRACT);
        // require(ethdkgSubmitMPK != address(0), "invalid address for ethdkgSubmitMPK");
    }

    function updatePhaseLength(uint256 newDelta) public {
        require(msg.sender == owner, "Not authorized");

        DELTA_INCLUDE = newDelta;
    }

    function getPhaseLength() public view returns (uint256) {
        return DELTA_INCLUDE;
    }

    function initializeState() public {
        require(
            msg.sender == owner || msg.sender == address(validators), "Not authorized");
        _initializeState();
    }

    function _initializeState() internal {
        uint256 T_CONTRACT_CREATION = block.number;
        T_REGISTRATION_END = T_CONTRACT_CREATION + DELTA_INCLUDE;
        T_SHARE_DISTRIBUTION_END = T_REGISTRATION_END + DELTA_CONFIRM + DELTA_INCLUDE;
        T_DISPUTE_END = T_SHARE_DISTRIBUTION_END + DELTA_CONFIRM + DELTA_INCLUDE;
        T_KEY_SHARE_SUBMISSION_END = T_DISPUTE_END + DELTA_CONFIRM + DELTA_INCLUDE;
        T_MPK_SUBMISSION_END = T_KEY_SHARE_SUBMISSION_END + DELTA_CONFIRM + DELTA_INCLUDE;
        T_GPKJ_SUBMISSION_END = T_MPK_SUBMISSION_END + DELTA_CONFIRM + DELTA_INCLUDE;
        T_GPKJ_DISPUTE_END = T_GPKJ_SUBMISSION_END + DELTA_CONFIRM + DELTA_INCLUDE;
        T_DKG_COMPLETE = T_GPKJ_DISPUTE_END + DELTA_CONFIRM + DELTA_INCLUDE;

        emit RegistrationOpen(
            T_CONTRACT_CREATION, T_REGISTRATION_END, T_SHARE_DISTRIBUTION_END, T_DISPUTE_END,
            T_KEY_SHARE_SUBMISSION_END, T_MPK_SUBMISSION_END, T_GPKJ_SUBMISSION_END,
            T_GPKJ_DISPUTE_END, T_DKG_COMPLETE);

        registration_check = false;
        share_distribution_check = false;
        key_share_submission_check = false;
        mpk_submission_check = false;
        completion_check = false;

        delete master_public_key;

        while (addresses.length > 0) {
            address addr = addresses[addresses.length-1];

            delete public_keys[addr];
            delete share_distribution_hashes[addr];
            delete commitments_1st_coefficient[addr];
            delete key_shares[addr];
            delete gpkj_submissions[addr];
            delete initial_signatures[addr];
            delete is_malicious[addr];
            delete indices[addr];

            addresses.pop();
        }
    }

    function numberOfRegistrations() public view returns (uint256) {
        require(block.number > T_REGISTRATION_END, "registration not complete");
        return addresses.length;
    }


    ////////////////////////////////////////////////////////////////////////////////////////////////
    //// MAIN CONTRACT FUNCTIONS

    function register(uint256[2] memory public_key)
    public
    {
        require(public_key[0] != 0, "registration failed (public key[0] == 0)");
        require(public_key[1] != 0, "registration failed (public key[1] == 0)");

        require(
            block.number <= T_REGISTRATION_END,
            "registration failed (contract is not in registration phase)"
        );
        require(
            public_keys[msg.sender][0] == 0,
            "registration failed (account already registered a public key)"
        );
        require(
            crypto.bn128_is_on_curve(public_key),
            "registration failed (public key not on elliptic curve)"
        );

        validators.confirmValidators();

        require(
            validators.isValidator(msg.sender),
            "validator not allowed"
        );

        addresses.push(msg.sender);
        public_keys[msg.sender] = public_key;
        indices[msg.sender] = addresses.length - 1;
    }


    function distribute_shares(uint256[] memory encrypted_shares, uint256[2][] memory commitments)
    public
    {
        require(
            (T_REGISTRATION_END < block.number) && (block.number <= T_SHARE_DISTRIBUTION_END),
            "share distribution failed (contract is not in share distribution phase)"
        );

        require(
            commitments_1st_coefficient[msg.sender][0] == 0 && commitments_1st_coefficient[msg.sender][1] == 0, "shares already distributed"
        );

        // Check current state; will only be run on first call
        if (!registration_check) {
            // Ensure we meet the minimum registration requirements
            if (addresses.length < MINIMUM_REGISTRATION) {
                // Failed to meet minimum registration requirements; must restart
                _initializeState();
                return;
            }
            else {
                // Everything is valid and we do not need to perform this check again
                registration_check = true;
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
        uint256 n = addresses.length;
        uint256 k = n / 3;
        uint256 t = 2*k;
        if (2 == (n - 3*k)) {
            t = t + 1;
        }

        require(
            public_keys[msg.sender][0] != 0,
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
                crypto.bn128_is_on_curve(commitments[k]),
                "key sharing failed (commitment not on elliptic curve)"
            );
        }

        share_distribution_hashes[msg.sender] = keccak256(
            abi.encodePacked(encrypted_shares, commitments)
        );
        commitments_1st_coefficient[msg.sender] = commitments[0];

        emit ShareDistribution(msg.sender, indices[msg.sender] + 1, encrypted_shares, commitments);
    }


    function submit_dispute(
        address issuer,
        uint256 issuer_list_idx,
        uint256 disputer_list_idx,
        uint256[] memory encrypted_shares,
        uint256[2][] memory commitments,
        uint256[2] memory shared_key,
        uint256[2] memory shared_key_correctness_proof
    )
    public
    {
        require(
            (T_SHARE_DISTRIBUTION_END < block.number) && (block.number <= T_DISPUTE_END),
            "dispute failed (contract is not in dispute phase)"
        );
        require(
            addresses[issuer_list_idx] == issuer &&
            addresses[disputer_list_idx] == msg.sender,
            "dispute failed (invalid list indices)"
        );

        // Check if a other node already submitted a dispute against the same issuer.
        // In this case the issuer is already disqualified and no further actions are required here.
        if (share_distribution_hashes[issuer] == 0) {
            return;
        }

        require(
            share_distribution_hashes[issuer] == keccak256(
                abi.encodePacked(encrypted_shares, commitments)
            ),
            "dispute failed (invalid replay of sharing transaction)"
        );
        require(
            crypto.dleq_verify(
                [G1x, G1y], public_keys[msg.sender], public_keys[issuer], shared_key, shared_key_correctness_proof
            ),
            "dispute failed (invalid shared key or proof)"
        );

        // Since all provided data is valid so far, we load the share and use the verified shared
        // key to decrypt the share for the disputer.
        uint256 share;
        uint256 disputer_idx = disputer_list_idx + 1;
        if (disputer_list_idx < issuer_list_idx) {
            share = encrypted_shares[disputer_list_idx];
        }
        else {
            share = encrypted_shares[disputer_list_idx - 1];
        }
        uint256 decryption_key = uint256(keccak256(
            abi.encodePacked(shared_key[0], disputer_idx)
        ));
        share ^= decryption_key;

        // Verify the share for it's correctness using the polynomial defined by the commitments.
        // First, the polynomial (in group G1) is evaluated at the disputer's idx.
        uint256 x = disputer_idx;
        uint256[2] memory result = commitments[0];
        uint256[2] memory tmp = crypto.bn128_multiply([commitments[1][0], commitments[1][1], x]);
        result = crypto.bn128_add([result[0], result[1], tmp[0], tmp[1]]);
        for (uint256 j = 2; j < commitments.length; j += 1) {
            x = mulmod(x, disputer_idx, GROUP_ORDER);
            tmp = crypto.bn128_multiply([commitments[j][0], commitments[j][1], x]);
            result = crypto.bn128_add([result[0], result[1], tmp[0], tmp[1]]);
        }

        // Then the result is compared to the point in G1 corresponding to the decrypted share.
        // In this case, either the shared value is invalid, so the issuer
        // should be burned; otherwise, the share is valid, and whoever
        // submitted this accusation should be burned. In any case, someone
        // will have his stake burned.
        // We do this by marking the disqualified, we zero the hash and
        // set the participant to malicious.
        tmp = crypto.bn128_multiply([G1x, G1y, share]);
        if (result[0] != tmp[0] || result[1] != tmp[1]) {
            delete share_distribution_hashes[issuer];
            is_malicious[issuer] = true;
        } else {
            delete share_distribution_hashes[msg.sender];
            is_malicious[msg.sender] = true;
        }
    }


    function submit_key_share(
        address issuer,
        uint256[2] memory key_share_G1,
        uint256[2] memory key_share_G1_correctness_proof,
        uint256[4] memory key_share_G2
    )
    public
    {
        require(
            (T_DISPUTE_END < block.number) && (block.number <= T_KEY_SHARE_SUBMISSION_END),
            "key share submission failed (contract is not in key derivation phase)"
        );

        // Check current state; will only be run on first call
        if (!share_distribution_check) {
            bool isValid = true;
            for (uint256 idx; idx<addresses.length; idx++) {
                address addr = addresses[idx];
                if (share_distribution_hashes[addr] == 0) {
                    if (is_malicious[addr]) {
                        // Someone was malicious and had shares deleted;
                        // should receive a major fine.
                        validators.majorFine(addr);
                    }
                    else {
                        // Someone did not submit shares;
                        // should receive a minor fine.
                        validators.minorFine(addr);
                    }
                    isValid = false;
                }
            }
            if (!isValid) {
                // Restart process; fines should be handled above
                _initializeState();
                return;
            }
            else {
                // Everything is valid and we do not need to perform this check again
                share_distribution_check = true;
            }
        }

        if (key_shares[issuer][0] != 0) {
            return;
        }

        // With the above check, this can be removed;
        // everyone has nonzero hashes
        require(
            share_distribution_hashes[issuer] != 0,
            "key share submission failed (issuer not qualified)"
        );
        require(
            crypto.dleq_verify(
                [H1x, H1y],
                key_share_G1,
                [G1x, G1y],
                commitments_1st_coefficient[issuer],
                key_share_G1_correctness_proof
            ),
            "key share submission failed (invalid key share (G1))"
        );
        require(
            bn128_check_pairing([
                key_share_G1[0], key_share_G1[1],
                H2xi, H2x, H2yi, H2y,
                H1x, H1y,
                key_share_G2[0], key_share_G2[1], key_share_G2[2], key_share_G2[3]
            ]),
            "key share submission failed (invalid key share (G2))"
        );

        key_shares[issuer] = key_share_G1;
        emit KeyShareSubmission(issuer, key_share_G1, key_share_G1_correctness_proof, key_share_G2);
    }


    function submit_master_public_key(
        uint256[4] memory _master_public_key
    )
    public
    {
        // Just a straight DELEGATECALL to ethdkgGroupAccusation
        (bool ok, bytes memory res ) = ethdkgSubmitMPK.delegatecall(
            abi.encodeWithSignature("submit_master_public_key(uint256[4])", _master_public_key));
        require(ok, "delegated call failed for submit_master_public_key()");

        bool reinitialize = abi.decode(res, (bool));
        if (reinitialize) {
            _initializeState();
        }
    }

    // Begin new functions added
    function Submit_GPKj(
        uint256[4] memory gpkj,
        uint256[2] memory sig
    )
    public
    {
        require(
            (T_MPK_SUBMISSION_END < block.number) && (block.number <= T_GPKJ_SUBMISSION_END),
            "gpkj key submission failed (contract is not in gpkj derivation phase)"
        );

        // Check current state; will only be run on first call
        if (!mpk_submission_check) {
            if (master_public_key[0] == 0 && master_public_key[1] == 0 &&
                    master_public_key[2] == 0 && master_public_key[3] == 0) {
                // No one submitted mpk;
                // fine everyone;
                // restart process
                _initializeState();
                return;
            }
            else {
                // Everything is valid and we do not need to perform this check again
                mpk_submission_check = true;
            }
        }

        require(
            gpkj_submissions[msg.sender][0] == 0 &&
            gpkj_submissions[msg.sender][1] == 0 &&
            gpkj_submissions[msg.sender][2] == 0 &&
            gpkj_submissions[msg.sender][3] == 0,
            "GPKj submission failed (already submitted gpkj)"
        );
        require(
            crypto.bn128_is_on_curve(sig),
            "Invalid signature (not on curve)"
        );
        require(
            crypto.Verify(initial_message, sig, gpkj),
            "GPKj submission failed (signature verification failed due to invalid gpkj)"
        );
        gpkj_submissions[msg.sender] = gpkj;
        initial_signatures[msg.sender] = sig;
    }


    function Group_Accusation_GPKj(
        uint256[] memory invArray,
        uint256[] memory honestIndices,
        uint256[] memory dishonestIndices
    )
    public
    {
        // Just a straight DELEGATECALL to ethdkgGroupAccusation
        (bool ok, ) = ethdkgGroupAccusation.delegatecall(
            abi.encodeWithSignature("Group_Accusation_GPKj(uint256[],uint256[],uint256[])", invArray, honestIndices,  dishonestIndices));
        require(ok, "delegated call failed for Group_Accusation_GPKj()");
    }

    function Successful_Completion() public {

        // This should be the logic, but using DELEGATECALL
        // ----------------------------------------------
        // if (ethdkgCompletion.Successful_Completion()) {
        //     initializeState();
        // }

        (bool ok, bytes memory res) = ethdkgCompletion.delegatecall(abi.encodeWithSignature("Successful_Completion()"));
        require(ok, "delegated call failed for Successful_Completion()");

        bool reinitialize = abi.decode(res, (bool));
        if (reinitialize) {
            _initializeState();
        }

    }
    // End new functions added


}
