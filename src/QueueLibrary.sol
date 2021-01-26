// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.15;

import "./SafeMath.sol";

library QueueLibrary {

    using SafeMath for uint;

    struct Queue {
        mapping(address => bool) present;
        mapping(uint32 => address) queue;
        uint32 first; // By convention, this is the first index in queue with a value
        uint32 last;  // ... this is the first index in queue *without* a value -- queue defaults are empty
    }

    function size(Queue storage queue) internal view returns (uint256) {
        return queue.last - queue.first;
    }

    function enqueue(Queue storage queue, address data) internal {
        require(!queue.present[data], "duplicates not allowed");

        queue.queue[queue.last] = data;
        queue.present[data] = true;
        queue.last++;
    }

    function dequeue(Queue storage queue) internal returns (address val) {
        require(queue.last > queue.first, "queue is empty");

        val = queue.queue[queue.first];
        delete queue.queue[queue.first];
        delete queue.present[val];

        queue.first++;
    }

}