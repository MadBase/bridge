pragma solidity >=0.5.15;

import "./ETHDKGStorage.sol";

contract ETHDKGGroupAccusation is ETHDKGStorage {

    function Group_Accusation_GPKj(
        uint256[] memory invArray,
        uint256[] memory honestIndices,
        uint256[] memory dishonestIndices
    )
    public
    {
        require(
            (T_GPKJ_SUBMISSION_END < block.number) && (block.number <= T_GPKJ_DISPUTE_END),
            "gpkj accusation failed (contract is not in gpkj accusation phase)"
        );

        uint256 k = addresses.length / 3;
        uint256 threshold = 2*k;
        if (2 == (addresses.length - 3*k)) {
            threshold = threshold + 1;
        }
        // All indices are the *correct* indices; we subtract 1 to get the approprtiate stuff.
        require(
            honestIndices.length >= (threshold+1),
            "Incorrect number of honest validators; exit"
        );
        require(
            crypto.checkIndices(honestIndices, dishonestIndices, addresses.length),
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
            crypto.checkInverses(invArray, addresses.length),
            "invArray does not include correct inverses"
        );
        // Failure here should not result in loss of stake

        // Construct signature array for honest participants; use first t+1
        for (k = 0; k < (threshold+1); k++) {
            cur_idx = honestIndices[k];
            cur_addr = addresses[cur_idx-1];
            sigs[k] = initial_signatures[cur_addr];
            indices[k] = cur_idx;
        }
        uint256[2] memory grpsig = crypto.AggregateSignatures(sigs, indices, threshold, invArray);
        require(
            crypto.Verify(initial_message, grpsig, master_public_key),
            "honestIndices failed to produce valid group signature"
        );
        // Failure above will not result in loss of stake.
        // At this point, you have not accused anyone of malicious behavior.
        // Asinine behavior does not necessitate stake burning.

        for (k = 0; k < dishonestIndices.length; k++) {
            cur_idx = dishonestIndices[k];
            cur_addr = addresses[cur_idx-1];
            indices[threshold] = cur_idx;
            sigs[threshold] = initial_signatures[cur_addr];
            grpsig = crypto.AggregateSignatures(sigs, indices, threshold, invArray);
            // Either the group signature is invalid, implying the person
            // is dishonest, or the signature is valid, implying whoever
            // submitted the accusation is dishonest. Either way, someone
            // is getting burned.
            if (!crypto.Verify(initial_message, grpsig, master_public_key)) {
                delete gpkj_submissions[cur_addr];
                is_malicious[cur_addr] = true;
            } else {
                delete gpkj_submissions[msg.sender];
                is_malicious[msg.sender] = true;
            }
        }
    }
}