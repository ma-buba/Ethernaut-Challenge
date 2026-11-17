//SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {GatekeeperOne} from "../GateKeeperOne.sol";

contract GatekeeperOneTest is Test {
    GatekeeperOne gatekeeper;

    address sender = makeAddr("sender");
    address originSender = makeAddr("originSender");

    function setUp() public {
        gatekeeper = new GatekeeperOne();
    }
    function test_Challenge13_Passed() public {
        vm.prank(sender, originSender);
        if(gasleft() % 8191 == 0) {
            bytes8 gatekey = bytes8(uint64(uint16(uint160(address(originSender)))));
            bool result = gatekeeper.enter(gatekey);
            assert(result);
        } 
    }
}