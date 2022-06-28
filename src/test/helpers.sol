// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface CheatCodes {
    // Performs a foreign function call via terminal.
    function ffi(string[] calldata) external returns (bytes memory);

    // Foundry: Generate new fuzzing inputs if conditional not met.
    function assume(bool) external;
}

/**
 * Skip invalid fuzzing inputs.
 *
 * Both Foundry and Echidna (in dapptest mode) will take revert/assert errors
 * as test failure. This helper function is for skipping invalid inputs that
 * shouldn't be misunderstood as a fuzzer-finding.
 * HEVM_ADDRESS = 0x7109709ECfa91a80626fF3989D68f67F5b1DD12D;
 */
function assuming(bool condition) {
    // Foundry has a special cheatcode for this:
    if (block.gaslimit > 0) {
        // This call will cause Echidna to get stuck, so this "gaslimit" check
        // ensures it's only executed when doing fuzzing within foundry.
        // NOTE: The gaslimit in Echidna will only be 0 if there's an init file!
        CheatCodes(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D).assume(
            condition
        );
    }
    // For Echidna in dapptest mode: Use a specific revert reason for skipping.
    require(condition, "FOUNDRY::ASSUME");
}

function exec(string[] memory args) returns (bytes memory) {
    return CheatCodes(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D).ffi(args);
}

// OpenZeppelin's toString function
function toString(uint256 value) pure returns (string memory) {
    // Inspired by OraclizeAPI's implementation - MIT licence
    // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

    if (value == 0) {
        return "0";
    }
    uint256 temp = value;
    uint256 digits;
    while (temp != 0) {
        digits++;
        temp /= 10;
    }
    bytes memory buffer = new bytes(digits);
    while (value != 0) {
        digits -= 1;
        buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
        value /= 10;
    }
    return string(buffer);
}
