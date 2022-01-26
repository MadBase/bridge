// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.11;

interface IValidatorPool {
    function setMinimumStake(uint256 minimumStake_) external;

    function setMaxNumValidators(uint256 maxNumValidators_) external;

    function getValidatorsCount() external view returns (uint256);

    function getValidator(uint256 index) external view returns (address);

    function getValidatorAddresses() external view returns (address[] memory);

    function isValidator(address participant) external view returns (bool);

    function collectProfits() external returns (uint256 payoutEth, uint256 payoutToken);

    function claimStakeNFTPosition() external returns (uint256 stakeTokenID);

    function majorSlash(address participant) external;

    function minorSlash(address participant) external;

    function initializeETHDKG() external;
}
