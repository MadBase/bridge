// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.11;

import "../../../CryptoLibrary.sol";
import "../../utils/AtomicCounter.sol";
import "../validatorPool/interfaces/IValidatorPool.sol";
import "./interfaces/IETHDKGEvents.sol";
import "./interfaces/IETHDKG.sol";
import "./ETHDKGStorage.sol";
import "./utils/ETHDKGUtils.sol";

contract ETHDKG is ETHDKGStorage, IETHDKG, IETHDKGEvents, ETHDKGUtils {
    constructor(
        address validatorPool,
        address ethdkgAccusations,
        address ethdkgPhases,
        bytes memory hook
    ) {
        _nonce = 0;
        _phaseStartBlock = 0;
        _phaseLength = 40;
        _confirmationLength = 6;
        _numParticipants = 0;
        _badParticipants = 0;
        _minValidators = 4;
        // todo: use contract factory with create2
        _validatorPool = IValidatorPool(validatorPool);
        // todo: use contract factory with create2
        _ethdkgAccusations = ethdkgAccusations;
        // todo: use contract factory with create2
        _ethdkgPhases = ethdkgPhases;
        _admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == _admin, "ETHDKG: requires admin privileges");
        _;
    }

    modifier onlyValidatorPool() {
        require(
            msg.sender == address(_validatorPool),
            "ETHDKG: Only validatorPool contract allowed!"
        );
        _;
    }

    modifier onlyValidator() {
        require(_validatorPool.isValidator(msg.sender), "ETHDKG: Only validators allowed!");
        _;
    }

    /// @dev getAdmin returns the current _admin
    function getAdmin() public view returns (address) {
        return _admin;
    }

    /// @dev assigns a new admin may only be called by _admin
    function setAdmin(address admin_) public onlyAdmin {
        _admin = admin_;
    }

    function setPhaseLength(uint16 phaseLength_) external onlyAdmin {
        //todo: doesnt allow to change while an ethdkg round is going on
        _phaseLength = phaseLength_;
    }

    function setConfirmationLength(uint16 confirmationLength_) external onlyAdmin {
        //todo: doesnt allow to change while an ethdkg round is going on
        _confirmationLength = confirmationLength_;
    }

    function setValidatorPoolAddress(address validatorPool) external onlyAdmin {
        _validatorPool = IValidatorPool(validatorPool);
    }

    function setMinNumberOfValidator(uint16 minValidators_) external onlyAdmin {
        _minValidators = minValidators_;
    }

    function isETHDKGRunning() public view returns (bool) {
        // Handling initial case
        if (_phaseStartBlock == 0) {
            return false;
        }
        return !_isETHDKGCompleted() && !_isETHDKGHalted();
    }

    function isETHDKGCompleted() public view returns(bool) {
        return _isETHDKGCompleted();
    }

    function _isETHDKGCompleted() internal view returns(bool) {
        return _ethdkgPhase == Phase.Completion;
    }

    function isETHDKGHalted() public view returns(bool) {
        return _isETHDKGHalted();
    }

    function _isETHDKGHalted() internal view returns(bool) {
        bool ethdkgFailedInDisputePhase = (_ethdkgPhase == Phase.DisputeShareDistribution ||
            _ethdkgPhase == Phase.DisputeGPKJSubmission) &&
            block.number >= _phaseStartBlock + _phaseLength &&
            _badParticipants != 0;
        bool ethdkgFailedInNormalPhase = block.number >= _phaseStartBlock + 2 * _phaseLength;
        return ethdkgFailedInNormalPhase || ethdkgFailedInDisputePhase;
    }

    function isMasterPublicKeySet() public view returns (bool) {
        return ((_masterPublicKey[0] != 0) ||
            (_masterPublicKey[1] != 0) ||
            (_masterPublicKey[2] != 0) ||
            (_masterPublicKey[3] != 0));
    }

    function getNonce() public view returns (uint256) {
        return _nonce;
    }

    function getPhaseStartBlock() public view returns (uint256) {
        return _phaseStartBlock;
    }

    function getPhaseLength() public view returns (uint256) {
        return _phaseLength;
    }

    function getConfirmationLength() public view returns (uint256) {
        return _confirmationLength;
    }

    function getETHDKGPhase() public view returns (Phase) {
        return _ethdkgPhase;
    }

    function getNumParticipants() public view returns (uint256) {
        return _numParticipants;
    }

    function getBadParticipants() public view returns (uint256) {
        return _badParticipants;
    }

    function getMinValidators() public view returns (uint256) {
        return _minValidators;
    }

    function getParticipantInternalState(address participant)
        public
        view
        returns (Participant memory)
    {
        return _participants[participant];
    }

    function getParticipantsInternalState(address[] calldata participantAddresses)
        public
        view
        returns (Participant[] memory)
    {
        Participant[] memory participants = new Participant[](participantAddresses.length);

        for (uint256 i = 0; i < participantAddresses.length; i++) {
            participants[i] = _participants[participantAddresses[i]];
        }

        return participants;
    }

    function getMasterPublicKey() public view returns (uint256[4] memory) {
        return _masterPublicKey;
    }

    function initializeETHDKG() external onlyValidatorPool {
        _initializeETHDKG();
    }

    function _callAccusationContract(bytes memory callData) internal returns (bytes memory) {
        // todo: change logic to use create2 address
        (bool success, bytes memory returnData) = _ethdkgAccusations.delegatecall(callData);
        if (!success) {
            // solhint-disable no-inline-assembly
            assembly {
                let ptr := mload(0x40)
                let size := returndatasize()
                returndatacopy(ptr, 0, size)
                revert(ptr, size)
            }
        }
        return returnData;
    }

    function _callPhaseContract(bytes memory callData) internal returns (bytes memory) {
        // todo: change logic to use create2 address
        (bool success, bytes memory returnData) = _ethdkgPhases.delegatecall(callData);
        if (!success) {
            // solhint-disable no-inline-assembly
            assembly {
                let ptr := mload(0x40)
                let size := returndatasize()
                returndatacopy(ptr, 0, size)
                revert(ptr, size)
            }
        }
        return returnData;
    }

    function _initializeETHDKG() internal {
        //todo: should we reward ppl here?
        uint256 numberValidators = _validatorPool.getValidatorsCount();
        require(
            numberValidators >= _minValidators,
            "ETHDKG: Minimum number of validators staked not met!"
        );

        _phaseStartBlock = uint64(block.number);
        _nonce++;
        _numParticipants = 0;
        _badParticipants = 0;
        _mpkG1 = [uint256(0), uint256(0)];
        _ethdkgPhase = Phase.RegistrationOpen;

        delete _masterPublicKey;

        emit RegistrationOpened(
            block.number,
            numberValidators,
            _nonce,
            _phaseLength,
            _confirmationLength
        );
    }

    function register(uint256[2] memory publicKey) external onlyValidator {
        _callPhaseContract(abi.encodeWithSignature("register(uint256[2])", publicKey));
    }

    function accuseParticipantNotRegistered(address[] memory dishonestAddresses) external {
        _callAccusationContract(
            abi.encodeWithSignature("accuseParticipantNotRegistered(address[])", dishonestAddresses)
        );
    }

    function distributeShares(uint256[] memory encryptedShares, uint256[2][] memory commitments)
        external
        onlyValidator
    {
        _callPhaseContract(
            abi.encodeWithSignature(
                "distributeShares(uint256[],uint256[2][])",
                encryptedShares,
                commitments
            )
        );
    }

    ///
    function accuseParticipantDidNotDistributeShares(address[] memory dishonestAddresses) external {
        _callAccusationContract(
            abi.encodeWithSignature(
                "accuseParticipantDidNotDistributeShares(address[])",
                dishonestAddresses
            )
        );
    }

    // Someone sent bad shares
    function accuseParticipantDistributedBadShares(
        address dishonestAddress,
        uint256[] memory encryptedShares,
        uint256[2][] memory commitments,
        uint256[2] memory sharedKey,
        uint256[2] memory sharedKeyCorrectnessProof
    ) external onlyValidator {
        _callAccusationContract(
            abi.encodeWithSignature(
                "accuseParticipantDistributedBadShares(address,uint256[],uint256[2][],uint256[2],uint256[2])",
                dishonestAddress,
                encryptedShares,
                commitments,
                sharedKey,
                sharedKeyCorrectnessProof
            )
        );
    }

    function submitKeyShare(
        uint256[2] memory keyShareG1,
        uint256[2] memory keyShareG1CorrectnessProof,
        uint256[4] memory keyShareG2
    ) external onlyValidator {
        _callPhaseContract(
            abi.encodeWithSignature(
                "submitKeyShare(uint256[2],uint256[2],uint256[4])",
                keyShareG1,
                keyShareG1CorrectnessProof,
                keyShareG2
            )
        );
    }

    function accuseParticipantDidNotSubmitKeyShares(address[] memory dishonestAddresses) external {
        _callAccusationContract(
            abi.encodeWithSignature(
                "accuseParticipantDidNotSubmitKeyShares(address[])",
                dishonestAddresses
            )
        );
    }

    function submitMasterPublicKey(uint256[4] memory masterPublicKey_) external {
        _callPhaseContract(
            abi.encodeWithSignature("submitMasterPublicKey(uint256[4])", masterPublicKey_)
        );
    }

    function submitGPKJ(uint256[4] memory gpkj) external onlyValidator {
        _callPhaseContract(abi.encodeWithSignature("submitGPKJ(uint256[4])", gpkj));
    }

    function accuseParticipantDidNotSubmitGPKJ(address[] memory dishonestAddresses) external {
        _callAccusationContract(
            abi.encodeWithSignature(
                "accuseParticipantDidNotSubmitGPKJ(address[])",
                dishonestAddresses
            )
        );
    }

    function accuseParticipantSubmittedBadGPKJ(
        address[] memory validators,
        bytes32[] memory encryptedSharesHash,
        uint256[2][][] memory commitments,
        address dishonestAddress
    ) external onlyValidator {
        _callAccusationContract(
            abi.encodeWithSignature(
                "accuseParticipantSubmittedBadGPKJ(address[],bytes32[],uint256[2][][],address)",
                validators,
                encryptedSharesHash,
                commitments,
                dishonestAddress
            )
        );
    }

    // Successful_Completion should be called at the completion of the DKG algorithm.
    function complete() external onlyValidator {
        _callPhaseContract(abi.encodeWithSignature("complete()"));
    }
}
