// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../helpers/Ownable-05.sol";

// You've uncovered an Alien contract. Claim ownership to complete the level.

//   Things that might help

// Understanding how array storage works
// Understanding ABI specifications
// Using a very underhanded approach

contract AlienCodex is Ownable {
    bool public contact;
    bytes32[] public codex;

    modifier contacted() {
        assert(contact);
        _;
    }

    function makeContact() public {
        contact = true;
    }

    function record(bytes32 _content) public contacted {
        codex.push(_content);
    }

    function retract() public contacted {
        // underflow is not allowed in newer versions of solidity
        // codex.length--;
    }

    function revise(uint256 i, bytes32 _content) public contacted {
        codex[i] = _content;
    }
}