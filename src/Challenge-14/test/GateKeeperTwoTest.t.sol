//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {GatekeeperTwo} from "../GateKeeperTwo.sol";

contract GateKeeperTest is Test {
    GatekeeperTwo gatekeeper2;

    address sender = makeAddr("sender");
    address originSender = makeAddr("originSender");

    function setUp() public {
        gatekeeper2 = new GatekeeperTwo();
    }
    function test_Challenge14_Passed() public {
        vm.prank(sender, originSender);
        bytes8 gatekey = bytes8(uint64(bytes8(keccak256(abi.encodePacked(sender)))) ^ type(uint64).max);
        gatekeeper2.enter(gatekey);
        assertEq(gatekeeper2.entrant(), originSender);
    }
}