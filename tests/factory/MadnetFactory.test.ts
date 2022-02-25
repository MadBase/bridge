import { expect } from "chai";
import { expectRevert } from "@openzeppelin/test-helpers";
import {
  checkMockInit,
  CONTRACT_ADDR,
  deployCreate2Initable as deployCreate2Initializable,
  DEPLOYED_PROXY,
  DEPLOYED_RAW,
  DEPLOYED_STATIC,
  DEPLOYED_TEMPLATE,
  deployFactory,
  endPointBase,
  expectTxSuccess,
  getAccounts,
  getCreateAddress,
  getDeployStaticArgs,
  getDeployTemplateArgs,
  getEventVar,
  getMetamorphicAddress,
  getSalt,
  MADNET_FACTORY,
  metaMockLogicTest,
  mockBase,
  mockFactoryBase,
  MOCK_INITIALIZABLE,
  proxyBase,
  RECEIPT,
  utilsBase,
} from "./Setup.test";
import { ethers } from "hardhat";
import { BytesLike, ContractFactory } from "ethers";
import { MadnetFactory, Utils } from "../../typechain-types";

describe("Madnet Contract Factory", () => {
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
//delete
  it("deploy mock", async () => {
    let mock = await mockBase.new(2, "s");
    let size = await utilsContract.getCodeSize(mock.address);
    expect(size.toNumber()).to.be.greaterThan(0);
  });
//delete
  it("deploy endpoint", async () => {
    let endPoint = await endPointBase.new(factory.address);
    let size = await utilsContract.getCodeSize(endPoint.address);
    expect(size.toNumber()).to.be.greaterThan(0);
  });

  it("set owner", async () => {
    //sets the second account as owner
    expect(await factory.owner()).to.equal(firstOwner);
    await factory.setOwner(accounts[1], { from: firstOwner });
    expect(await factory.owner()).to.equal(accounts[1]);
  });

  it("set delegator", async () => {
    //sets the second account as delegator
    await factory.setDelegator(firstDelegator, { from: firstOwner });
    expect(await factory.delegator()).to.equal(firstDelegator);
  });

  it("should not allow set owner via delegator", async () => {
    //sets the second account as delegator
    await factory.setDelegator(firstDelegator, { from: firstOwner });
    expect(await factory.delegator()).to.equal(firstDelegator);
    await expectRevert(
      factory.setOwner(accounts[0], { from: firstDelegator }),
      "unauthorized"
    );
  });

  it("get owner, delegator", async () => {
    await factory.setDelegator(firstDelegator, { from: firstOwner });
    expect(await factory.delegator()).to.equal(firstDelegator);
    let owner = await factory.owner();
    expect(owner).to.equal(firstOwner);
    let delegator = await factory.delegator();
    expect(delegator).to.equal(firstDelegator);
  });

  it("deploy mock with deploytemplate as owner expect succeed", async () => {
    //ethers instance of Mock contract abstraction
    let mockCon = await ethers.getContractFactory("Mock");
    //deploy code for mock with constructor args i = 2
    let deployTxData = mockCon.getDeployTransaction(2, "s").data as BytesLike;
    //deploy the mock Contract to deployTemplate
    let transactionCount = await ethers.provider.getTransactionCount(
      factory.address
    );
    let expectedMockTempAddress = getCreateAddress(
      factory.address,
      transactionCount
    );
    let receipt = await factory.deployTemplate(deployTxData);
    expectTxSuccess(receipt);
    let mockTempAddress = await getEventVar(
      receipt,
      DEPLOYED_TEMPLATE,
      CONTRACT_ADDR
    );
    expect(mockTempAddress).to.equal(expectedMockTempAddress);
    // console.log("DEPLOYTEMPLATE GASUSED: ", receipt["receipt"]["gasUsed"]);
  });

  it("should not allow deploy contract with bytecode 0", async () => {
    let Salt = getSalt();
    await expectRevert(
        factory.deployStatic(Salt, "0x"),
        "reverted with an unrecognized custom error"
      );

  });

  it("should not allow deploy static with unauthorized account", async () => {
    let Salt = getSalt();
    await expectRevert(
      factory.deployStatic(Salt, "0x", { from: firstDelegator }),
      "unauthorized"
    );
  });

  it("deploy contract with deploystatic", async () => {
    //deploy a template of the mock Initializable
    let byteCode = (await getDeployTemplateArgs(
      MOCK_INITIALIZABLE
    )) as BytesLike;
    let receipt = await factory.deployTemplate(byteCode);
    let deployStatic = await getDeployStaticArgs(MOCK_INITIALIZABLE, [2]);
    receipt = await factory.deployStatic(
      deployStatic.salt,
      deployStatic.initCallData
    );
    let mockInitAddr = getEventVar(receipt, DEPLOYED_STATIC, CONTRACT_ADDR);
    checkMockInit(mockInitAddr, 2);
  });

  it("deployproxy", async () => {
    let proxySalt = getSalt();
    //the calculated proxy address
    const expectedProxyAddr = getMetamorphicAddress(factory.address, proxySalt);
    //deploy the proxy through the factory
    let receipt = await factory.deployProxy(proxySalt);
    //check if transaction succeeds
    expectTxSuccess(receipt);
    //get the deployed proxy contract address fom the DeployedProxy event
    let proxyAddr = await getEventVar(receipt, DEPLOYED_PROXY, CONTRACT_ADDR);
    //check if the deployed contract address match the calculated address
    expect(proxyAddr).to.equal(expectedProxyAddr);
    // console.log("DEPLOYPROXY GASUSED: ", receipt["receipt"]["gasUsed"]);
    let cSize = await utilsContract.getCodeSize(proxyAddr);
    expect(cSize.toNumber()).to.equal(
      (proxyBase.deployedBytecode.length - 2) / 2
    );
  });

  it("should not allow deploy proxy with unauthorized account", async () => {
    let Salt = getSalt();
    await expectRevert(
      factory.deployProxy(Salt, { from: firstDelegator }),
      "unauthorized"
    );
  });

  it("deploycreate mock logic contract expect success", async () => {
    //use the ethers Mock contract abstraction to generate the deploy transaction data
    let mockCon: ContractFactory = await ethers.getContractFactory("Mock");
    //get the init code with contructor args appended
    let deployTx = mockCon.getDeployTransaction(2, "s");
    let transactionCount = await ethers.provider.getTransactionCount(
      factory.address
    );
    //deploy Mock Logic through the factory
    // 27fe1822
    let receipt = await factory.deployCreate(deployTx.data as BytesLike);
    //check if the transaction is mined or failed
    expectTxSuccess(receipt);
    let dcMockAddress = getEventVar(receipt, DEPLOYED_RAW, CONTRACT_ADDR);
    //calculate the deployed address
    let expectedMockAddr = ethers.utils.getContractAddress({
      from: factory.address,
      nonce: transactionCount,
    });
    expect(dcMockAddress).to.equal(expectedMockAddr);
    // console.log("DEPLOYCREATE MOCK LOGIC GASUSED: ", receipt["receipt"]["gasUsed"]);
  });

  it("should not allow deploycreate mock logic contract with unauthorized account", async () => {
    //use the ethers Mock contract abstraction to generate the deploy transaction data
    let mockCon = await ethers.getContractFactory("Mock");
    //get the init code with contructor args appended
    let deployTx = mockCon.getDeployTransaction(2, "s");
    //deploy Mock Logic through the factory
    // 27fe1822
    let receipt = factory.deployCreate(deployTx.data as BytesLike, { from: firstDelegator });
    await expectRevert(receipt, "unauthorized");
  });


  it("upgrade proxy to point to mock address with the factory", async () => {
    let proxySalt = getSalt();
    let txResponse = await factory.deployProxy(proxySalt);
    expectTxSuccess(txResponse);
    let mockContract = await mockBase.new(2, "s");
    txResponse = await factory.upgradeProxy(
      proxySalt,
      mockContract.address,
      "0x"
    );
    expectTxSuccess(txResponse);
    // console.log("UPGRADE PROXY GASUSED: ", txResponse["receipt"]["gasUsed"]);
  });

  it("should not allow unauthorized account to update proxy to point to other address ", async () => {
    let proxySalt = getSalt();
    let txResponse = await factory.deployProxy(proxySalt);
    expectTxSuccess(txResponse);
    let mockContract = await mockBase.new(2, "s");
    txResponse = await factory.upgradeProxy(
      proxySalt,
      mockContract.address,
      "0x"
    );
    expectTxSuccess(txResponse);
    // console.log("UPGRADE PROXY GASUSED: ", txResponse["receipt"]["gasUsed"]);
    await expectRevert(factory.upgradeProxy(proxySalt, mockContract.address, "0x", {
        from: firstDelegator,
      }), "unauthorized");
  });

  it("call setfactory in mock through proxy expect su", async () => {
    let endPoint = await endPointBase.new(factory.address);
    let mockContract = await mockBase.new(2, "s");
    let proxySalt = getSalt();
    let txResponse = await factory.deployProxy(proxySalt);
    let proxyAddr = await getEventVar(
      txResponse,
      "DeployedProxy",
      "contractAddr"
    );
    txResponse = await factory.upgradeProxy(
      proxySalt,
      mockContract.address,
      "0x"
    );
    expectTxSuccess(txResponse);
    //connect a Mock interface to the proxy contract
    let proxyMock = await mockBase.at(proxyAddr);
    txResponse = await proxyMock.setFactory(accounts[0]);
    expectTxSuccess(txResponse);
    let mockFactoryAddress = await proxyMock.getFactory.call();
    expect(mockFactoryAddress).to.equal(accounts[0]);
    // console.log("SETFACTORY GASUSED: ", txResponse["receipt"]["gasUsed"]);
    //lock the proxy
    txResponse = await proxyMock.lock();
    expectTxSuccess(txResponse);
    // console.log("LOCK UPGRADES GASUSED: ", txResponse["receipt"]["gasUsed"]);
    let txResponse2 = factory.upgradeProxy(proxySalt, endPoint.address, "0x");
    expectRevert(txResponse2, "revert");
    txResponse = await proxyMock.unlock();
    expectTxSuccess(txResponse);
    txResponse = await factory.upgradeProxy(proxySalt, endPoint.address, "0x");
    expectTxSuccess(txResponse);
  });

  //fail on bad code
  it("should not allow deploycreate with bad code", async () => {
    let receipt = factory.deployCreate("0x6000", { from: firstOwner });
    await expectRevert(receipt, "csize0");
  });

  //fail on unauthorized with bad code
  it("should not allow deploycreate with bad code and unauthorized account", async () => {
    let receipt = factory.deployCreate("0x6000", { from: accounts[2] });
    await expectRevert(receipt, "unauthorized");
  });

  //fail on unauthorized with good code
  it("should not allow deploycreate with valid code and unauthorized account", async () => {
    const receipt = factory.deployCreate(endPointBase.bytecode, {
      from: accounts[2],
    });
    await expectRevert(receipt, "unauthorized");
  });

  it("deploycreate2 mockinitializable", async () => {
    let receiptObj = await deployCreate2Initializable(factory);
    let receipt = receiptObj[RECEIPT];
    expectTxSuccess(receipt);
    let mockInitAddr = await getEventVar(receipt, DEPLOYED_RAW, CONTRACT_ADDR);
    expect(mockInitAddr).to.not.be.undefined;
    let mockInitializable = await ethers.getContractFactory(MOCK_INITIALIZABLE);
    let initCallData = await mockInitializable.interface.encodeFunctionData(
      "initialize",
      [2]
    );
    let txResponse = await factory.initializeContract(
      mockInitAddr,
      initCallData
    );
    expectTxSuccess(txResponse);
    await checkMockInit(mockInitAddr, 2);
  });

  it("callany", async () => {
    let receiptObj = await deployCreate2Initializable(factory);
    let receipt = receiptObj[RECEIPT];
    expectTxSuccess(receipt);
    let mockInitAddr = await getEventVar(receipt, DEPLOYED_RAW, CONTRACT_ADDR);
    expect(mockInitAddr).to.not.be.undefined;
    // call data to initialize mockInitializable
    let mockInitable = await ethers.getContractFactory(MOCK_INITIALIZABLE);
    let initCallData = await mockInitable.interface.encodeFunctionData(
      "initialize",
      [2]
    );
    receipt = await factory.callAny(mockInitAddr, 0, initCallData);
    await checkMockInit(mockInitAddr, 2);
  });

  it("delegatecallany", async () => {
    expect(await factory.owner()).to.equal(firstOwner);
    //deploy an instance of mock logic for factory
    let mockFactoryInstance = await mockFactoryBase.new();
    //generate the call data for the factory instance
    let mfEncode = await ethers.getContractFactory("MockFactory");
    let setOwner = await mfEncode.interface.encodeFunctionData("setOwner", [
      accounts[2],
    ]);
    //delegate call into the factory and change the owner
    let receipt = await factory.delegateCallAny(
      mockFactoryInstance.address,
      setOwner
    );
    expectTxSuccess(receipt);
    let owner = await factory.owner();
    expect(owner).to.equal(accounts[2]);
    setOwner = await mfEncode.interface.encodeFunctionData("setOwner", [
      accounts[0],
    ]);
    receipt = await factory.delegateCallAny(
      mockFactoryInstance.address,
      setOwner,
      { from: accounts[2] }
    );
    expectTxSuccess(receipt);
    owner = await factory.owner();
    expect(owner).to.equal(accounts[0]);
  });

  it("upgrade proxy through factory", async () => {
    let factory = await deployFactory(MADNET_FACTORY);
    let endPointLockableFactory = await ethers.getContractFactory("EndPointLockable");
    let endPointLockable = await endPointLockableFactory.deploy(factory.address);
    let salt = getSalt();
    let expectedProxyAddr = getMetamorphicAddress(factory.address, salt);
    let txResponse = await factory.deployProxy(salt);
    expectTxSuccess(txResponse);
    let proxyAddr = await getEventVar(txResponse, DEPLOYED_PROXY, CONTRACT_ADDR);
    expect(proxyAddr).to.equal(expectedProxyAddr);
    txResponse = await factory.upgradeProxy(salt, endPointLockable.address, "0x");
    expectTxSuccess(txResponse);
    let proxyFactory = await ethers.getContractFactory("Proxy");
    let proxyContract = proxyFactory.attach(proxyAddr)
    let proxyImplAddress = await proxyContract.callStatic.getImplementationAddress();
    expect(proxyImplAddress).to.equal(endPointLockable.address);
  });

  it("lock proxy upgrade from factory", async () => {
    let factory = await deployFactory(MADNET_FACTORY);
    let endPointLockableFactory = await ethers.getContractFactory("EndPointLockable");
    let endPointLockable = await endPointLockableFactory.deploy(factory.address);
    let salt = getSalt();
    let expectedProxyAddr = getMetamorphicAddress(factory.address, salt);
    let txResponse = await factory.deployProxy(salt);
    expectTxSuccess(txResponse);
    let proxyAddr = await getEventVar(txResponse, DEPLOYED_PROXY, CONTRACT_ADDR);
    expect(proxyAddr).to.equal(expectedProxyAddr);
    txResponse = await factory.upgradeProxy(salt, endPointLockable.address, "0x");
    expectTxSuccess(txResponse);
    let proxyFactory = await ethers.getContractFactory("Proxy");
    let proxyContract = proxyFactory.attach(proxyAddr)
    let proxyImplAddress = await proxyContract.callStatic.getImplementationAddress();
    expect(proxyImplAddress).to.equal(endPointLockable.address);
  });

  it("should prevent locked proxy logic from being upgraded from factory", async () => {
    let factory = await deployFactory(MADNET_FACTORY);
    let endPointFactory = await ethers.getContractFactory("EndPoint");
    let endPoint = await endPointFactory.deploy(factory.address);
    let endPointLockableFactory = await ethers.getContractFactory("EndPointLockable");
    let endPointLockable = await endPointLockableFactory.deploy(factory.address);
    let salt = getSalt();
    let expectedProxyAddr = getMetamorphicAddress(factory.address, salt);
    let txResponse = await factory.deployProxy(salt);
    expectTxSuccess(txResponse);
    let proxyAddr = await getEventVar(txResponse, DEPLOYED_PROXY, CONTRACT_ADDR);
    expect(proxyAddr).to.equal(expectedProxyAddr);
    txResponse = await factory.upgradeProxy(salt, endPointLockable.address, "0x");
    expectTxSuccess(txResponse);
    let proxyFactory = await ethers.getContractFactory("Proxy");
    let proxy = proxyFactory.attach(proxyAddr)
    let proxyImplAddress = await proxy.callStatic.getImplementationAddress();
    expect(proxyImplAddress).to.equal(endPointLockable.address);
    let proxyContract = endPointLockableFactory.attach(proxy.address);
    let lockResponse = await proxyContract.upgradeLock();
    let receipt = await lockResponse.wait();
    expect(receipt.status).to.equal(1);
    expect(factory.upgradeProxy(salt, endPoint.address, "0x"));
  });
});
