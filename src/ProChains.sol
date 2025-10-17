// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.8.30;

/**
 * @title ProChains
 * @author Prosciutto Team
 * @notice Comprehensive blockchain network definitions library
 * @dev Adapted from viem's chain definitions for Solidity usage
 */
library ProChains {
    
    struct NativeCurrency {
        string name;
        string symbol;
        uint8 decimals;
    }
    
    struct RpcUrls {
        string primary;
        string[] fallbacks;
    }
    
    struct BlockExplorer {
        string name;
        string url;
        string apiUrl;
    }
    
    struct Contracts {
        address multicall3;
        uint256 multicall3BlockCreated;
        address ensUniversalResolver;
        uint256 ensUniversalResolverBlockCreated;
    }
    
    struct Chain {
        uint256 id;
        string name;
        string network;
        NativeCurrency nativeCurrency;
        RpcUrls rpcUrls;
        BlockExplorer blockExplorer;
        Contracts contracts;
        bool testnet;
        uint256 blockTime; // in milliseconds
    }

    // Chain ID constants (following Solidity naming convention)
    uint256 public constant MAINNET = 1;
    uint256 public constant SEPOLIA = 11155111;
    uint256 public constant HOLESKY = 17000;
    uint256 public constant GOERLI = 5;
    
    uint256 public constant ARBITRUM_ONE = 42161;
    uint256 public constant ARBITRUM_NOVA = 42170;
    uint256 public constant ARBITRUM_GOERLI = 421613;
    uint256 public constant ARBITRUM_SEPOLIA = 421614;
    
    uint256 public constant OPTIMISM = 10;
    uint256 public constant OPTIMISM_GOERLI = 420;
    uint256 public constant OPTIMISM_SEPOLIA = 11155420;
    
    uint256 public constant BASE = 8453;
    uint256 public constant BASE_GOERLI = 84531;
    uint256 public constant BASE_SEPOLIA = 84532;
    
    uint256 public constant POLYGON = 137;
    uint256 public constant POLYGON_MUMBAI = 80001;
    uint256 public constant POLYGON_AMOY = 80002;
    
    uint256 public constant AVALANCHE = 43114;
    uint256 public constant AVALANCHE_FUJI = 43113;
    
    uint256 public constant BSC = 56;
    uint256 public constant BSC_TESTNET = 97;
    
    uint256 public constant FANTOM = 250;
    uint256 public constant FANTOM_TESTNET = 4002;
    
    uint256 public constant GNOSIS = 100;
    uint256 public constant GNOSIS_CHIADO = 10200;
    
    uint256 public constant ZKSYNC = 324;
    uint256 public constant ZKSYNC_SEPOLIA = 300;
    
    uint256 public constant LINEA = 59144;
    uint256 public constant LINEA_GOERLI = 59140;
    uint256 public constant LINEA_SEPOLIA = 59141;
    
    uint256 public constant SCROLL = 534352;
    uint256 public constant SCROLL_SEPOLIA = 534351;
    
    uint256 public constant CELO = 42220;
    uint256 public constant CELO_ALFAJORES = 44787;
    
    uint256 public constant BLAST = 81457;
    uint256 public constant BLAST_SEPOLIA = 168587773;
    
    uint256 public constant MANTLE = 5000;
    uint256 public constant MANTLE_TESTNET = 5001;
    
    uint256 public constant LOCAL = 31337; // Anvil/Hardhat local
    
    // Error for unsupported chains
    error UnsupportedChain(uint256 chainId);
    
    /**
     * @notice Get chain information by chain ID
     * @param chainId The chain ID to look up
     * @return Chain information struct
     */
    function getChain(uint256 chainId) internal pure returns (Chain memory) {
        if (chainId == MAINNET) return getMainnet();
        if (chainId == SEPOLIA) return getSepolia();
        if (chainId == ARBITRUM_ONE) return getArbitrumOne();
        if (chainId == ARBITRUM_SEPOLIA) return getArbitrumSepolia();
        if (chainId == OPTIMISM) return getOptimism();
        if (chainId == OPTIMISM_SEPOLIA) return getOptimismSepolia();
        if (chainId == BASE) return getBase();
        if (chainId == BASE_SEPOLIA) return getBaseSepolia();
        if (chainId == POLYGON) return getPolygon();
        if (chainId == POLYGON_MUMBAI) return getPolygonMumbai();
        if (chainId == AVALANCHE) return getAvalanche();
        if (chainId == AVALANCHE_FUJI) return getAvalancheFuji();
        if (chainId == BSC) return getBsc();
        if (chainId == BSC_TESTNET) return getBscTestnet();
        if (chainId == ZKSYNC) return getZkSync();
        if (chainId == ZKSYNC_SEPOLIA) return getZkSyncSepolia();
        if (chainId == LOCAL) return getLocal();
        
        revert UnsupportedChain(chainId);
    }
    
    /**
     * @notice Check if a chain is a testnet
     * @param chainId The chain ID to check
     * @return True if testnet, false if mainnet
     */
    function isTestnet(uint256 chainId) internal pure returns (bool) {
        return chainId == SEPOLIA ||
               chainId == HOLESKY ||
               chainId == GOERLI ||
               chainId == ARBITRUM_GOERLI ||
               chainId == ARBITRUM_SEPOLIA ||
               chainId == OPTIMISM_GOERLI ||
               chainId == OPTIMISM_SEPOLIA ||
               chainId == BASE_GOERLI ||
               chainId == BASE_SEPOLIA ||
               chainId == POLYGON_MUMBAI ||
               chainId == POLYGON_AMOY ||
               chainId == AVALANCHE_FUJI ||
               chainId == BSC_TESTNET ||
               chainId == FANTOM_TESTNET ||
               chainId == GNOSIS_CHIADO ||
               chainId == ZKSYNC_SEPOLIA ||
               chainId == LINEA_GOERLI ||
               chainId == LINEA_SEPOLIA ||
               chainId == SCROLL_SEPOLIA ||
               chainId == CELO_ALFAJORES ||
               chainId == BLAST_SEPOLIA ||
               chainId == MANTLE_TESTNET ||
               chainId == LOCAL;
    }
    
    /**
     * @notice Check if a chain is supported
     * @param chainId The chain ID to check
     * @return True if supported
     */
    function isSupported(uint256 chainId) internal pure returns (bool) {
        return chainId == MAINNET ||
               chainId == SEPOLIA ||
               chainId == ARBITRUM_ONE ||
               chainId == ARBITRUM_SEPOLIA ||
               chainId == OPTIMISM ||
               chainId == OPTIMISM_SEPOLIA ||
               chainId == BASE ||
               chainId == BASE_SEPOLIA ||
               chainId == POLYGON ||
               chainId == POLYGON_MUMBAI ||
               chainId == AVALANCHE ||
               chainId == AVALANCHE_FUJI ||
               chainId == BSC ||
               chainId == BSC_TESTNET ||
               chainId == ZKSYNC ||
               chainId == ZKSYNC_SEPOLIA ||
               chainId == LOCAL;
    }
    
    // Chain definitions
    function getMainnet() internal pure returns (Chain memory) {
        return Chain({
            id: MAINNET,
            name: "Ethereum",
            network: "mainnet",
            nativeCurrency: NativeCurrency({
                name: "Ether",
                symbol: "ETH",
                decimals: 18
            }),
            rpcUrls: RpcUrls({
                primary: "https://eth.merkle.io",
                fallbacks: new string[](0)
            }),
            blockExplorer: BlockExplorer({
                name: "Etherscan",
                url: "https://etherscan.io",
                apiUrl: "https://api.etherscan.io/api"
            }),
            contracts: Contracts({
                multicall3: 0xcA11bde05977b3631167028862bE2a173976CA11,
                multicall3BlockCreated: 14353601,
                ensUniversalResolver: 0xeEeEEEeE14D718C2B47D9923Deab1335E144EeEe,
                ensUniversalResolverBlockCreated: 23085558
            }),
            testnet: false,
            blockTime: 12000
        });
    }
    
    function getSepolia() internal pure returns (Chain memory) {
        return Chain({
            id: SEPOLIA,
            name: "Sepolia",
            network: "sepolia",
            nativeCurrency: NativeCurrency({
                name: "Sepolia Ether",
                symbol: "SEP",
                decimals: 18
            }),
            rpcUrls: RpcUrls({
                primary: "https://rpc.sepolia.org",
                fallbacks: new string[](0)
            }),
            blockExplorer: BlockExplorer({
                name: "Etherscan",
                url: "https://sepolia.etherscan.io",
                apiUrl: "https://api-sepolia.etherscan.io/api"
            }),
            contracts: Contracts({
                multicall3: 0xcA11bde05977b3631167028862bE2a173976CA11,
                multicall3BlockCreated: 751532,
                ensUniversalResolver: address(0),
                ensUniversalResolverBlockCreated: 0
            }),
            testnet: true,
            blockTime: 12000
        });
    }
    
    function getArbitrumOne() internal pure returns (Chain memory) {
        return Chain({
            id: ARBITRUM_ONE,
            name: "Arbitrum One",
            network: "arbitrum",
            nativeCurrency: NativeCurrency({
                name: "Ether",
                symbol: "ETH",
                decimals: 18
            }),
            rpcUrls: RpcUrls({
                primary: "https://arb1.arbitrum.io/rpc",
                fallbacks: new string[](0)
            }),
            blockExplorer: BlockExplorer({
                name: "Arbiscan",
                url: "https://arbiscan.io",
                apiUrl: "https://api.arbiscan.io/api"
            }),
            contracts: Contracts({
                multicall3: 0xcA11bde05977b3631167028862bE2a173976CA11,
                multicall3BlockCreated: 7654707,
                ensUniversalResolver: address(0),
                ensUniversalResolverBlockCreated: 0
            }),
            testnet: false,
            blockTime: 250
        });
    }
    
    function getArbitrumSepolia() internal pure returns (Chain memory) {
        return Chain({
            id: ARBITRUM_SEPOLIA,
            name: "Arbitrum Sepolia",
            network: "arbitrum-sepolia",
            nativeCurrency: NativeCurrency({
                name: "Arbitrum Sepolia Ether",
                symbol: "ETH",
                decimals: 18
            }),
            rpcUrls: RpcUrls({
                primary: "https://sepolia-rollup.arbitrum.io/rpc",
                fallbacks: new string[](0)
            }),
            blockExplorer: BlockExplorer({
                name: "Arbiscan",
                url: "https://sepolia.arbiscan.io",
                apiUrl: "https://api-sepolia.arbiscan.io/api"
            }),
            contracts: Contracts({
                multicall3: 0xcA11bde05977b3631167028862bE2a173976CA11,
                multicall3BlockCreated: 81930,
                ensUniversalResolver: address(0),
                ensUniversalResolverBlockCreated: 0
            }),
            testnet: true,
            blockTime: 250
        });
    }
    
    function getOptimism() internal pure returns (Chain memory) {
        return Chain({
            id: OPTIMISM,
            name: "OP Mainnet",
            network: "optimism",
            nativeCurrency: NativeCurrency({
                name: "Ether",
                symbol: "ETH",
                decimals: 18
            }),
            rpcUrls: RpcUrls({
                primary: "https://mainnet.optimism.io",
                fallbacks: new string[](0)
            }),
            blockExplorer: BlockExplorer({
                name: "Optimism Explorer",
                url: "https://optimistic.etherscan.io",
                apiUrl: "https://api-optimistic.etherscan.io/api"
            }),
            contracts: Contracts({
                multicall3: 0xcA11bde05977b3631167028862bE2a173976CA11,
                multicall3BlockCreated: 4286263,
                ensUniversalResolver: address(0),
                ensUniversalResolverBlockCreated: 0
            }),
            testnet: false,
            blockTime: 2000
        });
    }
    
    function getOptimismSepolia() internal pure returns (Chain memory) {
        return Chain({
            id: OPTIMISM_SEPOLIA,
            name: "OP Sepolia",
            network: "optimism-sepolia",
            nativeCurrency: NativeCurrency({
                name: "Sepolia Ether",
                symbol: "ETH",
                decimals: 18
            }),
            rpcUrls: RpcUrls({
                primary: "https://sepolia.optimism.io",
                fallbacks: new string[](0)
            }),
            blockExplorer: BlockExplorer({
                name: "Optimism Sepolia Explorer",
                url: "https://sepolia-optimism.etherscan.io",
                apiUrl: "https://api-sepolia-optimistic.etherscan.io/api"
            }),
            contracts: Contracts({
                multicall3: 0xcA11bde05977b3631167028862bE2a173976CA11,
                multicall3BlockCreated: 1620204,
                ensUniversalResolver: address(0),
                ensUniversalResolverBlockCreated: 0
            }),
            testnet: true,
            blockTime: 2000
        });
    }
    
    function getBase() internal pure returns (Chain memory) {
        return Chain({
            id: BASE,
            name: "Base",
            network: "base",
            nativeCurrency: NativeCurrency({
                name: "Ether",
                symbol: "ETH",
                decimals: 18
            }),
            rpcUrls: RpcUrls({
                primary: "https://mainnet.base.org",
                fallbacks: new string[](0)
            }),
            blockExplorer: BlockExplorer({
                name: "Basescan",
                url: "https://basescan.org",
                apiUrl: "https://api.basescan.org/api"
            }),
            contracts: Contracts({
                multicall3: 0xcA11bde05977b3631167028862bE2a173976CA11,
                multicall3BlockCreated: 5022,
                ensUniversalResolver: address(0),
                ensUniversalResolverBlockCreated: 0
            }),
            testnet: false,
            blockTime: 2000
        });
    }
    
    function getBaseSepolia() internal pure returns (Chain memory) {
        return Chain({
            id: BASE_SEPOLIA,
            name: "Base Sepolia",
            network: "base-sepolia",
            nativeCurrency: NativeCurrency({
                name: "Sepolia Ether",
                symbol: "ETH",
                decimals: 18
            }),
            rpcUrls: RpcUrls({
                primary: "https://sepolia.base.org",
                fallbacks: new string[](0)
            }),
            blockExplorer: BlockExplorer({
                name: "Basescan",
                url: "https://sepolia.basescan.org",
                apiUrl: "https://api-sepolia.basescan.org/api"
            }),
            contracts: Contracts({
                multicall3: 0xcA11bde05977b3631167028862bE2a173976CA11,
                multicall3BlockCreated: 1059647,
                ensUniversalResolver: address(0),
                ensUniversalResolverBlockCreated: 0
            }),
            testnet: true,
            blockTime: 2000
        });
    }
    
    function getPolygon() internal pure returns (Chain memory) {
        return Chain({
            id: POLYGON,
            name: "Polygon",
            network: "polygon",
            nativeCurrency: NativeCurrency({
                name: "MATIC",
                symbol: "MATIC",
                decimals: 18
            }),
            rpcUrls: RpcUrls({
                primary: "https://polygon-rpc.com",
                fallbacks: new string[](0)
            }),
            blockExplorer: BlockExplorer({
                name: "PolygonScan",
                url: "https://polygonscan.com",
                apiUrl: "https://api.polygonscan.com/api"
            }),
            contracts: Contracts({
                multicall3: 0xcA11bde05977b3631167028862bE2a173976CA11,
                multicall3BlockCreated: 25770160,
                ensUniversalResolver: address(0),
                ensUniversalResolverBlockCreated: 0
            }),
            testnet: false,
            blockTime: 2000
        });
    }
    
    function getPolygonMumbai() internal pure returns (Chain memory) {
        return Chain({
            id: POLYGON_MUMBAI,
            name: "Polygon Mumbai",
            network: "polygon-mumbai",
            nativeCurrency: NativeCurrency({
                name: "MATIC",
                symbol: "MATIC",
                decimals: 18
            }),
            rpcUrls: RpcUrls({
                primary: "https://rpc-mumbai.maticvigil.com",
                fallbacks: new string[](0)
            }),
            blockExplorer: BlockExplorer({
                name: "PolygonScan",
                url: "https://mumbai.polygonscan.com",
                apiUrl: "https://api-testnet.polygonscan.com/api"
            }),
            contracts: Contracts({
                multicall3: 0xcA11bde05977b3631167028862bE2a173976CA11,
                multicall3BlockCreated: 25770160,
                ensUniversalResolver: address(0),
                ensUniversalResolverBlockCreated: 0
            }),
            testnet: true,
            blockTime: 2000
        });
    }
    
    function getAvalanche() internal pure returns (Chain memory) {
        return Chain({
            id: AVALANCHE,
            name: "Avalanche",
            network: "avalanche",
            nativeCurrency: NativeCurrency({
                name: "Avalanche",
                symbol: "AVAX",
                decimals: 18
            }),
            rpcUrls: RpcUrls({
                primary: "https://api.avax.network/ext/bc/C/rpc",
                fallbacks: new string[](0)
            }),
            blockExplorer: BlockExplorer({
                name: "SnowTrace",
                url: "https://snowtrace.io",
                apiUrl: "https://api.snowtrace.io/api"
            }),
            contracts: Contracts({
                multicall3: 0xcA11bde05977b3631167028862bE2a173976CA11,
                multicall3BlockCreated: 11907934,
                ensUniversalResolver: address(0),
                ensUniversalResolverBlockCreated: 0
            }),
            testnet: false,
            blockTime: 2000
        });
    }
    
    function getAvalancheFuji() internal pure returns (Chain memory) {
        return Chain({
            id: AVALANCHE_FUJI,
            name: "Avalanche Fuji",
            network: "avalanche-fuji",
            nativeCurrency: NativeCurrency({
                name: "Avalanche",
                symbol: "AVAX",
                decimals: 18
            }),
            rpcUrls: RpcUrls({
                primary: "https://api.avax-test.network/ext/bc/C/rpc",
                fallbacks: new string[](0)
            }),
            blockExplorer: BlockExplorer({
                name: "SnowTrace",
                url: "https://testnet.snowtrace.io",
                apiUrl: "https://api-testnet.snowtrace.io/api"
            }),
            contracts: Contracts({
                multicall3: 0xcA11bde05977b3631167028862bE2a173976CA11,
                multicall3BlockCreated: 7096959,
                ensUniversalResolver: address(0),
                ensUniversalResolverBlockCreated: 0
            }),
            testnet: true,
            blockTime: 2000
        });
    }
    
    function getBsc() internal pure returns (Chain memory) {
        return Chain({
            id: BSC,
            name: "BNB Smart Chain",
            network: "bsc",
            nativeCurrency: NativeCurrency({
                name: "BNB",
                symbol: "BNB",
                decimals: 18
            }),
            rpcUrls: RpcUrls({
                primary: "https://bsc-dataseed.binance.org",
                fallbacks: new string[](0)
            }),
            blockExplorer: BlockExplorer({
                name: "BscScan",
                url: "https://bscscan.com",
                apiUrl: "https://api.bscscan.com/api"
            }),
            contracts: Contracts({
                multicall3: 0xcA11bde05977b3631167028862bE2a173976CA11,
                multicall3BlockCreated: 15921452,
                ensUniversalResolver: address(0),
                ensUniversalResolverBlockCreated: 0
            }),
            testnet: false,
            blockTime: 3000
        });
    }
    
    function getBscTestnet() internal pure returns (Chain memory) {
        return Chain({
            id: BSC_TESTNET,
            name: "BNB Smart Chain Testnet",
            network: "bsc-testnet",
            nativeCurrency: NativeCurrency({
                name: "tBNB",
                symbol: "tBNB",
                decimals: 18
            }),
            rpcUrls: RpcUrls({
                primary: "https://data-seed-prebsc-1-s1.binance.org:8545",
                fallbacks: new string[](0)
            }),
            blockExplorer: BlockExplorer({
                name: "BscScan",
                url: "https://testnet.bscscan.com",
                apiUrl: "https://api-testnet.bscscan.com/api"
            }),
            contracts: Contracts({
                multicall3: 0xcA11bde05977b3631167028862bE2a173976CA11,
                multicall3BlockCreated: 17422483,
                ensUniversalResolver: address(0),
                ensUniversalResolverBlockCreated: 0
            }),
            testnet: true,
            blockTime: 3000
        });
    }
    
    function getZkSync() internal pure returns (Chain memory) {
        return Chain({
            id: ZKSYNC,
            name: "zkSync Era",
            network: "zksync-era",
            nativeCurrency: NativeCurrency({
                name: "Ether",
                symbol: "ETH",
                decimals: 18
            }),
            rpcUrls: RpcUrls({
                primary: "https://mainnet.era.zksync.io",
                fallbacks: new string[](0)
            }),
            blockExplorer: BlockExplorer({
                name: "zkSync Era Block Explorer",
                url: "https://explorer.zksync.io",
                apiUrl: "https://block-explorer-api.mainnet.zksync.io/api"
            }),
            contracts: Contracts({
                multicall3: address(0),
                multicall3BlockCreated: 0,
                ensUniversalResolver: address(0),
                ensUniversalResolverBlockCreated: 0
            }),
            testnet: false,
            blockTime: 1000
        });
    }
    
    function getZkSyncSepolia() internal pure returns (Chain memory) {
        return Chain({
            id: ZKSYNC_SEPOLIA,
            name: "zkSync Era Sepolia Testnet",
            network: "zksync-era-sepolia",
            nativeCurrency: NativeCurrency({
                name: "Ether",
                symbol: "ETH",
                decimals: 18
            }),
            rpcUrls: RpcUrls({
                primary: "https://sepolia.era.zksync.dev",
                fallbacks: new string[](0)
            }),
            blockExplorer: BlockExplorer({
                name: "zkSync Era Block Explorer",
                url: "https://sepolia.explorer.zksync.io",
                apiUrl: "https://block-explorer-api.sepolia.zksync.dev/api"
            }),
            contracts: Contracts({
                multicall3: address(0),
                multicall3BlockCreated: 0,
                ensUniversalResolver: address(0),
                ensUniversalResolverBlockCreated: 0
            }),
            testnet: true,
            blockTime: 1000
        });
    }
    
    function getLocal() internal pure returns (Chain memory) {
        return Chain({
            id: LOCAL,
            name: "Localhost",
            network: "localhost",
            nativeCurrency: NativeCurrency({
                name: "Ether",
                symbol: "ETH",
                decimals: 18
            }),
            rpcUrls: RpcUrls({
                primary: "http://127.0.0.1:8545",
                fallbacks: new string[](0)
            }),
            blockExplorer: BlockExplorer({
                name: "Local Explorer",
                url: "http://localhost:8545",
                apiUrl: ""
            }),
            contracts: Contracts({
                multicall3: address(0),
                multicall3BlockCreated: 0,
                ensUniversalResolver: address(0),
                ensUniversalResolverBlockCreated: 0
            }),
            testnet: true,
            blockTime: 2000
        });
    }
}