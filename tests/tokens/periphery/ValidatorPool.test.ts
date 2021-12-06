import {expect} from "../../chai-setup";
import {ethers, deployments, getNamedAccounts} from 'hardhat';

// const { expect } = require("chai");
// const { ethers, upgrades } = require("hardhat");
// const { deployMockContract } = require("ethereum-waffle");


const setupTest = deployments.createFixture(async ({deployments, getNamedAccounts, getUnnamedAccounts, ethers}, options) => {
  await deployments.fixture(); // ensure you start from a fresh deployments
  const {deploy} = deployments;
  //const {admin, tokenOwner} = await getNamedAccounts();

  //const {admin, madStaking, minerStaking, lpStaking, foundation} = await getNamedAccounts();
  const [admin, madStaking, minerStaking, lpStaking, foundation, governance] = await getUnnamedAccounts();

  // MadToken

  let deployResultMadToken = await deploy('MadToken', {
    from: admin,
    args: ["MadToken", "MAD"],
    log: true,
    // proxy: false,
    // gasLimit: 4000000,
  });
  if (deployResultMadToken.newlyDeployed && deployResultMadToken.receipt) {
    console.log(
      `MadToken deployed at ${deployResultMadToken.address} using ${deployResultMadToken.receipt.gasUsed} gas`
    );
  }
  
  // MadByte

  let deployResultMadByte = await deploy('MadByte', {
    from: admin,
    args: [admin, madStaking, minerStaking, lpStaking, foundation],
    log: true,
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
    args: ['StakeNFT', 'MADSTK', deployResultMadByte.address, admin, governance],
    log: true,
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
    args: ['ValidatorNFT', 'VALSTK', deployResultMadByte.address, admin, governance],
    log: true,
    // proxy: false,
    // gasLimit: 4000000,
  });
  if (deployResultValidatorNFT.newlyDeployed && deployResultValidatorNFT.receipt) {
    console.log(
      `ValidatorNFT deployed at ${deployResultValidatorNFT.address} using ${deployResultValidatorNFT.receipt.gasUsed} gas`
    );
  }

  // Validators
  //const art = await hre.artifacts.readArtifact("src/tokens/periphery/Validators.sol:Validators")
  //console.log('artifact contractName', art.contractName)

  let deployResultValidators = await deploy('ValidatorPool', {
    //contract: "src/tokens/periphery/Validators.sol:Validators",
    from: admin,
    //args: [deployResultStakeNFT.address, deployResultValidatorNFT.address, deployResultMadByte.address],
    args: [],
    log: true,
    proxy: false,
    // gasLimit: 4000000,
  });
  if (deployResultValidators.newlyDeployed && deployResultValidators.receipt) {
    console.log(
      `ValidatorPool deployed at ${deployResultValidators.address} using ${deployResultValidators.receipt.gasUsed} gas`
    );
  }

  const ValidatorPool = await ethers.getContract("ValidatorPool", admin);
  await ValidatorPool.initialize(deployResultStakeNFT.address, deployResultValidatorNFT.address, deployResultMadByte.address)

  console.log('finished core deployment')

  return {
    MadToken: await ethers.getContract("MadToken"),
    MadByte: await ethers.getContract("MadByte"),
    StakeNFT: await ethers.getContract("StakeNFT"),
    ValidatorNFT: await ethers.getContract("ValidatorNFT"),
    ValidatorPool: await ethers.getContract("ValidatorPool"),
    admin: {
      address: admin,
    }
  };
});


describe("ValidatorPool", function () {

  it("compiles", async function () {
    const {MadByte, admin} = await setupTest()
    console.log('\t\tcompiles', MadByte.address, admin.address)
     
    
    await MadByte.mint(10, {value: 4})//.then(tx => tx.wait());

  });
});