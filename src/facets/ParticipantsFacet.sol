// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.6.4;
pragma experimental ABIEncoderV2;

import "./AccessControlLibrary.sol";
import "./ParticipantsStorageLibrary.sol";
import "./StakingValuesLibrary.sol";

import "../Constants.sol";
import "../QueueLibrary.sol";
import "../Registry.sol";
import "../Staking.sol";

contract ParticipantsFacet is AccessControlled, Constants {

    event ValidatorCreated(address indexed validator, address indexed signer, uint256[2] madID);
    event ValidatorJoined(address indexed validator, uint256[2] madID);
    event ValidatorLeft(address indexed validator, uint256[2] pkHash);
    event ValidatorQueued(address indexed validator, uint256[2] pkHash);

    using QueueLibrary for QueueLibrary.Queue;

    function initializeParticipants(Registry registry) external onlyOwner {
        require(address(registry) != address(0), "nil registry address");

        address stakingAddress = registry.lookup(STAKING_CONTRACT);
        require(stakingAddress != address(0), "nil staking address");

        ParticipantsStorageLibrary.ParticipantsStorage storage ps = ParticipantsStorageLibrary.participantsStorage();
        ps.stakingAddress = stakingAddress;
    }

    function confirmValidators() external returns (bool) {

        ParticipantsStorageLibrary.ParticipantsStorage storage ps = ParticipantsStorageLibrary.participantsStorage();

        // More filthyness. I _know_ there will be few iterations (if any) but this is still shit.
        while(ps.validatorCount < ps.validatorMaxCount && ps.queue.size() > 0) { // TODO Design how to be better
            address validator = ps.queue.dequeue();
            uint256[2] memory validatorMadID = ps.validatorPublicKey[validator];
            _addValidator(validator, validatorMadID);

            // TODO Place hook here to return stake to those we have requested; assuming we've passed the required epoch
        }

        // TODO emit current valid

        return true;
    }

     function isValidator(address validator) public view returns (bool) {

        ParticipantsStorageLibrary.ParticipantsStorage storage ps = ParticipantsStorageLibrary.participantsStorage();
        StakingValuesLibrary.StakingValuesStorage storage sv = StakingValuesLibrary.stakingValuesStorage();

        require(ps.stakingAddress != address(0), "nil staking address");
        Staking staking = Staking(ps.stakingAddress);

        return ps.validatorPresent[validator] && staking.balanceStakeFor(validator) >= sv.minimumStake;
    }

    function addValidator(address _validator, uint256[2] calldata _madID) external returns (uint8) {
        require(msg.sender == _validator, "Only self adding supported");
        return _addValidator(_validator, _madID);
    }

    function _addValidator(address _validator, uint256[2] memory _madID) internal returns (uint8) {

        ParticipantsStorageLibrary.ParticipantsStorage storage ps = ParticipantsStorageLibrary.participantsStorage();

        require(
            !ps.validatorPresent[_validator] && ps.validatorCount < ps.validatorMaxCount,
            "Can't add more validators."
        );

        ps.validators.push(_validator);

        ps.validatorIndex[_validator] = ps.validators.length - 1;
        ps.validatorPresent[_validator] = true;
        ps.validatorPublicKey[_validator] = _madID;
        ps.validatorsChanged = true;
        ps.validatorCount++;

        emit ValidatorJoined(_validator, _madID);

        return ps.validatorCount;
    }

    function validatorCount() external returns (uint8) {
        ParticipantsStorageLibrary.ParticipantsStorage storage ps = ParticipantsStorageLibrary.participantsStorage();

        return ps.validatorCount;
    }

    function validatorMaxCount() external returns (uint8) {
        ParticipantsStorageLibrary.ParticipantsStorage storage ps = ParticipantsStorageLibrary.participantsStorage();

        return ps.validatorMaxCount;
    }

    function setValidatorMaxCount(uint8 max) external onlyOwner {
        ParticipantsStorageLibrary.ParticipantsStorage storage ps = ParticipantsStorageLibrary.participantsStorage();

        ps.validatorMaxCount = max;
    }

    function removeValidator(address _validator, uint256[2] calldata _madID) external returns (uint8) {

        ParticipantsStorageLibrary.ParticipantsStorage storage ps = ParticipantsStorageLibrary.participantsStorage();
        require(ps.validatorPresent[_validator], "Validator not present");
        require(msg.sender == _validator, "Only self removal supported");

        uint256 index = ps.validatorIndex[_validator];
        uint256[2] memory publicKey = ps.validatorPublicKey[_validator];

        require(publicKey[0] == _madID[0], "Validator doesn't match public key");
        require(publicKey[1] == _madID[1], "Validator doesn't match public key");

        delete ps.validatorIndex[_validator];
        delete ps.validatorPresent[_validator];
        delete ps.validatorPublicKey[_validator];

        // Move last address in 'validators' to the spot this validator is relinquishing
        uint256 lastIndex = ps.validators.length - 1;
        address lastAddress = ps.validators[lastIndex];

        ps.validatorIndex[lastAddress] = index;
        ps.validators[index] = ps.validators[lastIndex];
        ps.validators.pop();

        require(ps.stakingAddress != address(0), "nil staking address");
        Staking staking = Staking(ps.stakingAddress);

        uint256 stake = staking.balanceStakeFor(_validator);
        if (stake>0) {
            staking.unlockStakeFor(_validator, stake); // If insufficient time has passed this will revert txn
            ps.validatorsChanged = true;
        }

        emit ValidatorLeft(_validator, _madID);

        return --ps.validatorCount;
    }

    //
    function queueValidator(address _validator, uint256[2] calldata _madID) external returns (uint256) {
        ParticipantsStorageLibrary.ParticipantsStorage storage ps = ParticipantsStorageLibrary.participantsStorage();

        require(msg.sender == _validator, "Only self queue supported");

        ps.queue.enqueue(_validator);

        emit ValidatorQueued(_validator, _madID);

        return ps.validatorCount;
    }

    function getValidatorPublicKey(address _validator) external view returns (uint256[2] memory) {
        ParticipantsStorageLibrary.ParticipantsStorage storage ps = ParticipantsStorageLibrary.participantsStorage();

        require(ps.validatorPresent[_validator], "Validator not present.");
        return ps.validatorPublicKey[_validator];
    }

    function getValidators() external view returns (address[] memory) {
        ParticipantsStorageLibrary.ParticipantsStorage storage ps = ParticipantsStorageLibrary.participantsStorage();

        return ps.validators;
    }
}