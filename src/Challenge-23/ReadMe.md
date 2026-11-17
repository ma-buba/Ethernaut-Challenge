# DexTwo Challenge
**Ethernaut Level 23 - Foundry Test Suite**

## 📋 Challenge
Steal all the funds in the given DEX.

## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/ 
forge install

# Run test
forge test --match-test test_Challenge23_Passed -vvv

Ethernaut-Challenge/
├── src
│   └── Challenge-23/
│       ├── DexTwo.sol          # Vulnerable contract
│       ├── test/
│       │   └── DexTwoTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md 