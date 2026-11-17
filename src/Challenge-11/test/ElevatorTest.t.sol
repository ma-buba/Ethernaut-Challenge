//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {Elevator} from "../Elevator.sol";

contract ElevatorTest is Test {
    Elevator elevator;
    Sender sender;

    function setUp() public {
        elevator = new Elevator();
        sender = new Sender();
    }
    function test_Challenge11_Passed() public {
        vm.prank(address(sender));
        elevator.goTo(0);
        vm.prank(address(sender));
        elevator.goTo(34);
        assert(elevator.top());
    }
}

contract Sender {
    uint256 count;
    function isLastFloor(uint256 floor)  public returns(bool) {
        uint256 click = ++count;
        if(click%2 == 1) {
            return false;
        }
        return true;
    }
}