
**MY HACKING LAYOUT**

# LAYER 1 (open main contract that users interact with)
# imports
# Inheritance map
# flow diagram
# external functions (call path and authors)
user ---> stakeETH() ---> stakeWETH() ---> Unstake() 
# money variables
totalStaked
UserStake
Stakers
# gate variables

# LAYER 2
# define main external functions with the critical flow(go line by line)
- stakeETH()
    must deposit > 0.001 ether
    update the ether deposited to totalStaked
    update caller deposit in mapping `UserStake`
    update caller in `stakers` mapping
- stakeWETH(): (amount)
    must deposit > 0.001 ether
    check the allowance caller has given the contract
    allowance must >= amount
    update totalstaked
    update userstake
    transfer tokens from caller to the contract
    update stakers
    return transfer status
- Unstake(): (amount)
    userstake must >= amount
    deduct amount from userstake
    deduct from total staked
    send eth `amount` to caller

# complete diagram

# AFTER LAYER 2: develop attacker mindset
# Read the docs and compare with your mental model
# questions 
1. what is the core invariants
2. what assumptions does this piece of code have, what does code believe is always true(trust assumptions)

# LAYER 3: Research
# find same case from similar protocols and study backward to compare 