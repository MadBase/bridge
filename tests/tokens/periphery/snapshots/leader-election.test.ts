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
import { getAdminAddress } from "@openzeppelin/upgrades-core";

describe("Tests leader election methods", () => {
  let fixture: Fixture;
  before(async function () {
    fixture = await getFixture();
  });

  it("Dummy test", async function () {
    let blockSignature = ethers.utils.solidityKeccak256(["uint256"], [0]);
    let myIdx = 1;
    let numValidators = 10;
    let isAllowed = await fixture.snapshots.mayValidatorSnapshot(
      numValidators,
      myIdx,
      800,
      blockSignature,
      50
    );
    await assert(isAllowed == false, "Validator:" + myIdx + " allowed!");
  });
});
