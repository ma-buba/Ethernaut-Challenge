# NotOptimisticPortal Challenge
**Ethernaut Level 40 - Foundry Test Suite**

## 📋 Challenge


## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/ 
forge install

# Run test
forge test --match-test test_Challenge40_Passed -vvv

Ethernaut-Challenge/
├── src
│   └── Challenge-40/
│       ├── NotOptimisticPortal.sol          # Vulnerable contract
│       ├── test/
│       │   └── NotOptimisticPortalTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md  
