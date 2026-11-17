
**MY HACKING LAYOUT**

# LAYER 1 (open main contract that users interact with)
# imports
- Cashback
    IERC20
    IERC721
    ERC1155: pool that can handle different token
    Transient Slot: This library is a type-safe wrapper around transient storage (TSTORE/TLOAD). It lets you read and write typed values to   
      transient storage slots without writing inline assembly yourself.

# Inheritance map
# flow diagram
# external functions (call path and authors)
# money variables
# gate variables

# LAYER 2
# define main external functions with the critical flow(go line by line)
- Cashback
    accrueCashback(currency, amount)
        caller EOA must be delegated to the `CASHBACK_ACCOUNT`
        cash must be unlocked in transient storage 
        only on cashback can it be called
        get the newNonce:
        get the cashback = (amount * cashbackRates[currency]) / BASIS_POINTS;
        if cashback is not 0:
            get maximum cashback of the currency from mapping 
            if (caller token balance + cashback) > maxCashback:
                get the cashback = maxCashback - caller token balance
                mints cashback amount of tokenID to caller;
        if nonce reaches 10,000:
            mint to the caller super cash back NFT
            req success
    payWithCashback(currency, receiver, amount)
        call must be from EOA
        UNLOCK TOKEN
        transfer amount to the receiver
        accrueCashback (currency, amount)

# complete diagram

# AFTER LAYER 2: develop attacker mindset
# Read the docs and compare with your mental model
# questions 
1. what is the core invariants
2. what assumptions does this piece of code have, what does code believe is always true(trust assumptions)

# LAYER 3: Research
# find same case from similar protocols and study backward to compare 