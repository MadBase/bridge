pragma solidity >=0.5.15;

contract MerkleProof {

    // Check if the bit at the given 'index' in 'self' is set.
    // Returns:
    //  'true' - if the value of the bit is '1'
    //  'false' - if the value of the bit is '0'
    function bitSet(uint self, uint8 index) public pure returns (bool) {
        return self >> (255 - index) & 1 == 1;
    }

    function checkProof(bytes memory proof, bytes32 root, bytes32 hash, uint key) pure public returns (bool) {
      bytes32 el;
      bytes32 h = hash;
      uint8 counter = 0;
      for (uint256 i = 32; i <= proof.length; i += 32) {
          assembly {
              el := mload(add(proof, i))
          }

          if (bitSet(key, 255 - counter)) {
              h = keccak256(abi.encodePacked(el, h));
          } else {
              h = keccak256(abi.encodePacked(h, el));
          }
          counter++;

      }
      return h == root;
    }

}
