# 📞 Telephone Challenge
**Ethernaut Level 4 - Foundry Test Suite**

## 📋 Challenge
Claim the ownership of the contract below to complete this level.

## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/
forge install

# Run test
forge test --match-test test_Challenge4_Passed -vvv

Ethernaut-Challenge/
├── src/
│   └── Challenge-4/
│       ├── Telephone.sol          # Vulnerable contract
│       ├── test/
│       │   └── TelephoneTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md