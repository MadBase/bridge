// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;

contract EthDKGConstants {

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
}