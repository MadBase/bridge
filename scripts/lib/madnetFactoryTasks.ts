import {
  DEPLOYED_PROXY,
  DEPLOYED_RAW,
  CONTRACT_ADDR,
  MADNET_FACTORY,
} from "./constants";
import { task } from "hardhat/config";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import {
  DeployCreateData,
  FactoryConfig,
  FactoryData,
  MetaContractData,
  ProxyData,
  readFactoryStateData,
  TemplateData,
  updateDefaultFactoryData,
  updateDeployCreateList,
  updateMetaList,
  updateProxyList,
  updateTemplateList,
} from "./factoryStateUtils";
import { ContractFactory } from "ethers";

//Should look into extending types into the hardhat type lib

type DeployProxyMCArgs = {
  contractName: string;
  logicAddress: string;
  factoryName: string;
  factoryAddress: string;
  initCallData?: string;
};

type DeployArgs = {
  contractName: any;
  factoryName: any;
  factoryAddress: any;
  initCallData?: string;
  constructorArgs?: any;
};

task("getSalt", "gets salt from contract")
  .addParam("contractName", "test contract")
  .setAction(async (taskArgs, hre) => {
    let salt = await getSalt(taskArgs.contractName, hre);
    console.log(salt);
  });

task(
  "deployFactory",
  "Deploys an instance of a factory contract specified by its name"
).setAction(async (taskArgs, hre) => {
  const factoryBase = await hre.artifacts.require(MADNET_FACTORY);
  const accounts = await getAccounts(hre);
  let txCount = await hre.ethers.provider.getTransactionCount(accounts[0]);
  //calculate the factory address for the constructor arg
  let futureFactoryAddress = hre.ethers.utils.getContractAddress({
    from: accounts[0],
    nonce: txCount,
  });
  let balance1 = await hre.ethers.provider.getBalance(accounts[0]);
  //deploys the factory
  let factory = await factoryBase.new(futureFactoryAddress);
  let balance2 = await hre.ethers.provider.getBalance(accounts[0]);
  let MadnetFacContractFactory = await hre.ethers.getContractFactory(
    MADNET_FACTORY
  );
  let deployTX =
    MadnetFacContractFactory.getDeployTransaction(futureFactoryAddress);
  let gasCost = await hre.ethers.provider.estimateGas(deployTX);
  //record the data in a json file to be used in other tasks
  let factoryData: FactoryData = {
    name: MADNET_FACTORY,
    address: factory.address,
    gas: gasCost.toNumber(),
  };
  await updateDefaultFactoryData(factoryData);
  // console.log("Deployed:", MADNET_FACTORY, "at address:", factory.address);
  return factory.address;
});

task(
  "deployUpgradeableProxy",
  "deploys logic contract, proxy contract, and points the proxy to the logic contract"
)
  .addParam(
    "contractName",
    "Name of logic contract to point the proxy at",
    "string"
  )
  .addOptionalParam(
    "factoryAddress",
    "address of the factory deploying the contract"
  )
  .addOptionalParam(
    "initCallData",
    "initialization call data for initializable contracts"
  )
  .addOptionalVariadicPositionalParam(
    "constructorArgs",
    "array that holds all arguements for constructor"
  )
  .setAction(async (taskArgs, hre) => {
    //uses the factory Data and logic contractName and returns deploybytecode and any constructor args attached
    let callArgs: DeployArgs = await getDeployCreateArgs(taskArgs);
    //deploy create the logic contract
    let result: DeployCreateData = await hre.run("deployCreate", callArgs);
    let mcCallArgs: DeployProxyMCArgs =
      await getMultiCallDeployProxySubtaskArgs(taskArgs, result.address);
    let proxyData = await hre.run("multiCallDeployProxy", mcCallArgs);
    // console.log("deployed Proxy at: ", proxyData)
    return proxyData;
  });

task(
  "deployMetamorphic",
  "deploys template contract, and then deploys metamorphic contract, and points the proxy to the logic contract"
)
  .addParam(
    "contractName",
    "Name of logic contract to point the proxy at",
    "string"
  )
  .addOptionalParam(
    "factoryName",
    "Name of the factory contract to deploy contract with"
  )
  .addOptionalParam(
    "factoryAddress",
    "address of the factory deploying the contract"
  )
  .addOptionalParam(
    "initCallData",
    "call data used to initialize initializable contracts"
  )
  .addOptionalVariadicPositionalParam(
    "constructorArgs",
    "array that holds all arguements for constructor"
  )
  .setAction(async (taskArgs, hre) => {
    let factoryData = await getFactoryData(taskArgs);
    //uses the factory Data and logic contractName and returns deploybytecode and any constructor args attached
    let callArgs: DeployArgs = await getDeployTemplateArgs(taskArgs);
    //deploy create the logic contract
    let templateAddress = await hre.run("deployTemplate", callArgs);
    callArgs = await getDeployStaticSubtaskArgs(taskArgs);
    let metaContractData = await hre.run("deployStatic", callArgs);
    // console.log("deployed Metamorphic at: ", metaContractData.metaAddress, "with logic from,", metaContractData.templateAddress);
    return metaContractData;
  });

//factoryName param doesnt do anything right now
task("deployCreate", "deploys a contract from the factory using create")
  .addParam("contractName", "logic contract name")
  .addParam("factoryName", "Name of the factory contract")
  .addParam("factoryAddress", "factory deploying the contract")
  .addOptionalVariadicPositionalParam(
    "constructorArgs",
    "array that holds all arguements for constructor"
  )
  .setAction(async (taskArgs, hre) => {
    let factoryData = await getFactoryData(taskArgs);
    let MadnetFactory = await hre.artifacts.require("MadnetFactory");
    //get logic contract interface

    let logicContract: ContractFactory = await hre.ethers.getContractFactory(
      taskArgs.contractName
    );
    //encode deployBcode
    let deployTx = logicContract.getDeployTransaction(
      ...taskArgs.constructorArgs
    );
    let deployBytecode = deployTx.data;
    //get a factory instance connected to the factory addr
    const factory = await MadnetFactory.at(factoryData.address);
    // console.log(taskArgs.contractName)
    let txResponse = await factory.deployCreate(deployBytecode);
    let deployCreateData: DeployCreateData = {
      name: taskArgs.contractName,
      address: await getEventVar(txResponse, DEPLOYED_RAW, CONTRACT_ADDR),
      factoryAddress: factoryData.address,
      gas: txResponse["receipt"]["gasUsed"],
      constructorArgs: taskArgs?.constructorArgs,
    };
    await updateDeployCreateList(deployCreateData);
    console.log(
      "Subtask deployCreate ",
      taskArgs.contractName,
      " contract at ",
      deployCreateData.address,
      "gas: ",
      txResponse["receipt"]["gasUsed"]
    );
    return deployCreateData;
  });

task("upgradeDeployedProxy", "deploys a contract from the factory using create")
  .addParam("contractName", "logic contract name")
  .addParam("factoryName", "Name of the factory contract")
  .addParam("factoryAddress", "factory deploying the contract")
  .addParam(
    "logicAddress",
    "address of the new logic contract to upgrade the proxy to"
  )
  .addParam("initCallData", "data used to initialize initializable contracts")
  .setAction(async (taskArgs, hre) => {
    let factoryData = await getFactoryData(taskArgs);
    let MadnetFactory = await hre.artifacts.require("MadnetFactory");
    //grab the salt from the logic contract
    let Salt = await getBytes32Salt(taskArgs.contractName, hre);
    //get logic contract interface
    let lcInstance = hre.artifacts.require(taskArgs.contractName);
    let logicContract: any = await hre.ethers.getContractFactory(
      taskArgs.contractName
    );
    const factory = await MadnetFactory.at(factoryData.address);
    let txResponse = await factory.upgradeProxy(
      Salt,
      taskArgs.logicAddress,
      taskArgs.initCallData
    );
    //Data to return to the main task
    let proxyData: ProxyData = {
      proxyAddress: getMetamorphicAddress(factoryData.address, Salt, hre),
      salt: Salt,
      logicName: taskArgs.contractName,
      logicAddress: taskArgs.logicAddress,
      factoryAddress: taskArgs.factoryAddress,
      gas: txResponse["receipt"]["gasUsed"],
      initCallData: taskArgs?.initCallData,
    };
    console.log(
      "Subtask upgradeDeployedProxy ",
      taskArgs.contractName,
      " contract at ",
      proxyData.proxyAddress,
      "gas: ",
      txResponse["receipt"]["gasUsed"]
    );
    await updateProxyList(proxyData);
    return proxyData;
  });

task(
  "deployTemplate",
  "deploys a template contract with the universal code copy constructor that deploys"
)
  .addParam("contractName", "logic contract name")
  .addParam("factoryName", "Name of the factory contract")
  .addParam("factoryAddress", "factory deploying the contract")
  .addOptionalVariadicPositionalParam(
    "constructorArgs",
    "array that holds all arguements for constructor"
  )
  .setAction(async (taskArgs, hre) => {
    let factoryData = await getFactoryData(taskArgs);
    let MadnetFactory = await hre.artifacts.require(factoryData.name);
    let logicContract = await hre.ethers.getContractFactory(
      taskArgs.contractName
    );
    let deployTxReq;
    if (taskArgs.constructorArgs !== undefined) {
      //encode deployBcode
      deployTxReq = logicContract.getDeployTransaction(
        taskArgs.constructorArgs
      );
    } else {
      deployTxReq = logicContract.getDeployTransaction();
    }
    let deployBytecode = deployTxReq.data;
    //get a factory instance connected to the factory addr
    const factory = await MadnetFactory.at(factoryData.address);
    let txResponse = await factory.deployTemplate(deployBytecode);

    let templateData: TemplateData = {
      name: taskArgs.contractName,
      address: await getEventVar(txResponse, "DeployedTemplate", CONTRACT_ADDR),
      factoryAddress: factoryData.address,
      gas: txResponse["receipt"]["gasUsed"],
    };
    if (taskArgs.constructorArgs !== undefined) {
      templateData.constructorArgs = taskArgs.constructorArgs;
    }
    // console.log("Subtask deployeTemplate ", taskArgs.contractName, " contract at ", templateData.address, "gas: ", txResponse["receipt"]["gasUsed"]);
    updateTemplateList(templateData);
    return templateData;
  });

//takes in optional
task(
  "deployStatic",
  "deploys a template contract with the universal code copy constructor that deploys"
)
  .addParam("contractName", "logic contract name")
  .addParam("factoryName", "Name of the factory contract")
  .addParam("factoryAddress", "factory deploying the contract")
  .addParam(
    "initCallData",
    "call data used to initialize initializable contracts"
  )
  .setAction(async (taskArgs, hre) => {
    let factoryData = await getFactoryData(taskArgs);
    let MadnetFactory = await hre.artifacts.require(factoryData.name);
    let Salt = await getBytes32Salt(taskArgs.contractName, hre);
    //get a factory instance connected to the factory addr
    const factory = await MadnetFactory.at(factoryData.address);
    let txResponse = await factory.deployStatic(Salt, taskArgs.initCallData);
    let contractAddr = await getEventVar(
      txResponse,
      "DeployedStatic",
      CONTRACT_ADDR
    );
    // console.log("Subtask deployStatic ", taskArgs.contractName, " contract at ", contractAddr, "gas: ", txResponse["receipt"]["gasUsed"]);
    let tmplAddress = await factory.getImplementation.call();
    let outputData: MetaContractData = {
      metaAddress: contractAddr,
      salt: Salt,
      templateName: taskArgs.contractName,
      templateAddress: tmplAddress,
      factoryAddress: factory.address,
      gas: txResponse["receipt"]["gasUsed"],
      initCallData: taskArgs.initCallData,
    };
    await updateMetaList(outputData);
    return contractAddr;
  });

/**
 * deploys a proxy and upgrades it using multicall from factory
 * @returns a proxyData object with logic contract name, address and proxy salt, and address.
 */
task("multiCallDeployProxy", "deploy and upgrade proxy with multicall")
  .addParam(
    "logicAddress",
    "Address of the logic contract to point the proxy to"
  )
  .addParam("contractName", "logic contract name")
  .addParam("factoryName", "Name of the factory contract")
  .addParam("factoryAddress", "factory deploying the contract")
  .addParam(
    "initCallData",
    "call data used to initialize initializable contracts"
  )
  .setAction(async (taskArgs, hre) => {
    let gas = 0;
    let factoryData = await getFactoryData(taskArgs);
    //get factory contract artifact object, a truffle contract object
    let MadnetFactory = await hre.artifacts.require(factoryData.name);
    //factory interface pointed to deployed factory contract
    let factory = await MadnetFactory.at(factoryData.address);
    //get the 32byte salt from logic contract file
    let Salt = await getBytes32Salt(taskArgs.contractName, hre);
    //get the multi call arguements as [deployProxy, upgradeProxy]
    let multiCallArgs = await getProxyMultiCallArgs(Salt, taskArgs, hre);
    //send the multicall transaction with deployProxy and upgradeProxy
    let MF: ContractFactory = await hre.ethers.getContractFactory(
      "MadnetFactory"
    );
    let txResponse = await factory.multiCall(multiCallArgs);
    //Data to return to the main task
    let proxyData: ProxyData = {
      factoryAddress: factoryData.address,
      logicName: taskArgs.contractName,
      logicAddress: taskArgs.logicAddress,
      salt: Salt,
      proxyAddress: await getEventVar(
        txResponse,
        DEPLOYED_PROXY,
        CONTRACT_ADDR
      ),
      gas: txResponse["receipt"]["gasUsed"],
      initCallData: taskArgs.initCallData,
    };
    // console.log("Subtask multiCallDeployProxy: ", proxyData.logicName, "with proxy at:", proxyData.proxyAddress, "and logic at:", proxyData.logicAddress, "gas: ", txResponse["receipt"]["gasUsed"]);
    updateProxyList(proxyData);
    return proxyData;
  });

async function getFactoryData(taskArgs: any) {
  //get Factory data from factoryConfig.json
  const factoryConfig = (await readFactoryStateData()) as FactoryConfig;
  const configFactoryData = factoryConfig.defaultFactoryData;
  let cliFactoryData: FactoryData = {
    name: taskArgs.factoryName,
    address: taskArgs.factoryAddress,
  };
  //object to store data to update config var
  let factoryData = <FactoryData>{};
  //check if the user provided factory Data in call
  if (
    cliFactoryData.address !== undefined &&
    cliFactoryData.name !== undefined
  ) {
    factoryData.name = cliFactoryData.name;
    factoryData.address = cliFactoryData.address;
  }
  //if the user did not provide factory data check for factory data in factoryConfig
  else if (
    configFactoryData.name !== undefined &&
    configFactoryData.address !== undefined
  ) {
    factoryData.name = configFactoryData.name;
    factoryData.address = configFactoryData.address;
  }
  //if no factoryData provided in call and in userConfig throw error
  else {
    throw new Error(
      "Insufficient Factory Data: specify factory name and address in call or HardhatUserConfig.defaultFactory"
    );
  }

  return factoryData;
}

async function getMultiCallDeployProxySubtaskArgs(
  taskArgs: any,
  logicAddress: string
) {
  let initCallData = "0x";
  if (taskArgs.initCallData !== undefined) {
    initCallData = taskArgs.initCallData;
  }
  let factoryData = await getFactoryData(taskArgs);
  let args: DeployProxyMCArgs = {
    contractName: taskArgs.contractName,
    logicAddress: logicAddress,
    factoryName: factoryData.name,
    factoryAddress: factoryData.address,
    initCallData: initCallData,
  };
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
async function getProxyMultiCallArgs(
  Salt: string,
  taskArgs: any,
  hre: HardhatRuntimeEnvironment
) {
  //get factory object from ethers for encoding function calls
  let factoryContractFactory = await hre.ethers.getContractFactory(
    taskArgs.factoryName
  );
  let initCallData: string = "0x";
  if (taskArgs.initCallData !== undefined) {
    initCallData = taskArgs.initCallData;
  }
  //encode the deployProxy function call with Salt as arg
  let deployProxy = factoryContractFactory.interface.encodeFunctionData(
    "deployProxy",
    [Salt]
  );
  //encode upgrade proxy multicall
  let upgradeProxy = factoryContractFactory.interface.encodeFunctionData(
    "upgradeProxy",
    [Salt, taskArgs.logicAddress, initCallData]
  );
  return [deployProxy, upgradeProxy];
}

0x39cab472536e617073686f74730000000000000000000000000000000000000000000000;

/**
 * @description parses config and task args for deployTemplate subtask call args
 * @param taskArgs arguements provided to the task
 * @returns object with call data for deployTemplate subtask
 */
async function getDeployTemplateArgs(taskArgs: any) {
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
async function getDeployStaticSubtaskArgs(taskArgs: any) {
  let factoryData = await getFactoryData(taskArgs);
  let initCallData: string = "0x";
  if (taskArgs.initCallData !== undefined) {
    initCallData = taskArgs.initCallData;
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
async function getDeployCreateArgs(taskArgs: any) {
  let factoryData = await getFactoryData(taskArgs);
  return <DeployArgs>{
    contractName: taskArgs.contractName,
    factoryName: factoryData.name,
    factoryAddress: factoryData.address,
    constructorArgs: taskArgs.constructorArgs,
  };
}

function getConstructorArgCount(contract: any) {
  for (let funcObj of contract.abi) {
    if (funcObj.type === "constructor") {
      return funcObj.inputs.length;
    }
  }
  return 0;
}

async function getAccounts(hre: HardhatRuntimeEnvironment) {
  let signers = await hre.ethers.getSigners();
  let accounts: string[] = [];
  for (let signer of signers) {
    accounts.push(signer.address);
  }
  return accounts;
}

async function getFullyQaulifiedName(
  contractName: string,
  hre: HardhatRuntimeEnvironment
) {
  let artifactPaths = await hre.artifacts.getAllFullyQualifiedNames();
  for (let i = 0; i < artifactPaths.length; i++) {
    if (artifactPaths[i].split(":")[1] === contractName) {
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
function getEventVar(receipt: any, eventName: string, varName: string) {
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
/**
 * @description extracts the value specified by custom:salt from the contracts artifacts
 * buildInfo
 * @param contractName the name of the contract to get the salt for
 * @param hre hardhat runtime environment
 * @returns the string version of salt specified by custom:salt
 *  NatSpec tag in the contract
 */
async function getSalt(
  contractName: string,
  hre: HardhatRuntimeEnvironment
): Promise<string> {
  let qualifiedName: any = await getFullyQaulifiedName(contractName, hre);
  let buildInfo = await hre.artifacts.getBuildInfo(qualifiedName);
  let contractOutput: any;
  let devdoc: any;
  let salt: string = "";
  if (buildInfo !== undefined) {
    let path = extractPath(qualifiedName);
    contractOutput = buildInfo.output.contracts[path][contractName];
    devdoc = contractOutput.devdoc;
    salt = devdoc["custom:salt"];
    return salt;
  } else {
    console.error("missing salt");
  }
  return salt;
}

/**
 * @description converts
 * @param contractName the name of the contract to get the salt for
 * @param hre hardhat runtime environment
 * @returns the string that represents the 32Bytes version
 * of the salt specified by custom:salt
 */
export async function getBytes32Salt(
  contractName: string,
  hre: HardhatRuntimeEnvironment
) {
  let salt: string = await getSalt(contractName, hre);
  return hre.ethers.utils.formatBytes32String(salt);
}

/**
 *
 * @param factoryAddress address of the factory that deployed the contract
 * @param salt value specified by custom:salt in the contrac
 * @param hre hardhat runtime environment
 * @returns returns the address of the metamorphic contract
 */
function getMetamorphicAddress(
  factoryAddress: string,
  salt: string,
  hre: HardhatRuntimeEnvironment
) {
  let initCode = "0x6020363636335afa1536363636515af43d36363e3d36f3";
  return hre.ethers.utils.getCreate2Address(
    factoryAddress,
    salt,
    hre.ethers.utils.keccak256(initCode)
  );
}
