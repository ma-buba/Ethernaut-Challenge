# 🤜 Force Challenge
**Ethernaut Level 7 - Foundry Test Suite**

## 📋 Challenge
The goal of this level is to make the balance of the contract greater than zero.

## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/ 
forge install

# Run test
forge test --match-test test_Challenge7_Passed -vvv

Ethernaut-Challenge/
├── src/
│   └── Challenge-7/
│       ├── Force.sol          # Vulnerable contract
│       ├── test/
│       │   └── ForceTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md