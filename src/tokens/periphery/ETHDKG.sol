// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "../../CryptoLibrary.sol";
import "./ValidatorPool.sol";
import "../utils/AtomicCounter.sol";


contract ETHDKG is Initializable, UUPSUpgradeable {

    event RegistrationOpen(
        uint256 dkgStarts,
        uint256 registrationEnds,
        uint256 shareDistributionEnds,
        uint256 disputeEnds,
        uint256 keyShareSubmissionEnds,
        uint256 mpkSubmissionEnds,
        uint256 gpkjSubmissionEnds,
        uint256 gpkjDisputeEnds,
        uint256 dkgComplete
    );

    event AddressRegistered(
        address issuerAddress,
        uint256 index,
        uint256 nonce,
        uint256[2] publicKey
    );

    event KeyShareSubmission(
        address issuerAddress,
        uint256[2] keyShareG1,
        uint256[2] keyShareG1CorrectnessProof,
        uint256[4] keyShareG2
    );

    event ShareDistribution(
        address issuerAddress,
        uint256 index,
        uint256[] encryptedShares,
        uint256[2][] commitments
    );

    event ValidatorSet(
        uint8 validatorCount,
        uint256 epoch,
        uint32 ethHeight,
        uint32 madHeight,
        uint256 groupKey0, uint256 groupKey1, uint256 groupKey2, uint256 groupKey3
    );

    event ValidatorMember(
        address account,
        uint256 epoch,
        uint256 index,
        uint256 share0, uint256 share1, uint256 share2, uint256 share3
    );

    event InvalidETHDKGRound(uint256 round, uint256 phase, uint256 numCulprits);

    enum Phase {
        RegistrationOpen,
        RegistrationError,
        ShareDistribution,
        ShareDistributionError,
        KeyShareSubmission,
        KeyShareSubmissionError,
        MPKSubmission,
        MPKSubmissionError,
        GPKJSubmission,
        GPKJSubmissionError,
        Completed
    }

    // State of key generation
    struct Participant {
        uint256[2] publicKey;
        uint224 nonce;
        uint32 index;
        Phase phase;
        bytes32 shareDistributionHashes;
        uint256[2] commitmentsFirstCoefficient;
        uint256[2] keyShares;
        uint256[4] gpkjSubmissions;
        uint256[2] initialSignatures;
    }

    //todo: get rid of this
    struct Schedule {
        uint32 registrationEnds;
        uint32 shareDistributionEnds;
        uint32 disputeEnds;
        uint32 keyShareSubmissionEnds;
        uint32 mpkSubmissionEnds;
        uint32 gpkjSubmissionEnds;
        uint32 gpkjDisputeEnds;
        uint32 dkgCompletionEnds;
    }

    struct Counter {
        uint32 numRegistered;
        uint32 numShareDistributed;
        uint32 numKeyShared;
        uint32 numGPKJShared;
    }

    uint256 internal _nonce;
    Schedule internal _schedule;
    Phase internal _phase;
    uint256[4] internal _masterPublicKey;
    // Configurable settings
    Counter internal _counter;
    uint32 internal _confirmationLength;
    uint32 internal _phaseLength;
    uint32 internal _minValidators;
    bytes internal _initialMessage;

    ValidatorPool internal _validatorPool;

    mapping(address => Participant) internal _participants;

    function initialize(address validatorPool) public initializer {
        _nonce = 0;
        _schedule = Schedule(0,0,0,0,0,0,0,0);
        _initialMessage = abi.encodePacked("Cryptography is great");
        _phaseLength = 40;
        _confirmationLength = 6;
        _minValidators = 4;
        _validatorPool = ValidatorPool(validatorPool);
        __UUPSUpgradeable_init();
    }

    modifier onlyAdmin() {
        require(msg.sender == _getAdmin(), "Validators: requires admin privileges");
        _;
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyAdmin {

    }

    function updatePhaseLength(uint32 phaseLength) external onlyAdmin {
        _phaseLength = phaseLength;
    }

    // todo: Put a modifier here? Who can call this?
    function initializeState() internal {

        require(
            _validatorPool.getValidatorsCount() > _minValidators,
            "ETHDKG: Minimum number of validators staked not met!"
        );

        uint32 totalLength = _confirmationLength + _phaseLength;
        Schedule memory schedule = _schedule;

        schedule.registrationEnds = uint32(block.number) + _phaseLength;
        schedule.shareDistributionEnds = schedule.registrationEnds + totalLength;
        schedule.disputeEnds = schedule.shareDistributionEnds + totalLength;
        schedule.keyShareSubmissionEnds = schedule.disputeEnds + totalLength;
        schedule.mpkSubmissionEnds = schedule.keyShareSubmissionEnds + totalLength;
        schedule.gpkjSubmissionEnds = schedule.mpkSubmissionEnds + totalLength;
        schedule.gpkjDisputeEnds = schedule.gpkjSubmissionEnds + totalLength;
        schedule.dkgCompletionEnds = schedule.gpkjDisputeEnds + totalLength;


        _nonce++;
        _schedule = schedule;
        _counter = Counter(0,0,0,0);
        _phase = Phase.RegistrationOpen;

        delete _masterPublicKey;

        emit RegistrationOpen(
            block.number, schedule.registrationEnds, schedule.shareDistributionEnds, schedule.disputeEnds,
            schedule.keyShareSubmissionEnds, schedule.mpkSubmissionEnds, schedule.gpkjSubmissionEnds,
            schedule.gpkjDisputeEnds, schedule.dkgCompletionEnds
        );
    }

    modifier onlyValidator() {
        require(_validatorPool.isValidator(msg.sender), "ETHDKG: Only validators allowed!");
        _;
    }

    //todo: pre-registration phase? Where are we going to run the dutch auction

    // modifier here if is a Validator?
    function register(uint256[2] memory publicKey) external onlyValidator {
        require(publicKey[0] != 0, "registration failed (public key[0] == 0)");
        require(publicKey[1] != 0, "registration failed (public key[1] == 0)");

        require(
            block.number <= _schedule.registrationEnds,
            "registration failed (contract is not in registration phase)"
        );
        require(
            CryptoLibrary.bn128_is_on_curve(publicKey),
            "registration failed (public key not on elliptic curve)"
        );
        require(
            _participants[msg.sender].nonce < _nonce,
            "Participant is already participating in this ETHDKG round"
        );
        uint32 numRegistered = _counter.numRegistered;
        numRegistered++;
        _counter.numRegistered = numRegistered;
        _participants[msg.sender] = Participant({
            publicKey: publicKey,
            index: numRegistered,
            nonce: uint224(_nonce),
            phase: _phase,
            shareDistributionHashes: 0x0,
            commitmentsFirstCoefficient: [uint256(0), uint256(0)],
            keyShares: [uint256(0), uint256(0)],
            gpkjSubmissions: [uint256(0),uint256(0),uint256(0),uint256(0)],
            initialSignatures: [uint256(0),uint256(0)]
        });
        emit AddressRegistered(msg.sender, numRegistered, _nonce, publicKey);
    }

    function distribute_shares(uint256[] memory encryptedShares, uint256[2][] memory commitments) external onlyValidator {
        require(
            (_schedule.registrationEnds < block.number) && (block.number <= _schedule.shareDistributionEnds),
            "ETHDKG: Share distribution failed, contract is not in share distribution phase!"
        );
        Participant memory participant = _participants[msg.sender];
        require(
            participant.nonce == _nonce,
            "ETHDKG: Share distribution failed, participant with invalid nonce!"
        );
        // participant should be coming from the registration phase
        require(
            participant.phase == Phase.RegistrationOpen,
            "ETHDKG: incorrect phase or already distributed shares!"
        );
        uint256 numParticipants = uint256(_counter.numRegistered);
        uint256 validatorCount = _validatorPool.getValidatorsCount();
        if (numParticipants != validatorCount) {
            // Failed to meet minimum registration requirements; must restart
            // todo: should we open a window to accuse ppl that didn't register in the ETHDKG?
            if ( _phase != Phase.ShareDistribution) {
                _phase = Phase.ShareDistributionError;
                emit InvalidETHDKGRound(_nonce, uint256(_phase), validatorCount - numParticipants);
                //todo: keep this initialize here???
                //todo: maybe initialize things in future?
                // initializeState();
            }
            return;
        }
        // Check current state; will only be run on first call
        if ( _phase != Phase.ShareDistribution) {
            _phase = Phase.ShareDistribution;
        }
        uint256 threshold = _getThreshold(numParticipants);
        require(
            encryptedShares.length == numParticipants - 1,
            "share distribution failed (invalid number of encrypted shares provided)"
        );
        require(
            commitments.length == threshold + 1,
            "key sharing failed (invalid number of commitments provided)"
        );
        for (uint k = 0; k <= threshold; k++) {
            require(
                CryptoLibrary.bn128_is_on_curve(commitments[k]),
                "key sharing failed (commitment not on elliptic curve)"
            );
        }

        participant.shareDistributionHashes = keccak256(abi.encodePacked(encryptedShares, commitments));
        participant.commitmentsFirstCoefficient = commitments[0];
        participant.phase = Phase.ShareDistribution;

        _participants[msg.sender] = participant;

        emit ShareDistribution(msg.sender, participant.index, encryptedShares, commitments);
    }

    ///
    function submitParticipantNotRegistered(address[] calldata issuerAddresses) external {
        require(
            (_schedule.registrationEnds < block.number) && (block.number <= _schedule.shareDistributionEnds),
            "ETHDKG: Share distribution failed, contract is not in share distribution phase!"
        );
        require(
            _phase == Phase.RegistrationError,
            "ETHDKG: should be in post-registration accusation phase!"
        );

        for (uint i=0 ; i<issuerAddresses.length ; i++) {
            require(
                _validatorPool.isValidator(issuerAddresses[i]),
                "validator not allowed"
            );
            Participant memory issuer = _participants[issuerAddresses[i]];
            require(
                issuer.nonce != _nonce, "Dispute failed! Issuer is participating in this ETHDKG round!"
            );

            // todo: ask Hunter if People will be allowed to stake more than the minimum amount of tokens to become validators!
            // todo: minor fine: evict the guy!
            // todo: in case the person is valid, the person sending the accusation should be punished?
            // es.validators.minorFine(issuerAddress);
        }       
        // todo: should we only allow ppl participating on ETHDKG to accuse ? no.
        // Participant memory disputer = _participants[msg.sender];

        // require(
        //     disputer.nonce == _nonce, "Dispute failed! Disputer is not participating in this ETHDKG round!"
        // );

        // the issuer didn't participate in the register, so it doesn't have a Participant object with the latest nonce
        // Participant memory issuer = _participants[issuerAddress];
        // require(
        //     issuer.nonce != _nonce, "Dispute failed! Issuer is participating in this ETHDKG round!"
        // );

        // todo: ask Hunter if People will be allowed to stake more than the minimum amount of tokens to become validators!
        // todo: minor fine: evict the guy!
        // todo: in case the person is valid, the person sending the accusation should be punished?
        // es.validators.minorFine(issuerAddress);
        //_phase = Phase.ShareDistribution;
    }

    ///
    function submitParticipantDidNotDistributeShares(address issuerAddress) external {
        require(
            (_schedule.shareDistributionEnds < block.number) && (block.number <= _schedule.disputeEnds),
            "dispute failed (contract is not in dispute phase)"
        );

        Participant memory issuer = _participants[issuerAddress];
        require(
            issuer.nonce == _nonce, "Dispute failed! Issuer is not participating in this ETHDKG round!"
        );

        require(issuer.shareDistributionHashes == 0x0, "ETHDKG: it looks like the issuer distributed shares");
        require(issuer.commitmentsFirstCoefficient[0] == 0 && issuer.commitmentsFirstCoefficient[1] == 0, "ETHDKG: it looks like the issuer had commitments");

        // todo: the actual accusation with fine
        // es.validators.minorFine(issuerAddress);
    }

    /// Someone sent bad shares
    function submit_dispute(
        address issuerAddress,
        uint256 issuerListIdx,
        uint256 disputerListIdx,
        uint256[] memory encryptedShares,
        uint256[2][] memory commitments,
        uint256[2] memory sharedKey,
        uint256[2] memory sharedKeyCorrectnessProof
    )
    public
    {
        require(
            (_schedule.shareDistributionEnds < block.number) && (block.number <= _schedule.disputeEnds),
            "dispute failed (contract is not in dispute phase)"
        );

        Participant memory issuer = _participants[issuerAddress];
        Participant memory disputer = _participants[msg.sender];

        require(
            disputer.nonce == _nonce, "Dispute failed! Disputer is not participating in this ETHDKG round!"
        );
        require(
            issuer.nonce == _nonce, "Dispute failed! Issuer is not participating in this ETHDKG round!"
        );

        require(
            issuer.index == issuerListIdx &&
            disputer.index == disputerListIdx,
            "Dispute failed! Invalid list indices for the issuer or for the disputer!"
        );

        // // Check if another node already submitted a dispute against the same issuerAddress.
        // // In this case the issuerAddress is already disqualified and no further actions are required here.
        // if (issuer.isMalicious) {
        //     return;
        // }

        require(
            issuer.shareDistributionHashes == keccak256(abi.encodePacked(encryptedShares, commitments)),
            "dispute failed (invalid replay of sharing transaction)"
        );

        require(
            CryptoLibrary.dleq_verify(
                [CryptoLibrary.G1x, CryptoLibrary.G1y], disputer.publicKey, issuer.publicKey, sharedKey, sharedKeyCorrectnessProof
            ),
            "dispute failed (invalid shared key or proof)"
        );

        // Since all provided data is valid so far, we load the share and use the verified shared
        // key to decrypt the share for the disputer.
        // todo: ask Chris!
        uint256 share;
        uint256 disputerIdx = disputerListIdx + 1;
        if (disputerListIdx < issuerListIdx) {
            share = encryptedShares[disputerListIdx];
        }
        else {
            share = encryptedShares[disputerListIdx - 1];
        }

        // uint256 decryption_key = uint256(keccak256(abi.encodePacked(sharedKey[0], disputerIdx)))
        share ^= uint256(keccak256(abi.encodePacked(sharedKey[0], disputerIdx)));

        // Verify the share for it's correctness using the polynomial defined by the commitments.
        // First, the polynomial (in group G1) is evaluated at the disputer's idx.
        uint256 x = disputerIdx;
        uint256[2] memory result = commitments[0];
        uint256[2] memory tmp = CryptoLibrary.bn128_multiply([commitments[1][0], commitments[1][1], x]);
        result = CryptoLibrary.bn128_add([result[0], result[1], tmp[0], tmp[1]]);
        for (uint256 j = 2; j < commitments.length; j += 1) {
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
    }

    function submit_key_share(
        address issuerAddress,
        uint256[2] memory keyShareG1,
        uint256[2] memory keyShareG1CorrectnessProof,
        uint256[4] memory keyShareG2
    )
    external
    {
        require(
            (_schedule.disputeEnds < block.number) && (block.number <= _schedule.keyShareSubmissionEnds),
            "key share submission failed (contract is not in key derivation phase)"
        );

        // Check current state; will only be run on first call
        if (_phase != Phase.KeyShareSubmission) {
            // todo: check with Hunter if this is enough, or if this contract should track non-active validators and fine them
            if (_counter.numShareDistributed != _validatorPool.getValidatorsCount()) {
                // Restart process; If by now the number of Validators
                // is not the same as the nodes that are participating in this ETHDKG round.
                initializeState();
                return;
            }
            else {
                // Everything is valid and we do not need to perform this check again
                _phase = Phase.KeyShareSubmission;
            }
        }

        Participant memory issuer = _participants[issuerAddress];
        if (issuer.keyShares[0] != 0) {
            return;
        }

        // With the above check, this can be removed;
        // everyone has nonzero hashes
        require(
            issuer.shareDistributionHashes != 0,
            "key share submission failed (issuerAddress not qualified)"
        );
        require(
            CryptoLibrary.dleq_verify(
                [CryptoLibrary.H1x, CryptoLibrary.H1y],
                keyShareG1,
                [CryptoLibrary.G1x, CryptoLibrary.G1y],
                issuer.commitmentsFirstCoefficient,
                keyShareG1CorrectnessProof
            ),
            "key share submission failed (invalid key share (G1))"
        );
        require(
            CryptoLibrary.bn128_check_pairing([
                keyShareG1[0], keyShareG1[1],
                CryptoLibrary.H2xi, CryptoLibrary.H2x, CryptoLibrary.H2yi, CryptoLibrary.H2y,
                CryptoLibrary.H1x, CryptoLibrary.H1y,
                keyShareG2[0], keyShareG2[1], keyShareG2[2], keyShareG2[3]
            ]),
            "key share submission failed (invalid key share (G2))"
        );

        issuer.keyShares = keyShareG1;
        _participants[issuerAddress] = issuer;
        emit KeyShareSubmission(issuerAddress, keyShareG1, keyShareG1CorrectnessProof, keyShareG2);
    }

    function submit_master_public_key(
        uint256[4] memory _master_public_key
    )
    public returns (bool)
    {
        require(
            (_schedule.keyShareSubmissionEnds < block.number) && (block.number <= _schedule.mpkSubmissionEnds),
            "master key submission failed (contract is not in mpk derivation phase)"
        );

        // Check current state; will only be run on first call
        if (_phase != Phase.KeyShareSubmission) {
            // for (uint256 idx; idx<es.addresses.length; idx++) {
            //     address vaddr = es.addresses[idx];
            //     if (es.key_shares[vaddr][0] == 0) {
            //         // Someone did not submit shares;
            //         // should receive a minor fine.
            //         isValid = false;
            //         es.validators.minorFine(vaddr);
            //     }
            // }
            // if (!isValid) {
            //     // Restart process; fines should be handled above
            //     return true; // initializeState();
            // }
            // else {
                // Everything is valid and we do not need to perform this check again
                _phase = Phase.KeyShareSubmission;
            // }
        }

        if ((_masterPublicKey[0] != 0) || (_masterPublicKey[1] != 0) ||
            (_masterPublicKey[2] != 0) || (_masterPublicKey[3] != 0)) {
            return false;
        }

        uint256 n = _counter.numKeyShared;

        // find first (i.e. lowest index) node contributing to the final key
        uint256 i = 0;
        address addr;

        // do {
        //     addr = es.addresses[i];
        //     i += 1;
        // } while(i < n && es.share_distribution_hashes[addr] == 0);

        // uint256[2] memory tmp = es.key_shares[addr];
        // require(tmp[0] != 0, "master key submission failed (key share missing)");
        // uint256[2] memory mpk_G1 = es.key_shares[addr];

        // for (; i < n; i += 1) {
        //     addr = es.addresses[i];
        //     if (es.share_distribution_hashes[addr] == 0) {
        //         continue;
        //     }
        //     tmp = es.key_shares[addr];
        //     require(tmp[0] != 0, "master key submission failed (key share missing)");
        //     mpk_G1 = CryptoLibrary.bn128_add([mpk_G1[0], mpk_G1[1], tmp[0], tmp[1]]);
        // }
        // require(
        //     CryptoLibrary.bn128_check_pairing([
        //         mpk_G1[0], mpk_G1[1],
        //         CryptoLibrary.H2xi, CryptoLibrary.H2x, CryptoLibrary.H2yi, CryptoLibrary.H2y,
        //         CryptoLibrary.H1x, CryptoLibrary.H1y,
        //         _master_public_key[0], _master_public_key[1],
        //         _master_public_key[2], _master_public_key[3]
        //     ]),
        //     "master key submission failed (pairing check failed)"
        // );

        // es._masterPublicKey = _master_public_key;

        return false;
    }

    function Submit_GPKj(
        uint256[4] memory gpkj,
        uint256[2] memory sig
    )
    external
    {
        require(
            (_schedule.mpkSubmissionEnds < block.number) && (block.number <= _schedule.gpkjSubmissionEnds),
            "gpkj key submission failed (contract is not in gpkj derivation phase)"
        );

        // Check current state; will only be run on first call
        if (_phase != Phase.GPKJSubmission) {
            // if (es._masterPublicKey[0] == 0 && es._masterPublicKey[1] == 0 &&
            //         es._masterPublicKey[2] == 0 && es._masterPublicKey[3] == 0) {
            //     // No one submitted mpk;
            //     // fine everyone;
            //     // restart process
            //     EthDKGLibrary.initializeState();
            //     return;
            // }
            // else {
                // Everything is valid and we do not need to perform this check again
                _phase = Phase.GPKJSubmission;
            // }
        }
        Participant memory participant = _participants[msg.sender];
        require(
            participant.gpkjSubmissions[0] == 0 &&
            participant.gpkjSubmissions[1] == 0 &&
            participant.gpkjSubmissions[2] == 0 &&
            participant.gpkjSubmissions[3] == 0,
            "GPKj submission failed (already submitted gpkj)"
        );
        require(
            CryptoLibrary.bn128_is_on_curve(sig),
            "Invalid signature (not on curve)"
        );
        require(
            CryptoLibrary.Verify(_initialMessage, sig, gpkj),
            "GPKj submission failed (signature verification failed due to invalid gpkj)"
        );
        participant.gpkjSubmissions = gpkj;
        participant.initialSignatures = sig;
        _participants[msg.sender] = participant;
    }

    function Group_Accusation_GPKj(
        uint256[] memory invArray,
        uint256[] memory honestIndices,
        uint256[] memory dishonestIndices
    )
    public
    {
        require(
            (_schedule.gpkjSubmissionEnds < block.number) && (block.number <= _schedule.gpkjDisputeEnds),
            "gpkj accusation failed (contract is not in gpkj accusation phase)"
        );

        uint256 numParticipants = _counter.numKeyShared;
        uint256 k = numParticipants / 3;
        uint256 threshold = 2*k;
        if (2 == (numParticipants - 3*k)) {
            threshold = threshold + 1;
        }
        // All indices are the *correct* indices; we subtract 1 to get the approprtiate stuff.
        require(
            honestIndices.length >= (threshold+1),
            "Incorrect number of honest validators; exit"
        );
        require(
            CryptoLibrary.checkIndices(honestIndices, dishonestIndices, numParticipants),
            "honestIndices and dishonestIndices do not contain unique indices"
        );

        // Failure here should not result in loss of stake.
        uint256[2][] memory sigs;
        sigs = new uint256[2][](threshold+1);
        uint256[] memory indices;
        indices = new uint256[](threshold+1);
        uint256 cur_idx;
        address cur_addr;

        require(
            CryptoLibrary.checkInverses(invArray, numParticipants),
            "invArray does not include correct inverses"
        );
        // Failure here should not result in loss of stake

        // Construct signature array for honest _participants; use first t+1
        // for (k = 0; k < (threshold+1); k++) {
        //     cur_idx = honestIndices[k];
        //     cur_addr = es.addresses[cur_idx-1];
        //     sigs[k] = es.initial_signatures[cur_addr];
        //     indices[k] = cur_idx;
        // }
        uint256[2] memory grpsig = CryptoLibrary.AggregateSignatures(sigs, indices, threshold, invArray);
        require(
            CryptoLibrary.Verify(_initialMessage, grpsig, _masterPublicKey),
            "honestIndices failed to produce valid group signature"
        );
        // Failure above will not result in loss of stake.
        // At this point, you have not accused anyone of malicious behavior.
        // Asinine behavior does not necessitate stake burning.

        // for (k = 0; k < dishonestIndices.length; k++) {
        //     cur_idx = dishonestIndices[k];
        //     cur_addr = es.addresses[cur_idx-1];
        //     indices[threshold] = cur_idx;
        //     sigs[threshold] = es.initial_signatures[cur_addr];
        //     grpsig = CryptoLibrary.AggregateSignatures(sigs, indices, threshold, invArray);
        //     // Either the group signature is invalid, implying the person
        //     // is dishonest, or the signature is valid, implying whoever
        //     // submitted the accusation is dishonest. Either way, someone
        //     // is getting burned.
        //     if (!CryptoLibrary.Verify(es._initialMessage, grpsig, es._masterPublicKey)) {
        //         delete es.gpkj_submissions[cur_addr];
        //         es.is_malicious[cur_addr] = true;
        //     } else {
        //         delete es.gpkj_submissions[msg.sender];
        //         es.is_malicious[msg.sender] = true;
        //     }
        // }
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
    function Group_Accusation_GPKj_Comp(
        uint256[][] memory encryptedShares,
        uint256[2][][] memory commitments,
        uint256 dishonest_list_idx,
        address dishonestAddress
    )
    public
    {
        require(
            (_schedule.gpkjSubmissionEnds < block.number) && (block.number <= _schedule.gpkjDisputeEnds),
            "gpkj acc comp failed: contract is not in gpkj accusation phase"
        );

        // n is total _participants;
        // t is threshold, so that t+1 is BFT majority.
        uint256 n = _counter.numKeyShared;
        uint256 k = n / 3;
        uint256 t = 2*k;
        if (2 == (n - 3*k)) {
            t = t + 1;
        }

        // Begin initial check
        ////////////////////////////////////////////////////////////////////////
        // First, check length of things
        require(
            (encryptedShares.length == n) && (commitments.length == n),
            "gpkj acc comp failed: invalid submission of arguments"
        );

        // Now, ensure subarrays are the correct length as well
        for (k = 0; k < n; k++) {
            require(
                encryptedShares[k].length == n - 1,
                "gpkj acc comp failed: invalid number of encrypted shares provided"
            );
            require(
                commitments[k].length == t + 1,
                "gpkj acc comp failed: invalid number of commitments provided"
            );
        }

        // // Ensure submissions are valid
        // for (k = 0; k < n; k++) {
        //     address currentAddr = es.addresses[k];
        //     require(
        //         es.share_distribution_hashes[currentAddr] == keccak256(
        //             abi.encodePacked(encryptedShares[k], commitments[k])
        //         ),
        //         "gpkj acc comp failed: invalid shares or commitments"
        //     );
        // }

        Participant memory issuer = _participants[dishonestAddress];
        // Confirm nontrivial submission
        if ((issuer.gpkjSubmissions[0] == 0) &&
                (issuer.gpkjSubmissions[1] == 0) &&
                (issuer.gpkjSubmissions[2] == 0) &&
                (issuer.gpkjSubmissions[3] == 0)) {
            return;
        }
        //todo: check with Chris
        // ^^^ TODO: this check will need to be changed once we allow for multiple accusations per loop

        // Ensure address submissions are correct; this will be converted to loop later
        require(
            dishonest_list_idx == issuer.index,
            "gpkj acc comp failed: dishonest index does not match dishonest address"
        );
        ////////////////////////////////////////////////////////////////////////
        // End initial check

        // At this point, everything has been validated.
        uint256 j = dishonest_list_idx + 1;

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
        // More explicityly, we have
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
        for (idx = 1; idx < n; idx++) {
            gpkjStar = CryptoLibrary.bn128_add([gpkjStar[0], gpkjStar[1], commitments[idx][0][0], commitments[idx][0][1]]);
        }

        // Add linear term
        tmp = commitments[0][1]; // Store initial linear term
        pow = j;
        for (idx = 1; idx < n; idx++) {
            tmp = CryptoLibrary.bn128_add([tmp[0], tmp[1], commitments[idx][1][0], commitments[idx][1][1]]);
        }
        tmp = CryptoLibrary.bn128_multiply([tmp[0], tmp[1], pow]);
        gpkjStar = CryptoLibrary.bn128_add([gpkjStar[0], gpkjStar[1], tmp[0], tmp[1]]);

        // Loop through higher order terms
        for (k = 2; k <= t; k++) {
            tmp = commitments[0][k]; // Store initial degree k term
            // Increase pow by factor
            pow = mulmod(pow, j, CryptoLibrary.GROUP_ORDER);
            //x = mulmod(x, disputerIdx, GROUP_ORDER);
            for (idx = 1; idx < n; idx++) {
                tmp = CryptoLibrary.bn128_add([tmp[0], tmp[1], commitments[idx][k][0], commitments[idx][k][1]]);
            }
            tmp = CryptoLibrary.bn128_multiply([tmp[0], tmp[1], pow]);
            gpkjStar = CryptoLibrary.bn128_add([gpkjStar[0], gpkjStar[1], tmp[0], tmp[1]]);
        }
        ////////////////////////////////////////////////////////////////////////
        // End computation loop

        // We now have gpkj*; we now verify.
        uint256[4] memory gpkj = issuer.gpkjSubmissions;
        bool isValid = CryptoLibrary.bn128_check_pairing([
            gpkjStar[0], gpkjStar[1],
            CryptoLibrary.H2xi, CryptoLibrary.H2x, CryptoLibrary.H2yi, CryptoLibrary.H2y,
            CryptoLibrary.G1x, CryptoLibrary.G1y,
            gpkj[0], gpkj[1], gpkj[2], gpkj[3]
        ]);
        // if (isValid) {
        //     // Valid gpkj submission; burn whomever submitted accusation
        //     delete es.gpkj_submissions[msg.sender];
        //     es.is_malicious[msg.sender] = true;
        // }
        // else {
        //     // Invalid gpkj submission; burn participant
        //     delete es.gpkj_submissions[dishonestAddress];
        //     es.is_malicious[dishonestAddress] = true;
        // }
    }

    // Successful_Completion should be called at the completion of the DKG algorithm.
    //
    // -- The bool returned indicates whether we should start over immediately.
    function Successful_Completion() public returns (bool) {

        require(
            (_schedule.gpkjDisputeEnds < block.number) && (block.number <= _schedule.dkgCompletionEnds),
            "successful completion is only after window for accusations has closed"
        );

        bool reinitialize = false; // Just being explicit

        // Check current state; will only be run on first call
        if (_phase != Phase.Completed) {
            bool isValid = true;
            // for (uint256 idx; idx<es.addresses.length; idx++) {
            //     address addr = es.addresses[idx];
            //     if (es.gpkj_submissions[addr][0] == 0 && es.gpkj_submissions[addr][1] == 0 &&
            //             es.gpkj_submissions[addr][2] == 0 && es.gpkj_submissions[addr][3] == 0) {
            //         if (es.is_malicious[addr]) {
            //             // Someone was malicious and had gpkj deleted;
            //             // should receive a major fine.
            //             es.validators.majorFine(addr);
            //         }
            //         else {
            //             // Someone did not submit gpkj;
            //             // should receive a minor fine.
            //             es.validators.minorFine(addr);
            //         }
            //         isValid = false;
            //     }
            // }

            if (!isValid) {
                // Restart process; fines should be handled above
                reinitialize = true; // initializeState();
            } else {
                // Everything is valid and we do not need to perform this check again
                _phase = Phase.Completed;

                //todo:fix this!!!!!
                uint32 epoch = 1; //uint32(es.validators.epoch()) - 1; // validators is always set to the _next_ epoch
                uint32 ethHeight = 1; //uint32(es.validators.getHeightFromSnapshot(epoch));
                uint32 madHeight = 1;// uint32(es.validators.getMadHeightFromSnapshot(epoch));

                emit ValidatorSet(
                    uint8(_validatorPool.getValidatorsCount()),
                    1,//es.validators.epoch(),
                    ethHeight,
                    madHeight,
                    _masterPublicKey[0],
                    _masterPublicKey[1],
                    _masterPublicKey[2],
                    _masterPublicKey[3]
                );

                for (uint256 idx; idx<_validatorPool.getValidatorsCount(); idx++) {
                    address addr = _validatorPool.validators(idx);
                    Participant memory participant = _participants[addr];
                    emit ValidatorMember(
                        addr,
                        1,//es.validators.epoch(),
                        idx+1,
                        participant.gpkjSubmissions[0],
                        participant.gpkjSubmissions[1],
                        participant.gpkjSubmissions[2],
                        participant.gpkjSubmissions[3]
                    );
                }
            }
        }

        if (reinitialize) {
		    initializeState();
	    }
    }

    function _getThreshold(uint256 numParticipants_) internal pure returns(uint256 threshold){
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
        threshold = 2*quotient;
        uint256 remainder = numParticipants_ - 3*quotient;
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