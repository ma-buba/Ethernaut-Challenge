# Stake Challenge
**Ethernaut Level 31 - Foundry Test Suite**

## 📋 Challenge


## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/ 
forge install

# Run test
forge test --match-test test_Challenge31_Passed -vvv

Ethernaut-Challenge/
├── src
│   └── Challenge-31/
│       ├── Stake.sol          # Vulnerable contract
│       ├── test/
│       │   └── StakeTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md  
