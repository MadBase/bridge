// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;

import "../CryptoLibrary.sol";
import "../Constants.sol";
import "../EthDKGConstants.sol";
import "../Registry.sol";
import "./EthDKGLibrary.sol";

contract EthDKGSubmitDisputeFacet is Constants, EthDKGConstants {

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
        EthDKGLibrary.EthDKGStorage storage es = EthDKGLibrary.ethDKGStorage();

        require(
            (es.T_SHARE_DISTRIBUTION_END < block.number) && (block.number <= es.T_DISPUTE_END),
            "dispute failed (contract is not in dispute phase)"
        );
        require(
            es.addresses[issuer_list_idx] == issuer &&
            es.addresses[disputer_list_idx] == msg.sender,
            "dispute failed (invalid list indices)"
        );

        // Check if a other node already submitted a dispute against the same issuer.
        // In this case the issuer is already disqualified and no further actions are required here.
        if (es.share_distribution_hashes[issuer] == 0) {
            return;
        }

        require(
            es.share_distribution_hashes[issuer] == keccak256(
                abi.encodePacked(encrypted_shares, commitments)
            ),
            "dispute failed (invalid replay of sharing transaction)"
        );
        require(
            CryptoLibrary.dleq_verify(
                [G1x, G1y], es.public_keys[msg.sender], es.public_keys[issuer], shared_key, shared_key_correctness_proof
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

        // uint256 decryption_key = uint256(keccak256(abi.encodePacked(shared_key[0], disputer_idx)))
        share ^= uint256(keccak256(abi.encodePacked(shared_key[0], disputer_idx)));

        // Verify the share for it's correctness using the polynomial defined by the commitments.
        // First, the polynomial (in group G1) is evaluated at the disputer's idx.
        uint256 x = disputer_idx;
        uint256[2] memory result = commitments[0];
        uint256[2] memory tmp = CryptoLibrary.bn128_multiply([commitments[1][0], commitments[1][1], x]);
        result = CryptoLibrary.bn128_add([result[0], result[1], tmp[0], tmp[1]]);
        for (uint256 j = 2; j < commitments.length; j += 1) {
            x = mulmod(x, disputer_idx, GROUP_ORDER);
            tmp = CryptoLibrary.bn128_multiply([commitments[j][0], commitments[j][1], x]);
            result = CryptoLibrary.bn128_add([result[0], result[1], tmp[0], tmp[1]]);
        }

        // Then the result is compared to the point in G1 corresponding to the decrypted share.
        // In this case, either the shared value is invalid, so the issuer
        // should be burned; otherwise, the share is valid, and whoever
        // submitted this accusation should be burned. In any case, someone
        // will have his stake burned.
        // We do this by marking the disqualified, we zero the hash and
        // set the participant to malicious.
        tmp = CryptoLibrary.bn128_multiply([G1x, G1y, share]);
        if (result[0] != tmp[0] || result[1] != tmp[1]) {
            delete es.share_distribution_hashes[issuer];
            es.is_malicious[issuer] = true;
        } else {
            delete es.share_distribution_hashes[msg.sender];
            es.is_malicious[msg.sender] = true;
        }
    }
}