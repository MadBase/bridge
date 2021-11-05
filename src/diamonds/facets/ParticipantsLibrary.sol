// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

import "./StakingLibrary.sol";

import "../../QueueLibrary.sol";

library ParticipantsLibrary {

    bytes32 constant STORAGE_LOCATION = keccak256("participants.storage");

    event ValidatorCreated(address indexed validator, address indexed signer, uint256[2] madID);
    event ValidatorJoined(address indexed validator, uint256[2] madID);
    event ValidatorLeft(address indexed validator, uint256[2] pkHash);
    event ValidatorQueued(address indexed validator, uint256[2] pkHash);

    struct ParticipantsStorage {
        address[] validators;
        mapping(address => uint256) validatorIndex;
        mapping(address => bool) validatorPresent;
        mapping(address => uint256[2]) validatorPublicKey;
        uint8 validatorCount;
        uint8 validatorMaxCount;
        bool validatorsChanged;
        uint256 minimumStake;
        QueueLibrary.Queue queue;
    }

    function participantsStorage() internal pure returns (ParticipantsStorage storage ps) {
        bytes32 position = STORAGE_LOCATION;
        assembly { // solium-disable-line
            ps.slot := position
        }
    }

    function confirmValidators() internal returns (bool) {

        ParticipantsStorage storage ps = participantsStorage();

        // More filthyness. I _know_ there will be few iterations (if any) but this is still shit.
        while(ps.validatorCount < ps.validatorMaxCount && QueueLibrary.size(ps.queue) > 0) { // TODO Design how to be better
            address validator = QueueLibrary.dequeue(ps.queue);
            uint256[2] memory validatorMadID = ps.validatorPublicKey[validator];
            addValidator(validator, validatorMadID); // TODO Check stake and skip if missing?

            // TODO Place hook here to return stake to those we have requested; assuming we've passed the required epoch
        }

        // TODO emit current valid

        return true;
    }

     function isValidator(address validator) internal view returns (bool) {
        ParticipantsStorage storage ps = participantsStorage();

        return ps.validatorPresent[validator] && StakingLibrary.balanceStakeFor(validator) >= StakingLibrary.minimumStake();
    }

    function addOrQueueValidator(address _validator, uint256[2] memory _madID) internal returns (bool) {

        ParticipantsStorage storage ps = participantsStorage();
        StakingLibrary.StakingStorage storage ss = StakingLibrary.stakingStorage();

        require(!ps.validatorPresent[_validator], "validator already present");
        require(StakingLibrary.balanceStakeFor(_validator) >= ss.minimumStake, "insufficient stake");

        if(ps.validatorCount < ps.validatorMaxCount) {
            // Manually adding validator to validator set
            ps.validators.push(_validator);

            ps.validatorIndex[_validator] = ps.validators.length - 1;
            ps.validatorPresent[_validator] = true;
            ps.validatorPublicKey[_validator] = _madID;
            ps.validatorsChanged = true;
            ps.validatorCount++;

            emit ValidatorJoined(_validator, _madID);
        } else {
            QueueLibrary.enqueue(ps.queue, _validator);

            emit ValidatorQueued(_validator, _madID);
        }

        return true;
    }

    function addValidator(address _validator, uint256[2] memory _madID) internal returns (uint8) {

        ParticipantsStorage storage ps = participantsStorage();

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

    function removeValidator(address _validator, uint256[2] memory _madID) internal returns (uint8) {

        ParticipantsStorage storage ps = participantsStorage();
        require(ps.validatorPresent[_validator], "Validator not present");

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

        uint256 stake = StakingLibrary.balanceStakeFor(_validator);

        if (stake>0) {
            StakingLibrary.unlockStakeFor(_validator, stake); // If insufficient time has passed this will revert txn
            ps.validatorsChanged = true;
        }

        emit ValidatorLeft(_validator, _madID);

        return --ps.validatorCount;
    }

    function queueValidator(address _validator, uint256[2] calldata _madID) internal returns (uint256) {
        ParticipantsStorage storage ps = participantsStorage();

        require(msg.sender == _validator, "Only self queue supported");

        QueueLibrary.enqueue(ps.queue, _validator);

        emit ValidatorQueued(_validator, _madID);

        return ps.validatorCount;
    }

    function getValidatorPublicKey(address _validator) internal view returns (uint256[2] memory) {
        ParticipantsStorage storage ps = participantsStorage();

        require(ps.validatorPresent[_validator], "Validator not present.");
        return ps.validatorPublicKey[_validator];
    }

}