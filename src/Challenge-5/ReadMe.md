# 💰 Token Challenge
**Ethernaut Level 5 - Foundry Test Suite**

## 📋 Challenge
You are given 20 tokens to start with and you will beat the level if you somehow manage to 
get your hands on any additional tokens. Preferably a very large amount of tokens.

## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/
forge install

# Run test
forge test --match-test test_Challenge5_Passed -vvv

Ethernaut-Challenge/
├── src/
│   └── Challenge-5/
│       ├── Token.sol          # Vulnerable contract
│       ├── test/
│       │   └── TokenTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md