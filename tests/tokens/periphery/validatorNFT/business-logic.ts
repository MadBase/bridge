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

describe("Tests ValidatorNFT methods", () => {

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

  it("Should mint a token and sender should be the owner", async function () {
    let tx = await fixture.validatorNFT
      .connect(adminSigner)
      .mint(amount);
    let tokenId = await getTokenIdFromTx(tx)
    expect(await fixture.validatorNFT.
      ownerOf(tokenId)).
      to.equal(adminSigner.address);
  });

  it("Should burn a token and token should not exist any more", async function () {
    let tx = await fixture.validatorNFT
      .connect(adminSigner)
      .mint(amount);
    let tokenId = await getTokenIdFromTx(tx)
    await fixture.validatorNFT
      .connect(adminSigner)
      .burn(tokenId);
    expect(
      fixture.validatorNFT.ownerOf(tokenId)
    ).to.be
      .revertedWith("ERC721: owner query for nonexistent token");
  });

  it("Should mint a token to an address and send staking funds from this address to the contract", async function () {
    console.log("admin MAD balance before", await fixture.madToken.balanceOf(adminSigner.address))
    console.log("admin ETH balance before", await ethers.provider.getBalance(adminSigner.address))
    console.log("notAdmin MAD balance before", await fixture.madToken.balanceOf(notAdminSigner.address))
    console.log("notAdmin ETH balance before", await ethers.provider.getBalance(notAdminSigner.address))
    console.log("stakeNFT MAD balance before", await fixture.stakeNFT.balanceOf(fixture.stakeNFT.address))
    console.log("stakeNFT ETH balance before", await ethers.provider.getBalance(fixture.stakeNFT.address))
    let tx = await fixture.validatorNFT
      .connect(adminSigner)
      .mint(amount);
    let tokenId = await getTokenIdFromTx(tx)
    await fixture.validatorNFT
      .connect(adminSigner)
      .mintTo(notAdminSigner.address, amount, lockTime);
    console.log("admin MAD balance before", await fixture.madToken.balanceOf(adminSigner.address))
    console.log("admin ETH balance before", await ethers.provider.getBalance(adminSigner.address))
    console.log("notAdmin MAD balance before", await fixture.madToken.balanceOf(notAdminSigner.address))
    console.log("notAdmin ETH balance before", await ethers.provider.getBalance(notAdminSigner.address))
    console.log("stakeNFT MAD balance before", await fixture.stakeNFT.balanceOf(fixture.stakeNFT.address))
    console.log("stakeNFT ETH balance before", await ethers.provider.getBalance(fixture.stakeNFT.address))
    expect(
      await fixture.validatorNFT.ownerOf(tokenId))
      .to.equal(notAdminSigner.address);
  });

  it("Should burn a token and send staking funds to an address", async function () {
    let tx = await fixture.validatorNFT
      .connect(adminSigner)
      .mint(amount);
    let tokenId = await getTokenIdFromTx(tx)
    await fixture.validatorNFT
      .connect(adminSigner)
      .burnTo(notAdminSigner.address, 1);
    expect(
      fixture.validatorNFT.ownerOf(tokenId)
    ).to.be
      .revertedWith("ERC721: owner query for nonexistent token");
  });

});