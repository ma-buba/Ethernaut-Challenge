# 🚪🏢 Elevator Challenge
**Ethernaut Level 11 - Foundry Test Suite**

## 📋 Challenge
This elevator won't let you reach the top of your building,
reach the top of the building to pass this challenge.

## 🚀 Quick Start

```bash
# Clone & install
git clone https://github.com/ma-buba/Ethernaut-Challenge
cd Ethernaut-Challenge/ 
forge install

# Run test
forge test --match-test test_Challenge11_Passed -vvv

Ethernaut-Challenge/
├── src
│   └── Challenge-11/
│       ├── Elevator.sol          # Vulnerable contract
│       ├── test/
│       │   └── ElevatorTest.t.sol  # Exploit test
│       └── README.md             # This file
├── foundry.toml
└── README.md