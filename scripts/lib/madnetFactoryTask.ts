import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { ContractFactory } from "ethers";
import { task, extendEnvironment, subtask, extendConfig } from "hardhat/config";
import { string } from "hardhat/internal/core/params/argumentTypes";
import { lazyObject } from "hardhat/plugins";
import { BuildInfo, HardhatConfig, HardhatRuntimeEnvironment, HardhatUserConfig } from "hardhat/types";
import "./type-extensions";
import fs from "fs";
import { fstat } from "fs";
import { table } from "console";
//Should look into extending types into the hardhat type lib

type ProxyData = {
  logicName:string;
  logicAddress:string;
  salt:string;
  proxyAddress:string;
}


type DeployProxyMCArgs = {
  contractName: string;
  factoryName: string;
  logicAddress: string;
  factoryAddress: string;
}
type FactoryData = {
  name: string| any;
  address: string|any;
}

type DeployCreateArgs = {
  contractName: any;
  factoryName: any;
  factoryAddress: any;
  optionalArgs?:  Array<any>;
}
const contractAddrKey = "contractAddr";
const deployedProxyKey = "DeployedProxy";
const deployedRawKey = "DeployedRaw";
let defaultFactoryName = "MadnetFactory";
let defaultFactoryAddress:string;

task("getSalt", "gets salt from contract")
  .addParam("contractName", "test contract")
  .setAction(async (taskArgs, hre) => {
    let salt = await getSalt(taskArgs.contractName, hre)
    console.log(salt)
  });

task("deployFactory", "Deploys and instance of a factory contract specified by its name")
  .addParam("factoryName", "The name of the factory contract")
  .setAction(async (taskArgs, hre) => {
      try {
        const factoryName = taskArgs.factoryName;
        const factoryContractInstance = await hre.artifacts.require(factoryName)
        const signers = await hre.ethers.getSigners();
        const accounts = getAccounts(signers);
        let txCount = await hre.ethers.provider.getTransactionCount(accounts[0]);
        //calculate the factory address for the constructor arg
        let futureFactoryAddress = hre.ethers.utils.getContractAddress({
          from: accounts[0],
          nonce: txCount
        });
        //deploys the factory
        let factory = await factoryContractInstance.new(futureFactoryAddress);
        defaultFactoryAddress = factory.address;
        defaultFactoryName = factoryName;
        //record the data in a json file to be used in other tasks 
        await writeFactoryConfigJSON(defaultFactoryName, defaultFactoryAddress);
        console.log("Deployed:", factoryName, "at address:", factory.address);
        return factory.address;
      } catch (error) {
        console.log(error);
      }
  });

task("deployUpgradeableProxy", "deploys logic contract, proxy contract, and points the proxy to the logic contract")
  .addParam("contractName", "Name of logic contract to point the proxy at", "string")
  .addOptionalParam("factoryName", "Name of the factory contract to deploy contract with")
  .addOptionalParam("factoryAddress", "address of the factory deploying the contract")
  .addOptionalVariadicPositionalParam("constructorArgs", "array that holds all arguements for constructor")
  .setAction(async (taskArgs, hre) => {
    try{
      let factoryData = await getFactoryData(taskArgs);
      //uses the factory Data and logic contractName and returns deploybytecode and any constructor args attached       
      let callArgs:DeployCreateArgs = getDeploySubtaskArgs(factoryData, taskArgs);
      //deploy create the logic contract 
      let logicAddress = await hre.run("deployCreate", callArgs);
      console.log("deployUpgradeableProxy logicAddress: ", logicAddress);
      let mcCallArgs:DeployProxyMCArgs = await getDeployUpgradeableMultiCallArgs(taskArgs, logicAddress);
      let proxyData = await hre.run("multiCallDeployProxy", mcCallArgs);
      console.log("deployed Proxy at: ", proxyData)
      return proxyData;
    }
    catch(error){
      console.log(error);
    }
  });

task("deployStatic", "deploys template contract, and then deploys metamorphic contract, and points the proxy to the logic contract")
  .addParam("contractName", "Name of logic contract to point the proxy at", "string")
  .addOptionalParam("factoryName", "Name of the factory contract to deploy contract with")
  .addOptionalParam("factoryAddress", "address of the factory deploying the contract")
  .addOptionalVariadicPositionalParam("constructorArgs", "array that holds all arguements for constructor")
  .setAction(async (taskArgs, hre) => {
    try{
      let factoryData = await getFactoryData(taskArgs);
      //uses the factory Data and logic contractName and returns deploybytecode and any constructor args attached       
      let callArgs:DeployCreateArgs = getDeploySubtaskArgs(factoryData, taskArgs);
      //deploy create the logic contract 
      let logicAddress = await hre.run("deployTemplate", callArgs);
      console.log("Deploy Static logicAddress:", logicAddress);
      callArgs = await getDeployStaticArgs(taskArgs, logicAddress);
      let metaData = await hre.run("deployStatic", callArgs);
      console.log("deployed Metamorphic at: ", metaData, "with logic from,", logicAddress);
      return metaData;
    }
    catch(error){
      console.log(error);
    }
  });

  //factoryName param doesnt do anything right now
subtask("deployCreate", "deploys a contract from the factory using create")
  .addParam("contractName", "logic contract name")
  .addParam("factoryName", "Name of the factory contract")
  .addParam("factoryAddress", "factory deploying the contract")
  .addOptionalVariadicPositionalParam("constructorArgs", "array that holds all arguements for constructor")
  .setAction(async (taskArgs, hre) => {
    let factoryData = await getFactoryData(taskArgs);
    let MadnetFactory = await hre.artifacts.require("MadnetFactory");
    try{
      //get logic contract interface
      let lcInstance = hre.artifacts.require(taskArgs.contractName);
      let logicContract:any = await hre.ethers.getContractFactory(taskArgs.contractName);
      //encode deployBcode 
      let deployBytecode = logicContract.getDeployTransaction(...taskArgs.constructorArgs)
      deployBytecode = deployBytecode.data
      //get a factory instance connected to the factory addr
      const factory = await MadnetFactory.at(factoryData.address);
      let receipt = await factory.deployCreate(deployBytecode);
      let contractAddr = await getEventVar(receipt, deployedRawKey, contractAddrKey);
      console.log("Deployed ", taskArgs.contractName, " contract at ", contractAddr);
      return contractAddr;
    }
    catch (error){
      console.log(error)
    }
    
  });

subtask("deployTemplate", "deploys a template contract with the universal code copy constructor that deploys")
  .addParam("contractName", "logic contract name")
  .addParam("factoryName", "Name of the factory contract")
  .addParam("factoryAddress", "factory deploying the contract")
  .addOptionalVariadicPositionalParam("constructorArgs", "array that holds all arguements for constructor")
  .setAction(async (taskArgs, hre) => {
    let factoryData = await getFactoryData(taskArgs);
    let MadnetFactory = await hre.artifacts.require(factoryData.name);
    try{
      let logicContract:any = await hre.ethers.getContractFactory(taskArgs.contractName);
      //encode deployBcode 
      let deployBytecode = logicContract.getDeployTransaction(...taskArgs.constructorArgs)
      deployBytecode = deployBytecode.data
      //get a factory instance connected to the factory addr
      const factory = await MadnetFactory.at(factoryData.address);
      let receipt = await factory.deployTemplate(deployBytecode);
      let contractAddr = await getEventVar(receipt, deployedRawKey, contractAddrKey);
      console.log("Deployed ", taskArgs.contractName, " contract at ", contractAddr);
      return contractAddr;
    }
    catch (error){
      console.log(error)
    }
    
  });

function getDeployStaticArgs(factoryData:FactoryData, taskArgs:any){
  return <DeployCreateArgs>{
    contractName: taskArgs.contractName,
    factoryName: factoryData.name,
    factoryAddress: factoryData.address,
    optionalArgs: taskArgs?.initCallData
  };
}

subtask("deployStatic", "deploys a template contract with the universal code copy constructor that deploys")
  .addParam("contractName", "logic contract name")
  .addParam("factoryName", "Name of the factory contract")
  .addParam("factoryAddress", "factory deploying the contract")
  .addOptionalParam("initCallData")
  .setAction(async (taskArgs, hre) => {
    let factoryData = await getFactoryData(taskArgs);
    let MadnetFactory = await hre.artifacts.require(factoryData.name);
    try{
      let Salt = getBytes32Salt(taskArgs.contractName, hre);
      let initCallData:string;
      if(taskArgs.initCallData === undefined){
        initCallData = "0x"
      }else{
        initCallData = taskArgs.initCallData;
      }
      //get a factory instance connected to the factory addr
      const factory = await MadnetFactory.at(factoryData.address);
      let receipt = await factory.deployStatic(Salt, initCallData);
      let contractAddr = await getEventVar(receipt, "DeployedStatic", contractAddrKey);
      console.log("Deployed ", taskArgs.contractName, " contract at ", contractAddr);
      return contractAddr;
    }
    catch (error){
      console.log(error)
    }
    
  });  


/**
 * deploys a proxy and upgrades it using multicall from factory
 * @returns a proxyData object with logic contract name, address and proxy salt, and address. 
 */
subtask("multiCallDeployProxy", "deploy and upgrade proxy with multicall")
  .addParam("logicAddress", "Address of the logic contract to point the proxy to")
  .addParam("contractName", "logic contract name")
  .addParam("factoryName", "Name of the factory contract")
  .addParam("factoryAddress", "factory deploying the contract")
  .setAction(async (taskArgs, hre) => {
    //extract factory name from taskArgs
    let factoryName:string = taskArgs.factoryName;
    //extract factory address from taskArgs
    let factoryAddr:string = taskArgs.factoryAddress;
    //get factory contract artifact object, a truffle contract object 
    let factoryObj = await hre.artifacts.require(factoryName);
    //factory interface pointed to deployed factory contract
    let iFactory = await factoryObj.at(factoryAddr);
    //get the 32byte salt from logic contract file 
    let Salt = await getBytes32Salt(taskArgs.contractName, hre);
    //get the multi call arguements as [deployProxy, upgradeProxy]
    let multiCallArgs = await getProxyMultiCallArgs(Salt, taskArgs, hre);
    //send the multicall transaction with deployProxy and upgradeProxy
    let receipt = await iFactory.multiCall(multiCallArgs);
    //Data to return to the main task 
    let proxyData:ProxyData = {
      logicName: taskArgs.contractName,
      logicAddress: taskArgs.logicAddress,
      salt: Salt,
      proxyAddress: await getEventVar(receipt, deployedProxyKey, contractAddrKey)
    };
    return proxyData;
  });

async function writeFactoryConfigJSON(name:string, address:string){
  
  let factoryConfigObj:{[name:string]:any} = {}
  
  factoryConfigObj.defaultFactoryData = {
    name: name,
    address: address
  };
  
  
  let jsonString = JSON.stringify(factoryConfigObj);
  console.log(jsonString)
  fs.writeFileSync("./factoryConfig.json", jsonString);
}

async function getJSONFactoryData(){
  let outputObj:{[name:string]:any} = {}
  let rawData = fs.readFileSync("./factoryConfig.json");
  const output = await JSON.parse(rawData.toString("utf8"));
  outputObj = output;
  console.log(outputObj);
  return outputObj;
}

async function getFactoryData(taskArgs:any){
  //get Factory data from factoryConfig.json
  const factoryConfig = await getJSONFactoryData()
  const configFactoryData = factoryConfig.defaultFactoryData;
  let cliFactoryData:FactoryData = {
    name: taskArgs.factoryName,
    address: taskArgs.factoryAddress
  }
  //object to store data to update config var
  let factoryData = <FactoryData>{};
  //check if the user provided factory Data in call
  if(cliFactoryData.address !== undefined && cliFactoryData.name !== undefined){
    factoryData.name = cliFactoryData.name;
    factoryData.address = cliFactoryData.address;
  }
  //if the user did not provide factory data check for factory data in factoryConfig 
  else if (configFactoryData.name !== undefined && configFactoryData.address !== undefined){
    factoryData.name = configFactoryData.name; 
    factoryData.address = configFactoryData.address; 
  }
  //if no factoryData provided in call and in userConfig throw error
  else{
    throw new Error("Insufficient Factory Data: specify factory name and address in call or HardhatUserConfig.defaultFactory")
  }

  return factoryData;
}

async function getDeployUpgradeableMultiCallArgs(taskArgs:any, logicAddress:string){
  let args = <DeployProxyMCArgs>{};
  let factoryData = await getFactoryData(taskArgs);
  args.contractName = taskArgs.contractName;
  args.logicAddress = logicAddress;
  args.factoryName = factoryData.name;
  args.factoryAddress = factoryData.address;
  return args;
}
/**
 * @description function used to get the arguements for deploy proxy upgrade proxy contract multicall 
 * @param taskArgs.factoryName name of factory contract used
 * @param Salt Salt specified in the logic contract file
 * @param taskArgs.logicAddress address of the logic contract 
 * @param hre hardhat runtime environment 
 * @returns array of solidity function calls 
 */
async function getProxyMultiCallArgs(Salt:string, taskArgs:any, hre:HardhatRuntimeEnvironment){
  //get factory object from ethers for encoding function calls 
  let factoryObj = await hre.ethers.getContractFactory(taskArgs.factoryName);
  //encode the deployProxy function call with Salt as arg
  let deployProxy = factoryObj.interface.encodeFunctionData("deployProxy", [Salt]);
  //encode upgrade proxy multicall     
  let upgradeProxy = factoryObj.interface.encodeFunctionData("upgradeProxy", [Salt, taskArgs.logicAddress]);
  return [deployProxy, upgradeProxy];
}

function getDeploySubtaskArgs(factoryData: FactoryData, taskArgs: any){
  return <DeployCreateArgs>{
    contractName: taskArgs.contractName,
    factoryName: factoryData.name,
    factoryAddress: factoryData.address,
    optionalArgs: taskArgs?.constructorArgs
  };
}

function getConstructorArgCount(contract: any){
  for (let funcObj of contract.abi){
    if(funcObj.type === "constructor"){
      return funcObj.inputs.length;
    }
  }
  return 0;
}

function getAccounts(signers: Array<SignerWithAddress>){
    let accounts: string[] = [];
    for (let signer of signers){
        accounts.push(signer.address)
    }
    return accounts;
}
async function getFullyQaulifiedName(contractName: string, hre:HardhatRuntimeEnvironment) {
    
    let artifactPaths = await hre.artifacts.getAllFullyQualifiedNames();
    for (let i = 0; i < artifactPaths.length; i++){
        if (artifactPaths[i].split(":")[1] === contractName){
            return String(artifactPaths[i]);
        } 
    }
    
}

function extractPath(qualifiedName: string) {
    return qualifiedName.split(":")[0];
}

function getEventVar(receipt:any, eventName:string, varName:string){
  let result 
  for (let i = 0; i < receipt["logs"].length; i++) {
      //look for the event
      if(receipt["logs"][i]["event"] == eventName){
          //extract the deployed mock logic contract address from the event
          result = receipt["logs"][i]["args"][varName];
          //exit the loop
          break;
      }
  }
  return result;
}

async function getSalt(contractName:string, hre:HardhatRuntimeEnvironment){
    let qualifiedName:any = await getFullyQaulifiedName(contractName, hre);
    let buildInfo= await hre.artifacts.getBuildInfo(qualifiedName);
    let path = extractPath(qualifiedName)
    let salt:any = buildInfo?.output.contracts[path][contractName];
    //buildInfo.resolve()
    //wrap this in a try catch block
    //console.log("getSalt CLI :", buildInfo["output"]["contracts"][contractPath][contractName])
    //let salt:any = buildInfo["output"]["contracts"][contractPath][contractName]["devdoc"]["custom:salt"];
    return salt.devdoc["custom:salt"]
}

async function getBytes32Salt(contractName:string, hre:HardhatRuntimeEnvironment){
  return hre.ethers.utils.formatBytes32String(await getSalt(contractName, hre));
}
