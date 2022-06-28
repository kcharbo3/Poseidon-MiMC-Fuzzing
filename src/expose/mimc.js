#!/usr/bin/env node
const { AbiCoder } = require("@ethersproject/abi");
const { buildMimcSponge, buildMimc7 } = require("circomlibjs");

abiCoder = new AbiCoder();
async function hash() {
  const identifier = process.argv[2];
  if (identifier == "sponge") {
    const sponge = await buildMimcSponge();

    const result = sponge.hash(
      BigInt(process.argv[3]),
      BigInt(process.argv[4]),
      BigInt(process.argv[5])
    );
    const xL = sponge.F.toString(result.xL);
    const xR = sponge.F.toString(result.xR);
    const abiEncode = abiCoder.encode(["uint256", "uint256"], [xL, xR]);
    process.stdout.write(abiEncode);
  } else {
    const mimc7 = await buildMimc7();

    const result = mimc7.hash(BigInt(process.argv[3]), BigInt(process.argv[4]));
    const resultString = mimc7.F.toString(result);
    const abiEncode = abiCoder.encode(["uint256"], [resultString]);
    process.stdout.write(abiEncode);
  }
}
hash();
