
**MY HACKING LAYOUT**

# LAYER 1 (open main contract that users interact with)
- Engine
# imports
- Engine
inherits Initializable
# Inheritance map
# flow diagram
# external functions (call path and authors)
- Engine 
user ---> initialize() ---> upgradeToAndCall() 
# money variables
# gate variables
- Engine 
`upgrader`
`horsePower`

# LAYER 2
# define main external functions with the critical flow(go line by line)
- Engine
initialize():
    set `horsePower` to 1000
    set caller the `upgrader`
upgradeToAndCall(): (newImplementation, data)
    _authorizeUpgrade():
        caller must be the upgrader
    _upgradeToAndCall(newImplementation, data)
        call `setImplementation()` to set the new Implementation
        if data not empty
            delegatecall the data with the newImplementation as the target.
# complete diagram

# AFTER LAYER 2: develop attacker mindset
# Read the docs and compare with your mental model
# questions 
1. what is the core invariants
2. what assumptions does this piece of code have, what does code believe is always true(trust assumptions)

# LAYER 3: Research
# find same case from similar protocols and study backward to compare 