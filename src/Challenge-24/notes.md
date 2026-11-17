
**MY HACKING LAYOUT**

# LAYER 1 (open main contract that users interact with)
- puzzlewallet:
- puzzleProxy:
# imports
- puzzlewallet: 
upgradeableProxy: allow for contract upgrade
- puzzleProxy:
inherits upgradeProxy:

# Inheritance map
# flow diagram
# external functions (call path and authors)
- puzzlewallet:
user ---> init() 
whitelisted ---> setMaxBalance() ---> deposit() ---> execute() ---> multicall() 
owner ---> addWhitelist()  

# money variables
# gate variables

# LAYER 2
# define main external functions with the critical flow(go line by line)
- PUZZLE WALLET:
- deposit():  
balance of the contract must not be more than maximum balance, after depositing, what if self destruct is used. 
set on the balances (mapping --> caller) the eth deposited.
- execute(): (to, value, data)
balance of sender in the balances mapping must reached the value in the argument.
deduct value from the balances mapping of the caller.
transfer to `to` the `value` amount, using low level call.
- multicall(): (data)
bool depositCalled = false
loop:
    get the index of the data.
    create var `selector`.
    skipping the first 32 bytes of the data in assembly, loads the actual data. 
    which then we truncate just the selector and stored.
    if the selector stored is deposit().
        revert if deposit is called before, in this very multi call.
        assign deposit called to true.
    delegate call to the very contract, puzzle wallet.
    require success.
# complete diagram

# AFTER LAYER 2: develop attacker mindset
# Read the docs and compare with your mental model
# questions 
1. what is the core invariants
2. what assumptions does this piece of code have, what does code believe is always true(trust assumptions)

# LAYER 3: Research
# find same case from similar protocols and study backward to compare 