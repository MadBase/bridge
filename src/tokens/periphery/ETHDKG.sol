// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "../../CryptoLibrary.sol";
import "./ValidatorPool.sol";
import "../utils/AtomicCounter.sol";

contract ETHDKG is Initializable, UUPSUpgradeable {
    event RegistrationOpened(uint256 startBlock, uint256 nonce);

    event AddressRegistered(address account, uint256 index, uint256 nonce, uint256[2] publicKey);

    event SharesDistributed(
        address account,
        uint256 index,
        uint256 nonce,
        uint256[] encryptedShares,
        uint256[2][] commitments
    );

    event KeyShareSubmitted(
        address account,
        uint256 index,
        uint256 nonce,
        uint256[2] keyShareG1,
        uint256[2] keyShareG1CorrectnessProof,
        uint256[4] keyShareG2
    );

    event ValidatorMemberAdded(
        address account,
        uint256 nonce,
        uint256 epoch,
        uint256 index,
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
        uint256[2] initialSignature;
    }

    uint256 internal _nonce;
    uint256 internal _phaseStartBlock;
    Phase internal _phase;
    uint256[4] internal _masterPublicKey;
    // Configurable settings
    uint32 internal _numParticipants;
    uint32 internal _badParticipants;
    uint32 internal _confirmationLength;
    uint32 internal _phaseLength;
    uint32 internal _minValidators;
    ValidatorPool internal _validatorPool;
    bytes internal _initialMessage;

    mapping(address => Participant) internal _participants;

    address[] internal _participantsOrdered;

    function initialize(address validatorPool) public initializer {
        _nonce = 0;
        _phaseStartBlock = 0;
        _initialMessage = abi.encodePacked("Cryptography is great");
        _phaseLength = 40;
        _numParticipants = 0;
        _badParticipants = 0;
        _confirmationLength = 6;
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

    function setPhaseLength(uint32 phaseLength_) external onlyAdmin {
        _phaseLength = phaseLength_;
    }

    function setConfirmationLength(uint32 confirmationLength_) external onlyAdmin {
        _confirmationLength = confirmationLength_;
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

    function initializeETHDKG() external onlyValidatorPool {
        _initializeETHDKG();
    }

    function _setPhase(Phase phase_) internal {
        _phase = phase_;
        // todo: Hunter should we add confirmation blocks? or +1?
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
        require(
            _validatorPool.getValidatorsCount() >= _minValidators,
            "ETHDKG: Minimum number of validators staked not met!"
        );

        _phaseStartBlock = block.number;
        _nonce++;
        _numParticipants = 0;
        _badParticipants = 0;
        _phase = Phase.RegistrationOpen;

        delete _masterPublicKey;

        delete _participantsOrdered;

        emit RegistrationOpened(block.number, _nonce);
    }

    function register(uint256[2] memory publicKey) external onlyValidator {
        require(
            _phase == Phase.RegistrationOpen && block.number <= _phaseStartBlock + _phaseLength,
            "ETHDKG: Cannot register at the moment"
        );
        require(publicKey[0] != 0, "registration failed (public key[0] == 0)");
        require(publicKey[1] != 0, "registration failed (public key[1] == 0)");

        require(
            CryptoLibrary.bn128_is_on_curve(publicKey),
            "registration failed (public key not on elliptic curve)"
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
            phase: _phase,
            distributedSharesHash: 0x0,
            commitmentsFirstCoefficient: [uint256(0), uint256(0)],
            keyShares: [uint256(0), uint256(0)],
            gpkj: [uint256(0), uint256(0), uint256(0), uint256(0)],
            initialSignature: [uint256(0), uint256(0)]
        });

        _participantsOrdered.push(msg.sender);

        emit AddressRegistered(msg.sender, numRegistered, _nonce, publicKey);
        if (
            _moveToNextPhase(
                Phase.ShareDistribution,
                _validatorPool.getValidatorsCount(),
                numRegistered
            )
        ) {
            // todo: emit RegistrationComplete(block.number)
        }
    }

    ///
    function accuseParticipantNotRegistered(address[] memory dishonestAddresses) external {
        require(
            _phase == Phase.RegistrationOpen &&
                ((block.number > _phaseStartBlock + _phaseLength) &&
                    (block.number <= _phaseStartBlock + 2 * _phaseLength)),
            "ETHDKG: should be in post-registration accusation phase!"
        );

        uint32 badParticipants = _badParticipants;

        for (uint256 i = 0; i < dishonestAddresses.length; i++) {
            require(_validatorPool.isValidator(dishonestAddresses[i]), "validator not allowed");

            // check if the issuer didn't participate in the registration phase,
            // so it doesn't have a Participant object with the latest nonce
            Participant memory issuer = _participants[dishonestAddresses[i]];
            require(
                issuer.nonce != _nonce,
                "Dispute failed! Issuer is participating in this ETHDKG round!"
            );

            // todo: minor fine: evict the guy!
            // todo: reward caller for taking this awesome action
            // todo: should we receive an address to send the reward to?
            // es.validators.minorFine(dishonestAddresses[i], msg.sender);
            // we cannot accuse someone twice

            badParticipants++;
        }

        // init ETHDKG if we find all the bad participants
        if (badParticipants + _numParticipants == _validatorPool.getValidatorsCount()) {
            _initializeETHDKG();
        } else {
            _badParticipants = badParticipants;
        }
    }

    function distributeShares(uint256[] memory encryptedShares, uint256[2][] memory commitments)
        external
        onlyValidator
    {
        require(
            _phase == Phase.ShareDistribution && block.number <= _phaseStartBlock + _phaseLength,
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
            "share distribution failed (invalid number of encrypted shares provided)"
        );
        require(
            commitments.length == threshold + 1,
            "key sharing failed (invalid number of commitments provided)"
        );
        for (uint256 k = 0; k <= threshold; k++) {
            require(
                CryptoLibrary.bn128_is_on_curve(commitments[k]),
                "key sharing failed (commitment not on elliptic curve)"
            );
            require(commitments[k][0] != 0, "ETHDKG: Commitments shouldn't be zero");
        }

        participant.distributedSharesHash = keccak256(
            abi.encodePacked(encryptedShares, commitments)
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
            // todo: emit ShareDistributionComplete(block.number)
        }
    }

    ///
    function accuseParticipantDidNotDistributeShares(address[] memory dishonestAddresses) external {
        require(
            _phase == Phase.ShareDistribution &&
                ((block.number > _phaseStartBlock + _phaseLength) &&
                    (block.number <= _phaseStartBlock + 2 * _phaseLength)),
            "ETHDKG: should be in post-ShareDistribution accusation phase!"
        );

        uint32 badParticipants = _badParticipants;

        for (uint256 i = 0; i < dishonestAddresses.length; i++) {
            Participant memory issuer = _participants[dishonestAddresses[i]];
            require(
                issuer.nonce == _nonce,
                "Dispute failed! Issuer is not participating in this ETHDKG round!"
            );

            require(
                issuer.phase != Phase.ShareDistribution,
                "Dispute failed! Issuer is not participating in this ETHDKG round!"
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

            // todo: the actual accusation with fine
            // es.validators.minorFine(issuerAddress);
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
            (_phase == Phase.DisputeShareDistribution &&
                block.number <= _phaseStartBlock + _phaseLength) ||
                (_phase == Phase.ShareDistribution &&
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
                keccak256(abi.encodePacked(encryptedShares, commitments)),
            "dispute failed (invalid replay of sharing transaction)"
        );

        require(
            CryptoLibrary.dleq_verify(
                [CryptoLibrary.G1x, CryptoLibrary.G1y],
                disputer.publicKey,
                issuer.publicKey,
                sharedKey,
                sharedKeyCorrectnessProof
            ),
            "dispute failed (invalid shared key or proof)"
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

        // uint256 decryption_key = uint256(keccak256(abi.encodePacked(sharedKey[0], disputerIdx)))
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
            (_phase == Phase.KeyShareSubmission &&
                block.number <= _phaseStartBlock + _phaseLength) ||
                (_phase == Phase.DisputeShareDistribution &&
                    block.number > _phaseStartBlock + _phaseLength &&
                    _badParticipants == 0),
            "ETHDKG: cannot participate on key share submission phase"
        );

        // Since we had a dispute stage prior this state we need to set global state in here
        if (_phase != Phase.KeyShareSubmission) {
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
            "key share submission failed (invalid key share (G1))"
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
            "key share submission failed (invalid key share (G2))"
        );

        participant.keyShares = keyShareG1;
        participant.phase = Phase.KeyShareSubmission;
        _participants[msg.sender] = participant;

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
            // todo: emit KeyShareSubmissionComplete(block.number)
        }
    }

    function accuseParticipantDidNotSubmitKeyShares(address[] memory dishonestAddresses) external {
        require(
            _phase == Phase.KeyShareSubmission &&
                (block.number > _phaseStartBlock + _phaseLength &&
                    block.number <= _phaseStartBlock + 2 * _phaseLength),
            "ETHDKG: should be in post-KeyShareSubmission phase!"
        );

        uint32 badParticipants = _badParticipants;

        for (uint256 i = 0; i < dishonestAddresses.length; i++) {
            Participant memory issuer = _participants[dishonestAddresses[i]];
            require(
                issuer.nonce == _nonce,
                "Dispute failed! Issuer is not participating in this ETHDKG round!"
            );

            require(
                issuer.phase != Phase.KeyShareSubmission,
                "Dispute failed! Issuer is not participating in this ETHDKG round!"
            );

            require(
                issuer.keyShares[0] == 0 && issuer.keyShares[1] == 0,
                "ETHDKG: it looks like the issuer submitted the key shares"
            );

            // todo: the actual accusation with fine
            // es.validators.minorFine(issuerAddress);
            badParticipants++;
        }

        // init ETHDKG if we find all the bad participants
        if (badParticipants + _numParticipants == _validatorPool.getValidatorsCount()) {
            _initializeETHDKG();
        } else {
            _badParticipants = badParticipants;
        }
    }

    function submitMasterPublicKey(uint256[4] memory masterPublicKey_) external returns (bool) {
        require(
            _phase == Phase.MPKSubmission && block.number <= _phaseStartBlock + _phaseLength,
            "ETHDKG: cannot participate on master public key submission phase"
        );

        uint256[2] memory mpkG1 = _participants[_participantsOrdered[0]].keyShares;
        //todo: can we remove the ordered array? Ask chris
        for (uint256 i = 1; i < _participantsOrdered.length; i++) {
            Participant memory participant = _participants[_participantsOrdered[i]];
            mpkG1 = CryptoLibrary.bn128_add(
                [mpkG1[0], mpkG1[1], participant.keyShares[0], participant.keyShares[1]]
            );
        }
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
            "master key submission failed (pairing check failed)"
        );

        _masterPublicKey = masterPublicKey_;

        _setPhase(Phase.GPKJSubmission);
        //todo: emit an event that MPK was sent
    }

    function submitGPKj(uint256[4] memory gpkj, uint256[2] memory sig) external onlyValidator {
        //todo: should we evict all validators if no one sent the master public key in time?

        require(
            _phase == Phase.GPKJSubmission && block.number <= _phaseStartBlock + _phaseLength,
            "ETHDKG: Not in GPKJ submission phase"
        );

        Participant memory participant = _participants[msg.sender];

        require(
            participant.nonce == _nonce,
            "ETHDKG: Key share submission failed, participant with invalid nonce!"
        );
        require(
            participant.phase == Phase.KeyShareSubmission,
            "Participant already submitted key shares this ETHDKG round"
        );
        require(CryptoLibrary.bn128_is_on_curve(sig), "Invalid signature (not on curve)");
        require(
            CryptoLibrary.Verify(_initialMessage, sig, gpkj),
            "GPKj submission failed (signature verification failed due to invalid gpkj)"
        );

        require(
            gpkj[0] != 0 || gpkj[1] != 0 || gpkj[2] != 0 || gpkj[3] != 0,
            "ETHDKG: GPKj cannot be all zeros!"
        );

        participant.gpkj = gpkj;
        participant.initialSignature = sig;
        participant.phase = Phase.GPKJSubmission;
        _participants[msg.sender] = participant;

        emit ValidatorMemberAdded(
            msg.sender,
            participant.nonce,
            1, //todo: es.validators.epoch(),
            participant.index,
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
            // todo: emit GPKJSubmissionComplete(block.number)
        }
    }

    function accuseParticipantDidNotSubmitGPKJ(address[] memory dishonestAddresses) external {
        require(
            _phase == Phase.GPKJSubmission &&
                (block.number > _phaseStartBlock + _phaseLength &&
                    block.number <= _phaseStartBlock + 2 * _phaseLength),
            "ETHDKG: should be in post-GPKJSubmission phase!"
        );

        uint32 badParticipants = _badParticipants;

        for (uint256 i = 0; i < dishonestAddresses.length; i++) {
            Participant memory issuer = _participants[dishonestAddresses[i]];
            require(
                issuer.nonce == _nonce,
                "Dispute failed! Issuer is not participating in this ETHDKG round!"
            );

            require(
                issuer.phase != Phase.GPKJSubmission,
                "Dispute failed! Issuer is not participating in this ETHDKG round!"
            );

            // todo: being paranoic, check if we need this or if it's expensive
            require(
                issuer.gpkj[0] == 0 &&
                    issuer.gpkj[1] == 0 &&
                    issuer.gpkj[2] == 0 &&
                    issuer.gpkj[3] == 0 &&
                    issuer.initialSignature[0] == 0 &&
                    issuer.initialSignature[1] == 0,
                "ETHDKG: it looks like the issuer distributed its GPKJ"
            );

            // todo: the actual accusation with fine
            // es.validators.minorFine(issuerAddress);
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
        uint256[][] memory encryptedShares,
        uint256[2][][] memory commitments,
        uint256 dishonestListIdx,
        address dishonestAddress
    ) external {
        // We should allow accusation, even if some of the participants didn't participate
        require(
            (_phase == Phase.DisputeGPKJSubmission &&
                block.number <= _phaseStartBlock + _phaseLength) ||
                (_phase == Phase.GPKJSubmission &&
                    (block.number > _phaseStartBlock + _phaseLength) &&
                    (block.number <= _phaseStartBlock + 2 * _phaseLength)),
            "dispute failed (contract is not in GPKJ dispute phase)"
        );

        // n is total _participants;
        // t is threshold, so that t+1 is BFT majority.
        uint256 numParticipants = _validatorPool.getValidatorsCount();
        uint256 threshold = _getThreshold(numParticipants);

        // Begin initial check
        ////////////////////////////////////////////////////////////////////////
        // First, check length of things
        require(
            (encryptedShares.length == numParticipants) && (commitments.length == numParticipants),
            "gpkj acc comp failed: invalid submission of arguments"
        );

        // Now, ensure subarrays are the correct length as well
        for (uint256 k = 0; k < numParticipants; k++) {
            require(
                encryptedShares[k].length == numParticipants - 1,
                "gpkj acc comp failed: invalid number of encrypted shares provided"
            );
            require(
                commitments[k].length == threshold + 1,
                "gpkj acc comp failed: invalid number of commitments provided"
            );
        }

        // // Ensure submissions are valid
        for (uint256 k = 0; k < numParticipants; k++) {
            Participant memory participant = _participants[_participantsOrdered[k]];
            require(
                participant.distributedSharesHash ==
                    keccak256(abi.encodePacked(encryptedShares[k], commitments[k])),
                "gpkj acc comp failed: invalid shares or commitments"
            );
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
    //
    // -- The bool returned indicates whether we should start over immediately.
    function complete() external onlyValidator returns (bool) {
        require(
            (_phase == Phase.DisputeGPKJSubmission &&
                block.number > _phaseStartBlock + _phaseLength &&
                _badParticipants == 0),
            "ETHDKG: cannot participate on key share submission phase"
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

    // baseBlock = msg.block;
    // if !dutchAuction && freeSlotsInValidatorPool{
    //     emit StartDutchAuction();
    // }

    // event StartDutchAuction();
    // uint256 basePrice = 2 ether;
    // uint256 baseBlock;
    // bool dutchAuction;
    // function dutchAuctionPrice() view public returns(uint256){
    //     uint256 price = 100*basePrice/(msg.block - baseBlock);
    //     if snapshotEpoch == 0 {
    //         return 0;
    //     }
    //     return price;
    // }

    // function dutchAuctionBid(uint256 StakeTokenNFT) payable external {
    //     require(msg.value > price);
    //     //become validator
    //     //reset dutch auction
    //     baseBlock = msg.block;
    //     if freeSlotsInValidatorPool {
    //         emit StartDutchAuction();
    //     }
    // }

    // function validatorLeave() payable external {
    //     emit StartDutchAuction();
    // }
}
