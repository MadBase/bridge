import { Fixture, getFixture, getTokenIdFromTxReceipt } from "../periphery/setup";
import { ethers } from "hardhat";
import { expect, assert } from "../../chai-setup";
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

describe("Tests ValidatorNFT Business Logic methods", () => {

  let fixture: Fixture
  let adminSigner: SignerWithAddress;
  let notAdminSigner: SignerWithAddress;
  let amount = 1;
  let lockTime = 0;


  beforeEach(async function () {
    fixture = await getFixture();
    const [admin, notAdmin] = fixture.namedSigners;
    adminSigner = await ethers.getSigner(admin.address);
    notAdminSigner = await ethers.getSigner(notAdmin.address);
    await fixture.madToken.approve(fixture.validatorNFT.address, amount)
  });

  it("Should mint a token and sender should be the payer and owner", async function () {
    let madBalanceBefore = await fixture.madToken.balanceOf(adminSigner.address)
    let nftBalanceBefore = await fixture.validatorNFT.balanceOf(adminSigner.address)
    await fixture.validatorNFT
      .connect(adminSigner)
      .mint(amount);
    expect(await fixture.validatorNFT. //NFT +1
      balanceOf(adminSigner.address)).
      to.equal(nftBalanceBefore.add(1));
    expect(await fixture.madToken.  //MAD -= amount
      balanceOf(adminSigner.address)).
      to.equal(madBalanceBefore.sub(amount))
  });

  it("Should burn a token and sender should receive funds", async function () {
    let tx = await fixture.validatorNFT
      .connect(adminSigner)
      .mint(amount);
    let tokenId = await getTokenIdFromTxReceipt(tx)
    let nftBalanceBefore = await fixture.validatorNFT.balanceOf(adminSigner.address)
    let madBalanceBefore = await fixture.madToken.balanceOf(adminSigner.address)
    await fixture.validatorNFT
      .connect(adminSigner)
      .burn(tokenId);
    expect(await fixture.validatorNFT. //NFT -1
      balanceOf(adminSigner.address)).
      to.equal(nftBalanceBefore.sub(1));
    expect(await fixture.madToken.  //MAD +=amount
      balanceOf(adminSigner.address)).
      to.equal(madBalanceBefore.add(amount))
  });

  it("Should mint a token to an address and send staking funds from sender address", async function () {
    let madBalanceBefore = await fixture.madToken.balanceOf(adminSigner.address)
    let nftBalanceBefore = await fixture.validatorNFT.balanceOf(notAdminSigner.address)
    await fixture.validatorNFT
      .connect(adminSigner)
      .mintTo(notAdminSigner.address, amount, lockTime);
      expect(await fixture.validatorNFT. //NFT +1
        balanceOf(notAdminSigner.address)).
        to.equal(nftBalanceBefore.add(1));
      expect(await fixture.madToken.  //MAD -= amount
        balanceOf(adminSigner.address)).
        to.equal(madBalanceBefore.sub(amount))
  });

  it("Should burn a token from an address and return staking funds", async function () {
    //Cannot test with notAdmin since burnTo requires connect and "to" address to be admin
    let tx = await fixture.validatorNFT
      .connect(adminSigner)
      .mintTo(adminSigner.address,amount,lockTime); // TODO testing with locktime > 0
    let tokenId = await getTokenIdFromTxReceipt(tx)
    let nftBalanceBefore = await fixture.validatorNFT.balanceOf(adminSigner.address)
    let madBalanceBefore = await fixture.madToken.balanceOf(adminSigner.address)
    await fixture.validatorNFT
      .connect(adminSigner)
      .burnTo(adminSigner.address, tokenId);
    expect(await fixture.validatorNFT. //NFT -1
      balanceOf(adminSigner.address)).
      to.equal(nftBalanceBefore.sub(1));
    expect(await fixture.madToken.  //MAD +=amount
      balanceOf(adminSigner.address)).
      to.equal(madBalanceBefore.add(amount))
  });

  async function showBalances(when: string) {
    console.log("Showing balances", when, "-------------------------------")
    console.log("admin        MAD", (await fixture.madToken.balanceOf(adminSigner.address)).toString())
    // console.log("admin        ETH", (await ethers.provider.getBalance(adminSigner.address)).toString())
    console.log("notAdmin     MAD", (await fixture.madToken.balanceOf(notAdminSigner.address)).toString())
    // console.log("notAdmin     ETH", (await ethers.provider.getBalance(notAdminSigner.address)).toString())
    console.log("validatorNFT MAD", (await fixture.madToken.balanceOf(fixture.validatorNFT.address)).toString())
    // console.log("validatorNFT ETH", (await ethers.provider.getBalance(fixture.validatorNFT.address)).toString())
    console.log("admin        NFT", (await fixture.validatorNFT.balanceOf(adminSigner.address)).toString())
    console.log("notAdmin     NFT", (await fixture.validatorNFT.balanceOf(notAdminSigner.address)).toString())
  }


});

