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

describe("Testing ValidatorPool Access Control ", () => {

  let fixture: Fixture;
  let adminSigner: SignerWithAddress;
  let notAdmin1Signer: SignerWithAddress;
  // let minimunStake = ethers.utils.parseUnits("20001", 18);
  let maxNumValidators = 5;
  let stakeAmount = 20000;
  let minimunStake = ethers.utils.parseUnits(stakeAmount.toString(), 18);
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
    fixture.namedSigners.map(async signer => {
      if (validators.length < 5) { // maximum validators by default
        validators.push(signer.address)
        // console.log("Signer", validators.length, "MAD balance:", await fixture.madToken.balanceOf(signer.address))
        // console.log("Signer", validators.length, "ETH balance:", await ethers.provider.getBalance(signer.address))
      }
    })
    await fixture.madToken.approve(fixture.validatorPool.address, stakeAmountMadWei.mul(validators.length));
    await fixture.madToken.approve(fixture.stakeNFT.address, stakeAmountMadWei.mul(validators.length));

    for (const validator of validators) {
      let tx = await fixture.stakeNFT
        .connect(adminSigner)
        .mintTo(validator, stakeAmountMadWei, lockTime);
      let tokenId = getTokenIdFromTx(tx)
      stakingTokenIds.push(tokenId);
      await fixture.stakeNFT
        .connect(await ethers.getSigner(validator))
        .setApprovalForAll(fixture.validatorPool.address, true);
    }

  });

  describe("A user that has admin role", async function () {

    it("Should be able to set a minimum stake", async function () {
      await fixture.validatorPool
        .connect(adminSigner)
        .setStakeAmount(stakeAmount);
    });
    it("Should be able to set a maximum number of validators stake", async function () {
      await fixture.validatorPool
        .connect(adminSigner)
        .setMaxNumValidators(maxNumValidators);
    });
    it("Should be able to set snapshot", async function () {
      await fixture.validatorPool
        .connect(adminSigner)
        .setSnapshot(fixture.snapshots.address);
    });

    it("Should be able to set ETHDKG", async function () {
      await fixture.validatorPool
        .connect(adminSigner)
        .setETHDKG(fixture.ethdkg.address);
    });

    it("Should be able to schedule maintenance", async function () {
      await fixture.validatorPool.
        connect(adminSigner).
        scheduleMaintenance();
    });

    it("Should be able to register validators", async function () {
      await fixture.validatorPool
        .connect(adminSigner)
        .registerValidators(validators, stakingTokenIds);
    });

    it("Should be able to initialize ETHDKG", async function () {
      await fixture.validatorPool
        .connect(adminSigner)
        .registerValidators(validators, stakingTokenIds);
      await fixture.validatorPool.
        connect(adminSigner).
        initializeETHDKG();
    });

    it("Should be able to unregister validators", async function () {
      await fixture.validatorPool
        .connect(adminSigner)
        .registerValidators(validators, stakingTokenIds);
      await fixture.validatorPool
        .connect(adminSigner)
        .unregisterValidators(validators);
    });

    it("Should be able to pause consensus", async function () {
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

  describe("As a user that has not admin role", async function () {
    it("Should not be able to set a minimum stake", async function () {
      await expect(
        fixture.validatorPool.
          connect(notAdmin1Signer).
          setStakeAmount(stakeAmount)
      ).to.be.revertedWith("ValidatorsPool: Requires admin privileges");
    });
    it("Should not be able to set a maximum number of validators", async function () {
      await expect(
        fixture.validatorPool
          .connect(notAdmin1Signer)
          .setMaxNumValidators(maxNumValidators)
      ).to.be.revertedWith("ValidatorsPool: Requires admin privileges");
    });
    it("Should not be able to set snapshot", async function () {
      await expect(
        fixture.validatorPool
          .connect(notAdmin1Signer)
          .setSnapshot(fixture.snapshots.address)
      ).to.be.revertedWith("ValidatorsPool: Requires admin privileges");
    });
    it("Should not be able to set ETHDKG", async function () {
      await expect(
        fixture.validatorPool
          .connect(notAdmin1Signer)
          .setETHDKG(fixture.ethdkg.address)
      ).to.be.revertedWith("ValidatorsPool: Requires admin privileges");
    });
    it("Should not be able to schedule maintenance", async function () {
      await expect(
        fixture.validatorPool.
          connect(notAdmin1Signer).
          scheduleMaintenance()
      ).to.be.revertedWith("ValidatorsPool: Requires admin privileges");
    });
    it("Should not be able to register validators", async function () {
      await expect(
        fixture.validatorPool
          .connect(notAdmin1Signer)
          .registerValidators(validators, stakingTokenIds)
      ).to.be.revertedWith("ValidatorsPool: Requires admin privileges");
    });

    it("Should not be able to initialize ETHDKG", async function () {
      await expect(
        fixture.validatorPool
          .connect(notAdmin1Signer)
          .initializeETHDKG()).
        to.be.revertedWith("ValidatorsPool: Requires admin privileges");
    });

    it("Should not be able to unregister validators", async function () {
      await expect(
        fixture.validatorPool
          .connect(notAdmin1Signer)
          .unregisterValidators(validators)
      ).to.be.revertedWith("ValidatorsPool: Requires admin privileges");
    });

    it("Should not be able to pause consensus", async function () {
      await expect(
        fixture.validatorPool
          .connect(notAdmin1Signer)
          .pauseConsensusOnArbitraryHeight(1)
      ).to.be.revertedWith("ValidatorsPool: Requires admin privileges");
    });

  })

  after(async function () {
    validators.map(async (validator) => {
      console.log("Signer", validators.indexOf(validator), "MAD balance:", await fixture.madToken.balanceOf(validator))
      console.log("Signer", validators.indexOf(validator), "ETH balance:", await ethers.provider.getBalance(validator))
    })
  })

});


