# PuzzleWallet Challenge
**Ethernaut Level 24 - Foundry Test Suite**

## 📋 Challenge
hijack the wallet and become admin of the proxy, to pass this challenge.

## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/ 
forge install

# Run test
forge test --match-test test_Challenge24_Passed -vvv

Ethernaut-Challenge/
├── src
│   └── Challenge-24/
│       ├── PuzzleWallet.sol          # Vulnerable contract
│       ├── test/
│       │   └── PuzzleWalletTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md 