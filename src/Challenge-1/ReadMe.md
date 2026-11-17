# 🎯 Fallback Challenge
**Ethernaut Level 1 - Foundry Test Suite**

## 📋 Challenge
Claim ownership and drain the contract.

## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/
forge install

# Run test
forge test --match-test test_Challenge1_Passed -vvv

Ethernaut-Challenge/
├── src/
│   └── Challenge-1/
│       ├── Fallback.sol          # Vulnerable contract
│       ├── test/
│       │   └── FallbackTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md