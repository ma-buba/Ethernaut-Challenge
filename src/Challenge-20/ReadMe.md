# Denial Challenge
**Ethernaut Level 20 - Foundry Test Suite**

## 📋 Challenge
deny the owner to be able to move funds when they call withdraw.

## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/ 
forge install

# Run test
forge test --match-test test_Challenge20_Passed -vvv

Ethernaut-Challenge/
├── src
│   └── Challenge-20/
│       ├── Denial.sol          # Vulnerable contract
│       ├── test/
│       │   └── DenialTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md 