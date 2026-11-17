# Impersonator Challenge
**Ethernaut Level 32 - Foundry Test Suite**

## 📋 Challenge


## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/ 
forge install

# Run test
forge test --match-test test_Challenge32_Passed -vvv

Ethernaut-Challenge/
├── src
│   └── Challenge-32/
│       ├── Impersonator.sol          # Vulnerable contract
│       ├── test/
│       │   └── ImpersonatorTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md  
