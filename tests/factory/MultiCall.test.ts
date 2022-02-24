import { expect } from "chai";
import { ContractFactory } from "ethers";
import { ethers } from "hardhat";
import { MadnetFactory, Utils } from "../../typechain-types";
import {
  CONTRACT_ADDR,
  DEPLOYED_PROXY,
  DEPLOYED_RAW,
  DEPLOYED_STATIC,
  DEPLOYED_TEMPLATE,
  deployFactory,
  endPointBase,
  getAccounts,
  getCreateAddress,
  getEventVar,
  getMetamorphicAddress,
  getSalt,
  MADNET_FACTORY,
  metaMockLogicTest,
  mockBase,
  proxyBase,
  proxyMockLogicTest,
  utilsBase,
} from "./Setup.test";

describe("Multicall deploy meta", async () => {
  let firstOwner: string;
  let secondOwner: string;
  let firstDelegator: string;
  let accounts: Array<string> = [];
  let utilsContract: Utils;
  let factory: MadnetFactory;

  beforeEach(async () => {
    accounts = await getAccounts();
    firstOwner = accounts[0];
    secondOwner = accounts[1];
    firstDelegator = accounts[2];
    utilsContract = await utilsBase.new();
    factory = await deployFactory(MADNET_FACTORY);
    let cSize = await utilsContract.getCodeSize(factory.address);
    expect(cSize.toNumber()).to.be.greaterThan(0);
  });

  describe("Multicall deploy proxy", async () => {

    it("multicall deployproxy, deploycreate, upgradeproxy expect success", async () => {
      let Salt = getSalt();
      let mockCon = await ethers.getContractFactory("Mock");
      let endPoint = await endPointBase.new(factory.address);
      //deploy code for mock with constructor args i = 2
      let deployTX = mockCon.getDeployTransaction(2, "s");
      const MadnetFactory = await ethers.getContractFactory("MadnetFactory");
      let transactionCount = await ethers.provider.getTransactionCount(
        factory.address
      );
      //calculate the deployCreate Address
      let expectedMockLogicAddr = getCreateAddress(
        factory.address,
        transactionCount + 1
      );
      //encoded function call to deployProxy
      let deployProxy = MadnetFactory.interface.encodeFunctionData(
        "deployProxy",
        [Salt]
      );
      //encoded function call to deployCreate
      let deployCreate = MadnetFactory.interface.encodeFunctionData(
        "deployCreate",
        [deployTX.data]
      );
      //encoded function call to upgradeProxy
      let upgradeProxy = MadnetFactory.interface.encodeFunctionData(
        "upgradeProxy",
        [Salt, expectedMockLogicAddr, "0x"]
      );
      let receipt = await factory.multiCall([
        deployProxy,
        deployCreate,
        upgradeProxy,
      ]);
      let mockLogicAddr = await getEventVar(
        receipt,
        DEPLOYED_RAW,
        CONTRACT_ADDR
      );
      let proxyAddr = await getEventVar(receipt, DEPLOYED_PROXY, CONTRACT_ADDR);
      expect(mockLogicAddr).to.equal(expectedMockLogicAddr);
      // console.log("MULTICALL DEPLOYPROXY, DEPLOYCREATE, UPGRADEPROXY GASUSED: ", receipt["receipt"]["gasUsed"]);
      //check the proxy behavior
      await proxyMockLogicTest(
        mockBase,
        Salt,
        proxyAddr,
        mockLogicAddr,
        endPoint.address,
        factory.address
      );
    });

    it("multicall deployproxy, deploytemplate, deploystatic, upgradeproxy, expect success", async () => {
      let endPoint = await endPointBase.new(factory.address);
      let proxySalt = getSalt();
      let mockCon: ContractFactory = await ethers.getContractFactory("Mock");
      //salt for deployStatic
      let metaSalt = getSalt();
      //deploy code for mock with constructor args i = 2, _p = "s"
      let deployTX = mockCon.getDeployTransaction(2, "s");
      let expectedMetaAddr = getMetamorphicAddress(factory.address, metaSalt);
      const MadnetFactory = await ethers.getContractFactory("MadnetFactory");
      //encoded function call to deployProxy
      let deployProxy = MadnetFactory.interface.encodeFunctionData(
        "deployProxy",
        [proxySalt]
      );
      //encoded function call to deployTemplate
      let deployTemplate = MadnetFactory.interface.encodeFunctionData(
        "deployTemplate",
        [deployTX.data]
      );
      //encoded function call to deployStatic
      let deployStatic = MadnetFactory.interface.encodeFunctionData(
        "deployStatic",
        [metaSalt, "0x"]
      );
      expect(proxySalt != metaSalt).to.equal(true);
      //encoded function call to upgradeProxy
      let upgradeProxy = MadnetFactory.interface.encodeFunctionData(
        "upgradeProxy",
        [proxySalt, expectedMetaAddr, "0x"]
      );
      let receipt = await factory.multiCall([
        deployProxy,
        deployTemplate,
        deployStatic,
        upgradeProxy,
      ]);
      //get the deployed template contract address from the event
      //get the deployed metamorphic contract address from the event
      let metaAddr = await getEventVar(receipt, DEPLOYED_STATIC, CONTRACT_ADDR);
      let proxyAddr = await getEventVar(receipt, DEPLOYED_PROXY, CONTRACT_ADDR);
      let proxyCsize = await utilsContract.getCodeSize(proxyAddr);
      expect(proxyCsize.toNumber()).to.equal(
        (proxyBase.deployedBytecode.length - 2) / 2
      );
      await proxyMockLogicTest(
        mockBase,
        proxySalt,
        proxyAddr,
        metaAddr,
        endPoint.address,
        factory.address
      );
      // console.log("MULTICALL DEPLOYPROXY, DEPLOYTEMPLATE, DEPLOYSTATIC, UPGRADEPROXY GASUSED: ", receipt["receipt"]["gasUsed"]);
    });

    it("multicall deploytemplate, deploystatic", async () => {
      let Salt = getSalt();
      //ethers instance of Mock contract abstraction
      let mockCon = await ethers.getContractFactory("Mock");
      //deploy code for mock with constructor args i = 2
      let deployTX = mockCon.getDeployTransaction(2, "s");
      const MadnetFactory = await ethers.getContractFactory("MadnetFactory");
      //encoded function call to deployTemplate
      let deployTemplate = MadnetFactory.interface.encodeFunctionData(
        "deployTemplate",
        [deployTX.data]
      );
      //encoded function call to deployStatic
      let deployStatic = MadnetFactory.interface.encodeFunctionData(
        "deployStatic",
        [Salt, "0x"]
      );
      let receipt = await factory.multiCall([deployTemplate, deployStatic]);
      //get the deployed template contract address from the event
      let tempSDAddr = await getEventVar(
        receipt,
        DEPLOYED_TEMPLATE,
        CONTRACT_ADDR
      );
      //get the deployed metamorphic contract address from the event
      let metaAddr = await getEventVar(receipt, DEPLOYED_STATIC, CONTRACT_ADDR);
      let tempCSize = await utilsContract.getCodeSize(tempSDAddr);
      let staticCSize = await utilsContract.getCodeSize(metaAddr);
      expect(tempCSize.toNumber()).to.be.greaterThan(0);
      expect(staticCSize.toNumber()).to.be.greaterThan(0);
      //test logic at deployed metamorphic location
      await metaMockLogicTest(mockBase, metaAddr, factory.address);
      // console.log("MULTICALL DEPLOYTEMPLATE, DEPLOYSTATIC GASUSED: ", receipt["receipt"]["gasUsed"]);
    });
  });
});
