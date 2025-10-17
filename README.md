# prosciutto

<div align="center">
  <img src="public/prosciutto.png" alt="Prosciutto Logo" width="200"/>
</div>

A Foundry toolkit providing network configuration management, chain metadata, and deployment utilities for multi-chain Ethereum development.

## Overview

prosciutto is a Foundry library designed to simplify multi-chain development workflows. It provides a robust configuration system with comprehensive blockchain metadata, inspired by viem's chain definitions, enabling seamless deployments across 17+ networks.

## Core Features

### **ProChains Library**

- **17+ Supported Networks**: Ethereum, Arbitrum, Optimism, Base, Polygon, Avalanche, BSC, zkSync, and more
- **Rich Chain Metadata**: RPC URLs, block explorers, native currencies, contract addresses
- **viem-Compatible**: Adapted from viem's comprehensive chain definitions
- **Network Classification**: Automatic mainnet/testnet/local detection

### **ProConfig System**

- **Abstract Configuration**: Generic base class for any domain (DeFi, NFT, Gaming, etc.)
- **Environment-Aware**: Automatic network detection and configuration
- **Extensible Design**: Easy to add domain-specific configuration fields
- **Best Practices**: Following Cyfrin's HelperConfig patterns

### **Additional Utilities**

- **ProScript**: Enhanced script functionality with deployment tracking
- **ProFs**: File system utilities for Foundry scripts
- **ProLanguages**: Language and localization support
- **ProZkSync**: zkSync-specific utilities

## Installation

```bash
forge install your-org/prosciutto
```

## Quick Start

### Basic Configuration

```solidity
import {ProConfig} from "prosciutto/ProConfig.sol";
import {ProChains} from "prosciutto/ProChains.sol";

contract MyDeployer is ProConfig {
    constructor() {
        _initializeDefaultConfigs();
    }

    function deploy() external {
        // Get rich chain metadata
        ProChains.Chain memory chain = getCurrentChain();
        BaseNetworkConfig memory config = getNetworkConfig();

        vm.startBroadcast(config.deployerKey);

        console.log("Deploying to:", chain.name);
        console.log("Native Currency:", chain.nativeCurrency.symbol);
        console.log("Block Explorer:", chain.blockExplorer.url);

        // Your deployment logic here

        vm.stopBroadcast();
    }
}
```

### Domain-Specific Extension

```solidity
contract DeFiDeployer is ProConfig {
    struct DeFiConfig {
        uint256 deployerKey;
        address deployer;
        ProChains.Chain chain;
        // Add your domain-specific fields
        address priceFeed;
        address token;
        address entryPoint;
    }

    function getDeFiConfig() public view returns (DeFiConfig memory) {
        // Implement domain-specific configuration logic
    }
}
```

## Supported Networks

**Mainnets:** Ethereum, Arbitrum One, Optimism, Base, Polygon, Avalanche, BSC, zkSync Era  
**Testnets:** Sepolia, Arbitrum Sepolia, Optimism Sepolia, Base Sepolia, Polygon Mumbai, Avalanche Fuji, BSC Testnet, zkSync Sepolia  
**Development:** Local/Anvil

Each network includes comprehensive metadata: RPC URLs, block explorers, native currency details, standard contract addresses (Multicall3, ENS), and more.

## Examples

See the [`examples/`](./examples/) directory for complete implementation patterns:

- [`BasicConfigExample.s.sol`](./examples/BasicConfigExample.s.sol) - Simple usage
- [`DeFiConfigExample.s.sol`](./examples/DeFiConfigExample.s.sol) - Complex domain-specific extension

## License

This project is licensed under the [AGPL-3.0](LICENSE) license.

The choice of AGPL-3.0 aligns with the principles outlined by Vitalik Buterin in his post ["Why I used to prefer permissive licenses and now favor copyleft"](https://vitalik.eth.limo/general/2025/07/07/copyleft.html), ensuring that improvements and derivatives remain open and accessible to the community.

## Contributing

Contributions are welcome! Please ensure all contributions maintain the open-source spirit of this project.

## Development

```bash
# Build
forge build

# Test
forge test

# Format
forge fmt
```
