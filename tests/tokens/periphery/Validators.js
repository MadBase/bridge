const { expect } = require("chai");
const { ethers, upgrades } = require("hardhat");
const { deployMockContract } = require("ethereum-waffle");

const MadToken = await ethers.getContractFactory("MadToken");
let madToken;
const StakeNFT = await ethers.getContractFactory("StakeNFT");
let stakeNFT;
const ValidatorNFT = await ethers.getContractFactory("ValidatorNFT");
let validatorNFT;
const Validator = await ethers.getContractFactory("Validator");
let validator;

describe("Validators", function () {
  before(async  () => {
    madToken = await MadToken.deploy();
    await madToken.deployed();

  })

  it("compiles", async function () {
    const instance = await upgrades.deployProxy(Validator, []);
    await instance.deployed();


  });
});