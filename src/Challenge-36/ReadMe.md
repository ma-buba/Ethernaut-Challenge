# Cashback Challenge
**Ethernaut Level 36 - Foundry Test Suite**

## 📋 Challenge


## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/ 
forge install

# Run test
forge test --match-test test_Challenge36_Passed -vvv

Ethernaut-Challenge/
├── src
│   └── Challenge-36/
│       ├── Cashback.sol          # Vulnerable contract
│       ├── test/
│       │   └── CashbackTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md  
