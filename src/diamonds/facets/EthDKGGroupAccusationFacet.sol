// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;
pragma abicoder v2;

import "../../CryptoLibrary.sol";
import "./EthDKGLibrary.sol";

contract EthDKGGroupAccusationFacet {

    function Group_Accusation_GPKj(
        uint256[] memory invArray,
        uint256[] memory honestIndices,
        uint256[] memory dishonestIndices
    )
    public
    {
        EthDKGLibrary.EthDKGStorage storage es = EthDKGLibrary.ethDKGStorage();

        require(
            (es.T_GPKJ_SUBMISSION_END < block.number) && (block.number <= es.T_GPKJ_DISPUTE_END),
            "gpkj accusation failed (contract is not in gpkj accusation phase)"
        );

        uint256 k = es.addresses.length / 3;
        uint256 threshold = 2*k;
        if (2 == (es.addresses.length - 3*k)) {
            threshold = threshold + 1;
        }
        // All indices are the *correct* indices; we subtract 1 to get the approprtiate stuff.
        require(
            honestIndices.length >= (threshold+1),
            "Incorrect number of honest validators; exit"
        );
        require(
            CryptoLibrary.checkIndices(honestIndices, dishonestIndices, es.addresses.length),
            "honestIndices and dishonestIndices do not contain unique indices"
        );

        // Failure here should not result in loss of stake.
        uint256[2][] memory sigs;
        sigs = new uint256[2][](threshold+1);
        uint256[] memory indices;
        indices = new uint256[](threshold+1);
        uint256 cur_idx;
        address cur_addr;

        require(
            CryptoLibrary.checkInverses(invArray, es.addresses.length),
            "invArray does not include correct inverses"
        );
        // Failure here should not result in loss of stake

        // Construct signature array for honest participants; use first t+1
        for (k = 0; k < (threshold+1); k++) {
            cur_idx = honestIndices[k];
            cur_addr = es.addresses[cur_idx-1];
            sigs[k] = es.initial_signatures[cur_addr];
            indices[k] = cur_idx;
        }
        uint256[2] memory grpsig = CryptoLibrary.AggregateSignatures(sigs, indices, threshold, invArray);
        require(
            CryptoLibrary.Verify(es.initial_message, grpsig, es.master_public_key),
            "honestIndices failed to produce valid group signature"
        );
        // Failure above will not result in loss of stake.
        // At this point, you have not accused anyone of malicious behavior.
        // Asinine behavior does not necessitate stake burning.

        for (k = 0; k < dishonestIndices.length; k++) {
            cur_idx = dishonestIndices[k];
            cur_addr = es.addresses[cur_idx-1];
            indices[threshold] = cur_idx;
            sigs[threshold] = es.initial_signatures[cur_addr];
            grpsig = CryptoLibrary.AggregateSignatures(sigs, indices, threshold, invArray);
            // Either the group signature is invalid, implying the person
            // is dishonest, or the signature is valid, implying whoever
            // submitted the accusation is dishonest. Either way, someone
            // is getting burned.
            if (!CryptoLibrary.Verify(es.initial_message, grpsig, es.master_public_key)) {
                delete es.gpkj_submissions[cur_addr];
                es.is_malicious[cur_addr] = true;
            } else {
                delete es.gpkj_submissions[msg.sender];
                es.is_malicious[msg.sender] = true;
            }
        }
    }

    // Perform Group accusation by computing gpkj*
    //
    // gpkj has already been submitted and stored in gpkj_submissions.
    // To confirm this is valid, we need to compute gpkj*, the corresponding
    // G1 element; we remember gpkj is a public key and an element of G2.
    // Once, we compute gpkj*, we can confirm
    //
    //      e(gpkj*, h2) != e(g1, gpkj)
    //
    // via a pairing check.
    // If we have inequality, then the participant is malicious;
    // if we have equality, then the accusor is malicious.
    function Group_Accusation_GPKj_Comp(
        uint256[][] memory encrypted_shares,
        uint256[2][][] memory commitments,
        uint256 dishonest_list_idx,
        address dishonestAddress
    )
    public
    {
        EthDKGLibrary.EthDKGStorage storage es = EthDKGLibrary.ethDKGStorage();

        require(
            (es.T_GPKJ_SUBMISSION_END < block.number) && (block.number <= es.T_GPKJ_DISPUTE_END),
            "gpkj acc comp failed: contract is not in gpkj accusation phase"
        );

        // n is total participants;
        // t is threshold, so that t+1 is BFT majority.
        uint256 n = es.addresses.length;
        uint256 k = n / 3;
        uint256 t = 2*k;
        if (2 == (n - 3*k)) {
            t = t + 1;
        }

        // Begin initial check
        ////////////////////////////////////////////////////////////////////////
        // First, check length of things
        require(
            (encrypted_shares.length == n) && (commitments.length == n),
            "gpkj acc comp failed: invalid submission of arguments"
        );

        // Now, ensure subarrays are the correct length as well
        for (k = 0; k < n; k++) {
            require(
                encrypted_shares[k].length == n - 1,
                "gpkj acc comp failed: invalid number of encrypted shares provided"
            );
            require(
                commitments[k].length == t + 1,
                "gpkj acc comp failed: invalid number of commitments provided"
            );
        }

        // Ensure submissions are valid
        for (k = 0; k < n; k++) {
            address currentAddr = es.addresses[k];
            require(
                es.share_distribution_hashes[currentAddr] == keccak256(
                    abi.encodePacked(encrypted_shares[k], commitments[k])
                ),
                "gpkj acc comp failed: invalid shares or commitments"
            );
        }

        // Confirm nontrivial submission
        if ((es.gpkj_submissions[dishonestAddress][0] == 0) &&
                (es.gpkj_submissions[dishonestAddress][1] == 0) &&
                (es.gpkj_submissions[dishonestAddress][2] == 0) &&
                (es.gpkj_submissions[dishonestAddress][3] == 0)) {
            return;
        }
        // ^^^ TODO: this check will need to be changed once we allow for multiple accusations per loop

        // Ensure address submissions are correct; this will be converted to loop later
        require(
            es.addresses[dishonest_list_idx] == dishonestAddress,
            "gpkj acc comp failed: dishonest index does not match dishonest address"
        );
        ////////////////////////////////////////////////////////////////////////
        // End initial check

        // At this point, everything has been validated.
        uint256 j = dishonest_list_idx + 1;

        // Info for looping computation
        uint256 pow;
        uint256[2] memory gpkjStar;
        uint256[2] memory tmp;
        uint256 idx;

        // Begin computation loop
        //
        // We remember
        //
        //      F_i(x) = C_i0 * C_i1^x * C_i2^(x^2) * ... * C_it^(x^t)
        //             = Prod(C_ik^(x^k), k = 0, 1, ..., t)
        //
        // We now compute gpkj*. We have
        //
        //      gpkj* = Prod(F_i(j), i)
        //            = Prod( Prod(C_ik^(j^k), k = 0, 1, ..., t), i)
        //            = Prod( Prod(C_ik^(j^k), i), k = 0, 1, ..., t)    // Switch order
        //            = Prod( [Prod(C_ik, i)]^(j^k), k = 0, 1, ..., t)  // Move exponentiation outside
        //
        // More explicityly, we have
        //
        //      gpkj* =  Prod(C_i0, i)        *
        //              [Prod(C_i1, i)]^j     *
        //              [Prod(C_i2, i)]^(j^2) *
        //                  ...
        //              [Prod(C_it, i)]^(j^t) *
        //
        ////////////////////////////////////////////////////////////////////////
        // Add constant terms
        gpkjStar = commitments[0][0]; // Store initial constant term
        for (idx = 1; idx < n; idx++) {
            gpkjStar = CryptoLibrary.bn128_add([gpkjStar[0], gpkjStar[1], commitments[idx][0][0], commitments[idx][0][1]]);
        }

        // Add linear term
        tmp = commitments[0][1]; // Store initial linear term
        pow = j;
        for (idx = 1; idx < n; idx++) {
            tmp = CryptoLibrary.bn128_add([tmp[0], tmp[1], commitments[idx][1][0], commitments[idx][1][1]]);
        }
        tmp = CryptoLibrary.bn128_multiply([tmp[0], tmp[1], pow]);
        gpkjStar = CryptoLibrary.bn128_add([gpkjStar[0], gpkjStar[1], tmp[0], tmp[1]]);

        // Loop through higher order terms
        for (k = 2; k <= t; k++) {
            tmp = commitments[0][k]; // Store initial degree k term
            // Increase pow by factor
            pow = mulmod(pow, j, CryptoLibrary.GROUP_ORDER);
            //x = mulmod(x, disputer_idx, GROUP_ORDER);
            for (idx = 1; idx < n; idx++) {
                tmp = CryptoLibrary.bn128_add([tmp[0], tmp[1], commitments[idx][k][0], commitments[idx][k][1]]);
            }
            tmp = CryptoLibrary.bn128_multiply([tmp[0], tmp[1], pow]);
            gpkjStar = CryptoLibrary.bn128_add([gpkjStar[0], gpkjStar[1], tmp[0], tmp[1]]);
        }
        ////////////////////////////////////////////////////////////////////////
        // End computation loop

        // We now have gpkj*; we now verify.
        uint256[4] memory gpkj = es.gpkj_submissions[dishonestAddress];
        bool isValid = CryptoLibrary.bn128_check_pairing([
            gpkjStar[0], gpkjStar[1],
            CryptoLibrary.H2xi, CryptoLibrary.H2x, CryptoLibrary.H2yi, CryptoLibrary.H2y,
            CryptoLibrary.G1x, CryptoLibrary.G1y,
            gpkj[0], gpkj[1], gpkj[2], gpkj[3]
        ]);
        if (isValid) {
            // Valid gpkj submission; burn whomever submitted accusation
            delete es.gpkj_submissions[msg.sender];
            es.is_malicious[msg.sender] = true;
        }
        else {
            // Invalid gpkj submission; burn participant
            delete es.gpkj_submissions[dishonestAddress];
            es.is_malicious[dishonestAddress] = true;
        }
    }
}