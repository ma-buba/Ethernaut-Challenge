# HigherOrder Challenge
**Ethernaut Level 30 - Foundry Test Suite**

## 📋 Challenge
become commander of higher order to passed this challenge

## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/ 
forge install

# Run test
forge test --match-test test_Challenge30_Passed -vvv

Ethernaut-Challenge/
├── src
│   └── Challenge-30/
│       ├── HigherOrder.sol          # Vulnerable contract
│       ├── test/
│       │   └── HigherOrderTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md  
