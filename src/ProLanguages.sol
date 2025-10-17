// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.8.30;

library ProLanguages {
    enum Language {
        SOLIDITY,
        VYPER,
        HUFF,
        YUL,
        FE,
        RUST
    }

    function toString(Language lang) internal pure returns (string memory) {
        if (lang == Language.SOLIDITY) return "solidity";
        if (lang == Language.VYPER) return "vyper";
        if (lang == Language.HUFF) return "huff";
        if (lang == Language.YUL) return "yul";
        if (lang == Language.FE) return "fe";
        if (lang == Language.RUST) return "rust";
        revert("Unknown language");
    }

    function getFileExtension(
        Language lang
    ) internal pure returns (string memory) {
        if (lang == Language.SOLIDITY) return ".sol";
        if (lang == Language.VYPER) return ".vy";
        if (lang == Language.HUFF) return ".huff";
        if (lang == Language.YUL) return ".yul";
        if (lang == Language.FE) return ".fe";
        if (lang == Language.RUST) return ".rs";
        revert("Unknown language");
    }

    function isCompiled(Language lang) internal pure returns (bool) {
        return
            lang == Language.SOLIDITY ||
            lang == Language.VYPER ||
            lang == Language.HUFF ||
            lang == Language.FE ||
            lang == Language.RUST;
    }

    function isInterpreted(Language lang) internal pure returns (bool) {
        return lang == Language.YUL;
    }

    function supportsInheritance(Language lang) internal pure returns (bool) {
        return lang == Language.SOLIDITY || lang == Language.RUST;
    }

    function hasNativeABI(Language lang) internal pure returns (bool) {
        return
            lang == Language.SOLIDITY ||
            lang == Language.VYPER ||
            lang == Language.FE;
    }
}
