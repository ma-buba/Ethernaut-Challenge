# MagicNumber Challenge
**Ethernaut Level 18 - Foundry Test Suite**

## 📋 Challenge
To solve this level, you only need to provide the Ethernaut with a Solver, 
a contract that responds to whatIsTheMeaningOfLife() with the right 32 byte number.

## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/ 
forge install

# Run test
forge test --match-test test_Challenge18_Passed -vvv

Ethernaut-Challenge/
├── src
│   └── Challenge-18/
│       ├── MagicNumber.sol          # Vulnerable contract
│       ├── test/
│       │   └── MagicNumberTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md 