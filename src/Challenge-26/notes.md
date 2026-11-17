
**MY HACKING LAYOUT**

# LAYER 1 (open main contract that users interact with)
- Forta
# imports
- Forta, cryptoVault, 
ERC20
ownable
- legacyToken, doubleEntryPoint
inherits: ERC20
ownable
# Inheritance map
# flow diagram
# external functions (call path and authors)
- Forta
user ---> setDetectionBot() ---> notify() ---> raiseAlert()
- cryptoVault
user ---> setUnderlying() ---> sweepToken()
- LegacyToken
user ---> delegateToNewContract()
- DoubleEntryPoint
onlyDelegatedFrom ---> delegateTransfer()
# money variables
# gate variables

# LAYER 2
# define main external functions with the critical flow(go line by line)
- Forta
setDetectionBot(): (detectionBotAddress)
    setDetectionBot address of the caller in the mapping
notify(): (user, msgData)
    return (do nothing) if the user detection bot address is set.
    make a `try/catch` call on `handleTransaction`, in the user detection bot's address.
    if succeeds exits, if fails exits.
raiseAlert(): (user)
    do nothing, if detectionbots address of the user is not the caller.
    increments botRaisedAlerts mapping by 1.

- DoubleEntryPoint
delegatTransfer(): (to, value, origSender)
    caller must be `legacyToken`
    fortaNotify
        get the players detection bot
        get the value of botRaisedAlerts of that same player detection bot.
    transfer token from origSender to `to`    
        reverts if after transfer botRaisedAlerts have been raised

- cryptoVault
sweepToken(): (token)
    token must not be the underlying token.
    transfer the whole token to the sweptTokenRecipient.
# complete diagram

# AFTER LAYER 2: develop attacker mindset
# Read the docs and compare with your mental model
# questions 
1. what is the core invariants
2. what assumptions does this piece of code have, what does code believe is always true(trust assumptions)

# LAYER 3: Research
# find same case from similar protocols and study backward to compare 