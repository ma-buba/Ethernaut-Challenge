# ImpersonatorTwo Challenge
**Ethernaut Level 37 - Foundry Test Suite**

## 📋 Challenge


## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/ 
forge install

# Run test
forge test --match-test test_Challenge37_Passed -vvv

Ethernaut-Challenge/
├── src
│   └── Challenge-37/
│       ├── ImpersonatorTwo.sol          # Vulnerable contract
│       ├── test/
│       │   └── ImpersonatorTwoTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md  
