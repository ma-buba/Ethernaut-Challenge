// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// This gatekeeper introduces a few new challenges. Register as an entrant to pass this level.

// Things that might help:
// Remember what you've learned from getting past the first gatekeeper - the first gate is the same.
// The assembly keyword in the second gate allows a contract to access functionality 
// that is not native to vanilla Solidity. See Solidity Assembly for more information. 
// The extcodesize call in this gate will get the size of a contract's code at a given address - 
// you can learn more about how and when this is set in section 7 of the yellow paper.
// The ^ character in the third gate is a bitwise operation (XOR), and is used here to apply 
// another common bitwise operation (see Solidity cheatsheet). 
// The Coin Flip level is also a good place to start when approaching this challenge.

contract GatekeeperTwo {
    address public entrant;

    // bytes8 gatekey = bytes8(uint64(bytes8(keccak256(abi.encodePacked(origSender)))) ^ type(uint64).max);

    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    // it's to ensure the caller is not a smart contract but an EOA.

    modifier gateTwo() {
        uint256 x;
        assembly {
            // caller() is an EVM opcode that returns the address of the immediate caller (msg.sender). 
            // It's used inside assembly {} blocks as a built-in function.

            // extcodesize() is an EVM opcode that returns the size (in bytes) of the code stored at a given address.
            x := extcodesize(caller())
            // address.code.length      // Code size in bytes
            // address.codehash         // Keccak256 hash of the code (Solidity 0.8.10+)

            // extcodesize(addr)        // Assembly version of code.length
            // extcodehash(addr)        // Assembly version of codehash
        }
        require(x == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        // type(uint64).max = 18446744073709551615
        require(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == type(uint64).max);
        _;
    }

    function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }
}