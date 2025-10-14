# Prosciutto

<div align="center">
  <img src="public/prosciutto.png" alt="Prosciutto Logo" width="200"/>
</div>

A DevOps foundry library that provides enhanced vm functionality and deployment management tools for Ethereum development workflows.

## Overview

Prosciutto is a foundry library designed to streamline DevOps operations in EVM-base chains development. It offers a powerful wrapper around the foundry vm interface, providing advanced deployment tracking, contract management, and development utilities.

## Core Features

- **Enhanced VM Interface**: ProVm contract that wraps and extends foundry's vm functionality
- **Deployment Tracking**: Comprehensive deployment management across multiple chains
- **Contract Discovery**: Advanced utilities for finding and managing deployed contracts
- **Chain Management**: Built-in support for multiple networks and chain configurations

## Installation

```bash
forge install pxlvre/prosciutto
```

## Quick Start

```solidity
import {ProVm} from "prosciutto/ProVm.sol";

contract MyScript is Script {
    ProVm public proVm = new ProVm();

    function run() public {
        // Get the most recent deployment
        address myContract = proVm.getMostRecentDeployment("MyContract");

        // Check if deployment exists
        bool exists = proVm.deploymentExists("MyContract");

        // Get deployment info
        ProVm.DeploymentInfo memory info = proVm.getDeploymentInfo("MyContract");
    }
}
```

## License

This project is licensed under the [AGPL-3.0-or-later](LICENSE) license.

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
