# There are several methods to pass calldata to delegatecall

1. `abi.encodeWithSignature()` (Most Common in Ethernaut)

// ✅ Send calldata to delegatecall
(bool success, ) = address(target).delegatecall(
    abi.encodeWithSignature("pwn()")
);

// With parameters:
(bool success, ) = address(target).delegatecall(
    abi.encodeWithSignature("transfer(address,uint256)", to, amount)
);

2. `abi.encodeWithSelector()` (More Type-Safe)

// ✅ Using function selector directly
(bool success, ) = address(target).delegatecall(
    abi.encodeWithSelector(Delegate.pwn.selector)
);

// With parameters:
(bool success, ) = address(target).delegatecall(
    abi.encodeWithSelector(Delegate.transfer.selector, to, amount)
);

3. `abi.encodeCall()` (Modern, Recommended)

// ✅ Type-safe, compile-time checking
(bool success, ) = address(target).delegatecall(
    abi.encodeCall(Delegate.pwn, ())
);

// With parameters:
(bool success, ) = address(target).delegatecall(
    abi.encodeCall(Delegate.transfer, (to, amount))
);

4. Raw Bytes (Manual Encoding)

// ✅ Hardcoded function selector
(bool success, ) = address(target).delegatecall(
    hex"dd365b8b"  // pwn() selector
);

// ✅ With parameters (manual)
(bool success, ) = address(target).delegatecall(
    abi.encodePacked(bytes4(0xa9059cbb), to, amount)
);

# take away
abi.encodeCall(Delegate.pwn, ()) uses Delegate as a reference to tell the compiler:

"This is the function signature I want to encode"

"This is what the function looks like" (parameters, return types)

"Encode this function call for me"

It does NOT mean the call will execute on Delegate! The actual execution happens on target.