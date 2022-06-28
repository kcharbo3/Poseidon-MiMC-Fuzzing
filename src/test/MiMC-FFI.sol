// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./helpers.sol";

import {MiMC} from "../implementation/MiMC.sol";

contract MiMCFFI is MiMC {
    uint256 internal constant SNARK_SCALAR_FIELD =
        21888242871839275222246405745257275088548364400416034343698204186575808495617;

    function test_MiMCSponge_FFI(
        uint256 xL_in,
        uint256 xR_in,
        uint256 k
    ) external {
        xL_in %= SNARK_SCALAR_FIELD;
        xR_in %= SNARK_SCALAR_FIELD;
        k %= SNARK_SCALAR_FIELD;

        (bool success, bytes memory results) = address(sponge).delegatecall(
            abi.encodeWithSignature(
                "MiMCSponge(uint256,uint256,uint256)",
                xL_in,
                xR_in,
                k
            )
        );
        require(success, "MiMC Sponge hash failed");
        (uint256 outputHashA, uint256 outputHashB) = abi.decode(
            results,
            (uint256, uint256)
        );

        string[] memory inputs = new string[](6);
        inputs[0] = "node";
        inputs[1] = "./src/expose/mimc.js";
        inputs[2] = "sponge";
        inputs[3] = toString(xL_in);
        inputs[4] = toString(xR_in);
        inputs[5] = toString(k);

        (uint256 outputHashC, uint256 outputHashD) = abi.decode(
            exec(inputs),
            (uint256, uint256)
        );
        assert(outputHashA == outputHashC);
        assert(outputHashB == outputHashD);
    }

    function test_MiMC7_FFI(uint256 in_x, uint256 in_y) external {
        in_x %= SNARK_SCALAR_FIELD;
        in_y %= SNARK_SCALAR_FIELD;

        (bool success, bytes memory results) = address(mimc7).delegatecall(
            abi.encodeWithSignature("MiMCpe7(uint256,uint256)", in_x, in_y)
        );
        require(success, "MiMC7 hash failed");
        uint256 outputHashA = abi.decode(results, (uint256));

        string[] memory inputs = new string[](5);
        inputs[0] = "node";
        inputs[1] = "./src/expose/mimc.js";
        inputs[2] = "7";
        inputs[3] = toString(in_x);
        inputs[4] = toString(in_y);

        uint256 outputHashB = abi.decode(exec(inputs), (uint256));
        assert(outputHashA == outputHashB);
    }
}
