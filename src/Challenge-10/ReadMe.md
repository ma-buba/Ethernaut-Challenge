# 🔄 Reentrancy Challenge
**Ethernaut Level 10 - Foundry Test Suite**

## 📋 Challenge
Drain all ETH from the contract using a reentrancy attack! 💰

## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/ 
forge install

# Run test
forge test --match-test test_Challenge10_Passed -vvv

Ethernaut-Challenge/
├── src/
│   └── Challenge-10/
│       ├── Reentrancy.sol          # Vulnerable contract
│       ├── test/
│       │   └── ReentrancyTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md