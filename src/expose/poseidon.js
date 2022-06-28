#!/usr/bin/env node
const { AbiCoder } = require("@ethersproject/abi");
const { buildPoseidon } = require("circomlibjs");

abiCoder = new AbiCoder();
async function hash() {
  const poseidon = await buildPoseidon();
  const numArgs = parseInt(process.argv[2]);
  let inputs = [];
  for (let i = 0; i < numArgs; i++) {
    inputs.push(BigInt(process.argv[3 + i]));
  }

  const result = poseidon(inputs);
  const resultString = poseidon.F.toString(result);
  const abiEncode = abiCoder.encode(["uint256"], [BigInt(resultString)]);
  process.stdout.write(abiEncode);
}
hash();
