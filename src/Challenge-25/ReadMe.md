# MotorBike Challenge
**Ethernaut Level 25 - Foundry Test Suite**

## 📋 Challenge
Ethernaut's motorbike has a brand new upgradeable engine design.
selfdestruct its engine and make the motorbike unusable to pass this challenge.

## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/ 
forge install

# Run test
forge test --match-test test_Challenge25_Passed -vvv

Ethernaut-Challenge/
├── src
│   └── Challenge-25/
│       ├── MotorBike.sol          # Vulnerable contract
│       ├── test/
│       │   └── MotorBikeTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md 