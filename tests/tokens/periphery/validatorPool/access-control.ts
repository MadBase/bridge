import { Fixture, getFixture, getTokenIdFromTx } from "../setup"
import { ethers } from "hardhat"
import { expect, assert } from "../../../chai-setup"
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers"

import {
  BigNumber,
  BigNumberish,
  ContractTransaction,
  Signer,
  utils,
  Wallet,
} from "ethers"

describe("Testing ValidatorPool Access Control ", () => {

  let fixture: Fixture
  let adminSigner: SignerWithAddress
  let notAdmin1Signer: SignerWithAddress
  // let minimunStake = ethers.utils.parseUnits("20001", 18)
  let maxNumValidators = 5
  let stakeAmount = 20000
  let minimunStake = ethers.utils.parseUnits(stakeAmount.toString(), 18)
  let stakeAmountMadWei = ethers.utils.parseUnits(stakeAmount.toString(), 18)
  let lockTime = 1
  let validators = new Array()
  let stakingTokenIds = new Array()
  let factory: Fixture["factory"]
  let validatorPool: Fixture["validatorPool"]
  let validatorPoolAddress: string

  beforeEach(async function () {
    validators = []
    stakingTokenIds = []
    fixture = await getFixture()
    const [admin, notAdmin1, notAdmin2, notAdmin3, notAdmin4] =
      fixture.namedSigners
    adminSigner = await ethers.getSigner(admin.address)
    notAdmin1Signer = await ethers.getSigner(notAdmin1.address)
    // fixture.namedSigners.map(async signer => {
    //   if (validators.length < 5) { // maximum validators by default
    //     validators.push(signer.address)
    //   }
    // })
    // await fixture.madToken.approve(fixture.validatorPool.address, stakeAmountMadWei.mul(validators.length))
    // await fixture.madToken.approve(fixture.stakeNFT.address, stakeAmountMadWei.mul(validators.length))
    // for (const validator of validators) {
    //   let tx = await fixture.stakeNFT
    //     .connect(adminSigner)
    //     .mintTo(validator, stakeAmountMadWei, lockTime)
    //   let tokenId = await getTokenIdFromTx(tx)
    //   stakingTokenIds.push(tokenId)
    //   await fixture.stakeNFT
    //     .connect(await ethers.getSigner(validator))
    //     .setApprovalForAll(fixture.validatorPool.address, true)
    // }
    factory = fixture.factory
    validatorPool = fixture.validatorPool
    validatorPoolAddress = validatorPool.address
  })

  describe("A user with admin role should be able to:", async function () {

    it("Set a minimum stake", async function () {
      let rcpt = await factoryCallAny(fixture, "validatorPool",
        "setStakeAmount", [stakeAmount])
      expect(rcpt.status).to.equal(1)
    })

    it("Set a maximum number of validators", async function () {
      let rcpt = await factoryCallAny(fixture, "validatorPool",
        "setMaxNumValidators", [maxNumValidators])
      expect(rcpt.status).to.equal(1)
    })

    it("Schedule maintenance", async function () {
      let rcpt = await factoryCallAny(fixture, "validatorPool",
        "scheduleMaintenance")
      expect(rcpt.status).to.equal(1)
    })

    it("Register validators", async function () {
      await expect(factoryCallAny(fixture, "validatorPool",
        "registerValidators", [["0x000000000000000000000000000000000000dEaD"], [1]])
      ).to.be.revertedWith("ERC721: owner query for nonexistent token")
    })

    it("Initialize ETHDKG", async function () {
      await expect(factoryCallAny(fixture, "validatorPool",
        "initializeETHDKG")
      ).to.be.revertedWith("THDKG: Minimum number of validators staked not met!")
    })

    it("Unregister validators", async function () {
      await expect(factoryCallAny(fixture, "validatorPool",
        "unregisterValidators", [["0x000000000000000000000000000000000000dEaD"]])
      ).to.be.revertedWith("ValidatorPool: There are not enough validators to be removed!")
    })

    it("Pause consensus", async function () {
      await expect(
        factoryCallAny(fixture, "validatorPool",
          "pauseConsensusOnArbitraryHeight", [1])
      ).to.be.revertedWith("ValidatorPool: Condition not met to stop consensus!")
    })
  })

  describe("A user without admin role should not be able to:", async function () {

    it("Set a minimum stake", async function () {
      await expect(
        fixture.validatorPool.
          connect(notAdmin1Signer).
          setStakeAmount(stakeAmount)
      ).to.be.revertedWith("onlyFactory")
    })

    it("Set a maximum number of validators", async function () {
      await expect(
        fixture.validatorPool
          .connect(notAdmin1Signer)
          .setMaxNumValidators(maxNumValidators)
      ).to.be.revertedWith("onlyFactory")
    })

    it("Schedule maintenance", async function () {
      await expect(
        fixture.validatorPool.
          connect(notAdmin1Signer).
          scheduleMaintenance()
      ).to.be.revertedWith("onlyFactory")
    })

    it("Register validators", async function () {
      await expect(
        fixture.validatorPool
          .connect(notAdmin1Signer)
          .registerValidators(validators, stakingTokenIds)
      ).to.be.revertedWith("onlyFactory")
    })

    it("Initialize ETHDKG", async function () {
      await expect(
        fixture.validatorPool
          .connect(notAdmin1Signer)
          .initializeETHDKG()).
        to.be.revertedWith("onlyFactory")
    })

    it("Unregister validators", async function () {
      await expect(
        fixture.validatorPool
          .connect(notAdmin1Signer)
          .unregisterValidators(validators)
      ).to.be.revertedWith("onlyFactory")
    })

    it("Pause consensus", async function () {
      await expect(
        fixture.validatorPool
          .connect(notAdmin1Signer)
          .pauseConsensusOnArbitraryHeight(1)
      ).to.be.revertedWith("onlyFactory")
    })

  })

  after(async function () {
    validators.map(async (validator) => {
      console.log("Signer", validators.indexOf(validator), "MAD balance:", await fixture.madToken.balanceOf(validator))
      console.log("Signer", validators.indexOf(validator), "ETH balance:", await ethers.provider.getBalance(validator))
    })
  })

})

async function factoryCallAny(fixture: Fixture, contractName: string, functionName: string, args?: Array<any>) {
  let factory = fixture.factory
  let contract = fixture[contractName]
  if (args === undefined) {
    args = []
  }
  let txResponse = await factory.callAny(contract.address, 0, contract.interface.encodeFunctionData(functionName, args))
  let receipt = await txResponse.wait()
  return receipt
}
