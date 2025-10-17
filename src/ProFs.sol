// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.8.30;

import {Vm} from "forge-std/Vm.sol";

abstract contract ProFs {
    Vm internal constant vm =
        Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    function _fileExists(string memory filePath) internal view returns (bool) {
        try vm.readFile(filePath) returns (string memory) {
            return true;
        } catch {
            return false;
        }
    }

    function _hasExtension(
        string memory filePath,
        string memory extension
    ) internal pure returns (bool) {
        return _contains(filePath, extension);
    }

    function _extractContractName(
        string memory filePath
    ) internal pure returns (string memory) {
        bytes memory pathBytes = bytes(filePath);
        uint256 lastSlash = 0;
        uint256 lastDot = pathBytes.length;

        for (uint256 i = pathBytes.length; i > 0; i--) {
            if (pathBytes[i - 1] == 0x2F && lastSlash == 0) {
                // '/'
                lastSlash = i;
            }
            if (pathBytes[i - 1] == 0x2E && lastDot == pathBytes.length) {
                // '.'
                lastDot = i - 1;
            }
        }

        bytes memory nameBytes = new bytes(lastDot - lastSlash);
        for (uint256 i = lastSlash; i < lastDot; i++) {
            nameBytes[i - lastSlash] = pathBytes[i];
        }

        return string(nameBytes);
    }

    function _contains(
        string memory str,
        string memory substr
    ) internal pure returns (bool) {
        bytes memory strBytes = bytes(str);
        bytes memory substrBytes = bytes(substr);

        if (substrBytes.length > strBytes.length) return false;

        for (uint256 i = 0; i <= strBytes.length - substrBytes.length; i++) {
            bool found = true;
            for (uint256 j = 0; j < substrBytes.length; j++) {
                if (strBytes[i + j] != substrBytes[j]) {
                    found = false;
                    break;
                }
            }
            if (found) return true;
        }
        return false;
    }

    function _isEqual(
        string memory a,
        string memory b
    ) internal pure returns (bool) {
        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }
}
