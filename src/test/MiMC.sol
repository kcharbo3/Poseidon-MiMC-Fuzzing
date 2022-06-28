// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

//import "forge-std/Test.sol";
import "./helpers.sol";

import {MiMC} from "../implementation/MiMC.sol";

contract MiMCTest is MiMC {
    function test_mimc_sponge(
        uint256 xL_in,
        uint256 xR_in,
        uint256 k
    ) external {
        // Every call to assertFreeMemPointer adds 128 bytes due to keccak256
        // 128 (default) + 0 (input)
        assertFreeMemPointer(128);

        // Surround memory of input with some junk that could be accidentially read/overwritten by lib.
        bytes
            memory preJunk1 = hex"f00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00f";
        // 128 + 128 + 64 (bytes length + data)
        assertFreeMemPointer(320);

        (bool success, bytes memory results) = address(sponge).delegatecall(
            abi.encodeWithSignature(
                "MiMCSponge(uint256,uint256,uint256)",
                xL_in,
                xR_in,
                k
            )
        );
        require(success, "mimcSponge hash failed");

        // assumed
        assertFreeMemPointer(676);

        bytes
            memory postJunk = hex"f00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00f";
        assertFreeMemPointer(868);

        // Check whether preJunk was overwritten by lib.
        assert(keccak256(preJunk1) == keccak256(postJunk));
    }

    function test_mimc_7(uint256 in_x, uint256 in_y) external {
        // Every call to assertFreeMemPointer adds 128 bytes due to keccak256
        // 128 (default) + 64 (input)
        assertFreeMemPointer(128);

        // Surround memory of input with some junk that could be accidentially read/overwritten by lib.
        bytes
            memory preJunk1 = hex"f00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00f";
        // 128 + 128 + 64 (bytes length + data)
        assertFreeMemPointer(320);

        (bool success, bytes memory results) = address(mimc7).delegatecall(
            abi.encodeWithSignature("MiMCpe7(uint256,uint256)", in_x, in_y)
        );
        require(success, "mimc7 hash failed");

        // assumed
        assertFreeMemPointer(612);

        // Fill memory with more junk that could overwrite memory of lib return value (if free mem pointer wasn't updated).
        bytes
            memory postJunk = hex"f00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00f";
        assertFreeMemPointer(804);

        // Check whether preJunk was overwritten by lib.
        assert(keccak256(preJunk1) == keccak256(postJunk));
    }

    function assertFreeMemPointer(uint256 num) private {
        bytes32 freeMem = getFreeMemPointer();

        // each keccak adds 64
        assert(
            keccak256(abi.encodePacked(freeMem)) ==
                keccak256(abi.encodePacked(bytes32(uint256(num))))
        );
    }

    function getFreeMemPointer() private pure returns (bytes32) {
        bytes32 freeMem;
        assembly {
            freeMem := mload(0x40) // slot 64 - free mem pointer
        }
        return freeMem;
    }
}
