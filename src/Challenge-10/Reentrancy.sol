// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// The goal of this level is for you to steal all the funds from the contract.

//   Things that might help:

// Untrusted contracts can execute code where you least expect it.
// Fallback methods
// Throw/revert bubbling
// Sometimes the best way to attack a contract is with another contract.
// See the "?" page above, section "Beyond the console"


contract Reentrance {

    mapping(address => uint256) public balances;

    function donate(address _to) public payable {
        balances[_to] = balances[_to] + msg.value;
    }

    function balanceOf(address _who) public view returns (uint256 balance) {
        return balances[_who];
    }

    function withdraw(uint256 _amount) public {
        if (balances[msg.sender] >= _amount) {
            (bool result,) = msg.sender.call{value: _amount}("");
            if (result) {
                _amount;
            }
            // this is impossible in newer versions, no overflow/underflow allowed
            // uncomment this !!!!!
            // balances[msg.sender] -= _amount;
        }
    }

    receive() external payable {}
}