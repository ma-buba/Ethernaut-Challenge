
**MY HACKING LAYOUT**

# LAYER 1 (open main contract that users interact with)
# imports
# Inheritance map
# flow diagram
# external functions (call path and authors)

# money variables
# gate variables

# LAYER 2
# define main external functions with the critical flow(go line by line)
- redeemVoucher(): (amount, receiver, salt, ownerSignature, receiverSignature)
    get the voucher Hash: (amount, receiver, salt)
    revert if vouchet hash is used
    verify that owner have signed the voucher
    verify that receiver have signed the voucher
    set the voucher hash as used voucher
    mint receiver the `amount`
- permit(): (amount, spender, tokenOwnerSignature, spenderSignature)
    get the permit hash: (amount)
    revert if hash is used
    get the token owner from signature
    get the permit hash: (tokenOwner, spender, amount)
    spender must sign the permit hash
    set the permit hash as used
    owner has approve spender `amounts`
# complete diagram

# AFTER LAYER 2: develop attacker mindset
# Read the docs and compare with your mental model
# questions 
1. what is the core invariants
2. what assumptions does this piece of code have, what does code believe is always true(trust assumptions)

# LAYER 3: Research
# find same case from similar protocols and study backward to compare 