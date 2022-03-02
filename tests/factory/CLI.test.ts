import { expect } from "chai";
import { ethers, run } from "hardhat";
import { getDefaultFactoryAddress } from "../../scripts/lib/factoryStateUtils";
import { MadnetFactory } from "../../typechain-types";
import {
  deployFactory,
  getAccounts,
  predictFactoryAddress
} from "./Setup.test";

describe("Cli tasks", async () => {
  let utilsBase;
  let firstOwner: string;
  let firstDelegator: string;
  let accounts: Array<string> = [];

  beforeEach(async () => {
    accounts = await getAccounts();
    //set owner and delegator
    firstOwner = accounts[0];
    firstDelegator = accounts[1];
  });

  it("deploy factory with cli", async () => {
    let futureFactoryAddress = await predictFactoryAddress(firstOwner);
    let factoryAddress = await run("deployFactory");
    //check if the address is the predicted
    expect(factoryAddress).to.equal(futureFactoryAddress);
    let defaultFactoryAddress = await getDefaultFactoryAddress();
    expect(defaultFactoryAddress).to.equal(factoryAddress);
  });


  it("deploy mock with deploystatic", async () => {
    await run("deployMetamorphic", {
      contractName: "Mock",
      constructorArgs: ["2", "s"]
    });
  });
});
