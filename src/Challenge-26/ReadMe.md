# DoubleEntryPoint Challenge
**Ethernaut Level 26 - Foundry Test Suite**

## 📋 Challenge
do the following tasks to complete the challenge
1. Find the bug in CryptoVault
2. Implement a detection bot and register it in the Forta contract to protect the vault.


## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/ 
forge install

# Run test
forge test --match-test test_Challenge26_Passed -vvv

Ethernaut-Challenge/
├── src
│   └── Challenge-26/
│       ├── DoubleEntryPoint.sol          # Vulnerable contract
│       ├── test/
│       │   └── DoubleEntryPointTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md 