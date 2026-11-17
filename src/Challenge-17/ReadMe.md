# 🔍 Recovery Challenge
**Ethernaut Level 17 - Foundry Test Suite**

## 📋 Challenge
This level will be completed if you can recover (or remove) the 0.001 ether from the lost contract address. 


## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/ 
forge install

# Run test
forge test --match-test test_Challenge17_Passed -vvv

Ethernaut-Challenge/
├── src
│   └── Challenge-17/
│       ├── Recovery.sol          # Vulnerable contract
│       ├── test/
│       │   └── RecoveryTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md