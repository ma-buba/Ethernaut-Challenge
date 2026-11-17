
**MY HACKING LAYOUT**

# LAYER 1 (open main contract that users interact with)
`DEX TWO`

# imports
ERC20
IERC20
Ownable
# Inheritance map
# flow diagram
# external functions (call path and authors)
owner ---> setTokens() ---> add_liquidity() 
user ---> swap()
# money variables
# gate variables

# LAYER 2
# define main external functions with the critical flow(go line by line)
- add_liquidity(): (token address, amount)
transfer amount from sender to the dex contract
- swap(): (from, to, amount)
caller must have enougth token to send
get the swap amount to receive
transfer token to swap from caller to the dex       // q which token, wait is any token validity verified?
transfer the caller the swap amount of the swapped token
# complete diagram

# AFTER LAYER 2: develop attacker mindset
# Read the docs and compare with your mental model
# questions 
1. what is the core invariants and trust assumptions
swap amount is always true.
caller will swap between valid tokens
the owner will always add liquidity for the valid deployed tokens of the pool, what if he made a mistake.
the owner will use different address when setting tokens.
2. what assumptions does this piece of code have, what does code believe is always true(trust assumptions)
it assumes the caller is always swapping between token1 and token2. what if he passes the address of another token and swap for the real contract token.

# LAYER 3: Research
# find same case from similar protocols and study backward to compare 