// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "../../CryptoLibrary.sol";
import "./ValidatorPool.sol";
import "../utils/AtomicCounter.sol";

contract ETHDKG is Initializable, UUPSUpgradeable {
    event RegistrationOpened(uint256 startBlock, uint256 nonce);

    event AddressRegistered(address account, uint256 index, uint256 nonce, uint256[2] publicKey);

    event RegistrationComplete(uint256 blockNumber);

    event SharesDistributed(
        address account,
        uint256 index,
        uint256 nonce,
        uint256[] encryptedShares,
        uint256[2][] commitments
    );

    event ShareDistributionComplete(uint256 blockNumber);

    event KeyShareSubmitted(
        address account,
        uint256 index,
        uint256 nonce,
        uint256[2] keyShareG1,
        uint256[2] keyShareG1CorrectnessProof,
        uint256[4] keyShareG2
    );

    event KeyShareSubmissionComplete(uint256 blockNumber);

    event MPKSet(uint256 blockNumber, uint256 nonce, uint256[4] mpk);

    event GPKJSubmissionComplete(uint256 blockNumber);

    event ValidatorMemberAdded(
        address account,
        uint256 index,
        uint256 nonce,
        uint256 epoch,
        uint256 share0,
        uint256 share1,
        uint256 share2,
        uint256 share3
    );

    event ValidatorSetCompleted(
        uint256 validatorCount,
        uint256 nonce,
        uint256 epoch,
        uint32 ethHeight,
        uint32 madHeight,
        uint256 groupKey0,
        uint256 groupKey1,
        uint256 groupKey2,
        uint256 groupKey3
    );

    enum Phase {
        RegistrationOpen,
        ShareDistribution,
        DisputeShareDistribution,
        KeyShareSubmission,
        MPKSubmission,
        GPKJSubmission,
        DisputeGPKJSubmission,
        Completion
    }

    // State of key generation
    struct Participant {
        uint256[2] publicKey;
        uint224 nonce;
        uint32 index;
        Phase phase;
        bytes32 distributedSharesHash;
        uint256[2] commitmentsFirstCoefficient;
        uint256[2] keyShares;
        uint256[4] gpkj;
    }

    uint256 internal _nonce;
    uint256 internal _phaseStartBlock;
    Phase internal _ethdkgPhase;
    uint256[4] internal _masterPublicKey;
    uint256[2] internal _mpkG1;
    // Configurable settings
    uint32 internal _numParticipants;
    uint32 internal _badParticipants;
    uint32 internal _minValidators;
    uint16 internal _phaseLength;
    uint16 internal _confirmationLength;
    ValidatorPool internal _validatorPool;

    mapping(address => Participant) internal _participants;

    function initialize(address validatorPool) public initializer {
        _nonce = 0;
        _phaseStartBlock = 0;
        _phaseLength = 40;
        _confirmationLength = 6;
        _numParticipants = 0;
        _badParticipants = 0;
        _minValidators = 4;
        _validatorPool = ValidatorPool(validatorPool);
        __UUPSUpgradeable_init();
    }

    modifier onlyAdmin() {
        require(msg.sender == _getAdmin(), "Validators: requires admin privileges");
        _;
    }

    modifier onlyValidatorPool() {
        require(
            msg.sender == address(_validatorPool),
            "Validators: only validatorPool contract allowed!"
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
        _validatorPool = ValidatorPool(validatorPool);
    }

    function setMinNumberOfValidator(uint32 minValidators_) external onlyAdmin {
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
        _phaseStartBlock = block.number;
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

    function _initializeETHDKG() internal {
        //todo: should we reward ppl here?
        require(
            _validatorPool.getValidatorsCount() >= _minValidators,
            "ETHDKG: Minimum number of validators staked not met!"
        );

        _phaseStartBlock = block.number;
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
        require(publicKey[0] != 0, "registration failed - pubKey0 invalid");
        require(publicKey[1] != 0, "registration failed - pubKey1 invalid");

        require(
            CryptoLibrary.bn128_is_on_curve(publicKey),
            "registration failed - public key not on elliptic curve"
        );
        require(
            _participants[msg.sender].nonce < _nonce,
            "Participant is already participating in this ETHDKG round"
        );
        uint32 numRegistered = uint32(_numParticipants);
        numRegistered++;
        _participants[msg.sender] = Participant({
            publicKey: publicKey,
            index: numRegistered,
            nonce: uint224(_nonce),
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

    ///
    function accuseParticipantNotRegistered(address[] memory dishonestAddresses) external {
        require(
            _ethdkgPhase == Phase.RegistrationOpen &&
                ((block.number > _phaseStartBlock + _phaseLength) &&
                    (block.number <= _phaseStartBlock + 2 * _phaseLength)),
            "ETHDKG: should be in post-registration accusation phase!"
        );

        uint32 badParticipants = _badParticipants;
        for (uint256 i = 0; i < dishonestAddresses.length; i++) {
            require(
                _validatorPool.isValidator(dishonestAddresses[i]),
                "Dishonest Address is not a validator at the moment!"
            );

            // check if the issuer didn't participate in the registration phase,
            // so it doesn't have a Participant object with the latest nonce
            Participant memory issuer = _participants[dishonestAddresses[i]];
            require(
                issuer.nonce != _nonce,
                "Dispute failed! Issuer is participating in this ETHDKG round!"
            );

            // this makes sure we cannot accuse someone twice because a minor fine will be enough to
            // evict the validator from the pool
            _validatorPool.minorSlash(dishonestAddresses[i]);
            badParticipants++;
        }
        _badParticipants = badParticipants;

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
            "Participant already distributed shares this ETHDKG round"
        );

        uint256 numValidators = _validatorPool.getValidatorsCount();
        uint256 threshold = _getThreshold(numValidators);
        require(
            encryptedShares.length == numValidators - 1,
            "share distribution failed, invalid number of encrypted shares provided"
        );
        require(
            commitments.length == threshold + 1,
            "key sharing failed, invalid number of commitments provided"
        );
        for (uint256 k = 0; k <= threshold; k++) {
            require(
                CryptoLibrary.bn128_is_on_curve(commitments[k]),
                "key sharing failed commitment not on elliptic curve"
            );
            require(commitments[k][0] != 0, "ETHDKG: Commitments shouldn't be zero");
        }

        bytes32 encryptedSharesHash = keccak256(abi.encodePacked(encryptedShares));
        bytes32 commitmentsHash = keccak256(abi.encodePacked(commitments));
        participant.distributedSharesHash = keccak256(
            abi.encodePacked(encryptedSharesHash, commitmentsHash)
        );
        require(
            participant.distributedSharesHash != 0x0,
            "ETHDKG: The hash of encryptedShares and commitments should be different from zero"
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
        require(
            _ethdkgPhase == Phase.ShareDistribution &&
                ((block.number > _phaseStartBlock + _phaseLength) &&
                    (block.number <= _phaseStartBlock + 2 * _phaseLength)),
            "ETHDKG: should be in post-ShareDistribution accusation phase!"
        );

        uint32 badParticipants = _badParticipants;

        for (uint256 i = 0; i < dishonestAddresses.length; i++) {
            require(
                _validatorPool.isValidator(dishonestAddresses[i]),
                "Dishonest Address is not a validator at the moment!"
            );
            Participant memory issuer = _participants[dishonestAddresses[i]];
            require(
                issuer.nonce == _nonce,
                "Dispute failed! Issuer is not participating in this ETHDKG round!"
            );

            require(
                issuer.phase != Phase.ShareDistribution,
                "Dispute failed! Issuer distributed its share in this ETHDKG round!"
            );

            require(
                issuer.distributedSharesHash == 0x0,
                "ETHDKG: it looks like the issuer distributed shares"
            );
            require(
                issuer.commitmentsFirstCoefficient[0] == 0 &&
                    issuer.commitmentsFirstCoefficient[1] == 0,
                "ETHDKG: it looks like the issuer had commitments"
            );

            _validatorPool.minorSlash(dishonestAddresses[i]);
            badParticipants++;
        }

        _badParticipants = badParticipants;
    }

    /// Someone sent bad shares
    function accuseParticipantDistributedBadShares(
        address issuerAddress,
        uint256 issuerListIdx,
        uint256 disputerListIdx,
        uint256[] memory encryptedShares,
        uint256[2][] memory commitments,
        uint256[2] memory sharedKey,
        uint256[2] memory sharedKeyCorrectnessProof
    ) external {
        // We should allow accusation, even if some of the participants didn't participate
        require(
            (_ethdkgPhase == Phase.DisputeShareDistribution &&
                block.number > _phaseStartBlock &&
                block.number <= _phaseStartBlock + _phaseLength) ||
                (_ethdkgPhase == Phase.ShareDistribution &&
                    (block.number > _phaseStartBlock + _phaseLength) &&
                    (block.number <= _phaseStartBlock + 2 * _phaseLength)),
            "dispute failed (contract is not in dispute phase)"
        );

        Participant memory issuer = _participants[issuerAddress];
        Participant memory disputer = _participants[msg.sender];

        require(
            disputer.nonce == _nonce,
            "Dispute failed! Disputer is not participating in this ETHDKG round!"
        );
        require(
            issuer.nonce == _nonce,
            "Dispute failed! Issuer is not participating in this ETHDKG round!"
        );

        require(
            issuer.index == issuerListIdx && disputer.index == disputerListIdx,
            "Dispute failed! Invalid list indices for the issuer or for the disputer!"
        );

        require(
            issuer.distributedSharesHash ==
                keccak256(
                    abi.encodePacked(
                        keccak256(abi.encodePacked(encryptedShares)),
                        keccak256(abi.encodePacked(commitments))
                    )
                ),
            "dispute failed, submitted commitments and encrypted shares don't match!"
        );

        require(
            CryptoLibrary.dleq_verify(
                [CryptoLibrary.G1x, CryptoLibrary.G1y],
                disputer.publicKey,
                issuer.publicKey,
                sharedKey,
                sharedKeyCorrectnessProof
            ),
            "dispute failed, invalid shared key or proof"
        );

        // Since all provided data is valid so far, we load the share and use the verified shared
        // key to decrypt the share for the disputer.
        uint256 share;
        uint256 disputerIdx = disputerListIdx + 1;
        if (disputerListIdx < issuerListIdx) {
            share = encryptedShares[disputerListIdx];
        } else {
            share = encryptedShares[disputerListIdx - 1];
        }

        share ^= uint256(keccak256(abi.encodePacked(sharedKey[0], disputerIdx)));

        // Verify the share for it's correctness using the polynomial defined by the commitments.
        // First, the polynomial (in group G1) is evaluated at the disputer's idx.
        uint256 x = disputerIdx;
        uint256[2] memory result = commitments[0];
        uint256[2] memory tmp = CryptoLibrary.bn128_multiply(
            [commitments[1][0], commitments[1][1], x]
        );
        result = CryptoLibrary.bn128_add([result[0], result[1], tmp[0], tmp[1]]);
        for (uint256 j = 2; j < commitments.length; j++) {
            x = mulmod(x, disputerIdx, CryptoLibrary.GROUP_ORDER);
            tmp = CryptoLibrary.bn128_multiply([commitments[j][0], commitments[j][1], x]);
            result = CryptoLibrary.bn128_add([result[0], result[1], tmp[0], tmp[1]]);
        }

        // Then the result is compared to the point in G1 corresponding to the decrypted share.
        // In this case, either the shared value is invalid, so the issuerAddress
        // should be burned; otherwise, the share is valid, and whoever
        // submitted this accusation should be burned. In any case, someone
        // will have his stake burned.
        tmp = CryptoLibrary.bn128_multiply([CryptoLibrary.G1x, CryptoLibrary.G1y, share]);
        if (result[0] != tmp[0] || result[1] != tmp[1]) {
            _validatorPool.majorSlash(issuerAddress);
        } else {
            _validatorPool.majorSlash(msg.sender);
        }
        _badParticipants++;
    }

    function submitKeyShare(
        uint256[2] memory keyShareG1,
        uint256[2] memory keyShareG1CorrectnessProof,
        uint256[4] memory keyShareG2
    ) external onlyValidator {
        // Only progress if all participants distributed their shares and no bad participant was
        // found
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
            "Participant already submitted key shares this ETHDKG round"
        );

        require(
            CryptoLibrary.dleq_verify(
                [CryptoLibrary.H1x, CryptoLibrary.H1y],
                keyShareG1,
                [CryptoLibrary.G1x, CryptoLibrary.G1y],
                participant.commitmentsFirstCoefficient,
                keyShareG1CorrectnessProof
            ),
            "key share submission failed invalid key share G1"
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
            "key share submission failed invalid key share G2"
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
        require(
            _ethdkgPhase == Phase.KeyShareSubmission &&
                (block.number > _phaseStartBlock + _phaseLength &&
                    block.number <= _phaseStartBlock + 2 * _phaseLength),
            "ETHDKG: should be in post-KeyShareSubmission phase!"
        );

        uint32 badParticipants = _badParticipants;

        for (uint256 i = 0; i < dishonestAddresses.length; i++) {
            require(
                _validatorPool.isValidator(dishonestAddresses[i]),
                "Dishonest Address is not a validator at the moment!"
            );

            Participant memory issuer = _participants[dishonestAddresses[i]];
            require(
                issuer.nonce == _nonce,
                "Dispute failed! Issuer is not participating in this ETHDKG round!"
            );

            require(
                issuer.phase != Phase.KeyShareSubmission,
                "Dispute failed! Issuer submitted its key shares in this ETHDKG round!"
            );

            require(
                issuer.keyShares[0] == 0 && issuer.keyShares[1] == 0,
                "ETHDKG: it looks like the issuer submitted the key shares"
            );

            // evict the validator that didn't submit his shares
            _validatorPool.minorSlash(dishonestAddresses[i]);
            badParticipants++;
        }
        _badParticipants = badParticipants;
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
            "master key submission pairing check failed"
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
            "Participant already submitted GPKj this ETHDKG round"
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
        require(
            _ethdkgPhase == Phase.GPKJSubmission &&
                (block.number > _phaseStartBlock + _phaseLength &&
                    block.number <= _phaseStartBlock + 2 * _phaseLength),
            "ETHDKG: should be in post-GPKJSubmission phase!"
        );

        uint32 badParticipants = _badParticipants;

        for (uint256 i = 0; i < dishonestAddresses.length; i++) {
            require(
                _validatorPool.isValidator(dishonestAddresses[i]),
                "Dishonest Address is not a validator at the moment!"
            );
            Participant memory issuer = _participants[dishonestAddresses[i]];
            require(
                issuer.nonce == _nonce,
                "Dispute failed! Issuer is not participating in this ETHDKG round!"
            );

            require(
                issuer.phase != Phase.GPKJSubmission,
                "Dispute failed! Issuer did participate in this GPKj submission!"
            );

            // todo: being paranoic, check if we need this or if it's expensive
            require(
                issuer.gpkj[0] == 0 &&
                    issuer.gpkj[1] == 0 &&
                    issuer.gpkj[2] == 0 &&
                    issuer.gpkj[3] == 0,
                "ETHDKG: it looks like the issuer distributed its GPKJ"
            );

            _validatorPool.minorSlash(dishonestAddresses[i]);
            badParticipants++;
        }

        _badParticipants = badParticipants;
    }

    // Perform Group accusation by computing gpkj*
    //
    // gpkj has already been submitted and stored in gpkj_submissions.
    // To confirm this is valid, we need to compute gpkj*, the corresponding
    // G1 element; we remember gpkj is a public key and an element of G2.
    // Once, we compute gpkj*, we can confirm
    //
    //      e(gpkj*, h2) != e(g1, gpkj)
    //
    // via a pairing check.
    // If we have inequality, then the participant is malicious;
    // if we have equality, then the accusor is malicious.
    function accuseParticipantSubmittedBadGPKj(
        address[] memory validators,
        bytes32[] memory encryptedSharesHash,
        uint256[2][][] memory commitments,
        uint256 dishonestListIdx,
        address dishonestAddress
    ) external {
        // We should allow accusation, even if some of the participants didn't participate
        require(
            (_ethdkgPhase == Phase.DisputeGPKJSubmission &&
                block.number > _phaseStartBlock &&
                block.number <= _phaseStartBlock + _phaseLength) ||
                (_ethdkgPhase == Phase.GPKJSubmission &&
                    (block.number > _phaseStartBlock + _phaseLength) &&
                    (block.number <= _phaseStartBlock + 2 * _phaseLength)),
            "ETHDKG: should be in post-GPKJSubmission phase!"
        );

        // n is total _participants;
        // t is threshold, so that t+1 is BFT majority.
        uint256 numParticipants = _validatorPool.getValidatorsCount();
        uint256 threshold = _getThreshold(numParticipants);

        // Begin initial check
        ////////////////////////////////////////////////////////////////////////
        // First, check length of things
        require(
            (validators.length == numParticipants) &&
                (encryptedSharesHash.length == numParticipants) &&
                (commitments.length == numParticipants),
            "gpkj acc comp failed: invalid submission of arguments"
        );
        {
            uint256 bitMap = 0;
            uint256 nonce = _nonce;
            // Now, ensure subarrays are the correct length as well
            for (uint256 k = 0; k < numParticipants; k++) {
                require(
                    commitments[k].length == threshold + 1,
                    "gpkj acc comp failed: invalid number of commitments provided"
                );
                bytes32 commitmentsHash = keccak256(abi.encodePacked(commitments[k]));
                Participant memory participant = _participants[validators[k]];
                require(
                    participant.nonce == nonce &&
                        participant.index <= type(uint8).max &&
                        !_isBitSet(bitMap, uint8(participant.index)),
                    "Invalid or duplicated participant address!"
                );
                require(
                    participant.distributedSharesHash ==
                        keccak256(abi.encodePacked(encryptedSharesHash[k], commitmentsHash)),
                    "gpkj acc comp failed: invalid shares or commitments"
                );
                bitMap = _setBit(bitMap, uint8(participant.index));
            }
        }
        Participant memory issuer = _participants[dishonestAddress];

        require(
            issuer.nonce == _nonce && issuer.phase == Phase.GPKJSubmission,
            "ETHDKG: Participant didn't submit his GPKJ for this round!"
        );

        // Ensure address submissions are correct; this will be converted to loop later
        require(
            dishonestListIdx == issuer.index,
            "gpkj acc comp failed: dishonest index does not match dishonest address"
        );
        ////////////////////////////////////////////////////////////////////////
        // End initial check

        // At this point, everything has been validated.
        uint256 j = dishonestListIdx + 1;

        // Info for looping computation
        uint256 pow;
        uint256[2] memory gpkjStar;
        uint256[2] memory tmp;
        uint256 idx;

        // Begin computation loop
        //
        // We remember
        //
        //      F_i(x) = C_i0 * C_i1^x * C_i2^(x^2) * ... * C_it^(x^t)
        //             = Prod(C_ik^(x^k), k = 0, 1, ..., t)
        //
        // We now compute gpkj*. We have
        //
        //      gpkj* = Prod(F_i(j), i)
        //            = Prod( Prod(C_ik^(j^k), k = 0, 1, ..., t), i)
        //            = Prod( Prod(C_ik^(j^k), i), k = 0, 1, ..., t)    // Switch order
        //            = Prod( [Prod(C_ik, i)]^(j^k), k = 0, 1, ..., t)  // Move exponentiation outside
        //
        // More explicitly, we have
        //
        //      gpkj* =  Prod(C_i0, i)        *
        //              [Prod(C_i1, i)]^j     *
        //              [Prod(C_i2, i)]^(j^2) *
        //                  ...
        //              [Prod(C_it, i)]^(j^t) *
        //
        ////////////////////////////////////////////////////////////////////////
        // Add constant terms
        gpkjStar = commitments[0][0]; // Store initial constant term
        for (idx = 1; idx < numParticipants; idx++) {
            gpkjStar = CryptoLibrary.bn128_add(
                [gpkjStar[0], gpkjStar[1], commitments[idx][0][0], commitments[idx][0][1]]
            );
        }

        // Add linear term
        tmp = commitments[0][1]; // Store initial linear term
        pow = j;
        for (idx = 1; idx < numParticipants; idx++) {
            tmp = CryptoLibrary.bn128_add(
                [tmp[0], tmp[1], commitments[idx][1][0], commitments[idx][1][1]]
            );
        }
        tmp = CryptoLibrary.bn128_multiply([tmp[0], tmp[1], pow]);
        gpkjStar = CryptoLibrary.bn128_add([gpkjStar[0], gpkjStar[1], tmp[0], tmp[1]]);

        // Loop through higher order terms
        for (uint256 k = 2; k <= threshold; k++) {
            tmp = commitments[0][k]; // Store initial degree k term
            // Increase pow by factor
            pow = mulmod(pow, j, CryptoLibrary.GROUP_ORDER);
            //x = mulmod(x, disputerIdx, GROUP_ORDER);
            for (idx = 1; idx < numParticipants; idx++) {
                tmp = CryptoLibrary.bn128_add(
                    [tmp[0], tmp[1], commitments[idx][k][0], commitments[idx][k][1]]
                );
            }
            tmp = CryptoLibrary.bn128_multiply([tmp[0], tmp[1], pow]);
            gpkjStar = CryptoLibrary.bn128_add([gpkjStar[0], gpkjStar[1], tmp[0], tmp[1]]);
        }
        ////////////////////////////////////////////////////////////////////////
        // End computation loop

        // We now have gpkj*; we now verify.
        uint256[4] memory gpkj = issuer.gpkj;
        bool isValid = CryptoLibrary.bn128_check_pairing(
            [
                gpkjStar[0],
                gpkjStar[1],
                CryptoLibrary.H2xi,
                CryptoLibrary.H2x,
                CryptoLibrary.H2yi,
                CryptoLibrary.H2y,
                CryptoLibrary.G1x,
                CryptoLibrary.G1y,
                gpkj[0],
                gpkj[1],
                gpkj[2],
                gpkj[3]
            ]
        );
        if (!isValid) {
            _validatorPool.majorSlash(dishonestAddress);
        } else {
            _validatorPool.majorSlash(msg.sender);
        }
        _badParticipants++;
    }

    // Successful_Completion should be called at the completion of the DKG algorithm.
    function complete() external onlyValidator {
        //todo: should we reward ppl here?
        require(
            (_ethdkgPhase == Phase.DisputeGPKJSubmission &&
                block.number > _phaseStartBlock + _phaseLength &&
                _badParticipants == 0),
            "ETHDKG: cannot complete yet"
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

    function _getThreshold(uint256 numParticipants_) internal pure returns (uint256 threshold) {
        // In our BFT consensus alg, we require t + 1 > 2*n/3.
        // Where t = threshold, n = numParticipants and k = quotient from the integer division
        // There are 3 possibilities for n:
        //
        //  n == 3*k:
        //      We set
        //                          t = 2*k
        //      This implies
        //                      2*k     == t     <= 2*n/3 == 2*k
        //      and
        //                      2*k + 1 == t + 1  > 2*n/3 == 2*k
        //
        //  n == 3*k + 1:
        //      We set
        //                          t = 2*k
        //      This implies
        //                      2*k     == t     <= 2*n/3 == 2*k + 1/3
        //      and
        //                      2*k + 1 == t + 1  > 2*n/3 == 2*k + 1/3
        //
        //  n == 3*k + 2:
        //      We set
        //                          t = 2*k + 1
        //      This implies
        //                      2*k + 1 == t     <= 2*n/3 == 2*k + 4/3
        //      and
        //                      2*k + 2 == t + 1  > 2*n/3 == 2*k + 4/3
        uint256 quotient = numParticipants_ / 3;
        threshold = 2 * quotient;
        uint256 remainder = numParticipants_ - 3 * quotient;
        if (remainder == 2) {
            threshold = threshold + 1;
        }
    }

    function _isBitSet(uint256 self, uint8 index) internal pure returns (bool) {
        uint256 val;
        // solhint-disable no-inline-assembly
        assembly {
            val := and(shr(index, self), 1)
        }
        return (val == 1);
    }

    function _setBit(uint256 self, uint8 index) internal pure returns (uint256) {
        // solhint-disable no-inline-assembly
        assembly {
            self := or(shl(index, 1), self)
        }
        return (self);
    }
}
