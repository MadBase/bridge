/* //import {expect} from "../../chai-setup";
import {expect} from "chai";
import {ethers, deployments, network, } from 'hardhat';

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

const setupTest = deployments.createFixture(async ({deployments, getNamedAccounts, getUnnamedAccounts, ethers}, options) => {
  await deployments.fixture(); // ensure you start from a fresh deployments
  const {deploy} = deployments;
  //const {admin, tokenOwner} = await getNamedAccounts();

  const {admin} = await getNamedAccounts();
  //const [madStaking, minerStaking, lpStaking, foundation, governance] = await getUnnamedAccounts();

  // MadToken

  let deployResultMadToken = await deploy('MadToken', {
    from: admin,
    args: ["MadToken", "MAD"],
    log: true,
    autoMine: true,
    // proxy: false,
    // gasLimit: 4000000,
  });

  //await mineBlocks(1)

  //let deployResultMadToken = await deployResultMadTokenP
  //console.log('deployResultMadToken', deployResultMadToken)
  if (deployResultMadToken.newlyDeployed && deployResultMadToken.receipt) {
    console.log(
      `MadToken deployed at ${deployResultMadToken.address} using ${deployResultMadToken.receipt.gasUsed} gas`
    );
  }
  
  // MadByte

  let deployResultMadByte = await deploy('MadByte', {
    from: admin,
    // args: [admin, madStaking, minerStaking, lpStaking, foundation],
    args: [admin, PLACEHOLDER_ADDRESS, PLACEHOLDER_ADDRESS, PLACEHOLDER_ADDRESS, PLACEHOLDER_ADDRESS],
    log: true,
    autoMine: true,
    // proxy: false,
    // gasLimit: 4000000,
  });
  if (deployResultMadByte.newlyDeployed && deployResultMadByte.receipt) {
    console.log(
      `MadByte deployed at ${deployResultMadByte.address} using ${deployResultMadByte.receipt.gasUsed} gas`
    );
  }

  // StakeNFT

  let deployResultStakeNFT = await deploy('StakeNFT', {
    from: admin,
    // args: ['StakeNFT', 'MADSTK', deployResultMadByte.address, admin, governance],
    args: ['StakeNFT', 'MADSTK', deployResultMadByte.address, admin, PLACEHOLDER_ADDRESS],
    log: true,
    autoMine: true,
    // proxy: false,
    // gasLimit: 4000000,
  });
  if (deployResultStakeNFT.newlyDeployed && deployResultStakeNFT.receipt) {
    console.log(
      `StakeNFT deployed at ${deployResultStakeNFT.address} using ${deployResultStakeNFT.receipt.gasUsed} gas`
    );
  }

  // ValidatorNFT

  let deployResultValidatorNFT = await deploy('ValidatorNFT', {
    from: admin,
    // args: ['ValidatorNFT', 'VALSTK', deployResultMadByte.address, admin, governance],
    args: ['ValidatorNFT', 'VALSTK', deployResultMadByte.address, admin, PLACEHOLDER_ADDRESS],
    log: true,
    autoMine: true,
    // proxy: false,
    // gasLimit: 4000000,
  });
  if (deployResultValidatorNFT.newlyDeployed && deployResultValidatorNFT.receipt) {
    console.log(
      `ValidatorNFT deployed at ${deployResultValidatorNFT.address} using ${deployResultValidatorNFT.receipt.gasUsed} gas`
    );
  }

  // ValidatorPool
  let deployResultValidatorPool = await deploy('ValidatorPoolMock', {
    //contract: "src/tokens/periphery/Validators.sol:Validators",
    from: admin,
    //args: [deployResultStakeNFT.address, deployResultValidatorNFT.address, deployResultMadByte.address],
    args: [],
    log: true,
    autoMine: true,
    proxy: false,
    // gasLimit: 4000000,
  });
  if (deployResultValidatorPool.newlyDeployed && deployResultValidatorPool.receipt) {
    console.log(
      `ValidatorPoolMock deployed at ${deployResultValidatorPool.address} using ${deployResultValidatorPool.receipt.gasUsed} gas`
    );
    const validatorPool = await ethers.getContractAt("ValidatorPoolMock", deployResultValidatorPool.address, admin) // as ValidatorPool
    let tx = validatorPool.initialize()
    await mineBlocks(1)
    await tx
  }

  let deployResultETHDKG = await deploy('ETHDKG', {
    //contract: "src/tokens/periphery/ETHDKG.sol:ETHDKG",
    from: admin,
    //args: [deployResultStakeNFT.address, deployResultValidatorNFT.address, deployResultMadByte.address],
    args: [],
    log: true,
    autoMine: true,
    proxy: false,
    // gasLimit: 4000000,
  });
  if (deployResultETHDKG.newlyDeployed && deployResultETHDKG.receipt) {
    console.log(
      `ETHDKG deployed at ${deployResultETHDKG.address} using ${deployResultETHDKG.receipt.gasUsed} gas`
    );
    const ethdkg = await ethers.getContractAt("ETHDKG", deployResultETHDKG.address, admin) // as ETHDKG
    await ethdkg.initialize(deployResultValidatorPool.address)
  }

  console.log('finished core deployment')

  return {
    MadToken: await ethers.getContract("MadToken"),
    MadByte: await ethers.getContract("MadByte"),
    StakeNFT: await ethers.getContract("StakeNFT"),
    ValidatorNFT: await ethers.getContract("ValidatorNFT"),//, deployResultValidatorNFT.address),
    ValidatorPool: await ethers.getContract("ValidatorPoolMock"),//, deployResultValidatorPool.address),
    ETHDKG: await ethers.getContract("ETHDKG"),//, deployResultETHDKG.address),
    // admin: {
    //   address: admin,
    // },
    namedAccounts: await getNamedAccounts(),
    unnamedAccounts: await getUnnamedAccounts(),
    // getSignedContract: async (contract: string, signer: string) => {
    //   return await ethers.getContract(contract, signer)
    // }
  };
});


describe("ETHDKG", function () {

  it("compiles", async function () {
    const {ValidatorPool, ETHDKG, namedAccounts, unnamedAccounts} = await setupTest()
    //console.log('named:', namedAccounts)
    //console.log('unnamed:', unnamedAccounts)
    const {admin, validator0, validator1, validator2, validator3} = namedAccounts;

    await ValidatorPool.setETHDKG(ETHDKG.address)
    await ValidatorPool.addValidator(validator0);
    await ValidatorPool.addValidator(validator1);
    await ValidatorPool.addValidator(validator2);
    await ValidatorPool.addValidator(validator3);

    expect(await ValidatorPool.isValidator(validator0)).to.equal(true)
    expect(await ValidatorPool.isValidator(validator1)).to.equal(true)
    expect(await ValidatorPool.isValidator(validator2)).to.equal(true)
    expect(await ValidatorPool.isValidator(validator3)).to.equal(true)

    expect(await ValidatorPool.initializeETHDKG()).to
      .emit(ETHDKG, "RegistrationOpened")
      .withArgs(14, 1);
    
    // register validator0
    expect(await (await ethers.getContract("ETHDKG", validator0)).register(
      ["0x23bc3a063e898eb1f5f8e856fca12f4e7d87eab069b053bf96f8cbaf8ad98884", "0x0e97501434da93e87f9a7badf3c99078f9bed24616f47f0267bd3d4dab7a4f11"]))
    .to.emit(ETHDKG, "AddressRegistered")
    .withArgs(validator0, 1, 1, ["0x23bc3a063e898eb1f5f8e856fca12f4e7d87eab069b053bf96f8cbaf8ad98884", "0x0e97501434da93e87f9a7badf3c99078f9bed24616f47f0267bd3d4dab7a4f11"])

    // register validator1
    expect(await (await ethers.getContract("ETHDKG", validator1)).register(
      ["0x05bbe20b28faf3c4c96fef2796d0c77b235de62119c663e4a125755a1d0025d7", "0x0599e9e116636921ccb9c44bd609d78e02473c2f8d67769f6dce5c70a4434230"]))
    .to.emit(ETHDKG, "AddressRegistered")
    .withArgs(validator1, 2, 1, ["0x05bbe20b28faf3c4c96fef2796d0c77b235de62119c663e4a125755a1d0025d7", "0x0599e9e116636921ccb9c44bd609d78e02473c2f8d67769f6dce5c70a4434230"])

    // register validator2
    expect(await (await ethers.getContract("ETHDKG", validator2)).register(
      ["0x2f74907761d553f40bde96cc6459b22488e16df0878dcf96c53bf98a387b2c99", "0x0fffb58eb894f542aae6bee6a8c7aa8b3dbb7162ace24ab995321679f8e1c3fe"]))
    .to.emit(ETHDKG, "AddressRegistered")
    .withArgs(validator2, 3, 1, ["0x2f74907761d553f40bde96cc6459b22488e16df0878dcf96c53bf98a387b2c99", "0x0fffb58eb894f542aae6bee6a8c7aa8b3dbb7162ace24ab995321679f8e1c3fe"])

    // register validator3
    let bn = await ethers.provider.getBlockNumber()
    console.log('bn', bn)
    expect(await (await ethers.getContract("ETHDKG", validator3)).register(
      ["0x18acfb61c62db84c8e502d8b1abf5fc4309eeedc64f2bbd2639b281d6c207cab", "0x09a300e6ffd862c99c2078df4160f20c3ed41b2b4af5497a0e8b50aaa5db35ca"]))
    .to.emit(ETHDKG, "AddressRegistered")
    .withArgs(validator3, 4, 1, ["0x18acfb61c62db84c8e502d8b1abf5fc4309eeedc64f2bbd2639b281d6c207cab", "0x09a300e6ffd862c99c2078df4160f20c3ed41b2b4af5497a0e8b50aaa5db35ca"])
    .to.emit(ETHDKG, "RegistrationComplete")
    .withArgs(bn+1)


    mineBlocks(1)
  });
}); */