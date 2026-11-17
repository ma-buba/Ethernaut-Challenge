# 🎯 Fallout Challenge
**Ethernaut Level 2 - Foundry Test Suite**

## 📋 Challenge
Claim ownership of the contract.

## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/
forge install

# Run test
forge test --match-test test_Challenge2_Passed -vvv

Ethernaut-Challenge/
├── src/
│   └── Challenge-2/
│       ├── Fallout.sol          # Vulnerable contract
│       ├── test/
│       │   └── FalloutTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md