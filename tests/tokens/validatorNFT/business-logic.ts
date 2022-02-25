import { Fixture, getFixture, getTokenIdFromTx } from "../periphery/setup";
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
    let rcpt = await factoryCallAny(fixture, "validatorNFT", "mint", [amount])
    expect(rcpt.status).to.equal(true)
    expect(await fixture.validatorNFT. //NFT +1
      balanceOf(adminSigner.address)).
      to.equal(nftBalanceBefore.add(1));
    expect(await fixture.madToken.  //MAD -= amount
      balanceOf(adminSigner.address)).
      to.equal(madBalanceBefore.sub(amount))
  });

  it("Should burn a token and sender should receive funds", async function () {
    let rcpt = await factoryCallAny(fixture, "validatorNFT", "mint", [amount])
    let tokenId = await getTokenIdFromTx(rcpt)
    let nftBalanceBefore = await fixture.validatorNFT.balanceOf(adminSigner.address)
    let madBalanceBefore = await fixture.madToken.balanceOf(adminSigner.address)
    rcpt = await factoryCallAny(fixture, "validatorNFT", "burn", [tokenId])
    tokenId = await getTokenIdFromTx(rcpt)
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
    let rcpt = await factoryCallAny(fixture, "validatorNFT", "mintTo", [notAdminSigner.address, amount, lockTime])
    expect(rcpt.status).to.equal(true)
      expect(await fixture.validatorNFT. //NFT +1
        balanceOf(notAdminSigner.address)).
        to.equal(nftBalanceBefore.add(1));
      expect(await fixture.madToken.  //MAD -= amount
        balanceOf(adminSigner.address)).
        to.equal(madBalanceBefore.sub(amount))
  });

  it("Should burn a token from an address and return staking funds", async function () {
    //Cannot test with notAdmin since burnTo requires connect and "to" address to be admin
    let rcpt = await factoryCallAny(fixture, "validatorNFT", "mintTo", [adminSigner.address, amount, lockTime])
    expect(rcpt.status).to.equal(1) // TODO testing with locktime > 0
    let tokenId = await getTokenIdFromTx(rcpt)
    let nftBalanceBefore = await fixture.validatorNFT.balanceOf(adminSigner.address)
    let madBalanceBefore = await fixture.madToken.balanceOf(adminSigner.address)
    rcpt = await factoryCallAny(fixture, "validatorNFT", "burnTo", [adminSigner.address, tokenId])
    expect(rcpt.status).to.equal(1)
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


async function factoryCallAny(fixture: Fixture, contractName:string, functionName:string, args?:Array<any>){
  let factory = fixture.factory
  let contract = fixture[contractName]
  if(args === undefined){
    args = []
  }
  let txResponse = await factory.callAny(contract.address, 0, contract.interface.encodeFunctionData(functionName, args))
  let receipt = await txResponse.wait()
  return receipt
}