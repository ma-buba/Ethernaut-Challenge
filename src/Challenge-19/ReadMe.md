# AlienCodex Challenge
**Ethernaut Level 19 - Foundry Test Suite**

## 📋 Challenge
Claim ownership of the AlienCodex contract to finish this challenge.

## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/ 
forge install

# Run test
forge test --match-test test_Challenge19_Passed -vvv

Ethernaut-Challenge/
├── src
│   └── Challenge-19/
│       ├── AlienCodex.sol          # Vulnerable contract
│       ├── test/
│       │   └── AlienCodexTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md 