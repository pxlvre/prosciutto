// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.8.30;

import {ProConfig} from "../src/ProConfig.sol";
import {ProChains} from "../src/ProChains.sol";

/**
 * @title DeFiConfigExample
 * @notice Example implementation showing how to extend ProConfig for DeFi-specific deployments
 * @dev Demonstrates pattern for adding domain-specific configuration fields
 */
contract DeFiConfigExample is ProConfig {
    // DeFi-specific constants
    uint8 public constant DECIMALS = 8;
    int256 public constant ETH_USD_PRICE = 2000e8;
    int256 public constant BTC_USD_PRICE = 1000e8;
    int256 public constant USDC_USD_PRICE = 1e8;

    struct DeFiNetworkConfig {
        // Base config fields
        uint256 deployerKey;
        address deployer;
        ProChains.Chain chain;
        // DeFi-specific fields
        address wethUsdPriceFeed;
        address wbtcUsdPriceFeed;
        address usdcUsdPriceFeed;
        address weth;
        address wbtc;
        address usdc;
        address entryPoint; // For account abstraction
    }

    mapping(uint256 => DeFiNetworkConfig) private s_defiConfigs;

    constructor() {
        _initializeDefaultConfigs();
        _initializeDeFiConfigs();
    }

    /**
     * @notice Get DeFi-specific network configuration for current chain
     * @return The DeFi network configuration
     */
    function getDeFiConfig() public view returns (DeFiNetworkConfig memory) {
        return getDeFiConfigByChainId(block.chainid);
    }

    /**
     * @notice Get DeFi configuration by chain ID
     * @param chainId The chain ID to get configuration for
     * @return The DeFi network configuration
     */
    function getDeFiConfigByChainId(
        uint256 chainId
    ) public view returns (DeFiNetworkConfig memory) {
        if (chainId == ProChains.SEPOLIA) {
            return _getSepoliaEthConfig();
        } else if (chainId == ProChains.LOCAL) {
            return _getOrCreateAnvilEthConfig();
        } else if (chainId == ProChains.MAINNET) {
            return _getMainnetEthConfig();
        } else if (chainId == ProChains.ARBITRUM_ONE) {
            return _getArbitrumOneConfig();
        } else if (chainId == ProChains.BASE) {
            return _getBaseConfig();
        }
        revert ProConfig__UnsupportedNetwork();
    }

    /**
     * @notice Initialize DeFi-specific configurations
     */
    function _initializeDeFiConfigs() private {
        // Configs are created on-demand in the getter functions
        // This could be optimized by pre-computing and storing them
    }

    /**
     * @notice Get Ethereum mainnet DeFi configuration
     */
    function _getMainnetEthConfig()
        private
        view
        returns (DeFiNetworkConfig memory)
    {
        BaseNetworkConfig memory baseConfig = getNetworkConfigByChainId(
            ProChains.MAINNET
        );

        return
            DeFiNetworkConfig({
                deployerKey: baseConfig.deployerKey,
                deployer: baseConfig.deployer,
                chain: baseConfig.chain,
                wethUsdPriceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419, // Real Chainlink feed
                wbtcUsdPriceFeed: 0xF4030086522a5bEEa4988F8cA5B36dbC97BeE88c, // Real Chainlink feed
                usdcUsdPriceFeed: 0x8fFfFfd4AfB6115b954Bd326cbe7B4BA576818f6, // Real Chainlink feed
                weth: 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2, // Real WETH
                wbtc: 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599, // Real WBTC
                usdc: 0xa0B86a33e6441467e7Fc87Bd1F1c1012D2E9bF0a, // Real USDC
                entryPoint: 0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789 // EntryPoint v0.6
            });
    }

    /**
     * @notice Get Ethereum Sepolia testnet DeFi configuration
     */
    function _getSepoliaEthConfig()
        private
        view
        returns (DeFiNetworkConfig memory)
    {
        BaseNetworkConfig memory baseConfig = getNetworkConfigByChainId(
            ProChains.SEPOLIA
        );

        return
            DeFiNetworkConfig({
                deployerKey: baseConfig.deployerKey,
                deployer: baseConfig.deployer,
                chain: baseConfig.chain,
                wethUsdPriceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306, // Sepolia WETH/USD
                wbtcUsdPriceFeed: 0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43, // Sepolia BTC/USD
                usdcUsdPriceFeed: 0xA2F78ab2355fe2f984D808B5CeE7FD0A93D5270E, // Sepolia USDC/USD
                weth: 0xdd13E55209Fd76AfE204dBda4007C227904f0a81, // Sepolia WETH
                wbtc: 0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063, // Mock WBTC
                usdc: 0x94a9D9AC8a22534E3FaCa9F4e7F2E2cf85d5E4C8, // Mock USDC
                entryPoint: 0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789 // EntryPoint v0.6
            });
    }

    /**
     * @notice Get Arbitrum One DeFi configuration
     */
    function _getArbitrumOneConfig()
        private
        view
        returns (DeFiNetworkConfig memory)
    {
        BaseNetworkConfig memory baseConfig = getNetworkConfigByChainId(
            ProChains.ARBITRUM_ONE
        );

        return
            DeFiNetworkConfig({
                deployerKey: baseConfig.deployerKey,
                deployer: baseConfig.deployer,
                chain: baseConfig.chain,
                wethUsdPriceFeed: 0x639Fe6ab55C921f74e7fac1ee960C0B6293ba612, // Arbitrum ETH/USD
                wbtcUsdPriceFeed: 0x6ce185860a4963106506C203335A2910413708e9, // Arbitrum BTC/USD
                usdcUsdPriceFeed: 0x50834F3163758fcC1Df9973b6e91f0F0F0434aD3, // Arbitrum USDC/USD
                weth: 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1, // Arbitrum WETH
                wbtc: 0x2f2a2543B76A4166549F7aaB2e75Bef0aefC5B0f, // Arbitrum WBTC
                usdc: 0xaf88d065e77c8cC2239327C5EDb3A432268e5831, // Arbitrum USDC
                entryPoint: 0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789 // EntryPoint v0.6
            });
    }

    /**
     * @notice Get Base DeFi configuration
     */
    function _getBaseConfig() private view returns (DeFiNetworkConfig memory) {
        BaseNetworkConfig memory baseConfig = getNetworkConfigByChainId(
            ProChains.BASE
        );

        return
            DeFiNetworkConfig({
                deployerKey: baseConfig.deployerKey,
                deployer: baseConfig.deployer,
                chain: baseConfig.chain,
                wethUsdPriceFeed: 0x71041dddad3595F9CEd3DcCFBe3D1F4b0a16Bb70, // Base ETH/USD
                wbtcUsdPriceFeed: 0x64c911996D3c6aC71f9b455B1E8E7266BcbD848F, // Base BTC/USD
                usdcUsdPriceFeed: 0x7e860098F58bBFC8648a4311b374B1D669a2bc6B, // Base USDC/USD
                weth: 0x4200000000000000000000000000000000000006, // Base WETH
                wbtc: 0x1C608a616A94c7aE8eC4ec83da2A3cc0E40CCB3C, // Base cbBTC (closest to WBTC)
                usdc: 0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913, // Base USDC
                entryPoint: 0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789 // EntryPoint v0.6
            });
    }

    /**
     * @notice Get or create Anvil local configuration with mocks
     */
    function _getOrCreateAnvilEthConfig()
        private
        view
        returns (DeFiNetworkConfig memory)
    {
        BaseNetworkConfig memory baseConfig = getNetworkConfigByChainId(
            ProChains.LOCAL
        );

        // For local development, use placeholder addresses
        // In practice, you'd deploy mock contracts here
        return
            DeFiNetworkConfig({
                deployerKey: baseConfig.deployerKey,
                deployer: baseConfig.deployer,
                chain: baseConfig.chain,
                wethUsdPriceFeed: _createMockPriceFeed(ETH_USD_PRICE),
                wbtcUsdPriceFeed: _createMockPriceFeed(BTC_USD_PRICE),
                usdcUsdPriceFeed: _createMockPriceFeed(USDC_USD_PRICE),
                weth: _createMockERC20("Wrapped Ether", "WETH", 1000e18),
                wbtc: _createMockERC20("Wrapped Bitcoin", "WBTC", 100e8),
                usdc: _createMockERC20("USD Coin", "USDC", 1000000e6),
                entryPoint: address(0x1234) // Mock EntryPoint for local testing
            });
    }

    /**
     * @notice Create a mock ERC20 token for testing
     * @param name The token name
     * @param symbol The token symbol
     * @param initialSupply The initial supply (unused for placeholder)
     * @return The address of the mock token (placeholder)
     */
    function _createMockERC20(
        string memory name,
        string memory symbol,
        uint256 initialSupply
    ) private pure returns (address) {
        // For demonstration purposes, return a placeholder address
        // In practice, you'd deploy a proper mock ERC20 contract
        name;
        symbol;
        initialSupply; // silence unused variable warnings
        return address(0x1111111111111111111111111111111111111111);
    }

    /**
     * @notice Create a mock price feed for testing
     * @param initialPrice The initial price to set (unused for placeholder)
     * @return The address of the mock price feed (placeholder)
     */
    function _createMockPriceFeed(
        int256 initialPrice
    ) private pure returns (address) {
        // For demonstration purposes, return a placeholder address
        // In practice, you'd deploy a proper mock price feed contract
        initialPrice; // silence unused variable warning
        return address(0x2222222222222222222222222222222222222222);
    }

    /**
     * @notice Example function showing how to use chain metadata
     * @return Human-readable deployment info
     */
    function getDeploymentInfo() public view returns (string memory) {
        ProChains.Chain memory currentChain = getCurrentChain();
        DeFiNetworkConfig memory config = getDeFiConfig();

        return
            string(
                abi.encodePacked(
                    "Deploying to: ",
                    currentChain.name,
                    " (",
                    _toString(currentChain.id),
                    ")",
                    " | Native: ",
                    currentChain.nativeCurrency.symbol,
                    " | Testnet: ",
                    currentChain.testnet ? "true" : "false",
                    " | Deployer: ",
                    _addressToString(config.deployer)
                )
            );
    }

    /**
     * @notice Convert uint256 to string
     */
    function _toString(uint256 value) private pure returns (string memory) {
        if (value == 0) return "0";

        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }

        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }

        return string(buffer);
    }

    /**
     * @notice Convert address to string
     */
    function _addressToString(
        address addr
    ) private pure returns (string memory) {
        return _toHexString(uint256(uint160(addr)), 20);
    }

    /**
     * @notice Convert bytes to hex string
     */
    function _toHexString(
        uint256 value,
        uint256 length
    ) private pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }

    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
}
