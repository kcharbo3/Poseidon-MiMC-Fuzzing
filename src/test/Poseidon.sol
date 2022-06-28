// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./helpers.sol";

import {Poseidon} from "../implementation/Poseidon.sol";

contract PoseidonTest is Poseidon {
    function test_poseidont3_uint256(uint256[2] memory input) external {
        // Every call to assertFreeMemPointer adds 128 bytes due to keccak256
        // 128 (default) + 64 (input)
        assertFreeMemPointer(192);

        // 192 + 128
        assertFreeMemPointer(320);

        // Surround memory of input with some junk that could be accidentially read/overwritten by lib.
        bytes
            memory preJunk1 = hex"f00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00f";
        // 320 + 128 + 64 (bytes length + data)
        assertFreeMemPointer(512);
        uint256[2] memory memInput = input;
        assertFreeMemPointer(640);
        bytes
            memory preJunk2 = hex"f00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00f";
        assertFreeMemPointer(832);

        (bool success, bytes memory results) = address(t3).delegatecall(
            abi.encodeWithSignature("poseidon(uint256[2])", memInput)
        );
        require(success, "t3 hash failed");

        // assumed
        assertFreeMemPointer(1124);

        // Fill memory with more junk that could overwrite memory of lib return value (if free mem pointer wasn't updated).
        bytes
            memory postJunk = hex"f00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00f";
        assertFreeMemPointer(1316);

        // Check whether input passed was modified.
        assert(
            keccak256(abi.encodePacked(input)) ==
                keccak256(abi.encodePacked(memInput))
        );
        // Check whether preJunk was overwritten by lib.
        assert(keccak256(preJunk1) == keccak256(postJunk));
        assert(keccak256(preJunk2) == keccak256(postJunk));
    }

    function test_poseidont3_bytes32(bytes32[2] memory input) external {
        // Every call to assertFreeMemPointer adds 128 bytes due to keccak256
        // 128 (default) + 64 (input)
        assertFreeMemPointer(192);

        // 192 + 128
        assertFreeMemPointer(320);

        // Surround memory of input with some junk that could be accidentially read/overwritten by lib.
        bytes
            memory preJunk1 = hex"f00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00f";
        // 320 + 128 + 64 (bytes length + data)
        assertFreeMemPointer(512);
        bytes32[2] memory memInput = input;
        assertFreeMemPointer(640);
        bytes
            memory preJunk2 = hex"f00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00f";
        assertFreeMemPointer(832);

        (bool success, bytes memory results) = address(t3).delegatecall(
            abi.encodeWithSignature("poseidon(bytes32[2])", input)
        );
        require(success, "t3 hash failed");

        // assumed
        assertFreeMemPointer(1124);

        // Fill memory with more junk that could overwrite memory of lib return value (if free mem pointer wasn't updated).
        bytes
            memory postJunk = hex"f00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00f";
        assertFreeMemPointer(1316);

        // Check whether input passed was modified.
        assert(
            keccak256(abi.encodePacked(input)) ==
                keccak256(abi.encodePacked(memInput))
        );
        // Check whether preJunk was overwritten by lib.
        assert(keccak256(preJunk1) == keccak256(postJunk));
        assert(keccak256(preJunk2) == keccak256(postJunk));
    }

    function test_poseidont6_uint256(uint256[5] memory input) external {
        // Every call to assertFreeMemPointer adds 128 bytes due to keccak256
        // 128 (default) + 160 (input)
        assertFreeMemPointer(288);

        // 288 + 128
        assertFreeMemPointer(416);

        // Surround memory of input with some junk that could be accidentially read/overwritten by lib.
        bytes
            memory preJunk1 = hex"f00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00f";
        // 416 + 128 + 64 (bytes length + data)
        assertFreeMemPointer(608);
        uint256[5] memory memInput = input;
        assertFreeMemPointer(736);
        bytes
            memory preJunk2 = hex"f00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00f";
        assertFreeMemPointer(928);

        (bool success, bytes memory results) = address(t6).delegatecall(
            abi.encodeWithSignature("poseidon(uint256[5])", input)
        );
        require(success, "t6 hash failed");

        // assumed
        assertFreeMemPointer(1316);

        // Fill memory with more junk that could overwrite memory of lib return value (if free mem pointer wasn't updated).
        bytes
            memory postJunk = hex"f00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00f";
        assertFreeMemPointer(1508);

        // Check whether input passed was modified.
        assert(
            keccak256(abi.encodePacked(input)) ==
                keccak256(abi.encodePacked(memInput))
        );
        // Check whether preJunk was overwritten by lib.
        assert(keccak256(preJunk1) == keccak256(postJunk));
        assert(keccak256(preJunk2) == keccak256(postJunk));
    }

    function test_poseidont6_bytes32(bytes32[5] memory input) external {
        // Every call to assertFreeMemPointer adds 128 bytes due to keccak256
        // 128 (default) + 160 (input)
        assertFreeMemPointer(288);

        // 288 + 128
        assertFreeMemPointer(416);

        // Surround memory of input with some junk that could be accidentially read/overwritten by lib.
        bytes
            memory preJunk1 = hex"f00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00f";
        // 416 + 128 + 64 (bytes length + data)
        assertFreeMemPointer(608);
        bytes32[5] memory memInput = input;
        assertFreeMemPointer(736);
        bytes
            memory preJunk2 = hex"f00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00f";
        assertFreeMemPointer(928);

        (bool success, bytes memory results) = address(t6).delegatecall(
            abi.encodeWithSignature("poseidon(bytes32[5])", input)
        );
        require(success, "t6 hash failed");

        // assumed
        assertFreeMemPointer(1316);

        // Fill memory with more junk that could overwrite memory of lib return value (if free mem pointer wasn't updated).
        bytes
            memory postJunk = hex"f00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00f";
        assertFreeMemPointer(1508);

        // Check whether input passed was modified.
        assert(
            keccak256(abi.encodePacked(input)) ==
                keccak256(abi.encodePacked(memInput))
        );
        // Check whether preJunk was overwritten by lib.
        assert(keccak256(preJunk1) == keccak256(postJunk));
        assert(keccak256(preJunk2) == keccak256(postJunk));
    }

    function assertFreeMemPointer(uint256 num) private pure {
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
