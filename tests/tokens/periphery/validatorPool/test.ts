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
    notAdmin1Signer = await ethers.getSigner(notAdmin1.address);
    notAdmin2Signer = await ethers.getSigner(notAdmin2.address);
    notAdmin3Signer = await ethers.getSigner(notAdmin3.address);
    notAdmin4Signer = await ethers.getSigner(notAdmin4.address);
    await fixture.madToken.approve(fixture.validatorPoolTrue.address, amount);
  });

  it("Should set a minimum stake if sender is admin", async function () {
    await fixture.validatorPoolTrue
      .connect(adminSigner)
      .setMinimumStake(amount);
  });

  it("Should not set a minimum stake if sender is not admin", async function () {
    await expect(
      fixture.validatorPoolTrue.connect(notAdmin1Signer).setMinimumStake(amount)
    ).to.be.revertedWith("ValidatorsPool: Requires admin privileges");
  });

  it("Should set a maximum number of validators stake if sender is admin", async function () {
    await fixture.validatorPoolTrue
      .connect(adminSigner)
      .setMaxNumValidators(amount);
  });

  it("Should not set a maximum number of validators if sender is not admin", async function () {
    await expect(
      fixture.validatorPoolTrue
        .connect(notAdmin1Signer)
        .setMaxNumValidators(amount)
    ).to.be.revertedWith("ValidatorsPool: Requires admin privileges");
  });

  it("Should schedule maintenance if sender is admin", async function () {
    await fixture.validatorPoolTrue.connect(adminSigner).scheduleMaintenance();
  });

  it("Should not schedule maintenance if sender is not admin", async function () {
    await expect(
      fixture.validatorPoolTrue.connect(notAdmin1Signer).scheduleMaintenance()
    ).to.be.revertedWith("ValidatorsPool: Requires admin privileges");
  });

  it.only("Should initialize ETHDKG if sender is admin", async function () {
    //More than 4
    //Mint tokens
    //Approve to move
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
      // let provider = await ethers.getDefaultProvider()
      let tx = await fixture.stakeNFT
        .connect(adminSigner)
        .mintTo(validator, amount, lockTime);

      //  await provider.waitForTransaction(tx.hash);
      let receipt = await ethers.provider.getTransactionReceipt(tx.hash);

      let log = iface.parseLog(receipt.logs[2]); // here you can add your own logic to find the correct log
      const { from, to, tokenId } = log.args;
      console.log(from);
      console.log(to);
      console.log(tokenId);
      // let tokenId = receipt.logs[2].topics[3]
      stakingTokenIds.push(tokenId);

      await fixture.stakeNFT
        .connect(await ethers.getSigner(validator))
        .setApprovalForAll(fixture.validatorPoolTrue.address, true);
    }

    console.log(validators);
    console.log(stakingTokenIds);

    // let receipt = await ethers.provider.getTransactionReceipt(tx.hash);
    // console.log(receipt.logs[1].data)

    // tx = await fixture.validatorNFT
    // .connect(adminSigner)
    // .mintTo(notAdmin1Signer.address, 1, 1);

    // console.log(receipt.logs[1].data)

    // let intrface = new ethers.utils.Interface([
    //   "event Transfer(address 0 , address to , uint256 tokenId)",
    // ]);
    // let data = receipt.logs[1].data;
    // let topics = receipt.logs[1].topics;
    // let event = intrface.decodeEventLog("Transfer", data, topics);
    // console.log("event",event)

    // await fixture.validatorNFT
    //   .connect(adminSigner)
    //   .mintTo(notAdmin2Signer.address, 1, 1);
    // await fixture.validatorNFT
    //   .connect(adminSigner)
    //   .mintTo(notAdmin3Signer.address, 1, 1);
    // await fixture.validatorNFT
    //   .connect(adminSigner)
    //   .mintTo(notAdmin4Signer.address, 1, 1);

    // console.log(tx)

    //   await fixture.namedSigners.forEach(async (signer) => {
    //   // console.log(signer)
    //   await console.log("hola")
    //   await fixture.madToken.approve(fixture.validatorNFT.address, amount);
    //   await console.log(await fixture.validatorNFT
    //     .connect(adminSigner)
    //     .mint(1));
    //   // console.log("tx",tx);

    // })
    let receipt2 = await fixture.validatorPoolTrue
      .connect(adminSigner)
      .registerValidators(validators, stakingTokenIds);
    console.log("registerValidators ran and succeeded");
    console.log(receipt2);

    // await fixture.ethdkg
    //   .connect(adminSigner)
    //   .initialize(fixture.validatorPoolTrue.address, fixture.validatorPoolTrue.address, fixture.validatorPoolTrue.address)
    await fixture.validatorPoolTrue.connect(adminSigner).initializeETHDKG();
  });

  // it("Should not initialize ETHDKG if sender is not admin", async function () {
  //   await expect(
  //     fixture.validatorPoolTrue
  //       .connect(notAdmin1Signer)
  //       .initializeETHDKG()).to.be
  //     .revertedWith("ValidatorsPool: Requires admin privileges");
  // });
});
