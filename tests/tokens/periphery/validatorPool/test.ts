import { Fixture, getFixture } from "../setup";
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
  let notAdmin2Signer: SignerWithAddress;
  let notAdmin3Signer: SignerWithAddress;
  let notAdmin4Signer: SignerWithAddress;
  let amount = 1;

  beforeEach(async function () {
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
      // await fixture.validatorNFT.
      // connect(adminSigner).
      // setSnapshot(fixture.snvalidatorPool.address);


      notAdmin1Signer = await ethers.getSigner(notAdmin1.address);
    notAdmin2Signer = await ethers.getSigner(notAdmin2.address);
    notAdmin3Signer = await ethers.getSigner(notAdmin3.address);
    notAdmin4Signer = await ethers.getSigner(notAdmin4.address);
    await fixture.madToken.approve(fixture.validatorPool.address, amount);
  });

  it("Should set a minimum stake if sender is admin", async function () {
    await fixture.validatorPool
      .connect(adminSigner)
      .setMinimumStake(amount);
  });

  it("Should not set a minimum stake if sender is not admin", async function () {
    await expect(
      fixture.validatorPool.connect(notAdmin1Signer).setMinimumStake(amount)
    ).to.be.revertedWith("ValidatorsPool: Requires admin privileges");
  });

  it("Should set a maximum number of validators stake if sender is admin", async function () {
    await fixture.validatorPool
      .connect(adminSigner)
      .setMaxNumValidators(amount);
  });

  it("Should not set a maximum number of validators if sender is not admin", async function () {
    await expect(
      fixture.validatorPool
        .connect(notAdmin1Signer)
        .setMaxNumValidators(amount)
    ).to.be.revertedWith("ValidatorsPool: Requires admin privileges");
  });

  it("Should schedule maintenance if sender is admin", async function () {
    await fixture.validatorPool.connect(adminSigner).scheduleMaintenance();
  });

  it("Should not schedule maintenance if sender is not admin", async function () {
    await expect(
      fixture.validatorPool.connect(notAdmin1Signer).scheduleMaintenance()
    ).to.be.revertedWith("ValidatorsPool: Requires admin privileges");
  });

  it.only("Should initialize ETHDKG if sender is admin", async function () {
    let validators = [
      notAdmin1Signer.address,
      notAdmin2Signer.address,
      notAdmin3Signer.address,
      notAdmin4Signer.address,
    ];
    let stakingTokenIds = new Array();
    let amount = ethers.utils.parseUnits("20000", 18);
    let lockTime = 1;
    await fixture.madToken.approve(fixture.stakeNFT.address, amount.mul(4));

    let abi = [
      "event Transfer(address indexed from, address indexed to, uint256 indexed tokenId)",
    ];
    let iface = new ethers.utils.Interface(abi);
    for (const validator of validators) {
      let tx = await fixture.stakeNFT
        .connect(adminSigner)
        .mintTo(validator, amount, lockTime);
      let receipt = await ethers.provider.getTransactionReceipt(tx.hash);
      let log = iface.parseLog(receipt.logs[2]); // here you can add your own logic to find the correct log
      const { from, to, tokenId } = log.args;
      // console.log(from);
      // console.log(to);
      // console.log(tokenId);
      stakingTokenIds.push(tokenId);
      await fixture.stakeNFT
        .connect(await ethers.getSigner(validator))
        .setApprovalForAll(fixture.validatorPool.address, true);
    }

    let receipt2 = await fixture.validatorPool
      .connect(adminSigner)
      .registerValidators(validators, stakingTokenIds);
    // console.log("registerValidators ran and succeeded");
    // console.log(receipt2);

    await fixture.validatorPool.connect(adminSigner).initializeETHDKG();
  });

  // it("Should not initialize ETHDKG if sender is not admin", async function () {
  //   await expect(
  //     fixture.validatorPool
  //       .connect(notAdmin1Signer)
  //       .initializeETHDKG()).to.be
  //     .revertedWith("ValidatorsPool: Requires admin privileges");
  // });
});
