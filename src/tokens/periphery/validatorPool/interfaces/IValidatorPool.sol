// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.11;

import "../utils/CustomEnumerableMaps.sol";

interface IValidatorPool {
    function setETHDKG(address _address) external;

    function setSnapshot(address _address) external;

    function setStakeAmount(uint256 stakeAmount_) external;

    function setMaxNumValidators(uint256 maxNumValidators_) external;

    function setLocation(string calldata ip) external;

    function getValidatorsCount() external view returns (uint256);

    function getValidatorAddresses() external view returns (address[] memory);

    function getValidator(uint256 index) external view returns (address);

    function getValidatorData(uint256 index) external view returns (ValidatorData memory);

    function getLocation(address validator) external view returns (string memory);

    function getLocations(address[] calldata validators_) external view returns (string[] memory);

    function isValidator(address participant) external view returns (bool);

    function isInExitingQueue(address participant) external view returns (bool);

    function isAccusable(address participant) external view returns (bool);

    function isMaintenanceScheduled() external view returns (bool);

    function scheduleMaintenance() external;

    function initializeETHDKG() external;

    function completeETHDKG() external;

    function pauseConsensus() external;

    function pauseConsensusOnArbitraryHeight(uint256 madnetHeight) external;

    function registerValidators(address[] calldata validators, uint256[] calldata stakerTokenIDs)
        external;

    function unregisterValidators(address[] calldata validators) external;

    function unregisterAllValidators() external;

    function collectProfits() external returns (uint256 payoutEth, uint256 payoutToken);

    function claimStakeNFTPosition() external;

    function majorSlash(address dishonestValidator_, address disputer_) external;

    function minorSlash(address dishonestValidator_, address disputer_) external;
}
