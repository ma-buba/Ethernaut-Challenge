
**MY HACKING LAYOUT**

# LAYER 1 (open main contract that users interact with)
`Dex`

# imports
`Dex`
ERC20: the token contract
IERC20: the token interface
**Ownable**: it allows a contract interactions to be restricted to the owner 
`Swappable Token`
**ERC20**
IERC20

# Inheritance map
# flow diagram
# external functions (call path and authors)
`Dex`
owner ---> setTokens() ---> addliquidity() 
user ---> swap() ---> approve()
`Swappable Token`
user ---> approve()
# money variables
# gate variables

# LAYER 2
# define main external functions with the critical flow(go line by line)
`Dex`
- setTokens(): (token1, token2) set tokens to the state variable
- addliquidity(): (tokenaddress, amount)
transfers the specified token from the caller to the `Dex` contract
- swap(): (from, to, amount)
must be valid token pairs, from and to 
balance of caller must be enough
get the swap amount from `getSwapPrice`   
transfer to the Dex the amount from the caller
the Dex transfers the swap amount to the caller, that's the equivalent price for the token sent by the swapper/caller.

# complete diagram

# AFTER LAYER 2: develop attacker mindset
# Read the docs and compare with your mental model
# questions 
1. what is the core invariants
2. what assumptions does this piece of code have, what does code believe is always true(trust assumptions)

# LAYER 3: Research
# find same case from similar protocols and study backward to compare 