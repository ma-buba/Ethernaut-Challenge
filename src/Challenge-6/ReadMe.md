# 🤝 Delegation Challenge
**Ethernaut Level 6 - Foundry Test Suite**

## 📋 Challenge
The goal of this level is for you to claim ownership of the instance(Delegation) you are given.

## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/
forge install

# Run test
forge test --match-test test_Challenge6_Passed -vvv

Ethernaut-Challenge/
├── src/
│   └── Challenge-6/
│       ├── Delegation.sol          # Vulnerable contract
│       ├── test/
│       │   └── DelegationTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md