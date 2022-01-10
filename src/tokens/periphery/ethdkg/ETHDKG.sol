// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.11;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "../../../CryptoLibrary.sol";
import "../../utils/AtomicCounter.sol";
import "../validatorPool/interfaces/IValidatorPool.sol";
import "./interfaces/IETHDKGEvents.sol";
import "./interfaces/IETHDKG.sol";
import "./ETHDKGStorage.sol";
import "./ETHDKGLibrary.sol";

contract ETHDKG is ETHDKGStorage, Initializable, UUPSUpgradeable, IETHDKG, IETHDKGEvents {
    function initialize(address validatorPool, address ethdkgAccusations) public initializer {
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
        __UUPSUpgradeable_init();
    }

    modifier onlyAdmin() {
        require(msg.sender == _getAdmin(), "ETHDKG: requires admin privileges");
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

    function _authorizeUpgrade(address newImplementation) internal override onlyAdmin {}

    function setPhaseLength(uint16 phaseLength_) external onlyAdmin {
        _phaseLength = phaseLength_;
    }

    function setConfirmationLength(uint16 confirmationLength_) external onlyAdmin {
        _confirmationLength = confirmationLength_;
    }

    function setValidatorPoolAddress(address validatorPool) external onlyAdmin {
        _validatorPool = IValidatorPool(validatorPool);
    }

    function setMinNumberOfValidator(uint16 minValidators_) external onlyAdmin {
        _minValidators = minValidators_;
    }

    function isAccusationWindowOver() public view returns (bool) {
        return block.number > _phaseStartBlock + 2 * _phaseLength;
    }

    function isMasterPublicKeySet() public view returns (bool) {
        return _isMasterPublicKeySet();
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

    function getMasterPublicKey() public view returns (uint256[4] memory) {
        return _masterPublicKey;
    }

    function initializeETHDKG() external onlyValidatorPool {
        _initializeETHDKG();
    }

    function _setPhase(Phase phase_) internal {
        _ethdkgPhase = phase_;
        _phaseStartBlock = uint64(block.number);
        _numParticipants = 0;
    }

    function _moveToNextPhase(
        Phase phase_,
        uint256 numValidators_,
        uint256 numParticipants_
    ) internal returns (bool) {
        // if all validators have registered, we can proceed to the next phase
        if (numParticipants_ == numValidators_) {
            _setPhase(phase_);
            _phaseStartBlock += _confirmationLength;
            return true;
        } else {
            _numParticipants = uint32(numParticipants_);
            return false;
        }
    }

    function _isMasterPublicKeySet() internal view returns (bool) {
        return ((_masterPublicKey[0] != 0) ||
            (_masterPublicKey[1] != 0) ||
            (_masterPublicKey[2] != 0) ||
            (_masterPublicKey[3] != 0));
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

    function _initializeETHDKG() internal {
        //todo: should we reward ppl here?
        require(
            _validatorPool.getValidatorsCount() >= _minValidators,
            "ETHDKG: Minimum number of validators staked not met!"
        );

        _phaseStartBlock = uint64(block.number);
        _nonce++;
        _numParticipants = 0;
        _badParticipants = 0;
        _mpkG1 = [uint256(0), uint256(0)];
        _ethdkgPhase = Phase.RegistrationOpen;

        delete _masterPublicKey;

        emit RegistrationOpened(block.number, _nonce);
    }

    function register(uint256[2] memory publicKey) external onlyValidator {
        require(
            _ethdkgPhase == Phase.RegistrationOpen &&
                block.number > _phaseStartBlock &&
                block.number <= _phaseStartBlock + _phaseLength,
            "ETHDKG: Cannot register at the moment"
        );
        require(
            publicKey[0] != 0 && publicKey[1] != 0,
            "ETHDKG: Registration failed - pubKey should be different from 0!"
        );

        require(
            CryptoLibrary.bn128_is_on_curve(publicKey),
            "ETHDKG: Registration failed - public key not on elliptic curve!"
        );
        require(
            _participants[msg.sender].nonce < _nonce,
            "ETHDKG: Participant is already participating in this ETHDKG round!"
        );
        uint32 numRegistered = uint32(_numParticipants);
        numRegistered++;
        _participants[msg.sender] = Participant({
            publicKey: publicKey,
            index: numRegistered,
            nonce: _nonce,
            phase: _ethdkgPhase,
            distributedSharesHash: 0x0,
            commitmentsFirstCoefficient: [uint256(0), uint256(0)],
            keyShares: [uint256(0), uint256(0)],
            gpkj: [uint256(0), uint256(0), uint256(0), uint256(0)]
        });

        emit AddressRegistered(msg.sender, numRegistered, _nonce, publicKey);
        if (
            _moveToNextPhase(
                Phase.ShareDistribution,
                _validatorPool.getValidatorsCount(),
                numRegistered
            )
        ) {
            emit RegistrationComplete(block.number);
        }
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
        require(
            _ethdkgPhase == Phase.ShareDistribution &&
                block.number > _phaseStartBlock &&
                block.number <= _phaseStartBlock + _phaseLength,
            "ETHDKG: cannot participate on this phase"
        );
        Participant memory participant = _participants[msg.sender];
        require(
            participant.nonce == _nonce,
            "ETHDKG: Share distribution failed, participant with invalid nonce!"
        );
        require(
            participant.phase == Phase.RegistrationOpen,
            "ETHDKG: Participant already distributed shares this ETHDKG round!"
        );

        uint256 numValidators = _validatorPool.getValidatorsCount();
        uint256 threshold = ETHDKGLibrary._getThreshold(numValidators);
        require(
            encryptedShares.length == numValidators - 1,
            "ETHDKG: Share distribution failed - invalid number of encrypted shares provided!"
        );
        require(
            commitments.length == threshold + 1,
            "ETHDKG: Key sharing failed - invalid number of commitments provided!"
        );
        for (uint256 k = 0; k <= threshold; k++) {
            require(
                CryptoLibrary.bn128_is_on_curve(commitments[k]),
                "ETHDKG: Key sharing failed - commitment not on elliptic curve!"
            );
            require(commitments[k][0] != 0, "ETHDKG: Commitments shouldn't be zero!");
        }

        bytes32 encryptedSharesHash = keccak256(abi.encodePacked(encryptedShares));
        bytes32 commitmentsHash = keccak256(abi.encodePacked(commitments));
        participant.distributedSharesHash = keccak256(
            abi.encodePacked(encryptedSharesHash, commitmentsHash)
        );
        require(
            participant.distributedSharesHash != 0x0,
            "ETHDKG: The hash of encryptedShares and commitments should be different from zero!"
        );
        participant.commitmentsFirstCoefficient = commitments[0];
        participant.phase = Phase.ShareDistribution;

        _participants[msg.sender] = participant;
        uint256 numParticipants = _numParticipants + 1;

        emit SharesDistributed(
            msg.sender,
            participant.index,
            participant.nonce,
            encryptedShares,
            commitments
        );

        if (_moveToNextPhase(Phase.DisputeShareDistribution, numValidators, numParticipants)) {
            emit ShareDistributionComplete(block.number);
        }
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
        // Only progress if all participants distributed their shares
        // and no bad participant was found
        require(
            (_ethdkgPhase == Phase.KeyShareSubmission &&
                block.number > _phaseStartBlock &&
                block.number <= _phaseStartBlock + _phaseLength) ||
                (_ethdkgPhase == Phase.DisputeShareDistribution &&
                    block.number > _phaseStartBlock + _phaseLength &&
                    _badParticipants == 0),
            "ETHDKG: cannot participate on key share submission phase"
        );

        // Since we had a dispute stage prior this state we need to set global state in here
        if (_ethdkgPhase != Phase.KeyShareSubmission) {
            _setPhase(Phase.KeyShareSubmission);
        }
        Participant memory participant = _participants[msg.sender];
        require(
            participant.nonce == _nonce,
            "ETHDKG: Key share submission failed, participant with invalid nonce!"
        );
        require(
            participant.phase == Phase.ShareDistribution,
            "ETHDKG: Participant already submitted key shares this ETHDKG round!"
        );

        require(
            CryptoLibrary.dleq_verify(
                [CryptoLibrary.H1x, CryptoLibrary.H1y],
                keyShareG1,
                [CryptoLibrary.G1x, CryptoLibrary.G1y],
                participant.commitmentsFirstCoefficient,
                keyShareG1CorrectnessProof
            ),
            "ETHDKG: Key share submission failed - invalid key share G1!"
        );
        require(
            CryptoLibrary.bn128_check_pairing(
                [
                    keyShareG1[0],
                    keyShareG1[1],
                    CryptoLibrary.H2xi,
                    CryptoLibrary.H2x,
                    CryptoLibrary.H2yi,
                    CryptoLibrary.H2y,
                    CryptoLibrary.H1x,
                    CryptoLibrary.H1y,
                    keyShareG2[0],
                    keyShareG2[1],
                    keyShareG2[2],
                    keyShareG2[3]
                ]
            ),
            "ETHDKG: Key share submission failed - invalid key share G2!"
        );

        participant.keyShares = keyShareG1;
        participant.phase = Phase.KeyShareSubmission;
        _participants[msg.sender] = participant;

        uint256[2] memory mpkG1 = _mpkG1;
        _mpkG1 = CryptoLibrary.bn128_add(
            [mpkG1[0], mpkG1[1], participant.keyShares[0], participant.keyShares[1]]
        );

        uint256 numParticipants = _numParticipants + 1;
        emit KeyShareSubmitted(
            msg.sender,
            participant.index,
            participant.nonce,
            keyShareG1,
            keyShareG1CorrectnessProof,
            keyShareG2
        );

        if (
            _moveToNextPhase(
                Phase.MPKSubmission,
                _validatorPool.getValidatorsCount(),
                numParticipants
            )
        ) {
            emit KeyShareSubmissionComplete(block.number);
        }
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
        //todo: should we reward ppl here?
        require(
            _ethdkgPhase == Phase.MPKSubmission &&
                block.number > _phaseStartBlock &&
                block.number <= _phaseStartBlock + _phaseLength,
            "ETHDKG: cannot participate on master public key submission phase"
        );
        uint256[2] memory mpkG1 = _mpkG1;
        require(
            CryptoLibrary.bn128_check_pairing(
                [
                    mpkG1[0],
                    mpkG1[1],
                    CryptoLibrary.H2xi,
                    CryptoLibrary.H2x,
                    CryptoLibrary.H2yi,
                    CryptoLibrary.H2y,
                    CryptoLibrary.H1x,
                    CryptoLibrary.H1y,
                    masterPublicKey_[0],
                    masterPublicKey_[1],
                    masterPublicKey_[2],
                    masterPublicKey_[3]
                ]
            ),
            "ETHDKG: Master key submission pairing check failed!"
        );

        _masterPublicKey = masterPublicKey_;

        _setPhase(Phase.GPKJSubmission);
        emit MPKSet(block.number, _nonce, masterPublicKey_);
    }

    function submitGPKj(uint256[4] memory gpkj) external onlyValidator {
        //todo: should we evict all validators if no one sent the master public key in time?

        require(
            _ethdkgPhase == Phase.GPKJSubmission &&
                block.number > _phaseStartBlock &&
                block.number <= _phaseStartBlock + _phaseLength,
            "ETHDKG: Not in GPKJ submission phase"
        );

        Participant memory participant = _participants[msg.sender];

        require(
            participant.nonce == _nonce,
            "ETHDKG: Key share submission failed, participant with invalid nonce!"
        );
        require(
            participant.phase == Phase.KeyShareSubmission,
            "ETHDKG: Participant already submitted GPKj this ETHDKG round!"
        );

        require(
            gpkj[0] != 0 || gpkj[1] != 0 || gpkj[2] != 0 || gpkj[3] != 0,
            "ETHDKG: GPKj cannot be all zeros!"
        );

        participant.gpkj = gpkj;
        participant.phase = Phase.GPKJSubmission;
        _participants[msg.sender] = participant;

        emit ValidatorMemberAdded(
            msg.sender,
            participant.index,
            participant.nonce,
            1, //todo: es.validators.epoch(),
            participant.gpkj[0],
            participant.gpkj[1],
            participant.gpkj[2],
            participant.gpkj[3]
        );

        uint256 numParticipants = _numParticipants + 1;
        if (
            _moveToNextPhase(
                Phase.DisputeGPKJSubmission,
                _validatorPool.getValidatorsCount(),
                numParticipants
            )
        ) {
            emit GPKJSubmissionComplete(block.number);
        }
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
        //todo: should we reward ppl here?
        require(
            (_ethdkgPhase == Phase.DisputeGPKJSubmission &&
                block.number > _phaseStartBlock + _phaseLength),
            "ETHDKG: should be in post-GPKJDispute phase!"
        );
        require(
            _badParticipants == 0,
            "ETHDKG: Not all requisites to complete this ETHDKG round were completed!"
        );

        // Since we had a dispute stage prior this state we need to set global state in here
        _setPhase(Phase.Completion);
        //todo:fix this once we have the snapshot logic!!!!!
        uint32 epoch = 1; //uint32(es.validators.epoch()) - 1; // validators is always set to the _next_ epoch
        uint32 ethHeight = 1; //uint32(es.validators.getHeightFromSnapshot(epoch));
        uint32 madHeight = 1; // uint32(es.validators.getMadHeightFromSnapshot(epoch));
        emit ValidatorSetCompleted(
            uint8(_validatorPool.getValidatorsCount()),
            _nonce,
            epoch,
            ethHeight,
            madHeight,
            _masterPublicKey[0],
            _masterPublicKey[1],
            _masterPublicKey[2],
            _masterPublicKey[3]
        );
    }
}
