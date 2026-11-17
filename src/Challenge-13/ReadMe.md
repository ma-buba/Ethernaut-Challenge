# 🚪 GatekeeperOne Challenge
**Ethernaut Level 13 - Foundry Test Suite**

## 📋 Challenge
Make it past the gatekeeper and register as an entrant to pass this level.

## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/ 
forge install

# Run test
forge test --match-test test_Challenge13_Passed -vvv

Ethernaut-Challenge/
├── src
│   └── Challenge-13/
│       ├── GatekeeperOne.sol          # Vulnerable contract
│       ├── test/
│       │   └── GatekeeperOneTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md