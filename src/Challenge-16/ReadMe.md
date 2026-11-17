# 🏛️ Preservation Challenge
**Ethernaut Level 16 - Foundry Test Suite**

## 📋 Challenge
The goal of this level is for you to claim ownership of the instance you are given.


## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/ 
forge install

# Run test
forge test --match-test test_Challenge16_Passed -vvv

Ethernaut-Challenge/
├── src
│   └── Challenge-16/
│       ├── Preservation.sol          # Vulnerable contract
│       ├── test/
│       │   └── PreservationTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md