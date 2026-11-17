# 🔐 Vault Challenge
**Ethernaut Level 8 - Foundry Test Suite**

## 📋 Challenge
Unlock the vault to pass the level!

## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/ 
forge install

# Run test
forge test --match-test test_Challenge8_Passed -vvv

Ethernaut-Challenge/
├── src/
│   └── Challenge-8/
│       ├── Vault.sol          # Vulnerable contract
│       ├── test/
│       │   └── VaultTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md