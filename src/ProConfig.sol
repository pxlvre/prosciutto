// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.8.30;

import {Script} from "forge-std/Script.sol";
import {ProChains} from "./ProChains.sol";

/**
 * @title ProConfig
 * @author Prosciutto Team
 * @notice Abstract configuration helper for network-specific deployments
 * @dev Provides a generalized pattern for managing multi-network configurations
 */
abstract contract ProConfig is Script {
    error ProConfig__UnsupportedNetwork();

    /**
     * @notice Base network configuration struct
     * @dev Override this in implementing contracts to add network-specific fields
     */
    struct BaseNetworkConfig {
        uint256 deployerKey;
        address deployer;
        ProChains.Chain chain;
    }

    mapping(uint256 => BaseNetworkConfig) private s_networkConfigs;

    /**
     * @notice Get the current network configuration
     * @return The network configuration for the current chain
     */
    function getNetworkConfig()
        public
        view
        virtual
        returns (BaseNetworkConfig memory)
    {
        return getNetworkConfigByChainId(block.chainid);
    }

    /**
     * @notice Get network configuration by chain ID
     * @param chainId The chain ID to get configuration for
     * @return The network configuration for the specified chain
     */
    function getNetworkConfigByChainId(
        uint256 chainId
    ) public view virtual returns (BaseNetworkConfig memory) {
        if (s_networkConfigs[chainId].deployerKey != 0) {
            return s_networkConfigs[chainId];
        }
        revert ProConfig__UnsupportedNetwork();
    }

    /**
     * @notice Check if a network is supported
     * @param chainId The chain ID to check
     * @return True if the network is supported
     */
    function isNetworkSupported(uint256 chainId) public view returns (bool) {
        return s_networkConfigs[chainId].deployerKey != 0;
    }

    /**
     * @notice Set network configuration
     * @param chainId The chain ID to set configuration for
     * @param config The network configuration
     */
    function _setNetworkConfig(
        uint256 chainId,
        BaseNetworkConfig memory config
    ) internal {
        s_networkConfigs[chainId] = config;
    }

    /**
     * @notice Initialize default network configurations
     * @dev Call this in the constructor of implementing contracts
     */
    function _initializeDefaultConfigs() internal {
        // Ethereum Mainnet
        _setNetworkConfig(
            ProChains.MAINNET,
            BaseNetworkConfig({
                deployerKey: vm.envUint("PRIVATE_KEY"),
                deployer: vm.addr(vm.envUint("PRIVATE_KEY")),
                chain: ProChains.getMainnet()
            })
        );

        // Ethereum Sepolia
        _setNetworkConfig(
            ProChains.SEPOLIA,
            BaseNetworkConfig({
                deployerKey: vm.envUint("PRIVATE_KEY"),
                deployer: vm.addr(vm.envUint("PRIVATE_KEY")),
                chain: ProChains.getSepolia()
            })
        );

        // Arbitrum One
        _setNetworkConfig(
            ProChains.ARBITRUM_ONE,
            BaseNetworkConfig({
                deployerKey: vm.envUint("PRIVATE_KEY"),
                deployer: vm.addr(vm.envUint("PRIVATE_KEY")),
                chain: ProChains.getArbitrumOne()
            })
        );

        // Arbitrum Sepolia
        _setNetworkConfig(
            ProChains.ARBITRUM_SEPOLIA,
            BaseNetworkConfig({
                deployerKey: vm.envUint("PRIVATE_KEY"),
                deployer: vm.addr(vm.envUint("PRIVATE_KEY")),
                chain: ProChains.getArbitrumSepolia()
            })
        );

        // Base
        _setNetworkConfig(
            ProChains.BASE,
            BaseNetworkConfig({
                deployerKey: vm.envUint("PRIVATE_KEY"),
                deployer: vm.addr(vm.envUint("PRIVATE_KEY")),
                chain: ProChains.getBase()
            })
        );

        // Base Sepolia
        _setNetworkConfig(
            ProChains.BASE_SEPOLIA,
            BaseNetworkConfig({
                deployerKey: vm.envUint("PRIVATE_KEY"),
                deployer: vm.addr(vm.envUint("PRIVATE_KEY")),
                chain: ProChains.getBaseSepolia()
            })
        );

        // ZkSync Era
        _setNetworkConfig(
            ProChains.ZKSYNC,
            BaseNetworkConfig({
                deployerKey: vm.envUint("PRIVATE_KEY"),
                deployer: vm.addr(vm.envUint("PRIVATE_KEY")),
                chain: ProChains.getZkSync()
            })
        );

        // ZkSync Sepolia
        _setNetworkConfig(
            ProChains.ZKSYNC_SEPOLIA,
            BaseNetworkConfig({
                deployerKey: vm.envUint("PRIVATE_KEY"),
                deployer: vm.addr(vm.envUint("PRIVATE_KEY")),
                chain: ProChains.getZkSyncSepolia()
            })
        );

        // Local/Anvil
        _setNetworkConfig(
            ProChains.LOCAL,
            BaseNetworkConfig({
                deployerKey: vm.envOr(
                    "ANVIL_PRIVATE_KEY",
                    uint256(
                        0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
                    )
                ),
                deployer: vm.addr(
                    vm.envOr(
                        "ANVIL_PRIVATE_KEY",
                        uint256(
                            0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
                        )
                    )
                ),
                chain: ProChains.getLocal()
            })
        );
    }

    /**
     * @notice Get environment variable with fallback
     * @param key The environment variable key
     * @param defaultValue The default value if env var is not set
     * @return The environment variable value or fallback
     */
    function _getEnvOr(
        string memory key,
        string memory defaultValue
    ) internal view returns (string memory) {
        try vm.envString(key) returns (string memory value) {
            return value;
        } catch {
            return defaultValue;
        }
    }

    /**
     * @notice Check if we're on a local network
     * @return True if on local network
     */
    function isLocalNetwork() public view returns (bool) {
        return block.chainid == ProChains.LOCAL;
    }

    /**
     * @notice Check if we're on a testnet
     * @return True if on a testnet
     */
    function isTestnet() public view returns (bool) {
        return ProChains.isTestnet(block.chainid);
    }

    /**
     * @notice Check if we're on mainnet
     * @return True if on mainnet
     */
    function isMainnet() public view returns (bool) {
        return
            ProChains.isSupported(block.chainid) &&
            !ProChains.isTestnet(block.chainid);
    }

    /**
     * @notice Get comprehensive chain information for current network
     * @return Complete chain metadata from ProChains
     */
    function getCurrentChain() public view returns (ProChains.Chain memory) {
        return ProChains.getChain(block.chainid);
    }

    /**
     * @notice Get chain information by chain ID
     * @param chainId The chain ID to get info for
     * @return Complete chain metadata from ProChains
     */
    function getChainById(
        uint256 chainId
    ) public pure returns (ProChains.Chain memory) {
        return ProChains.getChain(chainId);
    }
}
