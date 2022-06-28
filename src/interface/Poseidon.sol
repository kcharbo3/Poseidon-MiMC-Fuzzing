//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface PoseidonT3 {
    function poseidon(uint256[2] memory) external pure returns (uint256);

    function poseidon(bytes32[2] memory) external pure returns (bytes32);
}

interface PoseidonT6 {
    function poseidon(uint256[5] memory) external pure returns (uint256);

    function poseidon(bytes32[5] memory) external pure returns (bytes32);
}
