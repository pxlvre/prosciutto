// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.8.30;

import {ProConfig} from "../src/ProConfig.sol";
import {ProChains} from "../src/ProChains.sol";
import {console} from "forge-std/Console.sol";

/**
 * @title BasicConfigExample
 * @notice Simple example showing basic ProConfig usage
 * @dev Minimal implementation without domain-specific extensions
 */
contract BasicConfigExample is ProConfig {
    
    constructor() {
        _initializeDefaultConfigs();
    }

    /**
     * @notice Deploy function example
     * @dev Shows how to access chain information during deployment
     */
    function deploy() external {
        // Get comprehensive chain information
        ProChains.Chain memory currentChain = getCurrentChain();
        
        // Get basic network config
        BaseNetworkConfig memory config = getNetworkConfig();
        
        // Example deployment logic with chain-aware configuration
        vm.startBroadcast(config.deployerKey);
        
        // Access rich chain metadata from viem
        console.log("Deploying to:", currentChain.name);
        console.log("Chain ID:", currentChain.id);
        console.log("Native Currency:", currentChain.nativeCurrency.symbol);
        console.log("RPC URL:", currentChain.rpcUrls.primary);
        console.log("Block Explorer:", currentChain.blockExplorer.url);
        console.log("Is Testnet:", currentChain.testnet);
        console.log("Block Time (ms):", currentChain.blockTime);
        
        // Use multicall3 if available
        if (currentChain.contracts.multicall3 != address(0)) {
            console.log("Multicall3 available at:", currentChain.contracts.multicall3);
        }
        
        // Network type checks
        if (isTestnet()) {
            console.log("Using testnet configuration");
        } else if (isMainnet()) {
            console.log("Using mainnet configuration - BE CAREFUL!");
        } else if (isLocalNetwork()) {
            console.log("Using local development configuration");
        }
        
        vm.stopBroadcast();
    }

    /**
     * @notice Example function to show supported networks
     */
    function listSupportedNetworks() external pure {
        console.log("Supported Networks:");
        console.log("- Ethereum Mainnet (ID: %d)", ProChains.MAINNET);
        console.log("- Ethereum Sepolia (ID: %d)", ProChains.SEPOLIA);
        console.log("- Arbitrum One (ID: %d)", ProChains.ARBITRUM_ONE);
        console.log("- Arbitrum Sepolia (ID: %d)", ProChains.ARBITRUM_SEPOLIA);
        console.log("- Optimism (ID: %d)", ProChains.OPTIMISM);
        console.log("- Optimism Sepolia (ID: %d)", ProChains.OPTIMISM_SEPOLIA);
        console.log("- Base (ID: %d)", ProChains.BASE);
        console.log("- Base Sepolia (ID: %d)", ProChains.BASE_SEPOLIA);
        console.log("- Polygon (ID: %d)", ProChains.POLYGON);
        console.log("- Polygon Mumbai (ID: %d)", ProChains.POLYGON_MUMBAI);
        console.log("- Avalanche (ID: %d)", ProChains.AVALANCHE);
        console.log("- Avalanche Fuji (ID: %d)", ProChains.AVALANCHE_FUJI);
        console.log("- BSC (ID: %d)", ProChains.BSC);
        console.log("- BSC Testnet (ID: %d)", ProChains.BSC_TESTNET);
        console.log("- zkSync Era (ID: %d)", ProChains.ZKSYNC);
        console.log("- zkSync Sepolia (ID: %d)", ProChains.ZKSYNC_SEPOLIA);
        console.log("- Local/Anvil (ID: %d)", ProChains.LOCAL);
    }

    /**
     * @notice Get network information by chain ID
     * @param chainId The chain ID to query
     */
    function getNetworkInfo(uint256 chainId) external pure {
        if (!ProChains.isSupported(chainId)) {
            console.log("Chain ID %d is not supported", chainId);
            return;
        }

        ProChains.Chain memory chain = ProChains.getChain(chainId);
        
        console.log("=== Network Information ===");
        console.log("Name:", chain.name);
        console.log("Network:", chain.network);
        console.log("Chain ID:", chain.id);
        console.log("Native Currency: %s (%s)", chain.nativeCurrency.name, chain.nativeCurrency.symbol);
        console.log("Decimals:", chain.nativeCurrency.decimals);
        console.log("RPC URL:", chain.rpcUrls.primary);
        console.log("Block Explorer:", chain.blockExplorer.name);
        console.log("Explorer URL:", chain.blockExplorer.url);
        console.log("API URL:", chain.blockExplorer.apiUrl);
        console.log("Is Testnet:", chain.testnet);
        console.log("Block Time (ms):", chain.blockTime);
        
        if (chain.contracts.multicall3 != address(0)) {
            console.log("Multicall3:", chain.contracts.multicall3);
            console.log("Multicall3 Block Created:", chain.contracts.multicall3BlockCreated);
        }
        
        if (chain.contracts.ensUniversalResolver != address(0)) {
            console.log("ENS Universal Resolver:", chain.contracts.ensUniversalResolver);
            console.log("ENS Resolver Block Created:", chain.contracts.ensUniversalResolverBlockCreated);
        }
    }
}