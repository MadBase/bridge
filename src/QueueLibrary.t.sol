// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.15;

import "ds-test/test.sol";

import "./QueueLibrary.sol";

contract QueueLibraryTest is DSTest {

    using QueueLibrary for QueueLibrary.Queue;

    QueueLibrary.Queue queue;

    // Here is where real tests start
    function testInitialization() public {
        assertEq(queue.size(), 0);
    }

    function testEnqueue1() public {
        queue.enqueue(address(1));
        assertEq(queue.size(), 1);
    }

    function testEnqueue2() public {
        queue.enqueue(address(1));
        queue.enqueue(address(2));
        assertEq(queue.size(), 2);
    }

    function testEnqueue3() public {
        queue.enqueue(address(1));
        queue.enqueue(address(2));
        queue.enqueue(address(3));
        assertEq(queue.size(), 3);
    }

    function testDequeue1() public {
        queue.enqueue(address(1));

        assertEq(queue.dequeue(), address(1));

        assertEq(queue.size(), 0);
    }

    function testDequeue2() public {
        queue.enqueue(address(1));
        queue.enqueue(address(2));

        assertEq(queue.dequeue(), address(1));
        assertEq(queue.dequeue(), address(2));

        assertEq(queue.size(), 0);
    }

    function testDequeue3() public {
        queue.enqueue(address(1));
        queue.enqueue(address(2));
        queue.enqueue(address(3));

        assertEq(queue.dequeue(), address(1));
        assertEq(queue.dequeue(), address(2));
        assertEq(queue.dequeue(), address(3));

        assertEq(queue.size(), 0);
    }

    function testRequeue1() public {
        queue.enqueue(address(1));

        assertEq(queue.dequeue(), address(1));
        assertEq(queue.size(), 0);

        queue.enqueue(address(1));
        assertEq(queue.size(), 1);
    }

    function testRequeue2() public {
        queue.enqueue(address(1));
        queue.enqueue(address(2));

        assertEq(queue.dequeue(), address(1));
        assertEq(queue.dequeue(), address(2));

        assertEq(queue.size(), 0);

        queue.enqueue(address(1));
        queue.enqueue(address(2));
        assertEq(queue.size(), 2);
    }

    function testRequeue3() public {
        queue.enqueue(address(1));
        queue.enqueue(address(2));
        queue.enqueue(address(3));

        assertEq(queue.dequeue(), address(1));
        assertEq(queue.dequeue(), address(2));
        assertEq(queue.dequeue(), address(3));

        queue.enqueue(address(1));
        queue.enqueue(address(2));
        queue.enqueue(address(3));
        assertEq(queue.size(), 3);
    }

    function testFailEnqueueDuplicate() public {

        address fakeId = address(13);

        queue.enqueue(fakeId);
        assertEq(queue.size(), 1);

        queue.enqueue(fakeId);

    }

    function testEnqueueGood() public {
        queue.enqueue(address(1));
        assertEq(queue.size(), 1);

        queue.enqueue(address(2));
        queue.enqueue(address(3));
        queue.enqueue(address(4));
        assertEq(queue.size(), 4);

        queue.enqueue(address(5));
        assertEq(queue.size(), 5);
    }

    function testFailDequeueEmpty() public {
        assertEq(queue.size(), 0);

        queue.dequeue();
    }

    function testDequeueGood() public {
        address a = address(1);
        address b = address(2);
        address c = address(3);

        queue.enqueue(a);
        queue.enqueue(b);
        queue.enqueue(c);

        assertEq(queue.dequeue(), a);
        assertEq(queue.dequeue(), b);
    }

    function testQueueDequeue() public {
        address a = address(1);

        assertEq(queue.size(), 0);
        queue.enqueue(a);
        assertEq(queue.size(), 1);

        queue.dequeue();
        assertEq(queue.size(), 0);

        queue.enqueue(a);
        assertEq(queue.size(), 1);
    }

}