# 🔐 Privacy Challenge
**Ethernaut Level 12 - Foundry Test Suite**

## 📋 Challenge
The creator of this contract was careful enough to protect the sensitive areas of its storage.
Unlock this contract to beat the level.

## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/ 
forge install

# Run test
forge test --match-test test_Challenge12_Passed -vvv

Ethernaut-Challenge/
├── src
│   └── Challenge-12/
│       ├── Privacy.sol          # Vulnerable contract
│       ├── test/
│       │   └── PrivacyTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md