import { expect } from "chai";
import {
  deployFactory,
  getAccounts,
  MADNET_FACTORY,
  predictFactoryAddress,
} from "./Setup.test";
import { artifacts, ethers, run } from "hardhat";
import { getDefaultFactoryAddress } from "../../scripts/lib/factoryStateUtils";
import { MadnetFactory } from "../../typechain-types";

describe("Cli tasks", async () => {
  let utilsBase;
  let firstOwner: string;
  let firstDelegator: string;
  let accounts: Array<string> = [];
  let factory: MadnetFactory;

  beforeEach(async () => {
    accounts = await getAccounts();
    //set owner and delegator
    firstOwner = accounts[0];
    firstDelegator = accounts[1];
    let UtilsBase = await ethers.getContractFactory("Utils")
    let utilsContract = await UtilsBase.deploy();
    factory = await deployFactory(MADNET_FACTORY);
    let cSize = await utilsContract.getCodeSize(factory.address);
    expect(cSize.toNumber()).to.be.greaterThan(0);
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
      contractName: "EndPoint",
      constructorArgs: "0x92D3A65c5890a5623F3d73Bf3a30c973043eE90C",
    });
  });
});
