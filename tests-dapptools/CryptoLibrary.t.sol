// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;

import "lib/ds-test/test.sol";

import "src/CryptoLibrary.sol";

contract CryptoLibraryTest is DSTest {

    function sliceUint(bytes memory bs, uint start) internal pure returns (uint256) {
        require(bs.length >= start + 32, "slicing out of range");
        uint256 x;
        assembly {
            x := mload(add(bs, add(0x20, start)))
        }
        return x;
    }

    function testSign() public {
        // Sign(bytes memory message, uint256 privK) public view returns (uint256[2] memory sig)
        bytes memory message = bytes(hex"00010203");
        uint256 privateKey = 1234567890;

        uint256[2] memory signed = CryptoLibrary.Sign(message, privateKey);

        assertEq(signed[0], 0x05412e93451903d2c14b2233af494ec57f0e1687e9a96cee66af7c462801cc13);
        assertEq(signed[1], 0x2afe7512ed0054c225d816889060ebdb40a8281c554e637582d7ae6dcbd9c63a);
    }

    function testVerify() public {
        // Verify(bytes memory message, uint256[2] memory sig, uint256[4] memory pubK) public view returns (bool v)
        bytes memory message = bytes(hex"00010203");
        uint256 privateKey = 1234567890;


        uint256[2] memory signed = CryptoLibrary.Sign(message, privateKey);

        uint256[4] memory publicKey = [
            0x10d7b2c2f196fceb52d546ea33816bdcf2fa5dcc79bcbcf0ce34ca1128b0d6d8,
            0x2d8652a0c5193001a55c0c43b5e0450297d3824a039d924b08d46520b354251f,
            0x105a55d55c282005a5813480b48ee1efd61046d06b6084bafcf3c10dac57584b,
            0x0f0bb886f1f1e04bcfa575020e3f47cceb3c11cd5cba496e5aedddc3a04d5b5c
        ];

        bool ok = CryptoLibrary.Verify(message, signed, publicKey);
        assertTrue(ok);
    }

    function testFailVerify() public {
        bytes memory message = bytes(hex"00010203");
        uint256 privateKey = 1234567890;

        uint256[2] memory signed = CryptoLibrary.Sign(message, privateKey);

        uint256[4] memory publicKey = [0xbeef, 0xbee71e5, 0xface, uint256(0xdead)];

        CryptoLibrary.Verify(message, signed, publicKey);
    }

    function testHashToG1() public {
        // HashToG1(bytes memory message) public view returns (uint256[2] memory h)
        bytes memory message = bytes(hex"00010203");

        uint256[2] memory g1 = CryptoLibrary.HashToG1(message);

        assertEq(g1[0], 0x1b319b4cc4d718c6294de4e1704c988ba22489719e908af33db90969875aaa1b);
        assertEq(g1[1], 0x21e3ec9b261e303e0ace5ecc93b9db53b88a7fe0e9d082747965a8a559fe752b);
    }

    function testSafeSigningPoint() public {
        // safeSigningPoint(uint256[2] memory input) public pure returns (bool)
        uint256[2] memory validPoint = [
            0x7e25f1fd566a111f8113b1de7ef5913960ba554b7411f43f8504c54e42c64f3,
            0x23adbb251559f95cde2879920c0487fe39e15610a4d751bdb604dfc483d09b8c
        ];

        bool safe = CryptoLibrary.safeSigningPoint(validPoint);

        assertTrue(safe);
    }

    function testNotSafeSigningPoint() public {
        uint256[2] memory infinity; // elements default to 0, which is exactly what we want

        bool safe = CryptoLibrary.safeSigningPoint(infinity);

        assertTrue(!safe);
    }

    function getSignatures(uint8 quantity) internal pure returns (uint256[2][] memory _signatures) {
        require(quantity <= 3, "Only have 3 signatures to select from.");
        uint256[2][3] memory signatures = [[
            0x25d7670158550eba40e1772e7f2d9f92d03cad73e73cc778429526db35029168,
            0xb291911e727232a8f624454098188eaf4e3ba84320ba955dd90745dcc734226
        ],[
            0x125b69a58f0aa2cef12e519fba1ef655270f20ae6e1b32366e09a6a608eb9ae9,
            0x23fe611455204cbfb68d116571f46e2397a7f2a1372b3d8391cb64a24d6d0c2b
        ],[
            0x2b085543958ee2f704c7c30d9996fc38b144b209a0abdbfc914c8edf3862e41f,
            0xeac493a6a754693c028d07903bce14616cf32c777782899e3d4de2570494020
        ]];

        _signatures = new uint256[2][](quantity);
        for (uint8 idx; idx < quantity; idx++) {
            _signatures[idx] = signatures[idx];
        }
    }

    function getInverses(uint8 quantity) internal pure returns (uint256[] memory _inverses) {
        require(quantity <= 4, "Only have 4 inverses to select from.");
        uint256[4] memory inverses = [
            0x1,
            0x183227397098d014dc2822db40c0ac2e9419f4243cdcb848a1f0fac9f8000001,
            0x2042def740cbc01bd03583cf0100e59370229adafbd0f5b62d414e62a0000001,
            0x244b3ad628e5381f4a3c3448e1210245de26ee365b4b146cf2e9782ef4000001
        ];

        _inverses = new uint256[](quantity);
        for (uint8 idx; idx < quantity; idx++) {
            _inverses[idx] = inverses[idx];
        }
    }

    function testAggregateSignatures() public {
        uint256[2][] memory signatures = getSignatures(3);
        uint256[] memory indices = new uint256[](3);
        indices[0] = 1;
        indices[1] = 2;
        indices[2] = 3;

        uint256 threshold = 2;
        uint256[] memory inverses = getInverses(4);

        uint256[2] memory aggregate = CryptoLibrary.AggregateSignatures(signatures, indices, threshold, inverses);

        assertEq(aggregate[0], 0x29686b4983a0fbe7044a8e0d999ed459bd5b3aba366ebcfca8835940672bfc24);
        assertEq(aggregate[1], 0x201a0bb9362d5765b1885eaf646879ef68c1cd838dd228cc378663ea96e7a03b);
    }

    function testFailAggregateSignaturesLengthMismatch() public {
        uint256[2][] memory signatures = getSignatures(2);
        uint256[] memory indices = new uint256[](4);
        indices[0] = 1;
        indices[1] = 2;
        indices[2] = 3;
        indices[2] = 4;

        uint256 threshold = 2;
        uint256[] memory inverses = getInverses(4);

        CryptoLibrary.AggregateSignatures(signatures, indices, threshold, inverses);
    }

    function testFailAggregateSignaturesThreshold() public {
        uint256[2][] memory signatures = getSignatures(2);
        uint256[] memory indices = new uint256[](2);
        indices[0] = 1;
        indices[1] = 2;

        uint256 threshold = 2;
        uint256[] memory inverses = getInverses(4);

        CryptoLibrary.AggregateSignatures(signatures, indices, threshold, inverses);
    }
}