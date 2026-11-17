# 👑 King Challenge
**Ethernaut Level 9 - Foundry Test Suite**

## 📋 Challenge
Become the king and make it impossible for anyone else to claim the throne! 🏰

## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/ 
forge install

# Run test
forge test --match-test test_Challenge9_Passed -vvv

Ethernaut-Challenge/
├── src/
│   └── Challenge-9/
│       ├── King.sol          # Vulnerable contract
│       ├── test/
│       │   └── KingTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md