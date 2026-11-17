
**MY HACKING LAYOUT**

# LAYER 1 (open main contract that users interact with)
# imports

# Inheritance map
# flow diagram
# external functions (call path and authors)
- gatekeeperthree
user ---> createTrick()
- simpleTrick 
user ---> trickInit() ---> trickyTrick()
# money variables
# gate variables

# LAYER 2
# define main external functions with the critical flow(go line by line)
- gatekeeperThree
createTrick()
    deploy SimpleTrick with passing the address of gatekeeper as argument.
    initialize trick with `trickInit()`
- SimpleTrick
trickInit()
    set trick to address of the SimpleTrick
trickyTrick()
    if the SimpleTrick is the caller AND trick is not initialize with `trick()`
        check if the password is true
        set allowEntrance in gatekeeper to true
# complete diagram

# AFTER LAYER 2: develop attacker mindset
# Read the docs and compare with your mental model
# questions 
1. what is the core invariants
2. what assumptions does this piece of code have, what does code believe is always true(trust assumptions)

# LAYER 3: Research
# find same case from similar protocols and study backward to compare 