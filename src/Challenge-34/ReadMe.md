# BetHouse Challenge
**Ethernaut Level 34 - Foundry Test Suite**

## 📋 Challenge


## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/ 
forge install

# Run test
forge test --match-test test_Challenge34_Passed -vvv

Ethernaut-Challenge/
├── src
│   └── Challenge-34/
│       ├── BetHouse.sol          # Vulnerable contract
│       ├── test/
│       │   └── BetHouseTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md  
