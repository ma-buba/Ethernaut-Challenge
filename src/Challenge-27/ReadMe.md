# GoodSamaritan Challenge
**Ethernaut Level 27 - Foundry Test Suite**

## 📋 Challenge
drain the coin in the wallet to pass this challenge


## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/ 
forge install

# Run test
forge test --match-test test_Challenge27_Passed -vvv

Ethernaut-Challenge/
├── src
│   └── Challenge-27/
│       ├── GoodSamaritan.sol          # Vulnerable contract
│       ├── test/
│       │   └── GoodSamaritanTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md 