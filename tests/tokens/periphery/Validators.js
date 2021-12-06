const { expect } = require("chai");
const { ethers, upgrades } = require("hardhat");
const { deployMockContract } = require("ethereum-waffle");


const setupTest = deployments.createFixture(async ({deployments, getNamedAccounts, getUnnamedAccounts, ethers}, options) => {
  await deployments.fixture(); // ensure you start from a fresh deployments
  const [admin, madStaking, minerStaking, lpStaking, foundation] = await getUnnamedAccounts();
  const MadByte = await ethers.getContract("MadByte");
  console.log('MadByte at', MadByte.address)

  const MadByteAdmin = await ethers.getContract("MadByte", admin);
  //this mint is executed once and then `createFixture` will ensure it is snapshotted
  await MadByteAdmin.mint(10, {value: 4}).then(tx => tx.wait());

  return {
    MadByte,
    admin: {
      address: admin,
      MadByte: MadByteAdmin
    }
  };
});


describe("Validators", function () {

  it("compiles", async function () {
    const {MadByte, admin} = await setupTest()
    console.log('\t\tcompiles', MadByte.address, admin.address)
     
    
    await MadByte.mint(10, {value: 4}).then(tx => tx.wait());

  });
});