// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.11;

import "../../../CryptoLibrary.sol";
import "../../utils/AtomicCounter.sol";
import "../validatorPool/interfaces/IValidatorPool.sol";
import "./interfaces/IETHDKGEvents.sol";
import "./interfaces/IETHDKG.sol";
import "./ETHDKGStorage.sol";
import "./utils/ETHDKGUtils.sol";
import "../../../utils/DeterministicAddress.sol";

import "../../../proxy/Proxy.sol";

/// @custom:salt ETHDKG
/// @custom:deploy-type deployUpgradeable
contract ETHDKG is ETHDKGStorage, IETHDKG, IETHDKGEvents, ETHDKGUtils {
    address internal immutable _ethdkgAccusations;
    address internal immutable _ethdkgPhases;

    constructor() ETHDKGStorage() {
        // bytes32("ETHDKGPhases") = 0x455448444b475068617365730000000000000000000000000000000000000000;
        address ethdkgPhases = IProxy(
            getMetamorphicContractAddress(
                0x455448444b475068617365730000000000000000000000000000000000000000,
                _factory
            )
        ).getImplementationAddress();
        assembly {
            if iszero(extcodesize(ethdkgPhases)) {
                mstore(0x00, "ethdkgPhases sze 0")
                revert(0x00, 0x20)
            }
        }
        _ethdkgPhases = ethdkgPhases;
        // bytes32("ETHDKGAccusations") = 0x455448444b4741636375736174696f6e73000000000000000000000000000000;
        address ethdkgAccusations = IProxy(
            getMetamorphicContractAddress(
                0x455448444b4741636375736174696f6e73000000000000000000000000000000,
                _factory
            )
        ).getImplementationAddress();
        assembly {
            if iszero(extcodesize(ethdkgAccusations)) {
                mstore(0x00, "ethdkgAccusation sze 0")
                revert(0x00, 0x20)
            }
        }
        _ethdkgAccusations = ethdkgAccusations;
    }

    function initialize() public initializer {
        _phaseLength = 40;
        _confirmationLength = 6;
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

    function setPhaseLength(uint16 phaseLength_) external onlyFactory {
        require(
            !_isETHDKGRunning(),
            "ETHDKG: This variable cannot be set if an ETHDKG round is running!"
        );
        _phaseLength = phaseLength_;
    }

    function setConfirmationLength(uint16 confirmationLength_) external onlyFactory {
        require(
            !_isETHDKGRunning(),
            "ETHDKG: This variable cannot be set if an ETHDKG round is running!"
        );
        _confirmationLength = confirmationLength_;
    }

    function setCustomMadnetHeight(uint256 madnetHeight) external onlyValidatorPool {
        _customMadnetHeight = madnetHeight;
        emit ValidatorSetCompleted(
            0,
            _nonce,
            _snapshots.getEpoch(),
            _snapshots.getCommittedHeightFromLatestSnapshot(),
            madnetHeight,
            0x0,
            0x0,
            0x0,
            0x0
        );
    }

    function isETHDKGRunning() public view returns (bool) {
        return _isETHDKGRunning();
    }

    function _isETHDKGRunning() internal view returns (bool) {
        // Handling initial case
        if (_phaseStartBlock == 0) {
            return false;
        }
        return !_isETHDKGCompleted() && !_isETHDKGHalted();
    }

    function isETHDKGCompleted() public view returns (bool) {
        return _isETHDKGCompleted();
    }

    function _isETHDKGCompleted() internal view returns (bool) {
        return _ethdkgPhase == Phase.Completion;
    }

    function isETHDKGHalted() public view returns (bool) {
        return _isETHDKGHalted();
    }

    // todo: generate truth table
    function _isETHDKGHalted() internal view returns (bool) {
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

    function getMinValidators() public pure returns (uint256) {
        return MIN_VALIDATOR;
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

    function tryGetParticipantIndex(address participant) public view returns (bool, uint256) {
        Participant memory participantData = _participants[participant];
        if (participantData.nonce == _nonce) {
            return (true, _participants[participant].index);
        }
        return (false, 0);
    }

    function getMasterPublicKey() public view returns (uint256[4] memory) {
        return _masterPublicKey;
    }

    function initializeETHDKG() external onlyValidatorPool {
        _initializeETHDKG();
    }

    function _callAccusationContract(bytes memory callData) internal returns (bytes memory) {
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
            numberValidators >= MIN_VALIDATOR,
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
