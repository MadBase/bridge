import {expect} from "../../chai-setup";
//import {expect} from "chai";
import {ethers, network } from 'hardhat';

// const { expect } = require("chai");
// const { ethers, upgrades } = require("hardhat");
// const { deployMockContract } = require("ethereum-waffle");
const PLACEHOLDER_ADDRESS = "0x0000000000000000000000000000000000000000"

const mineBlocks = async (nBlocks: number) => {
  while (nBlocks > 0) {
    nBlocks--;
    await network.provider.request({
      method: "evm_mine",
      //params: [],
    });
  }
}

const getBlockByNumber = async () => {
  return await network.provider.send("eth_getBlockByNumber", [
    "pending",
    false,
  ])
}

const getPendingTransactions = async () => {
  return await network.provider.send("eth_pendingTransactions")
}

const getFixture = async () => {
  await network.provider.send("evm_setAutomine", [true]);

  const namedSigners = await ethers.getNamedSigners()
  const {admin} = namedSigners

  // MadToken
  const MadToken = await ethers.getContractFactory("MadToken");
  const madToken = await MadToken.deploy("MadToken", "MAD");
  await madToken.deployed();
  console.log(
    `MadToken deployed at ${madToken.address}`
  );

  // MadByte
  const MadByte = await ethers.getContractFactory("MadByte");
  const madByte = await MadByte.deploy(admin.address, PLACEHOLDER_ADDRESS, PLACEHOLDER_ADDRESS, PLACEHOLDER_ADDRESS, PLACEHOLDER_ADDRESS);
  await madByte.deployed();
  console.log(
    `MadByte deployed at ${madByte.address}`
  );

  // StakeNFT
  const StakeNFT = await ethers.getContractFactory("StakeNFT");
  const stakeNFT = await StakeNFT.deploy('StakeNFT', 'MADSTK', madByte.address, admin.address, PLACEHOLDER_ADDRESS);
  await stakeNFT.deployed();
  console.log(
    `StakeNFT deployed at ${stakeNFT.address}`
  );

  // ValidatorNFT
  const ValidatorNFT = await ethers.getContractFactory("ValidatorNFT");
  const validatorNFT = await ValidatorNFT.deploy('ValidatorNFT', 'VALSTK', madByte.address, admin.address, PLACEHOLDER_ADDRESS);
  await validatorNFT.deployed();
  console.log(
    `ValidatorNFT deployed at ${validatorNFT.address}`
  );

  // ValidatorPool
  const ValidatorPool = await ethers.getContractFactory("ValidatorPoolMock");
  const validatorPool = await ValidatorPool.deploy();
  await validatorPool.deployed();
  console.log(
    `ValidatorPool deployed at ${validatorPool.address}`
  );

  // ETHDKG
  const ETHDKG = await ethers.getContractFactory("ETHDKG");
  const ethdkg = await ETHDKG.deploy();
  await ethdkg.deployed();
  console.log(
    `ETHDKG deployed at ${ethdkg.address}`
  );

  await ethdkg.initialize(validatorPool.address)
  
  console.log('finished core deployment')

  return {
    madToken,
    madByte,
    stakeNFT,
    validatorNFT,
    validatorPool,
    ethdkg,
    namedSigners
  }
};


describe("ETHDKG", function () {

  it("compiles", async function () {
    const {ethdkg, validatorPool, namedSigners} = await getFixture()
    const {admin, validator0, validator1, validator2, validator3} = namedSigners
    
    await validatorPool.setETHDKG(ethdkg.address)
    await validatorPool.addValidator(validator0.address);
    await validatorPool.addValidator(validator1.address);
    await validatorPool.addValidator(validator2.address);
    await validatorPool.addValidator(validator3.address);

    expect(await validatorPool.isValidator(validator0.address)).to.equal(true)
    expect(await validatorPool.isValidator(validator1.address)).to.equal(true)
    expect(await validatorPool.isValidator(validator2.address)).to.equal(true)
    expect(await validatorPool.isValidator(validator3.address)).to.equal(true)

    // start ETHDKG
    await expect(validatorPool.initializeETHDKG()).to
      .emit(ethdkg, "RegistrationOpened")
      .withArgs(13, 1);
    
    // register validator0
    await expect(ethdkg.connect(validator0).register(
      ["0x23bc3a063e898eb1f5f8e856fca12f4e7d87eab069b053bf96f8cbaf8ad98884", "0x0e97501434da93e87f9a7badf3c99078f9bed24616f47f0267bd3d4dab7a4f11"]))
    .to.emit(ethdkg, "AddressRegistered")
    .withArgs(validator0.address, 1, 1, ["0x23bc3a063e898eb1f5f8e856fca12f4e7d87eab069b053bf96f8cbaf8ad98884", "0x0e97501434da93e87f9a7badf3c99078f9bed24616f47f0267bd3d4dab7a4f11"])

    // register validator1
    await expect(ethdkg.connect(validator1).register(
      ["0x05bbe20b28faf3c4c96fef2796d0c77b235de62119c663e4a125755a1d0025d7", "0x0599e9e116636921ccb9c44bd609d78e02473c2f8d67769f6dce5c70a4434230"]))
    .to.emit(ethdkg, "AddressRegistered")
    .withArgs(validator1.address, 2, 1, ["0x05bbe20b28faf3c4c96fef2796d0c77b235de62119c663e4a125755a1d0025d7", "0x0599e9e116636921ccb9c44bd609d78e02473c2f8d67769f6dce5c70a4434230"])

    // register validator2
    let bn = await ethers.provider.getBlockNumber()
    console.log('bn', bn)
    await expect(ethdkg.connect(validator2).register(
      ["0x2f74907761d553f40bde96cc6459b22488e16df0878dcf96c53bf98a387b2c99", "0x0fffb58eb894f542aae6bee6a8c7aa8b3dbb7162ace24ab995321679f8e1c3fe"]))
    .to.emit(ethdkg, "AddressRegistered")
    .withArgs(validator2.address, 3, 1, ["0x2f74907761d553f40bde96cc6459b22488e16df0878dcf96c53bf98a387b2c99", "0x0fffb58eb894f542aae6bee6a8c7aa8b3dbb7162ace24ab995321679f8e1c3fe"])

    // register validator3
    bn = await ethers.provider.getBlockNumber()
    console.log('bn', bn)
    await expect(ethdkg.connect(validator3).register(
      ["0x18acfb61c62db84c8e502d8b1abf5fc4309eeedc64f2bbd2639b281d6c207cab", "0x09a300e6ffd862c99c2078df4160f20c3ed41b2b4af5497a0e8b50aaa5db35ca"]))
    .to.emit(ethdkg, "AddressRegistered")
    .withArgs(validator3.address, 4, 1, ["0x18acfb61c62db84c8e502d8b1abf5fc4309eeedc64f2bbd2639b281d6c207cab", "0x09a300e6ffd862c99c2078df4160f20c3ed41b2b4af5497a0e8b50aaa5db35ca"])
    .to.emit(ethdkg, "RegistrationComplete")
    .withArgs(bn+1)

    // distribute shares
    //ethdkg.connect(validator0).distributeShares


  });
});
