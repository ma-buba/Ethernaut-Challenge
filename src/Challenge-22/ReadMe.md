# Dex Challenge
**Ethernaut Level 22 - Foundry Test Suite**

## 📋 Challenge
Use price manipulation to steal all the funds in the given DEX.

## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/ 
forge install

# Run test
forge test --match-test test_Challenge22_Passed -vvv

Ethernaut-Challenge/
├── src
│   └── Challenge-22/
│       ├── Dex.sol          # Vulnerable contract
│       ├── test/
│       │   └── DexTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md 