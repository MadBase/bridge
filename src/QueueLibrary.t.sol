pragma solidity >=0.5.15;

import "ds-test/test.sol";

import "./QueueLibrary.sol";

contract QueueLibraryTest is DSTest {

    using QueueLibrary for QueueLibrary.Queue;
    QueueLibrary.Queue queue = QueueLibrary.NewQueue();

    // Need wrapper functions to catch failed require()s
    function wrappedEnqueue(address val) internal {
        queue.enqueue(val);
    }

    function wrappedDequeue() internal returns (address) {
        return queue.dequeue();
    }

    function safeWrappedEnqueue(address val) internal returns (bool, bytes memory) {
        bool ok;
        bytes memory res;

        (ok, res) = address(this).call( // solium-disable-line
            abi.encodeWithSignature("wrappedEnqueue(address)", val));

        return (ok, res);
    }

    function safeWrappedDequeue() internal returns (bool, bytes memory) {
        bool ok;
        bytes memory res;

        (ok, res) = address(this).call( // solium-disable-line
            abi.encodeWithSignature("wrappedDequeue()"));

        return (ok, res);
    }

    // Here is where real tests start
    function testInitialization() public {
        assertEq(queue.size(), 0);
    }

    function testEnqueueBad() public {

        address fakeId = address(13);

        queue.enqueue(fakeId);
        assertEq(queue.size(), 1);

        bool ok;
        bytes memory res;
        (ok, res) = safeWrappedEnqueue(fakeId);

        assertTrue(!ok);
        assertEq(queue.size(), 1);
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

    function testDequeueBad() public {
        assertEq(queue.size(), 0);

        bool ok;
        bytes memory res;

        (ok, res) = safeWrappedDequeue();

        assertTrue(!ok);
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