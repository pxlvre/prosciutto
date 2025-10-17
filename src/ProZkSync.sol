// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.8.30;

import {Vm} from "forge-std/Vm.sol";

abstract contract ProZkSync {
    address internal constant VM_ADDRESS = 0x7109709ECfa91a80626fF3989D68f67F5b1DD12D;
    Vm internal constant vm = Vm(VM_ADDRESS);

    // ZkSync Chain IDs
    uint256 public constant ZKSYNC_MAINNET_CHAIN_ID = 324;
    uint256 public constant ZKSYNC_SEPOLIA_CHAIN_ID = 300;
    
    // ZkSync Precompile Address Range
    address public constant ZKSYNC_PRECOMPILE_START = address(0x8001);
    address public constant ZKSYNC_PRECOMPILE_END = address(0x8fff);

    error NotZkSyncChain();
    error NotFoundryZkSync();
    error OnlyZkSyncChain();
    error OnlyVanillaFoundry();

    modifier skipZkSync() {
        if (!isZkSyncChain()) {
            _;
        }
    }

    modifier onlyZkSync() {
        if (!isZkSyncChain()) {
            revert OnlyZkSyncChain();
        }
        _;
    }

    modifier onlyFoundryZkSync() {
        if (!isFoundryZkSync()) {
            revert NotFoundryZkSync();
        }
        _;
    }

    modifier onlyVanillaFoundry() {
        if (isFoundryZkSync()) {
            revert OnlyVanillaFoundry();
        }
        _;
    }

    function isZkSyncChain() public view returns (bool) {
        return isOnZkSyncChainId() || isOnZkSyncPrecompiles();
    }

    function isOnZkSyncChainId() public view returns (bool) {
        uint256 chainId = block.chainid;
        return chainId == ZKSYNC_MAINNET_CHAIN_ID || 
               chainId == ZKSYNC_SEPOLIA_CHAIN_ID;
    }

    function isOnZkSyncPrecompiles() public view returns (bool) {
        // Check if ZkSync precompiles exist by testing address range
        for (uint160 addr = uint160(ZKSYNC_PRECOMPILE_START); 
             addr <= uint160(ZKSYNC_PRECOMPILE_END); 
             addr += 0x100) {
            if (address(addr).code.length > 0) {
                return true;
            }
        }
        return false;
    }

    function isFoundryZkSync() public returns (bool) {
        try this._checkFoundryZkSyncVersion() returns (bool result) {
            return result;
        } catch {
            return false;
        }
    }

    function _checkFoundryZkSyncVersion() external returns (bool) {
        string[] memory inputs = new string[](2);
        inputs[0] = "forge";
        inputs[1] = "--version";
        
        try vm.ffi(inputs) returns (bytes memory result) {
            string memory version = string(result);
            return _containsSubstring(_convertBytesToLowerCase(bytes(version)), "zksync");
        } catch {
            return false;
        }
    }

    function getFoundryVersion() public returns (string memory) {
        string[] memory inputs = new string[](2);
        inputs[0] = "forge";
        inputs[1] = "--version";
        
        try vm.ffi(inputs) returns (bytes memory result) {
            return string(result);
        } catch {
            return "unknown";
        }
    }

    function _containsSubstring(bytes memory data, string memory substring) internal pure returns (bool) {
        bytes memory substringBytes = bytes(substring);
        if (substringBytes.length > data.length) {
            return false;
        }
        
        for (uint256 i = 0; i <= data.length - substringBytes.length; i++) {
            bool found = true;
            for (uint256 j = 0; j < substringBytes.length; j++) {
                if (data[i + j] != substringBytes[j]) {
                    found = false;
                    break;
                }
            }
            if (found) {
                return true;
            }
        }
        return false;
    }

    function _convertBytesToLowerCase(bytes memory data) internal pure returns (bytes memory) {
        bytes memory result = new bytes(data.length);
        for (uint256 i = 0; i < data.length; i++) {
            if (data[i] >= 0x41 && data[i] <= 0x5A) {
                // Convert uppercase to lowercase
                result[i] = bytes1(uint8(data[i]) + 32);
            } else {
                result[i] = data[i];
            }
        }
        return result;
    }

    function getZkSyncChainInfo() public view returns (
        bool isZkSync,
        bool isMainnet,
        bool isSepolia,
        uint256 chainId,
        bool hasPrecompiles
    ) {
        chainId = block.chainid;
        isZkSync = isZkSyncChain();
        isMainnet = chainId == ZKSYNC_MAINNET_CHAIN_ID;
        isSepolia = chainId == ZKSYNC_SEPOLIA_CHAIN_ID;
        hasPrecompiles = isOnZkSyncPrecompiles();
    }
}