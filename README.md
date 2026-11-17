# 🛡️ Ethernaut Solutions — Smart Contract Security Playground

---

## 📖 About

[Ethernaut](https://ethernaut.openzeppelin.com/) is a Web3/Solidity wargame by OpenZeppelin where each level is a smart contract with a hidden vulnerability. The goal is to **break it** — drain funds, take ownership, self-destruct, or otherwise subvert its intended behavior.

This repository is where I:
- 🧪 Write **PoC exploits** for every challenge I solve
- 📝 Document the **root cause**, the **attack vector**, for each bug — inside a `What_I_Learned.md`

The goal isn't just to "win" — it's to build a repeatable process for **finding and reasoning about on-chain vulnerabilities** and to practise writing **clean, verifiable exploit code**.

---

## 🗂️ Repository Structure

Each challenge is self-contained in its own folder — source code and tests all live together.
While all write-ups are consolidated into one master file, `What_I_Learned.md` file.

```
ethernaut-solutions/
├── src/
│   ├── Challenge-1/                # Fallback
│   │   ├── README.md               # describing the goal of the challenge
│   │   ├── Fallback.sol          # Attacker / exploit contract
│   │   └── test/
│   │       └── Fallback.t.sol    # Foundry test asserting the exploit works
│   ├── Challenge-2/                # Fallout
│   │   ├── README.md
│   │   ├── Fallout.sol
│   │   └── test/
│   │       └── Fallout.t.sol
│   ├── ...
│   └── Challenge-40/               # Non-Optimistic Portal
│       ├── README.md
│       ├── NonOptimisticPortal.sol
│       └── test/
│           └── NonOptimisticPortal.t.sol
├── foundry.toml
├── README.md
└── What_I_Learned.md
```
---

## 🚀 Getting Started

### Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation) installed
- Git

### Run the exploits

```bash
git clone https://github.com/<ma-buba>/Ethernaut-Challenge.git
cd Ethernaut-Challenge
forge install
forge test
```

Run a single challenge:

```bash
forge test --match-path "src/Challenge-1/test/*.t.sol" -vvv
```

Check gas / trace an exploit:

```bash
forge test --match-path "src/Challenge-10/test/*.t.sol" -vvvv
```

Run every test inside one challenge folder:

```bash
forge test --match-path "src/Challenge-16/**"
```
---

## 📊 Progress
`Challenges Solved-39/40`

> ✅ Solved · 🟡 In progress · ⬜ Not started

Each row links to the challenge's own `README.md`.

| # | Challenge | Vulnerability Class | Write-up | Status |
|---|-----------|---------------------|:--------:|:------:|
| 1 | Fallback | Access control / `receive()` abuse | [📄](src/Challenge-1/README.md) | ✅ |
| 2 | Fallout | Uninitialized / typo constructor | [📄](src/Challenge-2/README.md) | ✅ |
| 3 | Coin Flip | Weak randomness (block hash) | [📄](src/Challenge-3/README.md) | ✅ |
| 4 | Telephone | `tx.origin` vs `msg.sender` | [📄](src/Challenge-4/README.md) | ✅ |
| 5 | Token | Integer underflow (pre-0.8) | [📄](src/Challenge-5/README.md) | ✅ |
| 6 | Delegation | `delegatecall` storage context | [📄](src/Challenge-6/README.md) | ✅ |
| 7 | Force | `selfdestruct` force-send ETH | [📄](src/Challenge-7/README.md) | ✅ |
| 8 | Vault | Private ≠ secret (storage reads) | [📄](src/Challenge-8/README.md) | ✅ |
| 9 | King | Denial of service via reverting payout | [📄](src/Challenge-9/README.md) | ✅ |
| 10 | Re-entrancy | Reentrancy | [📄](src/Challenge-10/README.md) | ✅ |
| 11 | Elevator | Interface spoofing / unchecked return | [📄](src/Challenge-11/README.md) | ✅ |
| 12 | Privacy | Storage slot packing | [📄](src/Challenge-12/README.md) | ✅ |
| 13 | Gatekeeper One | Gas + `msg.gas` manipulation | [📄](src/Challenge-13/README.md) | ✅ |
| 14 | Gatekeeper Two | Bitwise + contract-creation trick | [📄](src/Challenge-14/README.md) | ✅ |
| 15 | Naught Coin | `transferFrom` bypass of `transfer` lock | [📄](src/Challenge-15/README.md) | ✅ |
| 16 | Preservation | Storage collision via `delegatecall` | [📄](src/Challenge-16/README.md) | ✅ |
| 17 | Recovery | Deterministic contract address | [📄](src/Challenge-17/README.md) | ✅ |
| 18 | MagicNumber | EVM bytecode hand-rolling | [📄](src/Challenge-18/README.md) | ✅ |
| 19 | Alien Codex | Storage collision / dynamic array overflow | [📄](src/Challenge-19/README.md) | ✅ |
| 20 | Denial | Gas griefing | [📄](src/Challenge-20/README.md) | ✅ |
| 21 | Shop | Reentrancy + state read during call | [📄](src/Challenge-21/README.md) | ✅ |
| 22 | Dex | AMM constant-product manipulation | [📄](src/Challenge-22/README.md) | ✅ |
| 23 | Dex Two | Fake token in AMM swap | [📄](src/Challenge-23/README.md) | ✅ |
| 24 | Puzzle Wallet | Proxy storage collision + `multicall` | [📄](src/Challenge-24/README.md) | ✅ |
| 25 | Motorbike | Unprotected `initialize` on implementation | [📄](src/Challenge-25/README.md) | ✅ |
| 26 | DoubleEntryPoint | Allowance bypass via inherited interface | [📄](src/Challenge-26/README.md) | ✅ |
| 27 | Good Samaritan | Malicious `INotify` callback | [📄](src/Challenge-27/README.md) | ✅ |
| 28 | Gatekeeper Three | Access-control chaining | [📄](src/Challenge-28/README.md) | ✅ |
| 29 | Switch | `calldata` encoding & selector abuse | [📄](src/Challenge-29/README.md) | ✅ |
| 30 | HigherOrder | Function-pointer hijack via calldata | [📄](src/Challenge-30/README.md) | ✅ |
| 31 | Stake | Staking logic flaw / reward manipulation | [📄](src/Challenge-31/README.md) | ✅ |
| 32 | Impersonator | Signature / authentication bypass | [📄](src/Challenge-32/README.md) | ✅ |
| 33 | Magic Animal Carousel | Logic / state-machine manipulation | [📄](src/Challenge-33/README.md) | ✅ |
| 34 | Bet House | Betting / randomness exploitation | [📄](src/Challenge-34/README.md) | ✅ |
| 35 | Elliptic Token | ECDSA / elliptic-curve validation issue | [📄](src/Challenge-35/README.md) | ✅ |
| 36 | Cashback | Refund / cashback logic flaw | [📄](src/Challenge-36/README.md) | ✅ |
| 37 | Impersonator Two | Advanced impersonation / auth bypass | [📄](src/Challenge-37/README.md) | ✅ |
| 38 | UniqueNFT | ERC-721 minting / transfer restriction bypass | [📄](src/Challenge-38/README.md) | ✅ |
| 39 | Forger | Forgery / signature replay | [📄](src/Challenge-39/README.md) | ✅ |
| 40 | Non-Optimistic Portal | Cross-domain / portal message validation | [📄](src/Challenge-40/README.md) | ⬜ |

---

## 🔍 Vulnerability Cheat Sheet

A quick reference of the bug classes covered — useful for reviewing before an audit or CTF.

| Class | Challenges | One-line takeaway |
|-------|-----------|------------------|
| **Access Control** | 1, 2, 6, 14, 16, 25, 28 | Never leave critical functions callable by anyone. |
| **Weak Randomness** | 3, 13, 34 | On-chain entropy is public — never use `blockhash`/`timestamp`. |
| **tx.origin** | 4 | Use `msg.sender`; `tx.origin` enables phishing. |
| **Integer Issues** | 5, 19 | Pre-0.8 underflow/overflow; unchecked math still bites. |
| **delegatecall / Storage** | 6, 12, 16, 24 | `delegatecall` runs in *your* storage — layout matters. |
| **Reentrancy** | 10, 21 | Checks-Effects-Interactions + reentrancy guards. |
| **DoS** | 9, 20 | External calls can revert and brick your contract. |
| **Bytecode / EVM** | 18, 30 | Understand opcodes to see what the compiler hides. |
| **AMM Logic** | 22, 23 | Constant-product invariants break with unverified tokens. |
| **Signature / Auth** | 32, 37, 39 | Verify signers and nonces; don't trust `ecrecover` blindly. |
| **NFT / ERC-721** | 38 | Minting and transfer hooks need explicit access checks. |
| **Cross-Domain / Bridge** | 40 | Validate messages on the receiving domain — don't trust the sender's word. |


## 🛠️ Tech Stack

- **Solidity** `0.8.x`
- **Foundry** (`forge`, `cast`, `anvil`)
- **OpenZeppelin Contracts** (where useful)

---

## ⚠️ Disclaimer

These contracts are **intentionally vulnerable exploits** written for **educational purposes only**. Do **not** deploy any of this code to a production network or use it against systems you do not own or have explicit permission to test. Attacking systems without authorization is illegal.

---

## 📄 License

Released under the [MIT License](LICENSE).

---

## 👤 Author

**<ma_buba>**
- GitHub: [@<ma-buba>](https://github.com/<ma-buba>)
- Twitter/X: [@<0xstrikerr>](https://twitter.com/<0xstrikerr>)
- LinkedIn: [<muhammad-abdullahi>](https://linkedin.com/in/<muhammadd-abdullahii-3a5774306>)

> Built while learning smart contract security. Feedback and PRs welcome — if you spot a cleaner exploit, open an issue! 🐛

---

### ⭐ If this helped you understand a challenge, consider starring the repo!