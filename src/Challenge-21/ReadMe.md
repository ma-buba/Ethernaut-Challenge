# Shop Challenge
**Ethernaut Level 21 - Foundry Test Suite**

## 📋 Challenge
get the item from the shop for less than the price asked to finish this challenge.

## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/ 
forge install

# Run test
forge test --match-test test_Challenge21_Passed -vvv

Ethernaut-Challenge/
├── src
│   └── Challenge-21/
│       ├── Shop.sol          # Vulnerable contract
│       ├── test/
│       │   └── ShopTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md 