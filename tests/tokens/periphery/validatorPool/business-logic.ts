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

describe("Testing ValidatorPool Business Logic ", () => {

  let fixture: Fixture;
  let adminSigner: SignerWithAddress;
  let notAdmin1Signer: SignerWithAddress;
  // let minimunStake = ethers.utils.parseUnits("20001", 18);
  let maxNumValidators = 5;
  let stakeAmount = 20000;
  let stakeAmountMadWei = ethers.utils.parseUnits(stakeAmount.toString(), 18);
  let lockTime = 1;
  let validators = new Array()
  let stakingTokenIds = new Array();

  beforeEach(async function () {
    validators = []
    stakingTokenIds = [];
    fixture = await getFixture();
    const [admin, notAdmin1, notAdmin2, notAdmin3, notAdmin4] =
      fixture.namedSigners;
    adminSigner = await ethers.getSigner(admin.address);
    await fixture.validatorNFT.
      connect(adminSigner).
      setAdmin(fixture.validatorPool.address);
    await fixture.validatorPool.
      connect(adminSigner).
      setETHDKG(fixture.ethdkg.address);
    notAdmin1Signer = await ethers.getSigner(notAdmin1.address);
    //create validators array
    fixture.namedSigners.map(async signer => {
      if (validators.length < maxNumValidators) { // maximum validators by default
        validators.push(signer.address)
      }
    })
    validators.shift();
    await fixture.madToken.approve(fixture.validatorPool.address, stakeAmountMadWei.mul(validators.length));
    await fixture.madToken.approve(fixture.stakeNFT.address, stakeAmountMadWei.mul(validators.length));

    for (const validatorAddress of validators) {
      //Send MAD tokens to each validator
      await fixture.madToken.
        transfer(validatorAddress, stakeAmountMadWei); //Assign funds to validators
    }
    console.log("After creating");
    await showBalances()

    for (const validatorAddress of validators) {
      // Stake all MAD tokens
      await fixture.madToken.
        connect(await ethers.getSigner(validatorAddress)).
        approve(fixture.stakeNFT.address, stakeAmountMadWei);
      //Check Allowance
      // console.log("Allowance", await fixture.madToken
      //   .allowance(validatorAddress, fixture.stakeNFT.address,))
      let tx = await fixture.stakeNFT
        .connect(await ethers.getSigner(validatorAddress))
        .mintTo(validatorAddress, stakeAmountMadWei, lockTime);
      let tokenId = getTokenIdFromTx(tx)
      stakingTokenIds.push(tokenId);
      await fixture.stakeNFT
        .connect(await ethers.getSigner(validatorAddress))
        .setApprovalForAll(fixture.validatorPool.address, true);
    }

    await showBalances()

  });

  describe("Settings:", async function () {

    it("Set a minimum stake amount for registration", async function () {
      await fixture.validatorPool
        .connect(adminSigner)
        .setStakeAmount(stakeAmountMadWei.add(1)); // Raise minimum by 1
      await expect(
        fixture.validatorPool
          .connect(adminSigner)
          .registerValidators(validators, stakingTokenIds)).
        to.be.revertedWith("ValidatorStakeNFT: Error, the Stake position doesn't have enough founds!")
    });

    it("Set a maximum number of validators", async function () {
      await fixture.validatorPool
        .connect(adminSigner)
        .setMaxNumValidators(maxNumValidators - 1);
      await expect(
        fixture.validatorPool
          .connect(adminSigner)
          .registerValidators(validators, stakingTokenIds)).
        to.be.revertedWith("There are not enough free spots for all new validators!")

    });
    it("Set snapshot", async function () {
      await fixture.validatorPool
        .connect(adminSigner)
        .setSnapshot(fixture.snapshots.address);
    });

    it("Set ETHDKG", async function () {
      await fixture.validatorPool
        .connect(adminSigner)
        .setETHDKG(fixture.ethdkg.address);
    });

  })

  describe("ETHDKG:", async function () {
    it("Schedule maintenance", async function () {
      await fixture.validatorPool.
        connect(adminSigner).
        scheduleMaintenance();
    });

    it("Register validators", async function () {
      await fixture.validatorPool
        .connect(adminSigner)
        .registerValidators(validators, stakingTokenIds);
    });

    it("Initialize ETHDKG", async function () {
      await fixture.validatorPool
        .connect(adminSigner)
        .registerValidators(validators, stakingTokenIds);
      await fixture.validatorPool.
        connect(adminSigner).
        initializeETHDKG();
    });

    it("Unregister validators", async function () {
      await fixture.validatorPool
        .connect(adminSigner)
        .registerValidators(validators, stakingTokenIds);
      console.log("After registering");
      await showBalances()
      await fixture.validatorPool
        .connect(adminSigner)
        .unregisterValidators(validators);
      console.log("After unregistering");
      await showBalances()
    });

    it("Pause consensus", async function () {
      await expect(
        fixture.validatorPool
          .connect(adminSigner)
          .pauseConsensusOnArbitraryHeight(1)
      ).to.be.revertedWith("ValidatorPool: Condition not met to stop consensus!");
      // await fixture.validatorPool
      //   .connect(adminSigner)
      //   .unregisterValidators(validators);
    });
  })

  describe("As a user without admin role should not be able to:", async function () {
    it("Set a minimum stake", async function () {
      await expect(
        fixture.validatorPool.
          connect(notAdmin1Signer).
          setStakeAmount(stakeAmount)
      ).to.be.revertedWith("ValidatorsPool: Requires admin privileges");
    });
    it("Set a maximum number of validators", async function () {
      await expect(
        fixture.validatorPool
          .connect(notAdmin1Signer)
          .setMaxNumValidators(maxNumValidators)
      ).to.be.revertedWith("ValidatorsPool: Requires admin privileges");
    });
    it("Set snapshot", async function () {
      await expect(
        fixture.validatorPool
          .connect(notAdmin1Signer)
          .setSnapshot(fixture.snapshots.address)
      ).to.be.revertedWith("ValidatorsPool: Requires admin privileges");
    });
    it("Set ETHDKG", async function () {
      await expect(
        fixture.validatorPool
          .connect(notAdmin1Signer)
          .setETHDKG(fixture.ethdkg.address)
      ).to.be.revertedWith("ValidatorsPool: Requires admin privileges");
    });
    it("Schedule maintenance", async function () {
      await expect(
        fixture.validatorPool.
          connect(notAdmin1Signer).
          scheduleMaintenance()
      ).to.be.revertedWith("ValidatorsPool: Requires admin privileges");
    });
    it("Register validators", async function () {
      await expect(
        fixture.validatorPool
          .connect(notAdmin1Signer)
          .registerValidators(validators, stakingTokenIds)
      ).to.be.revertedWith("ValidatorsPool: Requires admin privileges");
    });

    it("Initialize ETHDKG", async function () {
      await expect(
        fixture.validatorPool
          .connect(notAdmin1Signer)
          .initializeETHDKG()).
        to.be.revertedWith("ValidatorsPool: Requires admin privileges");
    });

    it("Unregister validators", async function () {
      await expect(
        fixture.validatorPool
          .connect(notAdmin1Signer)
          .unregisterValidators(validators)
      ).to.be.revertedWith("ValidatorsPool: Requires admin privileges");
    });

    it("Pause consensus", async function () {
      await expect(
        fixture.validatorPool
          .connect(notAdmin1Signer)
          .pauseConsensusOnArbitraryHeight(1)
      ).to.be.revertedWith("ValidatorsPool: Requires admin privileges");
    });

  })

  // after(async function () {
  //   await showBalances()
  // })

  async function showBalances() {
    console.log("Showing balance for validators ------------------------------------------")
    for (const validatorAddress of validators) {
      // console.log("Showing balance for validator address:", validatorAddress)
      console.log("Validator", validatorAddress, "MAD", (ethers.utils.formatEther(await fixture.madToken.balanceOf(validatorAddress))).toString(), "ETH", (ethers.utils.formatEther(await ethers.provider.getBalance(validatorAddress))).toString(), "StakeNFT", (await fixture.stakeNFT.balanceOf(validatorAddress)).toString(), "ValidatorNFT", (await fixture.validatorNFT.balanceOf(validatorAddress)).toString())
      // console.log("              ValidatorNFT", (await fixture.validatorNFT.balanceOf(validatorAddress)).toString())
      // console.log("ValidatorPool", (await fixture.validatorPool.getValidatorData(0))._tokenID)
    }
    console.log("Showing balance for contracts ------------------------------------------")
    console.log("ValidatorNFT(ValidatorPool)", (await fixture.validatorNFT.balanceOf(fixture.validatorPool.address)).toString())
    console.log("    StakeNFT(ValidatorPool)", (await fixture.stakeNFT.balanceOf(fixture.validatorPool.address)).toString())
    console.log("          ValidatorNFT(MAD)", (await fixture.madToken.balanceOf(fixture.validatorNFT.address)).toString())
    console.log("          ValidatorNFT(ETH)", (await ethers.provider.getBalance(fixture.validatorNFT.address)).toString())
    console.log("         ValidatorPool(MAD)", (await fixture.madToken.balanceOf(fixture.validatorPool.address)).toString())
    console.log("         ValidatorPool(ETH)", (await ethers.provider.getBalance(fixture.validatorPool.address)).toString())
    console.log("              StakeNFT(MAD)", (await fixture.madToken.balanceOf(fixture.stakeNFT.address)).toString())
    console.log("              StakeNFT(ETH)", (await ethers.provider.getBalance(fixture.stakeNFT.address)).toString())
  }

});



