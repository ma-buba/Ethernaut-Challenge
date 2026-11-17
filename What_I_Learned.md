# what i learned almost new or pure refresh, about each level in the ethernaut challenge


1. Fallback: The receive() function is triggered when you send ETH outside of the ABI, using a low-level call. When ETH is sent to the contract, it triggers 
   the receive() function, which runs the code block that allows claiming ownership.



2. Fallout: Transactions can be front-run when they are sent to the mem-pool. 
   fal1out is front-run by the attacker to claim ownership before the owner does.



3. Coin Flip: Any value calculated using block details can be recalculated exactly. 
   The guess on a coin flip result is recalculated to influence the correct outcome.



4. Telephone: There's a difference between tx.origin and msg.sender.
    tx.origin is the origin of the transaction — the address that initiated the call.
    For example, when a user calls contractA, and contractA makes a call to contractB, then:
    - tx.origin is the user's address (the original caller)
    - msg.sender in contractB is the address of contractA



5. Token: When an unsigned integer variable reaches its maximum value, it will overflow if incremented further. If it is empty (zero) and still subtracted from, it will underflow.
In the vulnerable contract, the balance check does not properly prevent underflow, so when a transfer of more tokens than the sender's balance is attempted, the balance underflows to a massive number — effectively granting infinite tokens.



6. Delegation: When a low-level call is sent with calldata, the fallback() function is triggered when no function selector matches, the fallback logic is then executed instead, does nothing if no implementation.

delegateCall uses the calling contracts storage to execute the implementation of the called contract

- The `Delegate` contract modifies a specific storage slot. When the fallback() function in the `Delegation` contract makes a low-level delegatecall to the `Delegate` contract, that same storage slot is updated in the `Delegation` contract's context.
As a result, the owner variable in the `Delegation` contract is replaced, allowing the attacker to claim ownership.



7. Force: force ETH to a contract
if a contract doesn't have any payable, receive or fallback function, you can send eth to it with the `selfdestruct` keyword.



8. Vault: Anything stored in the blockchain or contract can be access publicly.
a password is copied as bytes from a storage slot, which is then converted to string and pass as input to a function.
which allow the function to execute.



9. King: a contract with no payable function and no receive function can't accept ETH, unless through selfdestruct.
A game where who sends more than the current king becomes the new king while the current king is refunded, but this is stopped when the new king has no receive and fallback function to receive the ETH, so no refunding.
the function call will always revert.



10. Reentrancy: (similar to `1. fallback`) When a low-level call is made to a contract, the caller contract essentially triggers the receive() function of the target contract.
If a contract sends ETH to an attacker, and the attacker's receive() function repeatedly calls back into the original contract before the balance is updated, the protocol can be drained.



11. Elevator: Typecasting does not change the code in a contract—it simply tells the compiler to interpret the address using a specific interface or function signature template. The actual implementation deployed at that address is what gets executed. If the interface signature does not match any function in the target contract, the call will revert.
If the target has a fallback that doesn't revert, the call succeeds (returns empty or whatever the fallback returns).

In the Elevator challenge, the isLastFloor function from the Building interface is trusted to behave consistently across all calls. However, a malicious contract can implement the same function signature with different logic. This allows the attacker to bye pass the checks in the Elevator contract and move to the top of the building.




12. Privacy: (similar to `8. Vault`) data stored in the blockchain is publicly accessible.
A password is copied from index 2 of an array in storage, to by pass a check.




13. GateKeeperOne: Any check that is not reliable on some legitmate data can be bye passed, data can be recalculated and make a call only when the case is able to be bye passed.
modifier checks on gateOne, two and three are bye passed, coz they are based on some blockchain data that are not strong and can be accessed and recalculated.




14. GateKeeperTwo: Any check that is not reliable on some legitmate data can be bye passed, data can be recalculated and make a call only when the case is able to be bye passed.
modifier checks on gateOne, two and three are bye passed, coz they are based on some blockchain data that are not strong and can be accessed and recalculated.
if a contract make a call inside a constructor, at the moment the call reaches, that contract has 0 code in it, until it is deployed completely.




15. NaughtyCoin: In the OpenZeppelin ERC20 token library, the `transfer()` function allows the token owner to send their own tokens to another address. The `transferFrom()` function, on the other hand, allows an approved spender (who has been granted permission via the `approve()` function) to transfer tokens on behalf of the owner.




16. Preservation: delegateCall uses the calling contracts storage to execute the implementation of the called contract.
A storage slot that holds the owner address in a given contract is modified by delegatecalling another contract function, that modifies that exact slot. which makes the slot in the given contract modified, ending up claiming ownership by the attacker.




17. Recovery: A contract address can be deterministically recalculated.
A token contract whose address was forgotten can be recovered using vm.computeCreateAddress(), which takes the deployer's address and the nonce of that deployment.
Under the hood, the method uses the formula:
keccak256(rlp([creator_address, nonce]))
```solidity
   bytes memory tokenHash = bytes.concat(
      bytes1(0xd6),          // 0xc0 + 20 + 1 + 1
      bytes1(0x94), 
      abi.encodePacked(address(recovery)),  // 20 bytes
      bytes1(nonce)              // nonce
   ); 
   address payable tokenAddresss = payable(address(uint160(uint256(keccak256(tokenHash)))));
   SimpleToken tokenContract = SimpleToken(tokenAddresss);
```




18. Magic Number: you can use `huff` language for optimization to avoid some compiler features, and to reduce contract bytecode ┌─────────────────────────────────────────────────────────────┐
│  GENERAL MEMORY LAYOUT (Solidity)                           │
│                                                             │
│  0x00 - 0x3f: Scratch space (64 bytes, reserved)            │
│  0x40 - 0x5f: Free memory pointer (32 bytes)                │
│  0x60 - 0x7f: Zero slot (32 bytes, always zero, reserved)   │
│  0x80 - ... :  Free memory / your data starts here          │
└─────────────────────────────────────────────────────────────┘

in this case, bytecode + 32bytes  is the place where the actual data is stored, while the data length is stored at the exact bytecode slot.

if `new` keyword is use to deploy contracts in solidity, create() takes 3 params is used to deploy contract in assembly.
`var.slot` in assembly block is used to access the slot number of that variable.




19. AlienCodex: When an array in slot 1 underflows (length goes from 0 to 2^256 - 1), the array now covers the ENTIRE storage space of the contract. so now the array data (index 0) starts at the slot computed by `keccak256(abi.encode(1))`. slot 1 is where the array length is stored, slot 1 or Slot 0 of the contract becomes codex[target] where target is a specific index calculated to reach Slot 0.

Base slot does NOT become Slot 0. It remains the starting point of the array data. Slot 0 is accessed by calculating the target index such that BASE_SLOT + target = slot 0, then calling revise(target, newValue), which overwrites codex[target] — and that slot happens to be Slot 0.

Base slot is where the array DATA starts (i.e., codex[0]).
Modifying codex[0] modifies BASE_SLOT which is index 0, NOT Slot 0!.

Slot 1 does NOT store array data — it stores the array length, just like it is before. The actual array data starts at keccak256(abi.encode(1)), which is the BASE_SLOT. To access any storage slot (like Slot 0 or Slot 1) through the array, you calculate a target index that wraps around the maximum uint256 value, allowing you to overwrite any slot in the contract, before subtracting baseslot and add the slot number.

examples:
1. slot 0
target = MAX + 1 - BASE_SLOT + 0 
2. slot 1
target = MAX + 1 - BASE_SLOT + 1
3. slot 2
target = MAX + 1 - BASE_SLOT + 2




20. Denial: if a call is made to a contract, 63 out of 64 share of the remaining gas only is forwarded for transaction executions, revert if that gas finished, the remaining 1 out of the 64 will be used to complete the rest of the transasction in the parent contract.
this is introduced in EIP-150

if a low level call is made, any revert that triggered as a result of `receive` or `fallback` function being triggered will revert silenty and the rest of the parent contract call will continue.
Low-level calls (call, delegatecall, staticcall) do NOT automatically revert the parent transaction when they fail. Instead, they return a boolean value (true/false) indicating success or failure.




21. Shop: Typecasting does not change the code in a contract—it simply tells the compiler to interpret the address using a specific interface or function signature template. The actual implementation deployed at that address is what gets executed. If the interface signature does not match any function in the target contract, the call will revert.




22. Dex: when giving a token to simulated player using `deal(address token, address to, uint256 give)`  with 3 arguments, doesn't adjust the total supply.
while `deal(address token, address to, uint256 give, bool adjust)` with 4 argument do adjust the total supply.

"At Address" in Remix IDE lets you interact with an already-deployed contract at a specific address, without redeploying it.
# question
What Causes the Token Price to Shift?
# Answer
The price shifts because the `getSwapPrice()` function calculates the price based on the DEX's CURRENT BALANCE of both tokens. Every swap changes these balances, which changes the price for the next swap.
# core vunerability
The core vulnerability in the Dex challenge is that the price is calculated on-the-fly using the current token balances of the pool. This means a large trade can temporarily skew the price, allowing an attacker to profit.

The attacker swaps back and forth — each swap moves the price further in the attacker's favor.
# mitigation
A TWAP oracle makes the attack MORE EXPENSIVE and SLOWER, but a determined attacker with enough capital and time could still manipulate it.




23. Dex Two: i can deploy token and swap for the real contract token if the validity of the address is not verified.




24. Puzzle Wallet
Truncation rules:
- When `mload` loads 32 bytes and assigns them to a smaller `bytes` type (e.g., `bytes4`), Solidity keeps the leftmost (first) bytes — which is the function selector.
- For numeric types (e.g., `uint8`), truncation keeps the rightmost bytes instead.

`bytes` → `uint` conversion: 
- Solidity reads the bytes as a number.
- If the bytes type is smaller than the uint type → zero-padded on the left.
- If the uint type is smaller → truncated from the left (keeping the rightmost bytes).

Storage context with proxy:
- Whether a function in the implementation is `delegatecall`ed by a proxy, and that function uses `.call` or `.delegatecall` to call a function in that same implementation, the Proxy's storage is used, because the Proxy already `delegatecall`ed to the implementation.
- When `multicall()` uses `.call` or `.delegatecall`, the Proxy's storage is used — because the Proxy already `delegatecall`ed to `PuzzleWallet`.
- Even a check in the implementation (e.g., `onlyWhitelisted`) uses the Proxy's storage data to compare, so by calling `proposeNewAdmin` the attacker has already become the owner.
- No matter how many nested delegatecalls happen, the storage used is ALWAYS the Proxy's storage — because each delegatecall preserves address(this) and the storage context.





25. MotorBike: 
`switch result` is EVM assembly's version of an `if/else` statement. It checks the value of result and executes different code based on whether it's 0 (failure) or non-zero (success).

`case 0` runs when switch's value is 0, and `default` runs when the value is anything else (like 1)
switch result
case 0 { ... }    // ← runs when result == 0
default { ... }   // ← runs when result != 0 (e.g., 1);

# Assembly     Solidity	            When It Runs
case 0	      if (result == 0)	   When result is 0 (failure)
default	      else	               When result is non-zero (success)
# the bug
the bug is that you can become the `upgrader` of the `implementation` not the `proxy`, upgrade it to a malicious contract, and selfdestruct it. Once the old implementation gets destroyed, the proxy's calls to the implementation fail, breaking the Motorbike.
# deployCode is a cheatcode in foundry
a special function provided by the Foundry testing framework (forge-std) that lets you deploy contracts in your tests.
It deploys a contract by fetching its compiled bytecode from Foundry's `out/` artifacts directory . This is especially useful when you need to deploy contracts compiled with different Solidity versions than your test file .

# deployCode Input Combinations
1. 1 input: Just the contract identifier.
deployCode(string memory what)
Example: deployCode("MotorBike.sol:Engine")

2. 2 inputs: Contract identifier + constructor arguments OR Contract identifier + ETH value.
deployCode(string memory what, bytes memory args)
Example: deployCode("MyContract.sol", abi.encode(arg1, arg2))
deployCode(string memory what, uint256 val)
Example: deployCode("MyContract.sol", 1 ether)

3. 3 inputs: Contract identifier + constructor arguments + ETH value.
deployCode(string memory what, bytes memory args, uint256 val)
Example: deployCode("MyContract.sol", abi.encode(arg1), 1 ether)

# Fork Testing
you must create and select the fork BEFORE interacting with any deployed contract. Without the fork, those addresses don't exist in your test environment.
1. vm.createSelectFork("sepolia");
2. vm.createFork("sepolia");
3. vm.selectFork("sepolia");
when you fork mainnet, you get a snapshot of the ENTIRE state at that block, including all storage, balances, and code. You don't need to fill anything yourself — it's already there.

- Post-Dencun (EIP-6780): selfdestruct only deletes the contract code if it's called in the same transaction the contract was created (i.e., inside its constructor). If called later, it only sends the ETH — the code remains. So the classic MotorBike exploit may not fully destroy the Engine on modern networks (Sepolia, mainnet).

26. DoubleEntryPoint: `try/catch` calls the function call after the keyword `try`, if it succeed runs the first block of the code, runs the second if it fails.
In `Forta` contract case, `try/catch` attempts an external call. If it succeeds, `return` exits. If it fails, `catch {}` swallows the error and execution continues. if nothing in catch, do nothing and continue.
`try/catch` is for external calls only. It lets you handle failures gracefully instead of reverting the whole transaction. Use it carefully — empty catches can hide bugs. 

- legacy Token controls the DET token, so if legacy is passed as the token to be swept in crypto vault, it will now sweep the DET, but DET is not allowed to be swept.

# decoding msg.data passed in a function call
you need msgData[4:] to skip the 4-byte function selector. Without it, the decoding will fail or produce wrong values.
'''
   `(,,address origSender) = abi.decode(msgData[4:], (address, uint256, address));`
'''
# msgData contains:
[0:4]    Function selector (4 bytes)
[4:36]   to (address, 32 bytes)
[36:68]  value (uint256, 32 bytes)
[68:100] origSender (address, 32 bytes)

27. GoodSamaritan: even if you create an instances of account, which you interact with in the protocol
there might be chances which does accounts will be malicious 

a `try/catch` uses "NotEnoughBalance" error to trigger the catch block, which transfers all the balances from the wallet to the caller
when donating 10 of the coins, notify function is called from the callers address if it's a smart contract
so i use a malicious contract which will always return "NotEnoughBalance" error in what ever case, so this will trigger the catch block.
which will transfer to the malicious contract the whole coin of the wallet.

28. GatekeeperThree: 
gateOne requires msg.sender == owner AND tx.origin != owner.
To bypass it, the owner must be a contract, and the call must come from a different EOA.
tx.origin is the original EOA. msg.sender is the immediate caller. By using a middleman contract as the owner, you can bypass gateOne — the middleman is msg.sender, and the EOA is tx.origin. 





29. Switch: 
# ABI layout of a function taking `bytes`
| Bytes   | Content                                       | Who reads it                          |
|---------|-----------------------------------------------|---------------------------------------|
| 0–3     | `flipSwitch(bytes)` selector `30c13ade`       | EVM dispatcher                        |
| 4–35    | offset = `0x60` (96) → absolute byte 100      | ABI decoder in `flipSwitch`           |
| 36–67   | filler (zeros)                                | nobody                                |
| 68–99   | **`turnSwitchOff()`** `20606e15` + zero pad   | **`onlyOff` modifier (DECOY)**        |
| 100–131 | length of `_data` = `4`                       | ABI decoder in `flipSwitch`           |
| 132–163 | **`turnSwitchOn()`** `76227e12` + zero pad    | **`flipSwitch` → `call(_data)` (REAL)** |

- The offset is measured from the start of the arguments (byte 4), not byte 0.
- The offset points to the LENGTH word; the data starts 32 bytes after it.
- We trick the `onlyOff` modifier by placing a decoy `turnSwitchOff()` selector at byte 68,
the fixed position it checks. We then set the offset field to point elsewhere, so
`flipSwitch` decodes a different `_data` and executes `turnSwitchOn()`.
- Padding is not part of the data: a 4-byte selector inside `_data` has length 4,
  even though it sits in a 32-byte slot.

# The bug in Switch

`onlyOff` hardcodes `calldatacopy(selector, 68, 4)`, assuming `_data` starts at byte 68.
But the offset field is attacker-controlled, so we can:
- put a decoy `turnSwitchOff()` selector at byte 68 (passes the modifier)
- point the offset elsewhere, at the real `_data` = `turnSwitchOn()`

# Crafted calldata

Byte:   0      4       36      68        100      132
        ├──────┼───────┼───────┼─────────┼────────┼─────────┤
        │ sel  │ offset│filler │ decoy   │ length │ real    │
        │ 4 B  │ 0x60  │ 32 B  │turnOff  │  = 4   │ turnOn  │
        │      │       │       │ 32 B    │  32 B  │ 32 B    │

- offset = 96 (0x60) -> absolute byte 4 + 96 = 100 -> where the length lives
- byte 68: decoy `turnSwitchOff()` -> only what the modifier reads
- byte 100: length = 4
- byte 132: `turnSwitchOn()` -> the real _data that flipSwitch decodes and calls

Why 96 and not 100? Offsets are relative to byte 4. 100 - 4 = 96.
Why not 132? The offset points to the length word, not the data.

```solidity
bytes memory callData = abi.encodePacked(
    Switch.flipSwitch.selector,              // byte 0   (4 bytes)
    uint256(0x60),                           // byte 4   offset -> absolute 100
    uint256(0),                              // byte 36  filler
    bytes32(Switch.turnSwitchOff.selector),  // byte 68  decoy for onlyOff
    uint256(4),                              // byte 100 length of _data
    bytes32(Switch.turnSwitchOn.selector)    // byte 132 real _data
);

// must be a raw call; switchh.flipSwitch(callData) would re-encode it
(bool success,) = address(switchh).call(callData);
require(success);
```

# Flow
1. onlyOff reads 4 bytes at byte 68 -> turnSwitchOff selector -> passes.
2. flipSwitch decodes _data via the offset -> length 4, data = turnSwitchOn selector.
3. address(this).call(_data) -> msg.sender == address(this) -> onlyThis passes.
4. switchOn = true.





30. Higher Order:
# (uint8) — the parameter list
This is the parameter list. There is exactly one parameter, whose type is `uint8`, and — crucially — it has no name.

Contrast: named vs. unnamed parameters
Declaration	                  Named?	            Compiler behavior
- function f(uint8)	           ❌ no name	           No variable created. No decode. No validation. Only affects the selector.
- function f(uint8 x)	        ✅ named	          Creates local var x, ABI-decodes calldata[4:36] into it, applies type rules on use.

Because there's no name, Solidity:
Does not create any local variable
Does not generate code to read the calldata into anything
Does not range-check, mask, or revert on the value
Still includes uint8 in the selector string
Key point: (uint8) here is purely documentation / ABI metadata. Nothing at runtime consults it.


31. Impersonator 
Value types are stored on the stack even inside function declaration.
Reference types are stored on the stack as a pointer, with their data in memory (or storage/calldata).
- Value type (uint256, bytes32, address, bool)
- Reference type (bytes, string, arrays, structs)
# EIP-191 Version Bytes: Signature Context Prefixes
The defined versions
Version byte	         Name	                           Format
1. 0x00	               Data with intended validator	   0x19 0x00 <validator address> <data> — ties the signature to a specific contract, so 
                                                         it can't be reused elsewhere
2. 0x01	               Structured data (EIP-712)	      0x19 0x01 <domainSeparator> <hashStruct(message)> — the basis for typed data signing
3. 0x45 ('E')	         personal_sign messages	         0x19 Ethereum Signed Message:\n<length> <data> — what wallets use for eth_sign/personal

# how they look in codes
1. Use 0x45 mainly for simple off-chain logins.
`0x19    0x45    <"Ethereum Signed Message:\n" + decimal_length>     <data>`
Wait — careful. The 0x45 version byte is 'E', which is the first character of "Ethereum". So the format is:
- 0x19 "Ethereum Signed Message:\n" <length> <data>
```solidity
   function verifyPersonalSign(bytes32 messageHash, uint8 v, bytes32 r, bytes32 s)
      internal
      pure
      returns (address)
   {
      // messageHash is the keccak256 of the *inner* data (e.g. a 32-byte hash)
      bytes32 preimage = keccak256(
         abi.encodePacked(
               "\x19Ethereum Signed Message:\n32",
               messageHash
         )
      );
      return ecrecover(preimage, v, r, s);
   }
   // assembly version
   bytes32 ethSignedHash;
   assembly {
      mstore(0x00, "\x19Ethereum Signed Message:\n32")  // 28 bytes
      mstore(0x1C, messageHash)                         // 32 bytes
      ethSignedHash := keccak256(0x00, 0x3c)            // 60 bytes
   }
```
# more robust version looks like 
```solidity
   assembly {
      mstore(0x00, "\x19Ethereum Signed Message:\n32")
      mstore(0x1C, someHashThatIncludesContextualData) // e.g. keccak256(abi.encodePacked(address(this), block.chainid, _lockId))
      _msgHash := keccak256(0x00, 0x3c)
   }
```

2. If your goal is on-chain execution based on a signature, you should almost always use 0x01 (EIP-712) for its security and efficiency.  
0x01 — EIP-712 (typed structured data)
Raw preimage:
`0x19    0x01    <domainSeparator (32 bytes)>    <hashStruct(message) (32 bytes)>`
Total: 2 + 32 + 32 = 66 bytes.

```solidity
   // 1. Domain separator
   bytes32 DOMAIN_SEPARATOR = keccak256(
      abi.encode(
         keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
         keccak256("MyApp"),
         keccak256("1"),
         block.chainid,
         address(this)
      )
   );

   // 2. Type hash for the message
   bytes32 constant PERMIT_TYPEHASH = keccak256(
      "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
   );

   // 3. Hash the struct
   bytes32 structHash = keccak256(
      abi.encode(
         PERMIT_TYPEHASH,
         owner,
         spender,
         value,
         nonce,
         deadline
      )
   );

   // 4. Final digest
   bytes32 digest = keccak256(
      abi.encodePacked(
         "\x19\x01",
         DOMAIN_SEPARATOR,
         structHash
      )
   );

   // 5. Recover
   address signer = ecrecover(digest, v, r, s);

   // assembly version 
   bytes32 digest;
   assembly {
      // scratch: 0x00..0x42 = 2 + 32 + 32 = 66 bytes
      mstore(0x00, "\x19\x01")          // 2 bytes, right-aligned in the 32-byte word
      mstore(0x02, domainSeparator)     // 32 bytes at offset 2
      mstore(0x22, structHash)          // 32 bytes at offset 0x22 = 34
      digest := keccak256(0x00, 0x42)   // 66 bytes
   }
```


3. Use 0x00 if you are specifically building a smart contract wallet. 

0x00 — Data with intended validator
`0x19    0x00    <validator address (20 bytes)>    <data (arbitrary length)>`
```solidity
contract Validator {
    function verify(
        bytes calldata data,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external view returns (address) {
        // Build the preimage: 0x19 0x00 <this contract> <data>
        bytes32 digest = keccak256(
            abi.encodePacked(
                "\x19\x00",
                address(this),      // the validator address
                data
            )
        );
        address signer = ecrecover(digest, v, r, s);
        require(signer != address(0), "bad sig");
        return signer;
    }
}
   // assembly version
   bytes32 digest;
   assembly {
      // scratch memory: 0x00 onward
      mstore(0x00, "\x19\x00")             // 2 bytes
      // write validator address (20 bytes) right after — use mstore8 loop or shift
      mstore(0x02, shl(96, address()))     // address in the top 20 bytes of the word at 0x02
      // copy `data` into memory at 0x16 (2 + 20)
      let dataLen := data.length
      calldatacopy(0x16, data.offset, dataLen)
      digest := keccak256(0x00, add(0x16, dataLen))  // 2 + 20 + len(data)
   }
```


Scenario	                                       Version
- Off-chain login / SIWE	                     0x45
- On-chain typed data, permits, gasless tx	   0x01
- Smart contract wallet / multisig	            0x00

# manual, low-level implementation of ecrecover, done via a direct staticcall to the ecrecover precompile (address 0x01) instead of using Solidity's built-in ecrecover(...) function.
1. Store the parameters in memory before calling the ecrecover precompile, then pass the memory offset and length to the staticcall
```solidity
   // 0x40 is the free memory pointer, usually stores 0x80 as the free space
      let ptr := mload(0x40)
      mstore(ptr, _msgHash) // 32 bytes
      mstore(add(ptr, 32), mload(add(_signature, 0x60))) // 32 byte v
      mstore(add(ptr, 64), mload(add(_signature, 0x20))) // 32 bytes r
      mstore(add(ptr, 96), mload(add(_signature, 0x40))) // 32 bytes s
```
where signature is in a determined("random" in my words) memory location.
the first slot at that location is length of that signature and the following is the v, r and s, which is the signature.
so i load them to the top memory after the first "free memory pointer" where i store _msgHash.
2. 
```solidity
   pop(
         staticcall(
            gas(), // Amount of gas left for the transaction.
            initialController, // Address of `ecrecover
            ptr, // Start of input.
            0x80, // Size of input.
            0x00, // Start of output.
            0x20 // Size of output.
         )
   )
```
# Calling `ecrecover` Inside 
The ecrecover precompile expects input in this exact order:
hash (32) | v (32) | r (32) | s (32)   = 128 bytes total
but the real signature combined is in this order:
r(32) | s(32) | v(32)
## The Problem
`ecrecover` is a Solidity built-in, not a Yul built-in.
- Outside assembly: `ecrecover(hash, v, r, s)` ✅
- Inside `assembly { }`: not available ❌
Inside assembly, the only way to reach the precompile is a low-level call (`call` / `staticcall`) to address `0x01`.
If initialController is not `0x01`, you're calling whatever precompile is at that address
## The Mechanism
Send a call with the message hash + signature as input, and an address comes back as output.

pop will remove the success flag returned by the `staticcall`

3. read the return data size to see if it's zero revert the didn't succeed
if it's not zero stored in as the controller 
```solidity
   if iszero(returndatasize()) {
         mstore(0x00, 0x8baa579f) // `InvalidSignature()`.
         revert(0x1c, 0x04)
   }
   initialController := mload(0x00)
   mstore(0x40, add(ptr, 128))
```
`mstore(0x40, add(ptr, 128))` manually advances the free memory pointer past the 128 bytes just used at ptr, since this raw assembly bypassed Solidity's normal memory allocation bookkeeping.

# ECDSA signatures live on the secp256k1 elliptic curve. 
Given a signature (v, r, s) that recovers address A, there's always another signature that also recovers A:

v' = v flipped  (27 ↔ 28)
r' = r         (unchanged)
s' = n − s     (where n is the curve order)

# So what is the real bug, then
- Signature malleability —    `s' = n - s`,     `v' = flip(v)`
`uint8 vMalleable = v ^ 1`; // flips the low bit
recovers to the same signer but produces a different signatureHash, bypassing usedSignatures even though it's semantically "the same" authorization.
- No caller binding — _isValidSignature never checks msg.sender, so anyone who's seen a valid (v, r, s) on-chain (or its malleable twin) can submit it themselves.

```solidity
uint256 sMalleable = SECP256K1_N - uint256(s);
uint8 vMalleable = 55 - v;
```
That's it. 55 comes from 27 + 28, the two valid values of v. This single line always gives you the correct flip:
if v = 27, then vMalleable = 28
if v = 28, then vMalleable = 27


33. Magic Animal:
# Operator precedence (relevant portion)
Precedence	            Operator
Higher	               +, -
↓	                     <<, >>
↓	                     &
↓	                     ^
Lower	                  |

So:
+ binds tighter than << → 160 + 16 is evaluated first
<< binds tighter than &, ^, |
& binds tighter than ^
^ binds tighter than |

# The bug 
Bits [160, 255] is 96 bits = 12 bytes wide, but the field it's supposed to fit into — the animal field alone — is only [176, 255], 80 bits = 10 bytes wide. So even though the block correctly ends up "at the left," it's simply too wide: it overhangs by 16 bits on the low end, spilling into [160, 175], which is the nextCrateId field, not empty space. That overhang is exactly the last 2 bytes of the name (bytes 10 and 11), as established before — they're the least-significant end of the 12-byte block, so after the shift they land at the low edge of that leftward-shifted range, right where nextCrateId lives.

#	                     setAnimalAndSpin	                              changeAnimal
- encode	               encodeAnimalName(animal) >> 16	               encodeAnimalName(animal)
- bounds check	         require(encodedAnimal <= type(uint80).max)	   (none — the check happens on the untruncated value inside 
                                                                        encodeAnimalName itself, which only limits string
                                                                        length to 12 bytes, not the final field width)
- combine op	         (masked) ^ (encodedAnimal << 176)	            (encodedAnimal << 160) | (masked)
- shift amount	         << 160 + 16 = << 176	                           << 160
- result width placed	80 bits, fits exactly in [176,255]	            96 bits, spans [160,255]

# The critical difference: the >> 16
`setAnimalAndSpin()` does two things `changeAnimal()` doesn't:
```solidity
uint256 encodedAnimal = encodeAnimalName(animal) >> 16;                    // truncate first
require(encodedAnimal <= uint256(type(uint80).max), AnimalNameTooLong());   // then bound-check the truncated value
```
The >> 16 discards the last 2 bytes of the encoded name (name bytes 10 and 11) before


34. Bet House:
always check assumptions in the withdraw function, or any function that shift funds, use explicit amount and avoid using `balanceOf()`
# the trust assumption 
was that the depositor have wrapped token and burn the whole balance, while the depositor has moved the wrapped tokens before `burn()` was called, because `burn()` just burn the remaining balance without checking how much is it.


35. Elliptic Token:
- Cross-function domain confusion is when a signature produced for one function is accepted by a different function, due to the same hash message.
- Look very closely at permit: it does not call ECDSA.recover on `permitHash`. It calls it on `bytes32(amount)`
```solidity
address tokenOwner = ECDSA.recover(bytes32(amount), tokenOwnerSignature);
```
- What you manipulate is the `amount` parameter of your own permit call, choosing it so that bytes32(amount) equals the already-computed voucherHash from Alice's past transaction (redeemVoucher).
when you typecast the voucherHash to uint, you'll now get the uint equivalent that will be accepted as argument.
and when typecast to bytes32, it will give the same voucherHash combine with the signature stolen in the mempool or public data.
you can replay the signature in the permit functionn.

- One place they're not interchangeable: where you run them
If you're writing a Solidity test/exploit contract, use uint256(H) directly — it's a compile-time-safe cast, no string parsing needed, since H is already a bytes32 value in memory.
If you're working off-chain — say you copy-pasted a hash from Etherscan or a mempool watcher as a hex string — you need cast to-dec, Python's int(..., 16), or JS's BigInt(...) to turn that string into a usable number, since you don't have a live Solidity bytes32 variable to cast.

- keccak256 is a specific, deterministic hash function. Applying it twice is genuinely a different computation than applying it once:
keccak256(amount)                    →  some 32-byte value, call it X
keccak256(keccak256(amount))         →  keccak256 applied to X, giving a DIFFERENT 32-byte value, call it Y



36. Cashback: 
# EIP-7702 delegation designator
Under EIP-7702, an EOA can set its account code to a delegation designator: the 23-byte value `0xef0100 || <20-byte delegate address>`. This points the EOA to an existing contract. When the EOA is called, the EVM runs the delegate's code in the EOA's own context (its address, balance, and storage), so the EOA behaves like a smart contract wallet while keeping its address and private key. The designator persists until changed, and the EOA can clear it by delegating to the zero address. The `0xef` prefix is used because `EIP-3541` forbids deploying contracts whose code starts with 0xef, so a designator can't be mistaken for real contract code.
- Sending a tx to a delegated EOA runs the delegate contract's code against the EOA's own storage, balance, and address.

# I can delegate my own address to another code in 2 ways
1. Sign the Authorization: You (the EOA owner) sign an authorization tuple. This contains the chainId, the address of the delegate contract (the Cashback contract in your scenario), and a nonce.
2. Send the Transaction: You submit a type `0x04` transaction. This transaction includes the signed authorization in its authorizationList. The EVM processes this list first, setting your EOA's code to `0xef0100 || delegate_address` before executing the rest of the transaction.

# You have an EOA. You want it delegated. You send the transaction. You pay gas.
```bash
cast send $YOUR_EOA \
    "payWithCashback(address,address,uint256)" \
    $CURRENCY $RECEIVER $AMOUNT \
    --auth $CASHBACK_CONTRACT \
    --account $YOUR_EOA \
    --rpc-url $RPC_URL
```

# Someone else's EOA gets delegated (you pay gas)
If a different account is paying gas, you first sign the authorization, then pass the encoded signature to the broadcaster.

Someone else's EOA gets delegated, you pay
There's another EOA (not yours). Its owner wants it delegated to Cashback, but they have no ETH to pay gas. You have ETH. So you offer to pay for them.
The problem: only the EOA's owner can sign the authorization. You can't sign it — you don't have their key.
So:
The EOA owner signs an authorization (off-chain, free, no gas) and hands you the signed blob.

Your friend runs this. They own `$THEIR_EOA`. They sign the auth but do not send anything. No gas needed.

```bash
cast wallet sign-auth $CASHBACK_CONTRACT \
    --account $THEIR_EOA \
    --rpc-url $RPC_URL
```

You send a transaction containing that blob. You pay gas.

```bash
cast send $THEIR_EOA \
    "payWithCashback(address,address,uint256)" \
    $CURRENCY $RECEIVER $AMOUNT \
    --auth $SIGNED_AUTH_BLOB \
    --account $YOUR_ACCOUNT \
    --rpc-url $RPC_URL
```

# Combined into a single shell (if you have their key locally)
If both keys are accessible in the same shell, you can chain it:
```bash
cast send $THEIR_EOA \
    "payWithCashback(address,address,uint256)" \
    $CURRENCY $RECEIVER $AMOUNT \
    --auth "$(cast wallet sign-auth $CASHBACK_CONTRACT --account $THEIR_EOA --rpc-url $RPC_URL)" \
    --account $YOUR_ACCOUNT \
    --rpc-url $RPC_URL
```


# so this will revert if you delegate your EOA to a malicious contract 
```solidity
   modifier onlyDelegatedToCashback() {
        bytes memory code = msg.sender.code;

        address payable delegate;
        assembly {
            delegate := mload(add(code, 0x17))
        }
        require(Cashback(delegate) == CASHBACK_ACCOUNT, CashbackNotDelegatedToCashback());
        _;
    }
```



# TRANSIENT STORAGE
The boolean is not stored in the variable UNLOCKED_TRANSIENT. It's stored in the transient storage map at the key UNLOCKED_TRANSIENT. The variable is only the key.

```solidity
using TransientSlot for *;

UNLOCKED_TRANSIENT.asBoolean().tstore(true);
//  ^ slot key         ^ treat as bool   ^ TSTORE(slot, 1)

UNLOCKED_TRANSIENT.asBoolean().tload();
//  ^ slot key         ^ treat as bool   ^ TLOAD(slot) → bool
```

# WIERD SYNTAX 
############################
```solidity
using TransientSlot for *;
```
For any value x of any type, if TransientSlot has a function whose first parameter can accept x, then you can write x.func(...) instead of TransientSlot.func(x, ...).
So the rewrite is only allowed if a matching function exists. for * just removes the restriction on which type x is — it doesn't invent functions that don't exist.

############################
```solidity
type Currency is address;
```
Create a new type Currency. Under the hood it's an address, but the compiler treats Currency and address as different types.

###########################
```solidity
using {equals as ==} for Currency global;
```
- attaches one specific operator (==) backed by one specific free function (equals).
when ever using "==" to compare 2 Currency type it will act as equals
which will unwrap them back to address and then compare.
- global keywords means applies every where, any file that imports the type "Currency" gets the operator.

# TAKE AWAY
Yes, exactly. You can hand-craft a contract's bytecode so that bytes 3–22 (the exact window this modifier reads) contain any address you want, while the rest of the contract does whatever you actually want it to do.

Why this is possible: the check never verifies the code is a real delegation designator (0xef0100 prefix + exact 23-byte length). It just blindly reads 32 bytes starting at offset 23 of the code array and takes the low 20 bytes. Any bytecode with the target address sitting at that byte offset satisfies the check, regardless of what the bytecode actually does before or after.

- Your summary, cleaned up
I call my EOA (from my EOA) with payWithCashback. My EOA transfers the payment to the receiver. Then, in the same transaction, the canonical Cashback mints me cashback automatically.

# The trace
Frame	         Who calls whom	                                          address(this)	msg.sender
1	            You send a tx to your EOA → `payWithCashback()`          EOA	         EOA
2	            Frame 1 calls `CASHBACK_ACCOUNT.accrueCashback()`        Singleton	   EOA
3	            Frame 2 calls `Cashback(msg.sender).consumeNonce()`	   EOA	         Singleton

this `Cashback(msg.sender).consumeNonce()` is cast to the EOA storage, since that's the `msg.sender` inside accrueCashback.
so i can update my nonce personally and willingly since it is incremented and stored in my storage.

# Custom Storage Layout (`layout at`) — Short Notes
Solidity 0.8.29+ feature. Places a contract's storage at a chosen **base slot** instead of slot 0.
in this case the storage base slot is calculated from the comment.
```solidity
/// @dev keccak256(abi.encode(uint256(keccak256("Cashback")) - 1)) & ~bytes32(uint256(0xff))
contract Cashback is ERC1155 layout at 0x442a95e7... {}
```

The formula is from ERC7201
`erc7201(id: string) = keccak256(keccak256(id) - 1) & ~0xff`
In Solidity, it's expressed as:
```solidity
keccak256(abi.encode(uint256(keccak256(bytes(id))) - 1)) & ~bytes32(uint256(0xff))
```

###### SIGNING DELEGATION TO EOA IN FOUNDRY LOCAL ENVIRONMENT
```solidity 
        Vm.SignedDelegation memory signedDelegation = vm.signDelegation(address(cashback), userPk);
```
- This is a Foundry cheatcode that signs an EIP-7702 authorization tuple — essentially `(chainId, address(cashback), nonce)`
- using userPk as the signer's key. This is exactly what a real EOA would sign off-chain to say "I authorize my account to delegate execution to this contract's code."
- It returns a `Vm.SignedDelegation` struct, which holds the signature components (v, r, s) plus the nonce and implementation address that were signed. 
- It does not touch any state yet — it's just producing the signed authorization object, the same way a wallet would produce a signature before broadcasting.


```solidity
vm.attachDelegation(signedDelegation);
```
- This is the cheatcode that actually applies the signed authorization to the VM state, as if that authorization tuple had been included in a type-4 (EIP-7702) transaction.


# The goal of mload(add(code, 0x17)) is:
Load a 32-byte word whose low 20 bytes are exactly the 20-byte address stored at runtime offset 3.

1. Solidity's .code prepends a 32-byte length word. So the runtime's byte 0 sits at memory offset 32, not 0.
2. mload always reads 32 bytes, and an address keeps only the low 20. So the 20 bytes you want must occupy memory offsets [N+12 .. N+31] (the tail of the loaded word).
3. You want those 20 bytes to be runtime[3 .. 22], which in memory live at offsets [32+3 .. 32+22] = [35 .. 54].


```solidity
 bytes memory runtime = abi.encodePacked(
   hex"75", // this indicates the next push should be up to 22 bytes
   bytes2(0), // 2 bytes
   bytes20(cashbackAddr), // 20 bytes making 22
   hex"50", // removes the last push no matter how much bytes
   hex"363d3d373d3d3d363d73", // this copy the call data to memory and arrange the params for sending the delegatecall(serves just as the proxy)
   bytes20(address(impl)), // implementation to send the delegate call to
   hex"5af43d82803e903d91604357fd5bf3" // this fires the delegate call to impl contract
);
```
- basically you can't handle a lot of opcodes creation, we use a simple proxy in opcodes that can send delegate calls to an implementation contract and handle the returned data, so it's easier.
- 

```solidity
bytes memory initcode = abi.encodePacked(
   bytes1(0x60), bytes1(uint8(runtime.length)), // PUSH1 <len> 
   bytes1(0x80),                                 // DUP1
   bytes1(0x60), bytes1(0x09),                   // PUSH1 0x09 (offset of runtime within initcode)
   bytes1(0x3d),                                 // RETURNDATASIZE (== 0, used as destOffset)
   bytes1(0x39),                                 // CODECOPY
   bytes1(0x3d),                                 // RETURNDATASIZE (== 0, used as RETURN offset)
   bytes1(0xf3),                                 // RETURN
   runtime
);
```
this is the contract creation code that will copy the runtime to the memory and return it to the blockchain for deployment 





37. Impersonator Two
# ECDSA nonce reuse, which can leak the owners private-key outright
THE CORE IDEA:
- every ECDSA signature is generated using a random per signature secret called `k`.
- `k` is the signing nonce. It's the random number the signer picks for each signature. But it's important not to confuse it with the contract's nonce in your challenge

# In ECDSA, to sign a message hash z with private key d:
1. Pick a random integer `k` in [1, n-1] where n is the curve order. This is the ephemeral nonce (also called the signing nonce, session nonce, or k value).
2. Compute the point `R = k · G` (where G is the curve's generator point).
3. `r = R.x mod n` (the x-coordinate of R, reduced mod n).
4. `s = k⁻¹ · (z + r · d) mod n`.
5. The signature is `(r, s, v)`.
k is used once and thrown away. A fresh, unpredictable k per signature is essential.

# Why k must be secret and fresh
If an attacker learns `k` for one signature, they can compute the private key `d` from that single signature:
`d = (s · k - z) / r mod n`
If two signatures use the same k, the attacker can recover d from the pair (as I showed earlier). If k is biased or predictable, the attacker can often recover d too. This is why k must come from a cryptographically secure RNG, or be derived deterministically per RFC 6979.

# How to spot it 
- an ECDSA signature is (r, s). r is derived directly from k
`r = (k·G).x mod n`
- So if two signatures from the same signer have the same r value, that's strong evidence they were produced with the same k — exactly the flaw

# once you find matching r values, the private key is gotten with basic modular arithmetic:
Given: (r, s1, h1) for message 1, (r, s2, h2) for message 2, same r

k = (h1 - h2) * modinv(s1 - s2, n)  mod n
d = (s1*k - h1) * modinv(r, n)      mod n                <- d is the private 

where `n` is secp256k1's curve order and `h1/h2` are the two message hashes (exactly what hash_message() computes here).


# how can i know k is reused
An attacker doesn't need to predict k in advance — they just need to watch for a repeated r value across two different signed messages from the same signer





38. Unique NFT:
- EIP-7702 lets an EOA attach code to itself, so the same address can behave like both an EOA and a contract depending on what the code checks. 

- The UniqueNFT contract gives free mints to EOAs (tx.origin == msg.sender) and blocks contracts behind nonReentrant plus a 1 ETH fee. 
- The bug is that _mintNFT calls the ERC-721 receiver hook before _mint, so at hook time balanceOf(msg.sender) is still 0. Normally this doesn't matter because a plain EOA has no code and the hook is skipped, and a contract can't pass tx.origin == msg.sender. 
- But a 7702-delegated EOA has code, so the hook fires, and because the EOA is still tx.origin, the hook's re-entrant call to mintNFTEOA passes the EOA check. Each recursive call sees balanceOf == 0, so it mints again. Result: 6 NFTs minted to the same EOA, bypassing the "one badge per address" rule.




39. forger
# EIP 2098 Compact Signatures
If your contract implements replay protection by marking entire signature bytes as "used," you must be aware that the same signature can exist in both the 65-byte and 64-byte formats.

What it is: A standard for packing an ECDSA signature from 65 bytes (r || s || v) down to 64 bytes (r || vs).
- Why it works:
v only carries 1 bit of info (yParity: 0 or 1).
For canonical signatures (EIP-2), the top bit of s is always 0.
So the top bit of s is free — EIP-2098 uses it to store yParity.

The packing (used in the code):
```solidity
bytes32 vs = bytes32(uint256(s) | (uint256(recoveryId) << 255));
```

40. NotOptimisticPortal























