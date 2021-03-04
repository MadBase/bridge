// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.6.4;
pragma experimental ABIEncoderV2;

import "../facets/AccessControlLibrary.sol";
import "../facets/ParticipantsLibrary.sol";
import "../facets/StakingLibrary.sol";
import "../facets/StopLibrary.sol";

import "../Constants.sol";
import "../Registry.sol";
import "../SafeMath.sol";

contract MigrateParticipantsFacet is AccessControlled, Constants, Stoppable {

    using SafeMath for uint256;

    function addValidatorImmediate(
        address _validator,
        uint256[2] calldata _madID
    ) external onlyOperator returns (uint8) {
        ParticipantsLibrary.ParticipantsStorage storage ps = ParticipantsLibrary.participantsStorage();

        // If validator didn't exist before, create them and increment count
        if (!ps.validatorPresent[_validator]) {
            ps.validators.push(_validator);
            ps.validatorCount++;
        }

        ps.validatorIndex[_validator] = ps.validators.length - 1;
        ps.validatorPresent[_validator] = true;
        ps.validatorPublicKey[_validator] = _madID;
        ps.validatorsChanged = true;

        emit ParticipantsLibrary.ValidatorJoined(_validator, _madID);

        return ps.validatorCount;
    }

    function removeValidatorImmediate(
        address _validator,
        uint256[2] calldata _madID
    ) external onlyOperator returns (uint8) {
        ParticipantsLibrary.ParticipantsStorage storage ps = ParticipantsLibrary.participantsStorage();

        if (ps.validatorPresent[_validator]) {
            // Update validator array and indices
            uint256 index = ps.validatorIndex[_validator];
            uint256 lastIndex = ps.validators.length - 1;
            address lastAddress = ps.validators[lastIndex];

            ps.validatorIndex[lastAddress] = index;
            ps.validators[index] = ps.validators[lastIndex];
            ps.validators.pop();

            // Free some space
            delete ps.validatorIndex[_validator];
            delete ps.validatorPresent[_validator];
            delete ps.validatorPublicKey[_validator];

            // Immediately unlock any stake
            StakingLibrary.StakingStorage storage ss = StakingLibrary.stakingStorage();
            uint256 stake = ss.details[_validator].amountStaked;
            if (stake>0) {
                ss.details[_validator].unlockedStake = ss.details[_validator].unlockedStake.add(stake);
                ss.details[_validator].amountStaked = 0;
            }

            // Tell the world
            emit ParticipantsLibrary.ValidatorLeft(_validator, _madID);
            ps.validatorCount--;
        }

        return ps.validatorCount;
    }

}