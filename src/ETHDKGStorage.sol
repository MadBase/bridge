pragma solidity >=0.5.15;

import "./Crypto.sol";
import "./Registry.sol";
import "./Validators.sol";

contract ETHDKGStorage {
    
    ////////////////////////////////////////////////////////////////////////////////////////////////
    //// CRYPTOGRAPHIC CONSTANTS

    ////////
    //// These constants are updated to reflect our version, not theirs.
    ////////

    // GROUP_ORDER is the are the number of group elements in the groups G1, G2, and GT.
    uint256 constant GROUP_ORDER   = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
    // FIELD_MODULUS is the prime number over which the elliptic curves are based.
    uint256 constant FIELD_MODULUS = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
    // curveB is the constant of the elliptic curve for G1:
    //
    //      y^2 == x^3 + curveB,
    //
    // with curveB == 3.
    // uint256 constant curveB        = 3;

    // G1 == (G1x, G1y) is the standard generator for group G1.
    uint256 constant G1x  = 1;
    uint256 constant G1y  = 2;
    // H1 == (H1X, H1Y) = HashToG1([]byte("MadHive Rocks!") from golang code;
    // this is another generator for G1 and dlog_G1(H1) is unknown,
    // which is necessary for security.
    //
    // In the future, the specific value of H1 could be changed every time
    // there is a change in validator set. For right now, though, this will
    // be a fixed constant.
    uint256 constant H1x  =  2788159449993757418373833378244720686978228247930022635519861138679785693683;
    uint256 constant H1y  = 12344898367754966892037554998108864957174899548424978619954608743682688483244;

    // H2 == ([H2xi, H2x], [H2yi, H2y]) is the *negation* of the
    // standard generator of group G2. We let H2Gen denote the standard
    // generator. The standard generator comes from the Ethereum bn256 Go code.
    // The negated form is required because bn128_pairing check in Solidty
    // requires this.
    //
    // In particular, to check
    //
    //      sig = H(msg)^privK
    //
    // is a valid signature for
    //
    //      pubK = H2Gen^privK,
    //
    // we need
    //
    //      e(sig, H2Gen) == e(H(msg), pubK).
    //
    // This is equivalent to
    //
    //      e(sig, H2) * e(H(msg), pubK) == 1.
    uint256 constant H2xi = 11559732032986387107991004021392285783925812861821192530917403151452391805634;
    uint256 constant H2x  = 10857046999023057135944570762232829481370756359578518086990519993285655852781;
    uint256 constant H2yi = 17805874995975841540914202342111839520379459829704422454583296818431106115052;
    uint256 constant H2y  = 13392588948715843804641432497768002650278120570034223513918757245338268106653;

    // two256modP == 2^256 mod FIELD_MODULUS;
    // this is used in hashToBase to obtain a more uniform hash value.
    // uint256 constant two256modP = 6350874878119819312338956282401532409788428879151445726012394534686998597021;

    // pMinus1 == -1 mod FIELD_MODULUS;
    // this is used in sign0 and all ``negative'' values have this sign value.
    // uint256 constant pMinus1 = 21888242871839275222246405745257275088696311157297823662689037894645226208582;

    // pMinus2 == FIELD_MODULUS - 2;
    // this is the exponent used in finite field inversion.
    // uint256 constant pMinus2 = 21888242871839275222246405745257275088696311157297823662689037894645226208581;

    // pMinus1Over2 == (FIELD_MODULUS - 1) / 2;
    // this is the exponent used in computing the Legendre symbol and is
    // also used in sign0 as the cutoff point between ``positive'' and
    // ``negative'' numbers.
    // uint256 constant pMinus1Over2 = 10944121435919637611123202872628637544348155578648911831344518947322613104291;

    // pPlus1Over4 == (FIELD_MODULUS + 1) / 4;
    // this is the exponent used in computing finite field square roots.
    // uint256 constant pPlus1Over4 = 5472060717959818805561601436314318772174077789324455915672259473661306552146;

    // baseToG1 constants
    //
    // These are precomputed constants which are independent of t.
    // All of these constants are computed modulo FIELD_MODULUS.
    //
    // (-1 + sqrt(-3))/2
    // uint256 constant hashConst1 =                    2203960485148121921418603742825762020974279258880205651966;
    // sqrt(-3)
    // uint256 constant hashConst2 =                    4407920970296243842837207485651524041948558517760411303933;
    // 1/3
    // uint256 constant hashConst3 = 14592161914559516814830937163504850059130874104865215775126025263096817472389;
    // 1 + curveB (curveB == 3)
    // uint256 constant hashConst4 =                                                                             4;

    ////////////////////////////////////////////////////////////////////////////////////////////////
    //// EVENTS

    event KeyShareSubmission(
        address issuer,
        uint256[2] key_share_G1,
        uint256[2] key_share_G1_correctness_proof,
        uint256[4] key_share_G2
    );

    event RegistrationOpen(
        uint256 dkgStarts,
        uint256 registrationEnds,
        uint256 shareDistributionEnds,
        uint256 disputeEnds,
        uint256 keyShareSubmissionEnds,
        uint256 mpkSubmissionEnds,
        uint256 gpkjSubmissionEnds,
        uint256 gpkjDisputeEnds,
        uint256 dkgComplete);

    event ShareDistribution(
        address issuer,
        uint256 index,
        uint256[] encrypted_shares,
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



    ////////////////////////////////////////////////////////////////////////////////////////////////
    //// STORAGE

    // list of all registered account addresses
    address[] public addresses;

    // maps storing information required to perform in-contract validition for each registered node
    mapping (address => uint256[2]) public public_keys;
    mapping (address => bytes32) public share_distribution_hashes;
    mapping (address => uint256[2]) public commitments_1st_coefficient;
    mapping (address => uint256[2]) public key_shares;
    mapping (address => uint256[4]) public gpkj_submissions;
    mapping (address => uint256[2]) public initial_signatures;
    mapping (address => uint256) indices;
    mapping (address => bool) public is_malicious;

    // public output of the DKG protocol
    uint256[4] public master_public_key;

    // Added: initial message to be signed
    bytes public initial_message = abi.encodePacked("Cryptography is great");

    // Boolean checks for checking each phase. Each of these checks need to
    // be performed *once* at the first call of the next phase. As an example,
    // share_distribution_check should be called once we are out of the
    // share distribution phase and in the share dispute phase.
    // If not everyone submitted their shares, the entire process must be
    // restarted.
    bool public registration_check;
    bool public share_distribution_check;
    bool public key_share_submission_check;
    bool public mpk_submission_check;
    bool public completion_check;

    ////////////////////////////////////////////////////////////////////////////////////////////////
    //// INITIALIZATION AND TIME_BOUNDS FOR PROTOCOL PHASES

    // block numbers of different points in time during the protcol execution
    // initialized at time of contract deployment
    uint256 public T_REGISTRATION_END;
    uint256 public T_SHARE_DISTRIBUTION_END;
    uint256 public T_DISPUTE_END;
    uint256 public T_KEY_SHARE_SUBMISSION_END;
    uint256 public T_MPK_SUBMISSION_END;
    uint256 public T_GPKJ_SUBMISSION_END;
    uint256 public T_GPKJ_DISPUTE_END;
    uint256 public T_DKG_COMPLETE;

    // number of blocks to ensure that a transaction with proper fees gets included in a block
    // needs to be appropriately set for the production system
    uint256 DELTA_INCLUDE = 40;

    // number of confirmations to wait to ensure that a transaction cannot be reverted
    // needs to be appropriately set for the production system
    uint256 public constant DELTA_CONFIRM = 6;

    // Minimum required validators in order for DKG to continue
    uint256 constant MINIMUM_REGISTRATION = 4;

    address owner;

    Crypto crypto;
    Registry registry;
    Validators validators;
    address validatorsSnapshot;

    address ethdkgCompletion;
    address ethdkgGroupAccusation;
    address ethdkgSubmitMPK;

    // Used in multiple places
    function bn128_check_pairing(uint256[12] memory input) internal view returns (bool) {
        uint256[1] memory result;
        bool success;
        assembly { // solium-disable-line
            // 0x08     id of precompiled bn256Pairing contract     (checking the elliptic curve pairings)
            // 0        number of ether to transfer
            // 384       size of call parameters, i.e. 12*256 bits == 384 bytes
            // 32        size of result (one 32 byte boolean!)
            success := staticcall(not(0), 0x08, input, 384, result, 32)
        }
        require(success, "elliptic curve pairing failed");
        return result[0] == 1;
    }
}