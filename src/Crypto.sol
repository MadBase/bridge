// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;


import "./CryptoLibrary.sol";

contract Crypto {

    function dleq_verify(
        uint256[2] memory x1, uint256[2] memory y1,
        uint256[2] memory x2, uint256[2] memory y2,
        uint256[2] memory proof
    )
    external view returns (bool proof_is_valid)
    {
        return CryptoLibrary.dleq_verify(x1, y1, x2, y2, proof);
    }

    function bn128_is_on_curve(uint256[2] memory point)
    external pure returns(bool)
    {
        return CryptoLibrary.bn128_is_on_curve(point);
    }

    function bn128_add(uint256[4] memory input)
    external view returns (uint256[2] memory result) {
        return CryptoLibrary.bn128_add(input);
    }

    function bn128_multiply(uint256[3] memory input)
    external view returns (uint256[2] memory result) {
        return CryptoLibrary.bn128_multiply(input);
    }

    function bn128_check_pairing(uint256[12] memory input)
    external view returns (bool) {
        return CryptoLibrary.bn128_check_pairing(input);
    }

    function expmod(uint256 base, uint256 e, uint256 m)
    external view returns (uint256 result) {
        return CryptoLibrary.expmod(base, e, m);
    }

    function Sign(bytes memory message, uint256 privK)
    external view returns (uint256[2] memory sig) {
        return CryptoLibrary.Sign(message, privK);
    }

    function Verify(bytes memory message, uint256[2] memory sig, uint256[4] memory pubK)
    external view returns (bool v) {
        return CryptoLibrary.Verify(message, sig, pubK);
    }

    function HashToG1(bytes memory message)
    external view returns (uint256[2] memory h) {
        return CryptoLibrary.HashToG1(message);
    }

    function hashToBase(bytes memory message, bytes1 c0, bytes1 c1)
    external pure returns (uint256 t) {
        return CryptoLibrary.hashToBase(message, c0, c1);
    }

    function baseToG1(uint256 t)
    external view returns (uint256[2] memory h) {
        return CryptoLibrary.baseToG1(t);
    }

    function invert(uint256 t)
    external view returns (uint256 s) {
        return CryptoLibrary.invert(t);
    }

    function sqrt(uint256 t)
    external view returns (uint256 s) {
        return CryptoLibrary.sqrt(t);
    }

    function legendre(uint256 t)
    external view returns (int256 chi) {
        return CryptoLibrary.legendre(t);
    }

    function neg(uint256 t)
    external pure returns (uint256 s) {
        return CryptoLibrary.neg(t);
    }

    function sign0(uint256 t)
    external pure returns (uint256 s) {
        return CryptoLibrary.sign0(t);
    }

    function safeSigningPoint(uint256[2] memory input)
    external pure returns (bool) {
        return CryptoLibrary.safeSigningPoint(input);
    }

    function AggregateSignatures(uint256[2][] memory sigs, uint256[] memory indices, uint256 threshold, uint256[] memory invArray)
    external view returns (uint256[2] memory) {
        return CryptoLibrary.AggregateSignatures(sigs, indices, threshold, invArray);
    }

    function computeArrayMax(uint256[] memory uint256Array)
    external pure returns (uint256) {
        return CryptoLibrary.computeArrayMax(uint256Array);
    }

    function checkIndices(uint256[] memory honestIndices, uint256[] memory dishonestIndices, uint256 n)
    external pure returns (bool validIndices) {
        return CryptoLibrary.checkIndices(honestIndices, dishonestIndices, n);
    }

    function checkInverses(uint256[] memory invArray, uint256 maxIndex)
    external pure returns (bool) {
        return CryptoLibrary.checkInverses(invArray, maxIndex);
    }

    function LagrangeInterpolationG1(uint256[2][] memory pointsG1, uint256[] memory indices, uint256 threshold, uint256[] memory invArray)
    external view returns (uint256[2] memory) {
        return CryptoLibrary.LagrangeInterpolationG1(pointsG1, indices, threshold, invArray);
    }

    function liRjPartialConst(uint256 k, uint256 j, uint256[] memory invArray)
    external pure returns (uint256) {
        return CryptoLibrary.liRjPartialConst(k, j, invArray);
    }

}
