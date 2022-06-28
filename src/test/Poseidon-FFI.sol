// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./helpers.sol";

import {Poseidon} from "../implementation/Poseidon.sol";

contract PoseidonFFI is Poseidon {
    uint256 internal constant SNARK_SCALAR_FIELD =
        21888242871839275222246405745257275088548364400416034343698204186575808495617;

    function test_uint256_PoseidonT3_FFI(uint256[2] memory hashPreimage)
        external
    {
        hashPreimage[0] = hashPreimage[0] % SNARK_SCALAR_FIELD;
        hashPreimage[1] = hashPreimage[1] % SNARK_SCALAR_FIELD;

        (bool success, bytes memory results) = address(t3).delegatecall(
            abi.encodeWithSignature("poseidon(uint256[2])", hashPreimage)
        );
        require(success, "t3 hash failed");
        uint256 outputHashA = abi.decode(results, (uint256));

        string[] memory inputs = new string[](5);
        inputs[0] = "node";
        inputs[1] = "./src/expose/poseidon.js";
        inputs[2] = "2";
        inputs[3] = toString(hashPreimage[0]);
        inputs[4] = toString(hashPreimage[1]);

        uint256 outputHashB = abi.decode(exec(inputs), (uint256));
        assert(outputHashA == outputHashB);
    }

    function test_bytes32_PoseidonT3_FFI(bytes32[2] memory hashPreimage)
        external
    {
        hashPreimage[0] = bytes32(
            uint256(hashPreimage[0]) % SNARK_SCALAR_FIELD
        );
        hashPreimage[1] = bytes32(
            uint256(hashPreimage[1]) % SNARK_SCALAR_FIELD
        );

        (bool success, bytes memory results) = address(t3).delegatecall(
            abi.encodeWithSignature("poseidon(bytes32[2])", hashPreimage)
        );
        require(success, "t3 hash failed");
        uint256 outputHashA = abi.decode(results, (uint256));

        string[] memory inputs = new string[](5);
        inputs[0] = "node";
        inputs[1] = "./src/expose/poseidon.js";
        inputs[2] = "2";
        inputs[3] = toString(uint256(hashPreimage[0]));
        inputs[4] = toString(uint256(hashPreimage[1]));

        uint256 outputHashB = abi.decode(exec(inputs), (uint256));
        assert(outputHashA == outputHashB);
    }

    function test_uint256_PoseidonT6_FFI(uint256[5] memory hashPreimage)
        external
    {
        for (uint256 i = 0; i < 5; i++) {
            hashPreimage[i] = hashPreimage[i] % SNARK_SCALAR_FIELD;
        }

        (bool success, bytes memory results) = address(t6).delegatecall(
            abi.encodeWithSignature("poseidon(uint256[5])", hashPreimage)
        );
        require(success, "t6 hash failed");
        uint256 outputHashA = abi.decode(results, (uint256));

        string[] memory inputs = new string[](8);
        inputs[0] = "node";
        inputs[1] = "./src/expose/poseidon.js";
        inputs[2] = "5";
        for (uint256 i = 0; i < 5; i++) {
            inputs[3 + i] = toString(hashPreimage[i]);
        }

        uint256 outputHashB = abi.decode(exec(inputs), (uint256));
        assert(outputHashA == outputHashB);
    }

    function test_bytes32_PoseidonT6_FFI(bytes32[5] memory hashPreimage)
        external
    {
        for (uint256 i = 0; i < 5; i++) {
            hashPreimage[i] = bytes32(
                uint256(hashPreimage[i]) % SNARK_SCALAR_FIELD
            );
        }

        (bool success, bytes memory results) = address(t6).delegatecall(
            abi.encodeWithSignature("poseidon(bytes32[5])", hashPreimage)
        );
        require(success, "t6 hash failed");
        uint256 outputHashA = abi.decode(results, (uint256));

        string[] memory inputs = new string[](8);
        inputs[0] = "node";
        inputs[1] = "./src/expose/poseidon.js";
        inputs[2] = "5";
        for (uint256 i = 0; i < 5; i++) {
            inputs[3 + i] = toString(uint256(hashPreimage[i]));
        }

        uint256 outputHashB = abi.decode(exec(inputs), (uint256));
        assert(outputHashA == outputHashB);
    }
}
