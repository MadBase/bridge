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

  let fixture: Fixture
  let adminSigner: SignerWithAddress;
  let notAdminSigner: SignerWithAddress;
  let amount = 1;

  before(async function () {
    fixture = await getFixture();
    const [admin, notAdmin] = fixture.namedSigners;
    adminSigner = await ethers.getSigner(admin.address);
    notAdminSigner = await ethers.getSigner(notAdmin.address);
    await fixture.madToken.approve(fixture.validatorPoolTrue.address, amount)

  })

  it("Should set a minimum stake if sender is admin", async function () {
    await fixture.validatorPoolTrue
      .connect(adminSigner)
      .setMinimumStake(amount);
  });

  it("Should fail to set a minimum stake if sender is not admin", async function () {
    await expect(
      fixture.validatorPoolTrue
        .connect(notAdminSigner)
        .setMinimumStake(amount)
    ).to.be
      .revertedWith("ValidatorsPool: Requires admin privileges");
  });

  it("Should set a maximum number of validators stake if sender is admin", async function () {
    await fixture.validatorPoolTrue
      .connect(adminSigner)
      .setMaxNumValidators(amount);
  });

  it("Should fail to set a maximum number of validators if sender is not admin", async function () {
    await expect(
      fixture.validatorPoolTrue
        .connect(notAdminSigner)
        .setMaxNumValidators(amount)
    ).to.be
      .revertedWith("ValidatorsPool: Requires admin privileges");
  });

  // it("Should set a minimum stake if sender is admin", async function () {
  //   await fixture.validatorPoolTrue.sc
  //     .connect(adminSigner)
  //     .regi  });

//   it("Should fail to set a minimum stake if sender is not admin", async function () {
//     await expect(
//       fixture.validatorPoolTrue
//         .connect(notAdminSigner)
//         .addOperator(amount)
//     ).to.be
//       .revertedWith("Validators: requires admin privileges");
//   });
//   it("Should set a minimum stake if sender is admin", async function () {
//     await fixture.validatorPoolTrue
//       .connect(adminSigner)
//       .setMinimumStake(amount);
//   });

//   it("Should fail to set a minimum stake if sender is not admin", async function () {
//     await expect(
//       fixture.validatorPoolTrue
//         .connect(notAdminSigner)
//         .setMinimumStake(amount)
//     ).to.be
//       .revertedWith("Validators: requires admin privileges");
//   });


//   function setMaxNumValidators(uint256 maxNumValidators_) public onlyAdmin {
//     _maxNumValidators = maxNumValidators_;
// }

// function addOperator(address operator) public onlyAdmin {
//     _addOperator(operator);
// }

// function removeOperator(

});
