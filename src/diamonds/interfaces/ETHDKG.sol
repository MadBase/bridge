// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;
pragma abicoder v2;

import "../../Registry.sol";
import "./ETHDKGEvents.sol";

/*
    Author: Philipp Schindler
    Source code and documentation available on Github: https://github.com/PhilippSchindler/ethdkg

    Copyright 2019 Philipp Schindler

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

interface IETHDKG is ETHDKGEvents {

    function updatePhaseLength(uint256) external;

    function getPhaseLength() external view returns (uint256);

    function gpkj_submissions(address, uint256) external view returns (uint256);

    function master_public_key(uint256) external view returns (uint256);

    function numberOfRegistrations() external view returns (uint256);

    function initializeState() external;

    function initializeEthDKG(Registry) external;

    function addresses(uint256 idx) external view returns (address);

    function publicKeys(address addr, uint256 idx) external view returns (uint256);

    function keyShares(address addr, uint256 idx) external view returns (uint256);

    function initialMessage() external view returns (bytes memory);

    function initialSignatures(address addr, uint256 idx) external view returns (uint256);

    function T_REGISTRATION_END() external view returns (uint256);

    function T_SHARE_DISTRIBUTION_END() external view returns (uint256);

    function T_DISPUTE_END() external view returns (uint256);

    function T_KEY_SHARE_SUBMISSION_END() external view returns (uint256);

    function T_MPK_SUBMISSION_END() external view returns (uint256);

    function T_GPKJ_SUBMISSION_END() external view returns (uint256);

    function T_GPKJDISPUTE_END() external view returns (uint256);

    function T_DKG_COMPLETE() external view returns (uint256);

    function isMalicious(address addr) external view returns (bool);

    function shareDistributionHashes(address addr) external view returns (bytes32);

    function commitments_1st_coefficient(address addr, uint256 idx) external view returns (uint256);

    ////////////////////////////////////////////////////////////////////////////////////////////////
    //// MAIN CONTRACT FUNCTIONS

    function register(uint256[2] memory public_key) external;

    function distribute_shares(uint256[] memory encrypted_shares, uint256[2][] memory commitments) external;

    function submit_dispute(
        address issuer,
        uint256 issuer_list_idx,
        uint256 disputer_list_idx,
        uint256[] memory encrypted_shares,
        uint256[2][] memory commitments,
        uint256[2] memory shared_key,
        uint256[2] memory shared_key_correctness_proof
    )
    external;

    function submit_key_share(
        address issuer,
        uint256[2] memory key_share_G1,
        uint256[2] memory key_share_G1_correctness_proof,
        uint256[4] memory key_share_G2
    )
    external;

    function submit_master_public_key(
        uint256[4] memory _master_public_key
    )
    external;

    // Begin new functions added
    function Submit_GPKj(
        uint256[4] memory gpkj,
        uint256[2] memory sig
    )
    external;

    function Group_Accusation_GPKj(
        uint256[] memory invArray,
        uint256[] memory honestIndices,
        uint256[] memory dishonestIndices
    )
    external;

    function Group_Accusation_GPKj_Comp(
        uint256[][] memory encrypted_shares,
        uint256[2][][] memory commitments,
        uint256 dishonest_list_idx,
        address dishonestAddress
    )
    external;

    function Successful_Completion() external;

}
