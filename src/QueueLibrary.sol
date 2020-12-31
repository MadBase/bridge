pragma solidity >=0.5.15;

import "./SafeMath.sol";

library QueueLibrary {

    using SafeMath for uint;

    struct Queue {
        mapping(address => bool) present;
        mapping(uint256 => address) queue;
        uint256 first;
        uint256 last;
    }

    function NewQueue() internal pure returns (Queue memory) {
        return Queue({first:1, last:0});
    }


    function size(Queue storage queue) internal view returns (uint256) {
        uint256 sz = queue.last;
        sz = sz.add(1);
        sz = sz.sub(queue.first);
        return sz;
    }

    function enqueue(Queue storage queue, address data) internal {
        require(!queue.present[data], "Duplicate entries not allowed");
        queue.last = queue.last.add(1);
        queue.queue[queue.last] = data;
        queue.present[data] = true;
    }

    function dequeue(Queue storage queue) internal returns (address) {
        require(queue.last >= queue.first, "Queue is empty");

        address data;
        data = queue.queue[queue.first];

        delete queue.present[data];
        delete queue.queue[queue.first];
        queue.first = queue.first.add(1);

        return data;
    }
}