
**MY HACKING LAYOUT**

# LAYER 1 (open main contract that users interact with)
# imports
# Inheritance map
# flow diagram
# external functions (call path and authors)
user  ---> deposit() ---> withdrawAll()
# money variables
# gate variables

# LAYER 2
# define main external functions with the critical flow(go line by line)
- Pool
    deposit():(value)
        deposit must not be locked
        if ether deposited is 0.001:
            revert if already deposited
            update the amount of eth deposited by the caller `depositedEther`
            flag already deposited
            update in memory `valueToMint` + 10
        if value to deposit > 0
            check Pool tokenAllowance 
            update the value of token deposited by the caller `depositedPDT`
            transfer token from caller to the contract.
            update in memory `valueToMint` + 10
        revert if `valueToMint` = 0
        mint the caller `valueToMint`
    withdrawAll(): 
        get the deposited value from depositedPDT
        if deposited value > 0
            set it to 0 
            transfer deposited value to caller 
        get the deposited value from depositedEther
        if deposited value > 0
            set it to 0
            transfer value to caller
        burn callers token

# complete diagram

# AFTER LAYER 2: develop attacker mindset
# Read the docs and compare with your mental model
# questions 
1. what is the core invariants
it assumes caller has some balance of the wrappedToken and burns it 

2. what assumptions does this piece of code have, what does code believe is always true(trust assumptions)

# LAYER 3: Research
# find same case from similar protocols and study backward to compare 