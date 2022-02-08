import { Fixture, getFixture, getTokenIdFromTx } from "../setup";
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

describe("Tests ValidatorNFT Access Control", () => {

  let fixture: Fixture
  let adminSigner: SignerWithAddress;
  let notAdminSigner: SignerWithAddress;
  let amount = 1;
  let lockTime = 1;

  beforeEach(async function () {
    fixture = await getFixture();
    const [admin, notAdmin] = fixture.namedSigners;
    adminSigner = await ethers.getSigner(admin.address);
    notAdminSigner = await ethers.getSigner(notAdmin.address);
    await fixture.madToken.approve(fixture.validatorNFT.address, amount)
  });

  it("Should mint a token and send staking funds from sender address if sender is admin", async function () {
    await fixture.validatorNFT
      .connect(adminSigner)
      .mint(amount);
  });

  it("Should fail to mint a token and send staking funds from sender address if sender is not admin", async function () {
    await expect(
      fixture.validatorNFT
        .connect(notAdminSigner)
        .mint(amount)
    ).to.be
      .revertedWith("Must be admin");
  });

  it("Should burn a token and send staking funds to sender address if sender is admin", async function () {
    let tx = await fixture.validatorNFT
      .connect(adminSigner)
      .mint(amount);
    let tokenId = await getTokenIdFromTx(tx)
    await fixture.validatorNFT
      .connect(adminSigner)
      .burn(tokenId)
  });

  it("Should fail to burn a token and send staking funds to sender address if sender is not admin", async function () {
    let tx = await fixture.validatorNFT
      .connect(adminSigner)
      .mint(amount);
    let tokenId = await getTokenIdFromTx(tx)
    expect(
      fixture.validatorNFT
        .connect(notAdminSigner)
        .burn(tokenId)
    ).to.be
      .revertedWith("Must be admin");
  });

  it("Should mint a token and send staking funds from an address if sender is admin", async function () {
    await fixture.validatorNFT
      .connect(adminSigner)
      .mintTo(notAdminSigner.address, amount, lockTime);
  });

  it("Should fail to mint a token and send staking funds from an address if sender is not admin", async function () {
    expect(
      fixture.validatorNFT
        .connect(notAdminSigner)
        .mintTo(notAdminSigner.address, amount, lockTime)
    ).to.be
      .revertedWith("Must be admin");
  });

  it.only("Should burn a token and send staking funds to an address if sender is admin", async function () {
    let tx = await fixture.validatorNFT
      .connect(adminSigner)
      .mint(amount);
    let tokenId = await getTokenIdFromTx(tx)
    await fixture.validatorNFT
      .connect(adminSigner)
      .burnTo(notAdminSigner.address, tokenId);
  });

  it("Should fail to burn a token and send staking funds to an address if sender is not admin", async function () {
    let tx = await fixture.validatorNFT
      .connect(adminSigner)
      .mintTo(notAdminSigner.address, amount, lockTime);
    let tokenId = await getTokenIdFromTx(tx)
    expect(
      fixture.validatorNFT
        .connect(notAdminSigner)
        .burnTo(notAdminSigner.address, tokenId)
    ).to.be
      .revertedWith("Must be admin");
  });

});