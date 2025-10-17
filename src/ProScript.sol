// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.8.30;

import {Script} from "forge-std/Script.sol";
import {Vm} from "forge-std/Vm.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {console} from "forge-std/console.sol";
import {ProLanguages} from "./ProLanguages.sol";
import {ProFs} from "./ProFs.sol";

abstract contract ProScript is Script, ProFs {
    using stdJson for string;

    string public constant DEFAULT_BROADCAST_PATH = "./broadcast";
    string public constant DEFAULT_DEPLOYMENTS_PATH = "./deployments";
    string public constant DEFAULT_CONFIG_PATH = "./prosciutto.json";

    struct DeploymentInfo {
        address contractAddress;
        string contractName;
        uint256 blockNumber;
        uint256 timestamp;
        bytes32 txHash;
        address deployer;
    }

    struct ChainInfo {
        uint256 chainId;
        string name;
        string rpcUrl;
        uint256 blockNumber;
    }

    event DeploymentTracked(
        string indexed contractName,
        address indexed contractAddress,
        uint256 indexed chainId,
        uint256 blockNumber
    );

    error ContractNotFound(string contractName, uint256 chainId);
    error DeploymentNotFound(string contractName, uint256 chainId);
    error InvalidChainId(uint256 chainId);
    error InvalidPath(string path);

    function getMostRecentDeployment(
        string memory contractName
    ) public view returns (address) {
        return getMostRecentDeployment(contractName, block.chainid);
    }

    function getMostRecentDeployment(
        string memory contractName,
        uint256 chainId
    ) public view returns (address) {
        return
            getMostRecentDeployment(
                contractName,
                chainId,
                DEFAULT_BROADCAST_PATH
            );
    }

    function getMostRecentDeployment(
        string memory contractName,
        uint256 chainId,
        string memory broadcastPath
    ) public view returns (address) {
        DeploymentInfo memory deployment = getDeploymentInfo(
            contractName,
            chainId,
            broadcastPath
        );
        return deployment.contractAddress;
    }

    function getDeploymentInfo(
        string memory contractName,
        uint256 chainId
    ) public view returns (DeploymentInfo memory) {
        return getDeploymentInfo(contractName, chainId, DEFAULT_BROADCAST_PATH);
    }

    function getDeploymentInfo(
        string memory contractName,
        uint256 chainId,
        string memory broadcastPath
    ) public view returns (DeploymentInfo memory) {
        DeploymentInfo memory latestDeployment;
        uint256 latestTimestamp = 0;
        bool found = false;

        Vm.DirEntry[] memory entries = vm.readDir(broadcastPath, 3);

        for (uint256 i = 0; i < entries.length; i++) {
            string memory entryPath = entries[i].path;

            if (_isValidBroadcastFile(entryPath, chainId)) {
                string memory json = vm.readFile(entryPath);
                (
                    bool deploymentFound,
                    DeploymentInfo memory deployment
                ) = _parseDeploymentFromJson(json, contractName);

                if (deploymentFound && deployment.timestamp > latestTimestamp) {
                    latestDeployment = deployment;
                    latestTimestamp = deployment.timestamp;
                    found = true;
                }
            }
        }

        if (!found) {
            revert DeploymentNotFound(contractName, chainId);
        }

        return latestDeployment;
    }

    function getAllDeployments(
        string memory contractName
    ) public view returns (DeploymentInfo[] memory) {
        return getAllDeployments(contractName, DEFAULT_BROADCAST_PATH);
    }

    function getAllDeployments(
        string memory contractName,
        string memory broadcastPath
    ) public view returns (DeploymentInfo[] memory) {
        DeploymentInfo[] memory tempDeployments = new DeploymentInfo[](100);
        uint256 count = 0;

        Vm.DirEntry[] memory entries = vm.readDir(broadcastPath, 3);

        for (uint256 i = 0; i < entries.length; i++) {
            string memory entryPath = entries[i].path;

            if (_isValidBroadcastFile(entryPath, 0)) {
                string memory json = vm.readFile(entryPath);
                (
                    bool deploymentFound,
                    DeploymentInfo memory deployment
                ) = _parseDeploymentFromJson(json, contractName);

                if (deploymentFound && count < 100) {
                    tempDeployments[count] = deployment;
                    count++;
                }
            }
        }

        DeploymentInfo[] memory deployments = new DeploymentInfo[](count);
        for (uint256 i = 0; i < count; i++) {
            deployments[i] = tempDeployments[i];
        }

        return deployments;
    }

    function getChainInfo() public view returns (ChainInfo memory) {
        return
            ChainInfo({
                chainId: block.chainid,
                name: _getChainName(block.chainid),
                rpcUrl: "",
                blockNumber: block.number
            });
    }

    function deploymentExists(
        string memory contractName
    ) public view returns (bool) {
        return deploymentExists(contractName, block.chainid);
    }

    function deploymentExists(
        string memory contractName,
        uint256 chainId
    ) public view returns (bool) {
        try this.getMostRecentDeployment(contractName, chainId) returns (
            address
        ) {
            return true;
        } catch {
            return false;
        }
    }

    function saveDeployment(
        string memory contractName,
        address contractAddress,
        string memory deploymentsPath
    ) public {
        DeploymentInfo memory deployment = DeploymentInfo({
            contractAddress: contractAddress,
            contractName: contractName,
            blockNumber: block.number,
            timestamp: block.timestamp,
            txHash: bytes32(0),
            deployer: tx.origin
        });

        string memory json = _deploymentToJson(deployment);
        string memory fileName = string.concat(
            deploymentsPath,
            "/",
            vm.toString(block.chainid),
            "/",
            contractName,
            ".json"
        );

        vm.writeFile(fileName, json);

        emit DeploymentTracked(
            contractName,
            contractAddress,
            block.chainid,
            block.number
        );
    }

    function saveDeployment(
        string memory contractName,
        address contractAddress
    ) public {
        saveDeployment(contractName, contractAddress, DEFAULT_DEPLOYMENTS_PATH);
    }

    function deployContractFromFile(
        string memory filePath,
        ProLanguages.Language language
    ) public virtual returns (address) {
        return deployContractFromFile(filePath, language, "");
    }

    function deployContractFromFile(
        string memory filePath,
        ProLanguages.Language language,
        string memory constructorArgs
    ) public virtual returns (address contractAddress) {
        require(_fileExists(filePath), "Contract file does not exist");

        string memory expectedExtension = ProLanguages.getFileExtension(
            language
        );
        require(
            _hasExtension(filePath, expectedExtension),
            string.concat(
                "File extension must be ",
                expectedExtension,
                " for ",
                ProLanguages.toString(language)
            )
        );

        if (language == ProLanguages.Language.SOLIDITY) {
            contractAddress = _deploySolidityContract(
                filePath,
                constructorArgs
            );
        } else if (language == ProLanguages.Language.VYPER) {
            contractAddress = _deployVyperContract(filePath, constructorArgs);
        } else if (language == ProLanguages.Language.HUFF) {
            contractAddress = _deployHuffContract(filePath, constructorArgs);
        } else if (language == ProLanguages.Language.YUL) {
            contractAddress = _deployYulContract(filePath, constructorArgs);
        } else if (language == ProLanguages.Language.FE) {
            contractAddress = _deployFeContract(filePath, constructorArgs);
        } else if (language == ProLanguages.Language.RUST) {
            contractAddress = _deployRustContract(filePath, constructorArgs);
        } else {
            revert("Unsupported language");
        }

        string memory contractName = _extractContractName(filePath);
        saveDeployment(contractName, contractAddress);

        return contractAddress;
    }

    function _isValidBroadcastFile(
        string memory path,
        uint256 chainId
    ) internal view returns (bool) {
        if (!_contains(path, ".json") || _contains(path, "dry-run")) {
            return false;
        }

        if (chainId != 0) {
            return
                _contains(path, string.concat("/", vm.toString(chainId), "/"));
        }

        return true;
    }

    function _parseDeploymentFromJson(
        string memory json,
        string memory contractName
    ) internal view returns (bool found, DeploymentInfo memory deployment) {
        for (
            uint256 i = 0;
            vm.keyExistsJson(
                json,
                string.concat("$.transactions[", vm.toString(i), "]")
            );
            i++
        ) {
            string memory contractNamePath = string.concat(
                "$.transactions[",
                vm.toString(i),
                "].contractName"
            );

            if (vm.keyExistsJson(json, contractNamePath)) {
                string memory deployedContractName = json.readString(
                    contractNamePath
                );

                if (_isEqual(deployedContractName, contractName)) {
                    string memory basePath = string.concat(
                        "$.transactions[",
                        vm.toString(i),
                        "]"
                    );

                    deployment = DeploymentInfo({
                        contractAddress: json.readAddress(
                            string.concat(basePath, ".contractAddress")
                        ),
                        contractName: contractName,
                        blockNumber: vm.keyExistsJson(
                            json,
                            string.concat(basePath, ".blockNumber")
                        )
                            ? json.readUint(
                                string.concat(basePath, ".blockNumber")
                            )
                            : 0,
                        timestamp: vm.keyExistsJson(json, "$.timestamp")
                            ? json.readUint("$.timestamp")
                            : 0,
                        txHash: vm.keyExistsJson(
                            json,
                            string.concat(basePath, ".hash")
                        )
                            ? json.readBytes32(string.concat(basePath, ".hash"))
                            : bytes32(0),
                        deployer: vm.keyExistsJson(json, "$.commit")
                            ? address(0)
                            : address(0)
                    });

                    return (true, deployment);
                }
            }
        }

        return (false, deployment);
    }

    function _deploymentToJson(
        DeploymentInfo memory deployment
    ) internal view returns (string memory) {
        return
            string.concat(
                '{"contractName":"',
                deployment.contractName,
                '","contractAddress":"',
                vm.toString(deployment.contractAddress),
                '","blockNumber":',
                vm.toString(deployment.blockNumber),
                ',"timestamp":',
                vm.toString(deployment.timestamp),
                ',"deployer":"',
                vm.toString(deployment.deployer),
                '","chainId":',
                vm.toString(block.chainid),
                "}"
            );
    }

    function _getChainName(
        uint256 chainId
    ) internal pure returns (string memory) {
        if (chainId == 1) return "mainnet";
        if (chainId == 11155111) return "sepolia";
        if (chainId == 17000) return "holesky";
        if (chainId == 137) return "polygon";
        if (chainId == 42161) return "arbitrum";
        if (chainId == 10) return "optimism";
        if (chainId == 8453) return "base";
        if (chainId == 31337) return "anvil";
        return "unknown";
    }

    function _deploySolidityContract(
        string memory filePath,
        string memory constructorArgs
    ) internal virtual returns (address) {
        revert("Solidity deployment not yet implemented");
    }

    function _deployVyperContract(
        string memory filePath,
        string memory constructorArgs
    ) internal virtual returns (address) {
        revert("Vyper deployment not yet implemented");
    }

    function _deployHuffContract(
        string memory filePath,
        string memory constructorArgs
    ) internal virtual returns (address) {
        revert("Huff deployment not yet implemented");
    }

    function _deployYulContract(
        string memory filePath,
        string memory constructorArgs
    ) internal virtual returns (address) {
        revert("Yul deployment not yet implemented");
    }

    function _deployFeContract(
        string memory filePath,
        string memory constructorArgs
    ) internal virtual returns (address) {
        revert("Fe deployment not yet implemented");
    }

    function _deployRustContract(
        string memory filePath,
        string memory constructorArgs
    ) internal virtual returns (address) {
        revert("Rust deployment not yet implemented");
    }
}