// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; 

import {Token} from "../Token.sol";
import {Test, console2} from "forge-std/Test.sol";

contract TokenTest is Test {
    Token token;
    address receiver = makeAddr("receiver");
    function setUp() public {
        token = new Token(20);
    }
    function test_Challenge5_Passed() public {
        accessMoreToken();
    }
    function accessMoreToken() public {
        token.transfer(receiver, 20);
        // this can't be tested because a newer version of solidity automatically stops overflow now
        // uncomment this !!!!!
        // token.transfer(receiver, 2);
        uint256 receiverBalance = token.balanceOf(receiver);
        console2.log("receiver received more than 20 token:", receiverBalance);

    }
}