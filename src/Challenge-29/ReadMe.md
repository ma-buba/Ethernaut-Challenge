# Switch Challenge
**Ethernaut Level 29 - Foundry Test Suite**

## 📋 Challenge
flip the switch ON to pass this challenge

## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/ 
forge install

# Run test
forge test --match-test test_Challenge29_Passed -vvv

Ethernaut-Challenge/
├── src
│   └── Challenge-29/
│       ├── Switch.sol          # Vulnerable contract
│       ├── test/
│       │   └── SwitchTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md  
