import { expect, assert } from "../../../chai-setup";
import { ethers, network } from "hardhat";

import { MadToken, ValidatorNFT } from "../../../../typechain-types";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { BigNumber } from "ethers";

export const PLACEHOLDER_ADDRESS = "0x0000000000000000000000000000000000000000";

export const getFixture = async () => {
  await network.provider.send("evm_setAutomine", [true]);

  const namedSigners = await ethers.getSigners();
  const [admin] = namedSigners;

  // MadToken
  const MadToken = await ethers.getContractFactory("MadToken");
  const madToken = await MadToken
    .connect(await ethers.getSigner(admin.address))
    .deploy("MadToken", "MAD");
  await madToken.deployed();
  // console.log(`MadToken deployed at ${madToken.address}`);

  // MadByte
  const MadByte = await ethers.getContractFactory("MadByte");
  const madByte = await MadByte.deploy(
    admin.address,
    PLACEHOLDER_ADDRESS,
    PLACEHOLDER_ADDRESS,
    PLACEHOLDER_ADDRESS,
    PLACEHOLDER_ADDRESS
  );
  await madByte.deployed();
  // console.log(`MadByte deployed at ${madByte.address}`);

  // ValidatorNFT
  const ValidatorNFT = await ethers.getContractFactory("ValidatorNFT");
  const validatorNFT = await ValidatorNFT.deploy(
    "ValidatorNFT",
    "VALSTK",
    madToken.address,
    admin.address,
    PLACEHOLDER_ADDRESS
  );
  await validatorNFT.deployed();
  // console.log(`ValidatorNFT deployed at ${validatorNFT.address}`);

  return {
    madToken,
    madByte,
    validatorNFT,
    namedSigners,
  };

};

export const assertAdminMinting = async (validatorNFT: ValidatorNFT, madToken: MadToken, namedSigners: SignerWithAddress[]) => {
  const [admin, notAdmin] = namedSigners;
  await madToken.approve(validatorNFT.address, 1)
 await validatorNFT
    .connect(await ethers.getSigner(admin.address))
    .mint(1);
  expect(await validatorNFT.ownerOf(1)).to.equal(admin.address);
};

export const assertFailsNotAdminMinting = async (validatorNFT: ValidatorNFT, madToken: MadToken, namedSigners: SignerWithAddress[]) => {
  const [admin, notAdmin] = namedSigners;
  await madToken.approve(validatorNFT.address, 1)
  await expect(
    validatorNFT
      .connect(await ethers.getSigner(notAdmin.address))
      .mint(1)
  ).to.be
    .revertedWith("Must be admin");
};

export const assertAdminBurning = async (validatorNFT: ValidatorNFT, madToken: MadToken, namedSigners: SignerWithAddress[]) => {
  const [admin, notAdmin] = namedSigners;
  await madToken.approve(validatorNFT.address, 1)
  await validatorNFT
    .connect(await ethers.getSigner(admin.address))
    .mint(1);
  await validatorNFT
    .connect(await ethers.getSigner(admin.address))
    .burn(1);
  expect(
    validatorNFT.ownerOf(1)
  ).eventually.to.be
    .rejectedWith("VM Exception while processing transaction: reverted with reason string 'ERC721: owner query for nonexistent token'");
};

export const assertFailsNotAdminBurning = async (validatorNFT: ValidatorNFT, madToken: MadToken, namedSigners: SignerWithAddress[]) => {
  const [admin, notAdmin] = namedSigners;
  await madToken.approve(validatorNFT.address, 1)
  // It seems that to.be.reverted cannot access reason upon VM Exception so using rejectedWith instead
  expect(
    validatorNFT
      .connect(await ethers.getSigner(notAdmin.address))
      .burn(1)
  ).eventually.to.be
    .rejectedWith("VM Exception while processing transaction: reverted with reason string 'Must be admin'");
};

export const assertAdminMintingTo = async (validatorNFT: ValidatorNFT, madToken: MadToken, namedSigners: SignerWithAddress[]) => {
  const [admin, notAdmin] = namedSigners;
  await madToken.approve(validatorNFT.address, 1)
  await validatorNFT
    .connect(await ethers.getSigner(admin.address))
    .mintTo(notAdmin.address, 1, 1);
  expect(await validatorNFT.ownerOf(1)).to.equal(notAdmin.address);
};

export const assertFailsNotAdminMintingTo = async (validatorNFT: ValidatorNFT, madToken: MadToken, namedSigners: SignerWithAddress[]) => {
  const [admin, notAdmin] = namedSigners;
  await madToken.approve(validatorNFT.address, 1)
  // It seems that to.be.reverted cannot access reason upon VM Exception so using rejectedWith instead
  expect(
    validatorNFT
      .connect(await ethers.getSigner(notAdmin.address))
      .mintTo(notAdmin.address, 1, 1)
  ).eventually.to.be
    .rejectedWith("VM Exception while processing transaction: reverted with reason string 'Must be admin'");
};

export const assertAdminBurningTo = async (validatorNFT: ValidatorNFT, madToken: MadToken, namedSigners: SignerWithAddress[]) => {
  const [admin, notAdmin] = namedSigners;
  await madToken.approve(validatorNFT.address, 1)
  await validatorNFT
    .connect(await ethers.getSigner(admin.address))
    .mint(1);
  await validatorNFT
    .connect(await ethers.getSigner(admin.address))
    .burnTo(notAdmin.address, 1);
  expect(
    validatorNFT.ownerOf(1)
  ).eventually.to.be
    .rejectedWith("VM Exception while processing transaction: reverted with reason string 'ERC721: owner query for nonexistent token'");
};

export const assertFailsNotAdminBurningTo = async (validatorNFT: ValidatorNFT, madToken: MadToken, namedSigners: SignerWithAddress[]) => {
  const [admin, notAdmin] = namedSigners;
  await madToken.approve(validatorNFT.address, 1)
  await validatorNFT
    .connect(await ethers.getSigner(admin.address))
    .mintTo(notAdmin.address, 1, 1);
  // It seems that to.be.reverted cannot access reason upon VM Exception so using rejectedWith instead
  expect(
    validatorNFT
      .connect(await ethers.getSigner(notAdmin.address))
      .burnTo(notAdmin.address, 1)
  ).eventually.to.be
    .rejectedWith("VM Exception while processing transaction: reverted with reason string 'Must be admin'");
};