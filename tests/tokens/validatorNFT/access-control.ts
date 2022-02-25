import { Fixture, getFixture, getTokenIdFromTx } from "../periphery/setup";
import { ethers } from "hardhat";
import { expect, assert } from "../../chai-setup";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";

import {
  BigNumber,
  BigNumberish,
  ContractFactory,
  ContractTransaction,
  Signer,
  utils,
  Wallet,
} from "ethers";
import { getAdminAddress } from "@openzeppelin/upgrades-core";
import { afterEach } from "mocha";

describe("Testing ValidatorNFT Access Control", () => {

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

  describe("A user with admin role should be able to:", () => {
    it("Mint a token", async function () {
      // let rcpt = await factoryCallAny(fixture, "validatorNFT", "mint", [amount])
      // expect(rcpt.status).to.equal(1)
    });

    it("Burn a token", async function () {
      // let rcpt = await factoryCallAny(fixture, "validatorNFT", "burn", [42])
      // expect(rcpt.status).to.equal(1)

    });

    it("Mint a token to an address", async function () {
      let rcpt = await factoryCallAny(fixture, "validatorNFT", "mintTo", [notAdminSigner.address, amount, lockTime])
      expect(rcpt.status).to.equal(1)
    });

    it("Burn a token from an address", async function () {
      let rcpt = await factoryCallAny(fixture, "validatorNFT", "burnTo", [notAdminSigner.address, 42])
      expect(rcpt.status).to.equal(1)
    });

  })

  describe("A user without admin role should not be able to:", async function () {
    it("Mint a token", async function () {
      await expect(
        fixture.validatorNFT
          .connect(notAdminSigner)
          .mint(amount)
      ).to.be
        .revertedWith("onlyValidatorPool");
    })

    it("Burn a token", async function () {
      expect(
        fixture.validatorNFT
          .connect(notAdminSigner)
          .burn(42) //nonexistent
      ).to.be
        .revertedWith("onlyValidatorPool");
    });

    it("Mint a token to an address", async function () {
      expect(
        fixture.validatorNFT
          .connect(notAdminSigner)
          .mintTo(notAdminSigner.address, amount, lockTime)
      ).to.be
        .revertedWith("onlyValidatorPool");
    });

    it("Burn a token from an address", async function () {
      expect(
        fixture.validatorNFT
          .connect(notAdminSigner)
          .burnTo(notAdminSigner.address, 42) //nonexistent
      ).to.be
        .revertedWith("onlyValidatorPool");
    });

  })

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
