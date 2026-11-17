//SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {Recovery, SimpleToken} from "../Recovery.sol";

contract RecoveryTest is Test {
    Recovery recovery;

    address owner = makeAddr("owner");
    address payable tokenAddress;

    function setUp() public {
        vm.startPrank(owner);
        recovery = new Recovery();
        vm.deal(owner, 10 ether);
        
        bytes memory callData = abi.encodeWithSignature("generateToken(string,uint256)", "myToken", 100);
        (bool success,) = address(recovery).call(callData);
        require(success, "token creation failed");
 
        tokenAddress = payable(vm.computeCreateAddress(address(recovery), 1));
        (bool successs,) = payable(tokenAddress).call{value: 0.001 ether}("");
        vm.stopPrank();
    }
    function test_Challenge17_Passed() public {   
        // formula create
        // keccak256( rlp([creator_address, nonce]) )
        // In RLP, when encoding a LIST, the first byte tells the decoder two things:
            // "This is a list" (prefix starts at 0xc0)
            // "The list contains X bytes total" (0xc0 + total_bytes)

        // convert sender address to bytes
        uint8 nonce = 1;  
        // the first param is: RLP list prefix (0xc0 + 20 + 1 + 1)
         bytes memory tokenHash = bytes.concat(
            bytes1(0xd6),          // 0xc0 + 20 + 1 + 1
            bytes1(0x94), 
            abi.encodePacked(address(recovery)),  // 20 bytes
            bytes1(nonce)              // nonce
        ); 
        address payable tokenAddresss = payable(address(uint160(uint256(keccak256(tokenHash)))));
        SimpleToken tokenContract = SimpleToken(tokenAddresss); 
        assert(tokenAddresss.balance != 0);
        Receiver receiver = new Receiver();
        SimpleToken(tokenAddresss).destroy(payable(address(receiver)));
        assert(tokenAddresss.balance == 0);

        // formula create2
        // address = keccak256(0xff + sender + salt + keccak256(bytecode))
    }
}

contract Receiver {
    receive() external payable {

    }
}