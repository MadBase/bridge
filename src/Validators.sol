// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.15;

import "ds-stop/stop.sol";

import "./Constants.sol";
import "./QueueLibrary.sol";
import "./Registry.sol";
import "./Staking.sol";
import "./SignatureLibrary.sol";
import "./SimpleAuth.sol";
import "./ValidatorsStorage.sol";

contract Validators is Constants, DSStop, SimpleAuth, RegistryClient, ValidatorsStorage {

    constructor(uint8 maxValidators, Registry registry_) public {
        epoch = 1; // No options here
        validatorMaxCount = maxValidators;
        registry = registry_;

        // Defaults for configurable options
        minimumStake = 1_000_000;
        majorStakeFine = 200_000;
        minorStakeFine = 50_000;
        rewardAmount = 1_000;
        rewardBonus = 1_000;
    }

    function reloadRegistry() public override onlyOperator {
        address cryptoAddr = registry.lookup(CRYPTO_CONTRACT);
        crypto = Crypto(cryptoAddr);
        require(cryptoAddr != address(0), "invalid address for crypto");

        address ethdkgAddr = registry.lookup(ETHDKG_CONTRACT);
        ethdkg = ETHDKG(ethdkgAddr);
        require(ethdkgAddr != address(0), "invalid address for ethdkg");
        grantOperator(ethdkgAddr);
        
        address stakingAddr = registry.lookup(STAKING_CONTRACT);
        staking = Staking(stakingAddr);
        require(stakingAddr != address(0), "invalid address for staking");

        validatorsSnapshot = registry.lookup(VALIDATORS_SNAPSHOT_CONTRACT);
        require(validatorsSnapshot != address(0), "invalid address for snapshot contract");
    }

    function burn(address who) external onlyOperator stoppable {
        staking.burnStake(who, minimumStake);
    }

    function majorFine(address who) external onlyOperator stoppable {
        staking.fine(who, majorStakeFine);
    }

    function minorFine(address who) external onlyOperator stoppable {
        staking.fine(who, minorStakeFine);
    }

    // function createValidator(uint256[2] calldata madNetID, bytes calldata signature) external stoppable returns (Validator) {
    //     return _createValidator(msg.sender, madNetID, signature);
    // }

    // function createValidator(address who, uint256[2] calldata madNetID, bytes calldata signature) external stoppable returns (Validator) {
    //     return _createValidator(who, madNetID, signature);
    // }

    // function _createValidator(address owner, uint256[2] memory madNetID, bytes memory signature) internal returns (Validator) {
    //     Validator validator = new ValidatorStandin(madNetID, signature);

    //     bytes memory madNetIDBytes = abi.encodePacked(madNetID);

    //     address signer = signature.recoverSigner(madNetIDBytes);

    //     emit ValidatorCreated(address(validator), signer, madNetID);

    //     require(signer == owner, "Signer doesn't match owner.");

    //     return validator;
    // }

    function confirmValidators() external stoppable returns (bool) {
        // More filthyness. I _know_ there will be few iterations (if any) but this is still shit.
        while(validatorCount < validatorMaxCount && queue.size() > 0) { // TODO Design how to be better
            address validator = queue.dequeue();
            uint256[2] memory validatorMadID = validatorPublicKey[validator];
            _addValidator(validator, validatorMadID);

            // TODO Place hook here to return stake to those we have requested; assuming we've passed the required epoch
        }

        // TODO emit current valid

        return true;
    }

    function isValidator(address validator) public view returns (bool) {
        return validatorPresent[validator] && staking.balanceStakeFor(validator) >= minimumStake;
    }

    function extractBytes32(bytes memory src, uint idx) internal pure returns (bytes32 val) {
        for (uint offset=0; offset<32; offset++) {
            val |= bytes32(src[offset+idx]) >> (offset * 8);
        }
    }

    function snapshot(bytes calldata _signatureGroup, bytes calldata _bclaims) external stoppable {

        (bool ok, bytes memory res) = validatorsSnapshot.delegatecall(
            abi.encodeWithSignature("snapshot(bytes,bytes)", _signatureGroup, _bclaims));
        require(ok, "delegatecall failed for snapshot(...)");

        bool reinitialize = abi.decode(res, (bool));
        if (reinitialize) {
            ethdkg.initializeState();
        }

        // Now we just issue rewards
        staking.setCurrentEpoch(epoch);
        for (uint idx=0; idx<validators.length; idx++) {
            staking.lockRewardFor(validators[idx], rewardAmount, epoch+1);
        }
        staking.lockRewardFor(msg.sender, rewardBonus, epoch+1);
    }

    /**
     * _validator is a contract, so can't sign
     */
    function addValidator(address _validator, uint256[2] calldata _madID) external stoppable returns (uint8) {
        return _addValidator(_validator, _madID);
    }

    function _addValidator(address _validator, uint256[2] memory _madID) internal returns (uint8) {
        require(
            !validatorPresent[_validator] && validatorCount < validatorMaxCount,
            "Can't add more validators."
        );

        if (!validatorPresent[_validator]) {
            validators.push(_validator);

            validatorIndex[_validator] = validators.length - 1;
            validatorPresent[_validator] = true;
            validatorPublicKey[_validator] = _madID;
            validatorsChanged = true;
            ++validatorCount;
        }

        emit ValidatorJoined(_validator, _madID);

        return validatorCount;
    }

    function removeValidator(address _validator, uint256[2] calldata _madID) external stoppable returns (uint8) {
        require(validatorPresent[_validator], "Validator not present");

        uint256 index = validatorIndex[_validator];
        uint256[2] memory publicKey = validatorPublicKey[_validator];

        require(publicKey[0] == _madID[0], "Validator doesn't match public key");
        require(publicKey[1] == _madID[1], "Validator doesn't match public key");

        delete validatorIndex[_validator];
        delete validatorPresent[_validator];
        delete validatorPublicKey[_validator];

        // Move last address in 'validators' to the spot this validator is relinquishing
        uint256 lastIndex = validators.length - 1;
        address lastAddress = validators[lastIndex];

        validatorIndex[lastAddress] = index;
        validators[index] = validators[lastIndex];
        validators.pop();

        uint256 stake = staking.balanceStakeFor(_validator);
        if (stake>0) {
            staking.unlockStakeFor(_validator, stake); // If insufficient time has passed this will revert txn
            validatorsChanged = true;
        }

        emit ValidatorLeft(_validator, _madID);

        return --validatorCount;
    }

    //
    function queueValidator(address _validator, uint256[2] calldata _madID) external stoppable returns (uint256) {
        queue.enqueue(_validator);

        emit ValidatorQueued(_validator, _madID);

        return validatorCount;
    }

    function getValidatorPublicKey(address _validator) external view returns (uint256[2] memory) {
        require(validatorPresent[_validator], "Validator not present.");
        return validatorPublicKey[_validator];
    }

    function getValidators() external view returns (address[] memory) {
        return validators;
    }

    function setMinimumStake(uint256 _minimumStake) external onlyOperator {
        minimumStake = _minimumStake;
    }

    function setMajorStakeFine(uint256 _majorStakeFine) external onlyOperator {
        majorStakeFine = _majorStakeFine;
    }

    function setMinorStakeFine(uint256 _minorStakeFine) external onlyOperator {
        minorStakeFine = _minorStakeFine;
    }

    function setRewardAmount(uint256 _rewardAmount) external onlyOperator {
        rewardAmount = _rewardAmount;
    }

    function setRewardBonus(uint256 _rewardBonus) external onlyOperator {
        rewardBonus = _rewardBonus;
    }

    function setValidatorMaxCount(uint8 _validatorMaxCount) external onlyOperator {
        validatorMaxCount = _validatorMaxCount;
    }

}