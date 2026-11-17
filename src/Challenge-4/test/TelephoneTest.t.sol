// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {Telephone} from "../Telephone.sol";

contract TelephoneTest is Test {
    Telephone telephone;
    address sender = makeAddr("sender");
    address originSender = makeAddr("originSender");
    address newOwner = makeAddr("newOwner");

    function setUp() public {
        telephone = new Telephone();
    }
    function test_Challenge4_Passed() public {
        changeTelephoneOwner();
    }
    function changeTelephoneOwner() public {
        vm.prank(sender, originSender);
        telephone.changeOwner(newOwner);
        assertEq(telephone.owner(), newOwner);
    }
}