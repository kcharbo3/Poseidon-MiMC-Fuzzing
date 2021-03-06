//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface MiMC7 {
    function mimcPe7(uint256, uint256) external pure returns (uint256);
}

interface MiMCSponge {
    function mimcSponge(
        uint256,
        uint256,
        uint256
    ) external pure returns (uint256, uint256);
}
