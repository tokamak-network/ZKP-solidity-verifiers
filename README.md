# zkEVM Verifier Comparison
This repository is dedicated to comparing different zkEVM verifiers, specifically focusing on zkSync Era, Polygon, and Linea. zkEVMs are Layer 2 scaling solutions that leverage zero-knowledge proofs to enhance Ethereum's scalability while maintaining security and decentralization. By providing EVM compatibility, zkEVMs allow developers to deploy smart contracts using familiar tools and languages.

## Purpose
The primary goal of this repository is to evaluate and compare the performance, compatibility, and unique features of various zkEVM verifiers. By importing the Solidity code for each verifier and creating a comprehensive test suite, we aim to provide insights into their operational differences and potential use cases.

## Features
zkSync Era: Known for its Type 4 zkEVM, zkSync Era focuses on speed and scalability with a custom VM, offering native account abstraction and compatibility with Solidity 0.8.25.

Polygon zkEVM: A Type 3 zk-Rollup, Polygon zkEVM aims for EVM equivalence, providing high security and compatibility with existing Ethereum tools, suitable for high-value transactions.

## Test Suite
Each verifier is subjected to a series of tests designed to assess:

Performance: Evaluating transaction throughput and proof generation times.
Compatibility: Testing EVM opcode support and integration with Ethereum tools.
Security: Analyzing the robustness of zero-knowledge proofs and data availability mechanisms.
Getting Started
To explore the comparisons and run the tests yourself, follow these steps:

Clone the repository:
```
git clone <https://github.com/tokamak-network/ZKP-solidity-verifiers.git>
```
Run the foundry test suite: (zkSyncEra verifier) 
```
forge test --mp test/zkSyncEra-verifier.t.sol
```
Run the foundry test suite: (Linea verifier) 
```
forge test --mp test/linea-verifier.t.sol
```

Compile the Polygon zkEVM contracts :
```
npm install --force
npx hardhat compile
```
Run the hardhat test suite: (Polygon zkEVM)
```
npm run test
```
note: the ERC1967Utils contract is sometimes not compatible with Polygon v2 contracts. If it is the case, please modify the contract by manually importing the events inside of the contract.
## Conclusion
This repository serves as a resource for developers and researchers interested in understanding the nuances of zkEVM verifiers. By comparing zkSync Era, Polygon, and Linea, we hope to contribute to the ongoing discussion about the best approaches to scaling Ethereum.