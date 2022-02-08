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

describe("Tests ValidatorPool methods", () => {

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

  it("Should set a minimum stake if sender is admin", async function () {
    await fixture.validatorPool
      .connect(adminSigner)
      .setMinimumStake(minimunStake);
  });

  it("Should not set a minimum stake if sender is not admin", async function () {
    await expect(
      fixture.validatorPool.
        connect(notAdmin1Signer).
        setMinimumStake(minimunStake)
    ).to.be.revertedWith("ValidatorsPool: Requires admin privileges");
  });

  it("Should set a maximum number of validators stake if sender is admin", async function () {
    await fixture.validatorPool
      .connect(adminSigner)
      .setMaxNumValidators(maxNumValidators);
  });

  it("Should not set a maximum number of validators if sender is not admin", async function () {
    await expect(
      fixture.validatorPool
        .connect(notAdmin1Signer)
        .setMaxNumValidators(maxNumValidators)
    ).to.be.revertedWith("ValidatorsPool: Requires admin privileges");
  });

  it("Should set snapshot if sender is admin", async function () {
    await fixture.validatorPool
      .connect(adminSigner)
      .setSnapshot(fixture.snapshots.address);
  });

  it("Should not set snapshot if sender is not admin", async function () {
    await expect(
      fixture.validatorPool
        .connect(notAdmin1Signer)
        .setSnapshot(fixture.snapshots.address)
    ).to.be.revertedWith("ValidatorsPool: Requires admin privileges");
  });

  it("Should set ETHDKG if sender is admin", async function () {
    await fixture.validatorPool
      .connect(adminSigner)
      .setETHDKG(fixture.ethdkg.address);
  });

  it("Should not set ETHDKG if sender is not admin", async function () {
    await expect(
      fixture.validatorPool
        .connect(notAdmin1Signer)
        .setETHDKG(fixture.ethdkg.address)
    ).to.be.revertedWith("ValidatorsPool: Requires admin privileges");
  });

  it("Should schedule maintenance if sender is admin", async function () {
    await fixture.validatorPool.
      connect(adminSigner).
      scheduleMaintenance();
  });

  it("Should not schedule maintenance if sender is not admin", async function () {
    await expect(
      fixture.validatorPool.
        connect(notAdmin1Signer).
        scheduleMaintenance()
    ).to.be.revertedWith("ValidatorsPool: Requires admin privileges");
  });

  it("Should register validators if sender is admin", async function () {
    await fixture.validatorPool
      .connect(adminSigner)
      .registerValidators(validators, stakingTokenIds);
  });

  it("Should not register validators if sender is not admin", async function () {
    await expect(
      fixture.validatorPool
        .connect(notAdmin1Signer)
        .registerValidators(validators, stakingTokenIds)
    ).to.be.revertedWith("ValidatorsPool: Requires admin privileges");
  });

  it("Should initialize ETHDKG if sender is admin", async function () {
    await fixture.validatorPool
      .connect(adminSigner)
      .registerValidators(validators, stakingTokenIds);
    await fixture.validatorPool.
      connect(adminSigner).
      initializeETHDKG();
  });

  it("Should not initialize ETHDKG if sender is not admin", async function () {
    await expect(
      fixture.validatorPool
        .connect(notAdmin1Signer)
        .initializeETHDKG()).
      to.be.revertedWith("ValidatorsPool: Requires admin privileges");
  });

  it("Should unregister validators if sender is admin", async function () {
    await fixture.validatorPool
      .connect(adminSigner)
      .registerValidators(validators, stakingTokenIds);
    await fixture.validatorPool
      .connect(adminSigner)
      .unregisterValidators(validators);
  });

  it("Should not unregister validators if sender is not admin", async function () {
    await expect(
      fixture.validatorPool
        .connect(notAdmin1Signer)
        .unregisterValidators(validators)
    ).to.be.revertedWith("ValidatorsPool: Requires admin privileges");
  });

  it("Should pause consesus if sender is admin", async function () {
    await fixture.validatorPool
      .connect(adminSigner)
      .pauseConsensusOnArbitraryHeight(1);
    await fixture.validatorPool
      .connect(adminSigner)
      .unregisterValidators(validators);
  });

  it("Should not pause consensus if sender is not admin", async function () {
    await expect(
      fixture.validatorPool
        .connect(notAdmin1Signer)
        .pauseConsensusOnArbitraryHeight(1)
    ).to.be.revertedWith("ValidatorsPool: Requires admin privileges");
  });

  after(async function () {
    validators.map(async (validator) => {
      console.log("Signer", validators.indexOf(validator), "MAD balance:", await fixture.madToken.balanceOf(validator))
      console.log("Signer", validators.indexOf(validator), "ETH balance:", await ethers.provider.getBalance(validator))
    })
  })

});


