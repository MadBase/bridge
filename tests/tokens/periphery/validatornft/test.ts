import { Fixture, getFixture } from "../setup";
import { ethers } from "hardhat";
import { expect, assert } from "../../../chai-setup";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";

import {
  BigNumber,
  BigNumberish,
  ContractTransaction,
  Signer,
  utils,
  Wallet,
} from "ethers";
import { getAdminAddress } from "@openzeppelin/upgrades-core";

describe("Tests ValidatorNFT methods", () => {

  let fixture: Fixture
  let adminSigner: SignerWithAddress;
  let notAdminSigner: SignerWithAddress;
  let amount = 1;

  before(async function () {
    fixture = await getFixture();
    const [admin, notAdmin] = fixture.namedSigners;
    adminSigner = await ethers.getSigner(admin.address);
    notAdminSigner = await ethers.getSigner(notAdmin.address);
    await fixture.madToken.approve(fixture.validatorNFT.address, amount)
  });

  it("Should mint a token and send staking funds from sender address if sender is admin", async function () {
    await fixture.validatorNFT
      .connect(adminSigner)
      .mint(1);
    expect(await fixture.validatorNFT.ownerOf(1)).to.equal(adminSigner.address);
  });

  it("Should fail to mint a token and send staking funds from sender address if sender is not admin", async function () {
    await expect(
      fixture.validatorNFT
        .connect(notAdminSigner)
        .mint(1)
    ).to.be
      .revertedWith("Must be admin");
  });

  it("Should burn a token and send staking funds to sender address if sender is admin", async function () {
    const [admin, notAdmin] = fixture.namedSigners;
    await fixture.madToken.approve(fixture.validatorNFT.address, amount)
    await fixture.validatorNFT
      .connect(adminSigner)
      .mint(1);
    await fixture.validatorNFT
      .connect(adminSigner)
      .burn(1);
    expect(
      fixture.validatorNFT.ownerOf(1)
    ).to.be
      .revertedWith("ERC721: owner query for nonexistent token");
  });

  it("Should fail to burn a token and send staking funds to sender address if sender is not admin", async function () {
    expect(
      fixture.validatorNFT
        .connect(notAdminSigner)
        .burn(1)
    ).to.be
      .revertedWith("Must be admin");
  });

  it("Should mint a token and send staking funds from an address if sender is admin", async function () {
    await fixture.madToken.approve(fixture.validatorNFT.address, amount)
    await fixture.validatorNFT
      .connect(adminSigner)
      .mintTo(notAdminSigner.address, 1, 1);
    expect(
      await fixture.validatorNFT.ownerOf(1))
      .to.equal(notAdminSigner.address);
  });

  it("Should fail to mint a token and send staking funds from an address if sender is not admin", async function () {
    expect(
      fixture.validatorNFT
        .connect(notAdminSigner)
        .mintTo(notAdminSigner.address, 1, 1)
    ).to.be
      .revertedWith("Must be admin");
  });

  it("Should burn a token and send staking funds to an address if sender is admin", async function () {
    const [admin, notAdmin] = fixture.namedSigners;
    await fixture.madToken.approve(fixture.validatorNFT.address, 1)
    await fixture.validatorNFT
      .connect(await ethers.getSigner(admin.address))
      .mint(1);
    await fixture.validatorNFT
      .connect(await ethers.getSigner(admin.address))
      .burnTo(notAdmin.address, 1);
    expect(
      fixture.validatorNFT.ownerOf(1)
    ).to.be
    .revertedWith("ERC721: owner query for nonexistent token");
  });

  it("Should fail to burn a token and send staking funds to an address if sender is not admin", async function () {
    await fixture.madToken.approve(fixture.validatorNFT.address, amount)
    await fixture.validatorNFT
      .connect(adminSigner)
      .mintTo(notAdminSigner.address, 1, 1);
    expect(
      fixture.validatorNFT
        .connect(notAdminSigner)
        .burnTo(notAdminSigner.address, 1)
    ).to.be
      .revertedWith("Must be admin");
  });

});
