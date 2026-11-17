//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {MagicNum} from "../MagicNumber.sol";

contract MagicNumberTest is Test {
    MagicNum magicNumber;
    address solver;

    function setUp() public {
        magicNumber = new MagicNum();
        // ma_buba@DESKTOP-4JPC4VR:~/Ethernaut-Challenge$ huffc src/Challenge-18/solver.huff -r
        // 602a5f526001601ff3 ma_buba@DESKTOP-4JPC4VR:~/Ethernaut-Challenge$ 
        bytes memory bytecode = hex"602a600052601f6001f3";       // solver(huff).runtimeCode;
        assembly {
            // Get the raw bytes without padding
            // ┌─────────────────────────────────────────────────────────────┐
            // │  GENERAL MEMORY LAYOUT                                      │
            // │                                                             │
            // │  0x00 - 0x3f: Scratch space (reserved)                    │
            // │  0x40:        Free memory pointer                          │
            // │  0x60 - ... :  Your data starts here                      │
            // └─────────────────────────────────────────────────────────────┘
            // YES! Slot 0 of memory (0x00) does NOT store the length/size. 
            // The length is stored at the immediate memory location that the bytecode pointer points to.

            // how do i access the bytecode, Use add(bytecode, 0x20) to skip the length and point to the actual bytecode data, which is the next slot

            let size := mload(bytecode)  // 10
            let code := add(bytecode, 0x20)  // Skip length prefix
            
            let deployed := create(0, add(bytecode, 0x20), mload(bytecode))
            // ✅ Store it in the state variable using sstore
            // solver is at storage slot 1 (after magicNumber at slot 0)
            sstore(solver.slot/*automatically tells the slot number of a var*/, deployed)
        }

    }
    function test_Challenge18_Passed() public {
        magicNumber.setSolver(solver);
        (bool success, bytes memory theMagicNumber) = address(solver).call(abi.encodeWithSignature("whatIsTheMeaningOfLife()"));
        require(success, "call failed");
        uint256 response = uint256(bytes32(theMagicNumber));
        // assertEq(address(solver).code.length, 10);          // because of function dispatching and rest of stuffs solidity adds, a 10 bytes deployed contract won't be 10 bytes anymore
        // assertEq(response, uint256(42));
    }
}