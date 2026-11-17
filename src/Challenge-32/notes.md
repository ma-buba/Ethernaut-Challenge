
**MY HACKING LAYOUT**

# LAYER 1 (open main contract that users interact with)
# imports

# Inheritance map
# flow diagram
# external functions (call path and authors)
- Impersonator 
owner ---> deployNewLock()
- ECLocker
user ---> open() ---> ChangeController() 
# money variables
# gate variables

# LAYER 2
# define main external functions with the critical flow(go line by line)
- Impersonator
deployNewLock(): (signature)
    deploy ECLocker
    push ECLocker to lockers array 
    emit
- ECLocker
constructor(): (lockId, signature)
    update lockId var
    compute message hash
    update msgHash local var
    create initialController to address(1)
    
# complete diagram

# AFTER LAYER 2: develop attacker mindset
# Read the docs and compare with your mental model
# questions 
1. what is the core invariants
2. what assumptions does this piece of code have, what does code believe is always true(trust assumptions)

# LAYER 3: Research
# find same case from similar protocols and study backward to compare 