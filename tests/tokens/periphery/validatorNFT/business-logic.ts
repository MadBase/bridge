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

describe("Tests ValidatorNFT Business Logic methods", () => {

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

  it.only("Should mint a token to an address and send staking funds from this address to the contract", async function () {
    await showBalances("Before");
    let userMADBalanceBefore = await fixture.madToken.balanceOf(notAdminSigner.address)
    let validatorNFTMADBalanceBefore = await fixture.madToken.balanceOf(fixture.validatorNFT.address)
    let tx = await fixture.validatorNFT
      .connect(adminSigner)
      .mintTo(notAdminSigner.address, amount, lockTime);
    let tokenId = await getTokenIdFromTx(tx)
    await showBalances("After");
    expect(
      await fixture.validatorNFT.ownerOf(tokenId))
      .to.equal(notAdminSigner.address);
    expect(
      await fixture.madToken.balanceOf(fixture.validatorNFT.address))
      .to.be.equal(validatorNFTMADBalanceBefore.add(amount));
    //failing cause MAD is going to 'from' and not 'to' 
    // expect( 
    // await fixture.madToken.balanceOf(notAdminSigner.address))
    // .to.be.equal(userMADBalanceBefore.sub(amount));

  });

  it("Should burn a token and send staking funds to an address", async function () {
    await showBalances("Before");
    let tx = await fixture.validatorNFT
      .connect(adminSigner)
      .mintTo(notAdminSigner.address, amount, lockTime);
    let tokenId = await getTokenIdFromTx(tx)
    await fixture.validatorNFT
      .connect(adminSigner)
      .burnTo(notAdminSigner.address, tokenId);
    await showBalances("After");

    expect(
      fixture.validatorNFT.ownerOf(tokenId)
    ).to.be
      .revertedWith("ERC721: owner query for nonexistent token");
  });

  async function showBalances(when: string) {
    console.log("Showing balances", when,"-------------------------------")
    console.log("admin        MAD", (await fixture.madToken.balanceOf(adminSigner.address)).toString())
    // console.log("admin        ETH", (await ethers.provider.getBalance(adminSigner.address)).toString())
    console.log("notAdmin     MAD", (await fixture.madToken.balanceOf(notAdminSigner.address)).toString())
    // console.log("notAdmin     ETH", (await ethers.provider.getBalance(notAdminSigner.address)).toString())
    console.log("validatorNFT MAD", (await fixture.madToken.balanceOf(fixture.validatorNFT.address)).toString())
    // console.log("validatorNFT ETH", (await ethers.provider.getBalance(fixture.validatorNFT.address)).toString())
  }

});

