
**MY HACKING LAYOUT**

# LAYER 1 (open main contract that users interact with)
# imports
- GoodSamaritan, coin, wallet 
Address.sol
# Inheritance map
# flow diagram
# external functions (call path and authors)
- GoodSamaritan 
user ---> requestDonation() 
- Coin 
user ---> transfer()
- wallet 
owner ---> donate10() ---> transferRemainder()
# money variables
# gate variables

# LAYER 2
# define main external functions with the critical flow(go line by line)
- GoodSamaritan 
requestDonation(): 
    try/catch: donate 10 coins to the caller from `wallet` contract
        returns true if successful
        execute this if false
            if the revert error is "NotEnoughBalance()"
            transfer the remainder of the wallet to the caller.
            return false

- Coin 
transfer(): (dest, amount)
    get currentBalance of caller from `balances` mapping
    if amount <= currentBalance
        deduct amount from `balances` mapping of the caller
        add amount to `balances` mapping of the dest.
        if dest is a contract, notify contract
    revert if amount is more than balances

- wallet
donate10(): (dest)
    coin balances of wallet must be 10 or more
    tranfer 10 coin to the dest.
transferRemainder(): (dest)
    tranfers the balance left to the dest 
# complete diagram

# AFTER LAYER 2: develop attacker mindset
# Read the docs and compare with your mental model
# questions 
1. what is the core invariants
2. what assumptions does this piece of code have, what does code believe is always true(trust assumptions)

# LAYER 3: Research
# find same case from similar protocols and study backward to compare 