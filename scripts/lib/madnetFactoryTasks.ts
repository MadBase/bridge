
import { 
  defaultFactoryName,
  deployedProxyKey,
  deployedRawKey,
  contractAddrKey,
} from "./constants";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { subtask, task } from "hardhat/config";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import TransactionRequest from "@nomiclabs/hardhat-ethers"
import {
  DeployCreateData,
  FactoryConfig, FactoryData, MetaContractData, ProxyData, readFactoryStateData, TemplateData, updateDefaultFactoryData, updateDeployCreateList, updateMetaList, updateProxyList, updateTemplateList
} from "./factoryStateUtils";
import { ContractFactory } from "ethers";


//Should look into extending types into the hardhat type lib

type DeployProxyMCArgs = {
  contractName: string;
  logicAddress: string;
  factoryName: string;
  factoryAddress: string;
  initCallData?: string;
}

type DeployArgs = {
  contractName: any;
  factoryName: any;
  factoryAddress: any;
  initCallData?:  string;
  constructorArgs?: any;
}


let defaultFactoryAddress:string;

task("getSalt", "gets salt from contract")
  .addParam("contractName", "test contract")
  .setAction(async (taskArgs, hre) => {
    let salt = await getSalt(taskArgs.contractName, hre)
    console.log(salt)
  });

task("deployFactory", "Deploys an instance of a factory contract specified by its name")
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
        //record the data in a json file to be used in other tasks 
        await updateDefaultFactoryData(defaultFactoryName, defaultFactoryAddress);
        console.log("Deployed:", factoryName, "at address:", factory.address);
        return factory.address;
      } catch (error) {
        console.log(error);
      }
  });

task("deployUpgradeableProxy", "deploys logic contract, proxy contract, and points the proxy to the logic contract")
  .addParam("contractName", "Name of logic contract to point the proxy at", "string")
  .addOptionalParam("factoryAddress", "address of the factory deploying the contract")
  .addOptionalParam("initCallData", "initialization call data for initializable contracts")
  .addOptionalVariadicPositionalParam("constructorArgs", "array that holds all arguements for constructor")
  .setAction(async (taskArgs, hre) => {
    let factoryData = await getFactoryData(taskArgs);
    //uses the factory Data and logic contractName and returns deploybytecode and any constructor args attached       
    let callArgs:DeployArgs = await getDeployCreateArgs(taskArgs);
    //deploy create the logic contract 
    let result:DeployCreateData = await hre.run("deployCreate", callArgs);
    console.log("deployUpgradeableProxy logicAddress: ", result.address);
    let mcCallArgs:DeployProxyMCArgs = await getMultiCallDeployProxySubtaskArgs(taskArgs, result.address);
    let proxyData = await hre.run("multiCallDeployProxy", mcCallArgs);
    console.log("deployed Proxy at: ", proxyData)
    return proxyData;
  });

task("deployMetamorphic", "deploys template contract, and then deploys metamorphic contract, and points the proxy to the logic contract")
  .addParam("contractName", "Name of logic contract to point the proxy at", "string")
  .addOptionalParam("factoryName", "Name of the factory contract to deploy contract with")
  .addOptionalParam("factoryAddress", "address of the factory deploying the contract")
  .addOptionalParam("initCallData", "call data used to initialize initializable contracts")
  .addOptionalVariadicPositionalParam("constructorArgs", "array that holds all arguements for constructor")
  .setAction(async (taskArgs, hre) => {
    let metaContractData = <MetaContractData>{};
    let factoryData = await getFactoryData(taskArgs);
    metaContractData.factoryAddress = factoryData.address;
    //uses the factory Data and logic contractName and returns deploybytecode and any constructor args attached       
    let callArgs:DeployArgs = await getDeployTemplateArgs(taskArgs);
    //deploy create the logic contract
    metaContractData.templateName = taskArgs.contractName; 
    metaContractData.templateAddress = await hre.run("deployTemplate", callArgs);
    console.log("Deploy Static logicAddress:", metaContractData.templateAddress);
    callArgs = await getDeployStaticSubtaskArgs(taskArgs);
    metaContractData.metaAddress = await hre.run("deployStatic", callArgs);
    console.log("deployed Metamorphic at: ", metaContractData.metaAddress, "with logic from,", metaContractData.templateAddress);
    await updateMetaList(metaContractData);
    return metaContractData;
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
    //get logic contract interface
    let deployCreateData = <DeployCreateData>{};
    deployCreateData.name = taskArgs.contractName;
    deployCreateData.constructorArgs = taskArgs?.constructorArgs;
    deployCreateData.factoryAddress = factoryData.address;
    let logicContract:ContractFactory = await hre.ethers.getContractFactory(taskArgs.contractName);
    //encode deployBcode 
    console.log("deploy Create constructor args:", taskArgs.constructorArgs)
    let deployTx = logicContract.getDeployTransaction(...taskArgs.constructorArgs)
    let deployBytecode = deployTx.data
    //get a factory instance connected to the factory addr
    const factory = await MadnetFactory.at(factoryData.address);
    let receipt = await factory.deployCreate(deployBytecode);
    deployCreateData.address = await getEventVar(receipt, deployedRawKey, contractAddrKey);
    await updateDeployCreateList(deployCreateData);
    console.log("Deployed ", taskArgs.contractName, " contract at ", deployCreateData.address);
    return deployCreateData;
  });

subtask("upgradeDeployedProxy", "deploys a contract from the factory using create")
  .addParam("contractName", "logic contract name")
  .addParam("factoryName", "Name of the factory contract")
  .addParam("factoryAddress", "factory deploying the contract")
  .addParam("logicAddress", "address of the new logic contract to upgrade the proxy to")
  .addParam("initCallData", "data used to initialize initializable contracts")
  .setAction(async (taskArgs, hre) => {
    let factoryData = await getFactoryData(taskArgs);
    let MadnetFactory = await hre.artifacts.require("MadnetFactory");
    //grab the salt from the logic contract
    let Salt = await getBytes32Salt(taskArgs.contractName, hre)
    //get logic contract interface
    let lcInstance = hre.artifacts.require(taskArgs.contractName);
    let logicContract:any = await hre.ethers.getContractFactory(taskArgs.contractName);
    const factory = await MadnetFactory.at(factoryData.address);
    let receipt = await factory.upgradeProxy(Salt, taskArgs.newLogicAddress, taskArgs.initCallData); 
    //Data to return to the main task 
    let proxyData:ProxyData = {
      proxyAddress: getMetamorphicAddress(factoryData.address, Salt, hre),
      salt: Salt,
      logicName: taskArgs.contractName,
      logicAddress: taskArgs.logicAddress,
      factoryAddress: taskArgs.factoryAddress,
      initCallData: taskArgs?.initCallData,
    };
    await updateProxyList(proxyData);
    return proxyData;
  });

subtask("deployTemplate", "deploys a template contract with the universal code copy constructor that deploys")
  .addParam("contractName", "logic contract name")
  .addParam("factoryName", "Name of the factory contract")
  .addParam("factoryAddress", "factory deploying the contract")
  .addOptionalVariadicPositionalParam("constructorArgs", "array that holds all arguements for constructor")
  .setAction(async (taskArgs, hre) => {
    let templateData= <TemplateData>{name: taskArgs.contractName};
    let factoryData = await getFactoryData(taskArgs);
    console.log(factoryData)
    templateData.factoryAddress = factoryData.address;
    let MadnetFactory = await hre.artifacts.require(factoryData.name);
    let logicContract = await hre.ethers.getContractFactory(templateData.name);
    let deployTxReq
    if(taskArgs.constructorArgs !== undefined){
      //encode deployBcode 
      deployTxReq = logicContract.getDeployTransaction(taskArgs.constructorArgs);
    }else{
      deployTxReq = logicContract.getDeployTransaction();
    }
    let deployBytecode = deployTxReq.data;
    //get a factory instance connected to the factory addr
    const factory = await MadnetFactory.at(factoryData.address);
    let receipt = await factory.deployTemplate(deployBytecode);
    templateData.address = await getEventVar(receipt, "DeployedTemplate", contractAddrKey);
    if(taskArgs.constructorArgs !== undefined){
      templateData.constructorArgs = taskArgs.constructorArgs; 
    }
    console.log("Deployed ", taskArgs.contractName, " contract at ", templateData.address);
    updateTemplateList(templateData);
    return templateData;
  });

//takes in optional 
subtask("deployStatic", "deploys a template contract with the universal code copy constructor that deploys")
  .addParam("contractName", "logic contract name")
  .addParam("factoryName", "Name of the factory contract")
  .addParam("factoryAddress", "factory deploying the contract")
  .addParam("initCallData", "call data used to initialize initializable contracts")
  .setAction(async (taskArgs, hre) => {
    let factoryData = await getFactoryData(taskArgs);
    let MadnetFactory = await hre.artifacts.require(factoryData.name);
    let Salt = await getBytes32Salt(taskArgs.contractName, hre);
    console.log("INITCALLDATA", taskArgs.initCallData)
    //get a factory instance connected to the factory addr
    const factory = await MadnetFactory.at(factoryData.address);
    
    let receipt = await factory.deployStatic(Salt, taskArgs.initCallData);
    console.log("SALT:", Salt)
    let contractAddr = await getEventVar(receipt, "DeployedStatic", contractAddrKey);
    console.log("Deployed ", taskArgs.contractName, " contract at ", contractAddr);
    let tmplAddress = await factory.getImplementation.call();
    let outputData:MetaContractData = {
      metaAddress: contractAddr,
      salt: Salt,
      templateName: taskArgs.contractName,
      templateAddress: tmplAddress,
      factoryAddress: factory.address,
      initCallData: taskArgs.initCallData
    }
    await updateMetaList(outputData)
    return contractAddr;
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
  .addParam("initCallData", "call data used to initialize initializable contracts")
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
      factoryAddress: factoryAddr,
      logicName: taskArgs.contractName,
      logicAddress: taskArgs.logicAddress,
      salt: Salt,
      proxyAddress: await getEventVar(receipt, deployedProxyKey, contractAddrKey),
      initCallData: taskArgs.initCallData
    };
    updateProxyList(proxyData);
    return proxyData;
  });

async function getFactoryData(taskArgs:any){
  //get Factory data from factoryConfig.json
  const factoryConfig = await readFactoryStateData() as FactoryConfig;
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

async function getMultiCallDeployProxySubtaskArgs(taskArgs:any, logicAddress:string){
  let args = <DeployProxyMCArgs>{};
  let factoryData = await getFactoryData(taskArgs);
  args.contractName = taskArgs.contractName;
  args.logicAddress = logicAddress;
  args.factoryName = factoryData.name;
  args.factoryAddress = factoryData.address;
  args.initCallData = taskArgs?.initCallData;
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
  let factoryContractFactory = await hre.ethers.getContractFactory(taskArgs.factoryName);
  let initCallData:string = "0x"
  if(taskArgs.initCallData !== undefined){
    initCallData = taskArgs.initCallData;
  }
  //encode the deployProxy function call with Salt as arg
  let deployProxy = factoryContractFactory.interface.encodeFunctionData("deployProxy", [Salt]);
  //encode upgrade proxy multicall     
  let upgradeProxy = factoryContractFactory.interface.encodeFunctionData("upgradeProxy", [Salt, taskArgs.logicAddress, initCallData]);
  return [deployProxy, upgradeProxy];
}



/**
 * @description parses config and task args for deployTemplate subtask call args 
 * @param taskArgs arguements provided to the task 
 * @returns object with call data for deployTemplate subtask 
 */
async function getDeployTemplateArgs(taskArgs: any){
  let factoryData = await getFactoryData(taskArgs);
  return <DeployArgs>{
    contractName: taskArgs.contractName,
    factoryName: factoryData.name,
    factoryAddress: factoryData.address,
    constructorArgs: taskArgs?.constructorArgs,
  };
}

/**
 * @description parses config and task args for deployStatic subtask call args 
 * @param taskArgs arguements provided to the task 
 * @returns object with call data for deployStatic subtask 
 */
async function getDeployStaticSubtaskArgs(taskArgs: any){
  let factoryData = await getFactoryData(taskArgs);
  let initCallData:string = "0x"
  console.log("getDeployStaticSubtaskArgs task.initCallData:", taskArgs.initCallData);
  if(taskArgs.initCallData !== undefined){
    initCallData = taskArgs.initCallData;
    console.log("initCallData:", initCallData)
  }
  return <DeployArgs>{
    contractName: taskArgs.contractName,
    factoryName: factoryData.name,
    factoryAddress: factoryData.address,
    initCallData: initCallData,
  };
}
/**
 * @description parses config and task args for deploycreate subtask call args 
 * @param taskArgs arguements provided to the task 
 * @returns call data for deployCreate subtask 
 */
async function getDeployCreateArgs(taskArgs: any){
  let factoryData = await getFactoryData(taskArgs);
  return <DeployArgs>{
    contractName: taskArgs.contractName,
    factoryName: factoryData.name,
    factoryAddress: factoryData.address,
    constructorArgs: taskArgs?.constructorArgs
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
/**
 * @description returns everything on the left side of the :
 * ie: src/proxy/Proxy.sol:Mock => src/proxy/Proxy.sol 
 * @param qualifiedName the relative path of the contract file + ":" + name of contract
 * @returns the relative path of the contract
 */
function extractPath(qualifiedName: string) {
  return qualifiedName.split(":")[0];
}

/**
 * @description goes through the receipt from the 
 * transaction and extract the specified event name and variable
 * @param receipt tx object returned from the tran
 * @param eventName 
 * @param varName 
 * @returns 
 */
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
/**
 * @description extracts the value specified by custom:salt from the contracts artifacts
 * buildInfo
 * @param contractName the name of the contract to get the salt for 
 * @param hre hardhat runtime environment
 * @returns the string version of salt specified by custom:salt 
 *  NatSpec tag in the contract
 */
async function getSalt(contractName:string, hre:HardhatRuntimeEnvironment){
    let qualifiedName:any = await getFullyQaulifiedName(contractName, hre);
    let buildInfo= await hre.artifacts.getBuildInfo(qualifiedName);
    let path = extractPath(qualifiedName)
    let salt:any = buildInfo?.output.contracts[path][contractName];
    return salt.devdoc["custom:salt"]
}

/**
 * @description converts 
 * @param contractName the name of the contract to get the salt for 
 * @param hre hardhat runtime environment
 * @returns the string that represents the 32Bytes version 
 * of the salt specified by custom:salt 
 */
async function getBytes32Salt(contractName:string, hre:HardhatRuntimeEnvironment){
  return hre.ethers.utils.formatBytes32String(await getSalt(contractName, hre));
}

/**
 * 
 * @param factoryAddress address of the factory that deployed the contract
 * @param salt value specified by custom:salt in the contrac
 * @param hre hardhat runtime environment
 * @returns returns the address of the metamorphic contract 
 */
function getMetamorphicAddress(factoryAddress:string, salt:string, hre:HardhatRuntimeEnvironment){
  let initCode = "0x6020363636335afa1536363636515af43d36363e3d36f3";
  return hre.ethers.utils.getCreate2Address(factoryAddress, salt, hre.ethers.utils.keccak256(initCode));
}