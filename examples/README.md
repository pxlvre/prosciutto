# ProConfig Examples

This directory contains examples showing how to use the ProConfig system for network-specific deployments.

## Files

### `BasicConfigExample.s.sol`
A minimal example showing:
- How to extend ProConfig
- Accessing comprehensive chain metadata from ProChains
- Network type detection (mainnet/testnet/local)
- Using built-in chain information for deployments

### `DeFiConfigExample.s.sol`
A comprehensive example showing:
- How to extend ProConfig for domain-specific use cases (DeFi)
- Adding custom configuration fields (price feeds, tokens, etc.)
- Real mainnet/testnet addresses vs local mocks
- Pattern for managing complex multi-network deployments

## Key Features Demonstrated

### 🌐 Rich Chain Metadata
Access to comprehensive blockchain information from viem's chain definitions:
- Chain names, IDs, and network identifiers
- Native currency details (name, symbol, decimals)
- RPC URLs and block explorers
- Contract addresses (Multicall3, ENS, etc.)
- Block times and network characteristics

### 🔧 Flexible Configuration
- Base configuration inherited from ProConfig
- Domain-specific extensions (DeFi, NFT, Gaming, etc.)
- Environment-based key management
- Automatic testnet/mainnet detection

### 🚀 Deployment Ready
- Real contract addresses for production networks
- Mock contracts for local development
- Network-aware deployment logic
- Built-in safety checks

## Usage Patterns

### Basic Usage
```solidity
contract MyDeployer is ProConfig {
    constructor() {
        _initializeDefaultConfigs();
    }
    
    function deploy() external {
        ProChains.Chain memory chain = getCurrentChain();
        BaseNetworkConfig memory config = getNetworkConfig();
        
        vm.startBroadcast(config.deployerKey);
        // Deploy your contracts here
        vm.stopBroadcast();
    }
}
```

### Domain-Specific Extensions
```solidity
contract DeFiDeployer is ProConfig {
    struct DeFiConfig {
        uint256 deployerKey;
        address deployer;
        ProChains.Chain chain;
        // Add your domain-specific fields
        address priceFeed;
        address token;
    }
    
    function getDeFiConfig() public view returns (DeFiConfig memory) {
        // Implement domain-specific configuration logic
    }
}
```

## Supported Networks

The ProChains library includes comprehensive support for:

**Mainnets:**
- Ethereum (1)
- Arbitrum One (42161)
- Optimism (10)
- Base (8453)
- Polygon (137)
- Avalanche (43114)
- BSC (56)
- zkSync Era (324)

**Testnets:**
- Ethereum Sepolia (11155111)
- Arbitrum Sepolia (421614)
- Optimism Sepolia (11155420)
- Base Sepolia (84532)
- Polygon Mumbai (80001)
- Avalanche Fuji (43113)
- BSC Testnet (97)
- zkSync Sepolia (300)

**Development:**
- Local/Anvil (31337)

Each network includes complete metadata: RPC URLs, block explorers, native currency info, standard contract addresses, and more.

## Environment Variables

The examples expect these environment variables:

```bash
# Required for mainnet/testnet deployments
PRIVATE_KEY=your_private_key_here

# Optional for local development (uses default Anvil key if not set)
ANVIL_PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
```

## Running Examples

```bash
# Run basic example
forge script examples/BasicConfigExample.s.sol

# Run DeFi example
forge script examples/DeFiConfigExample.s.sol

# Deploy to specific network
forge script examples/BasicConfigExample.s.sol --rpc-url $RPC_URL --broadcast
```