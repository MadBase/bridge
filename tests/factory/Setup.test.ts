//const { contracts } from"@openzeppelin/cli/lib/prompts/choices");
import { expectRevert } from "@openzeppelin/test-helpers";
import { expect } from "chai";
import { BytesLike } from "ethers";
import { ethers, artifacts } from "hardhat";

export const MOCK_INITIALIZABLE = "MockInitializable";
export const END_POINT = "EndPoint";
export const DEPLOYED_STATIC = "DeployedStatic";
export const DEPLOYED_PROXY = "DeployedProxy";
export const DEPLOYED_RAW = "DeployedRaw";
export const DEPLOYED_TEMPLATE = "DeployedTemplate";
export const CONTRACT_ADDR = "contractAddr";
export const MADNET_FACTORY = "MadnetFactory";
export const MOCK = "Mock";
export const RECEIPT = "receipt";
export const PROXY = "Proxy";
export const madnetFactoryBase = artifacts.require(MADNET_FACTORY);
export const proxyBase = artifacts.require(PROXY);
export const endPointBase = artifacts.require(END_POINT);
export const mockBase = artifacts.require(MOCK);
export const mockInitBase = artifacts.require(MOCK_INITIALIZABLE);
export const mockFactoryBase = artifacts.require("MockFactory");
export const utilsBase = artifacts.require("Utils");

export async function getAccounts() {
  let signers = await ethers.getSigners();
  let accounts = [];
  for (let signer of signers) {
    accounts.push(signer.address);
  }
  return accounts;
}

export async function predictFactoryAddress(ownerAddress: string) {
  let txCount = await ethers.provider.getTransactionCount(ownerAddress);
  // console.log(txCount)
  let futureFactoryAddress = ethers.utils.getContractAddress({
    from: ownerAddress,
    nonce: txCount,
  });
  return futureFactoryAddress;
}

export async function proxyMockLogicTest(
  contract: any,
  salt: string,
  proxyAddress: string,
  mockLogicAddr: string,
  endPointAddr: string,
  factoryAddress: string
) {
  const factory = await madnetFactoryBase.at(factoryAddress);
  const mockProxy = await contract.at(proxyAddress);
  let receipt = await mockProxy.setFactory(factoryAddress);
  const testArg = 4;
  expectTxSuccess(receipt);
  let fa = await mockProxy.getFactory.call();
  expect(fa).to.equal(factoryAddress);
  receipt = await mockProxy.setv(testArg);
  expectTxSuccess(receipt);
  let v = await mockProxy.v.call();
  expect(v.toNumber()).to.equal(testArg);
  let i = await mockProxy.i.call();
  expect(i.toNumber()).to.equal(2);
  //upgrade the proxy
  receipt = await factory.upgradeProxy(salt, endPointAddr, "0x");
  expectTxSuccess(receipt);
  //endpoint interface connected to proxy address
  let proxyEndpoint = await endPointBase.at(proxyAddress);
  i = await proxyEndpoint.i.call();
  i = i.toNumber() + 2;
  receipt = await proxyEndpoint.addTwo();
  let test = await getEventVar(receipt, "addedTwo", "i");
  expect(test.toNumber()).to.equal(i);
  //lock the proxy upgrade
  receipt = await factory.upgradeProxy(salt, mockLogicAddr, "0x");
  expectTxSuccess(receipt);
  receipt = await mockProxy.setv(testArg + 2);
  expectTxSuccess(receipt);
  v = await mockProxy.v.call();
  expect(v.toNumber()).to.equal(testArg + 2);
  //lock the upgrade functionality
  receipt = await mockProxy.lock();
  expectTxSuccess(receipt);
  receipt = factory.upgradeProxy(salt, endPointAddr, "0x");
  expectRevert(receipt, "revert");
  //unlock the proxy
  receipt = await mockProxy.unlock();
  expectTxSuccess(receipt);
  receipt = await factory.upgradeProxy(salt, endPointAddr, "0x");
  expectTxSuccess(receipt);
  i = await proxyEndpoint.i.call();
  i = i.toNumber() + 2;
  receipt = await proxyEndpoint.addTwo();
  test = await getEventVar(receipt, "addedTwo", "i");
  expect(test.toNumber()).to.equal(i);
}

export async function metaMockLogicTest(
  contract: any,
  address: string,
  factoryAddress: string
) {
  const Contract = await contract.at(address);
  let receipt = await Contract.setFactory(factoryAddress);
  const test = 4;
  expectTxSuccess(receipt);
  let fa = await Contract.getFactory.call();
  expect(fa).to.equal(factoryAddress);
  receipt = await Contract.setv(test);
  expectTxSuccess(receipt);
  let v = await Contract.v.call();
  expect(v.toNumber()).to.equal(test);
  let i = await Contract.i.call();
  expect(i.toNumber()).to.equal(2);
}

export function getEventVar(receipt: any, eventName: string, varName: string) {
  let result;
  for (let i = 0; i < receipt["logs"].length; i++) {
    //look for the event
    if (receipt["logs"][i]["event"] == eventName) {
      //extract the deployed mock logic contract address from the event
      result = receipt["logs"][i]["args"][varName];
      //exit the loop
      break;
    }
  }
  return result;
}

export function expectTxSuccess(receipt: any) {
  expect(receipt["receipt"]["status"]).to.equal(true);
}

export function getCreateAddress(Address: string, nonce: number) {
  return ethers.utils.getContractAddress({
    from: Address,
    nonce: nonce,
  });
}
export function bytes32ArrayToStringArray(bytes32Array: Array<any>) {
  let ret = [];
  for (let i = 0; i < bytes32Array.length; i++) {
    ret.push(ethers.utils.parseBytes32String(bytes32Array[i]));
  }
  return ret;
}

export function getSalt() {
  //set a new salt
  let salt = new Date();
  //use the time as the salt
  let Salt = salt.getTime();
  return ethers.utils.formatBytes32String(Salt.toString());
}

export async function getDeployTemplateArgs(contractName: string) {
  let contract = await ethers.getContractFactory(contractName);
  let deployByteCode = contract.getDeployTransaction();
  return deployByteCode.data as BytesLike;
}

export type DeployStaticArgs = {
  salt: string;
  initCallData: string;
};

export async function getDeployStaticArgs(
  contractName: string,
  argsArray: Array<any>
) {
  let contract = await ethers.getContractFactory(contractName);
  let ret: DeployStaticArgs = {
    salt: getSalt(),
    initCallData: contract.interface.encodeFunctionData(
      "initialize",
      argsArray
    ),
  };
  return ret;
}

export async function checkMockInit(target: string, initVal: number) {
  let mock = await mockInitBase.at(target);
  let i = await mock.i.call();
  expect(i.toNumber()).to.equal(initVal);
}

export async function deployFactory(factoryName: string) {
  let factoryInstance = await artifacts.require(factoryName);
  let firstOwner = (await getAccounts())[0];
  //gets the initial transaction count for the address
  let transactionCount = await ethers.provider.getTransactionCount(firstOwner);
  //pre calculate the address of the factory contract
  let futureFactoryAddress = ethers.utils.getContractAddress({
    from: firstOwner,
    nonce: transactionCount,
  });
  //deploy the factory with its address as a constructor input
  let factory = await factoryInstance.new(futureFactoryAddress);
  expect(factory.address).to.equal(futureFactoryAddress);
  return factory;
}

export async function deployCreate2Initable(factory: any) {
  //set a new salt
  let salt = new Date();
  //use the time as the salt
  let Salt = ethers.utils.formatBytes32String(salt.getTime().toString());
  let ret: {
    Salt: string;
    receipt: any;
  } = {
    Salt: Salt,
    receipt: await factory.deployCreate2(0, Salt, mockInitBase.bytecode),
  };

  return ret;
}

export function getMetamorphicAddress(factoryAddress: string, salt: string) {
  let initCode = "0x6020363636335afa1536363636515af43d36363e3d36f3";
  return ethers.utils.getCreate2Address(
    factoryAddress,
    salt,
    ethers.utils.keccak256(initCode)
  );
}
