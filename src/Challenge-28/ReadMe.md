# GatekeeperThree Challenge
**Ethernaut Level 28 - Foundry Test Suite**

## 📋 Challenge
pass the gate and become the entrant

## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/ 
forge install

# Run test
forge test --match-test test_Challenge28_Passed -vvv

Ethernaut-Challenge/
├── src
│   └── Challenge-28/
│       ├── GatekeeperThree.sol          # Vulnerable contract
│       ├── test/
│       │   └── GatekeeperThreeTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md  
