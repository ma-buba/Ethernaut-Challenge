
**MY HACKING LAYOUT**

# LAYER 1 (open main contract that users interact with)
# imports
# Inheritance map
# flow diagram
# external functions (call path and authors)
user ---> setAnimalAndSpin() ---> changeAnimal() ---> 
# money variables
# gate variables

# LAYER 2
# define main external functions with the critical flow(go line by line)
- setAnimalAndSpin()
    get encodedAnimal(animal):
        length of animal must not be > 12
        shift the 12 bytes to the right most as uint256
        shift the same further 2 bytes 
    get nextCrateId
    encoded animal must not be more than 10 bytes



# complete diagram

# AFTER LAYER 2: develop attacker mindset
# Read the docs and compare with your mental model
# questions 
1. what is the core invariants
2. what assumptions does this piece of code have, what does code believe is always true(trust assumptions)

# LAYER 3: Research
# find same case from similar protocols and study backward to compare 