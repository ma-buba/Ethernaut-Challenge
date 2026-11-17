# 🎭 NaughtCoin Challenge
**Ethernaut Level 15 - Foundry Test Suite**

## 📋 Challenge
Complete this level by getting your token balance freely to 0.


## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/ 
forge install

# Run test
forge test --match-test test_Challenge15_Passed -vvv

Ethernaut-Challenge/
├── src
│   └── Challenge-15/
│       ├── NaughtyCoin.sol          # Vulnerable contract
│       ├── test/
│       │   └── NaughtyCoinTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md