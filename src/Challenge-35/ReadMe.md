# EllipticToken Challenge
**Ethernaut Level 35 - Foundry Test Suite**

## 📋 Challenge


## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/ 
forge install

# Run test
forge test --match-test test_Challenge35_Passed -vvv

Ethernaut-Challenge/
├── src
│   └── Challenge-35/
│       ├── EllipticToken.sol          # Vulnerable contract
│       ├── test/
│       │   └── EllipticTokenTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md  
