# 🎰 CoinFlip Challenge
**Ethernaut Level 3 - Foundry Test Suite**

## 📋 Challenge
To complete this level you'll need to use your psychic abilities to guess the correct outcome 10 times in a row.

## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/
forge install

# Run test
forge test --match-test test_Challenge3_Passed -vvv

Ethernaut-Challenge/
├── src/
│   └── Challenge-3/
│       ├── CoinFlip.sol          # Vulnerable contract
│       ├── test/
│       │   └── CoinFlipTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md