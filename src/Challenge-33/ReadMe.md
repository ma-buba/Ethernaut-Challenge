# MagicAnimal Challenge
**Ethernaut Level 33 - Foundry Test Suite**

## 📋 Challenge


## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/ 
forge install

# Run test
forge test --match-test test_Challenge33_Passed -vvv

Ethernaut-Challenge/
├── src
│   └── Challenge-33/
│       ├── MagicAnimal.sol          # Vulnerable contract
│       ├── test/
│       │   └── MagicAnimalTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md  
