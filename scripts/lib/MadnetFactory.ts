//separate deploy of template from deploy of deterministic address

//import { string } from "hardhat/internal/core/params/argumentTypes";

//assume you have to divide the transaction
//estimate gas, observe gas limit,

//return all addresses

//return the logs
import { BytesLike } from "ethers";
import {artifacts, ethers} from "hardhat";
import { MadnetFactory } from "../../typechain-types";
import { CONTRACT_ADDR, DEPLOYED_RAW } from "./constants";
const defaultFactoryName = "MadnetFactory";
const DeployedRawEvent = "DeployedRaw";
const contractAddrVar = "contractAddr";
const DeployedProxyEvent = "DeployedProxy";
const logicAddrKey = "LogicAddress";
const ProxyAddrKey = "ProxyAddress"
const deployedStaticEvent = "DeployedStatic";
const deployedTemplateEvent ="DeployedTemplate";
const MetaAddrKey = "MetaAddress"
const templateAddrKey = "TemplateAddress"


export async function deployUpgradeable(contractName:string, factoryAddress:string, constructorArgs:Array<string>){
    let MadnetFactory = await artifacts.require(defaultFactoryName);
    let factory = await MadnetFactory.at(factoryAddress);
    let deployCreateArgs = await getDeployCreateArgs(contractName, constructorArgs);
    //deploy the bytecode using the factory
    let txResponse = await factory.deployCreate(...deployCreateArgs);
    let proxySalt = await getSalt(contractName);
    let res = <{
        logicAddress: string,
        proxyAddress: string,
        proxySalt: string
    }>{
        logicAddress: await getEventVar(txResponse, DEPLOYED_RAW, CONTRACT_ADDR),
        proxySalt: proxySalt
    };
    if (proxySalt !== undefined){

        //multicall deployProxy. upgradeProxy
        let multiCallArgs = await getDeployUpgradeableMultiCallArgs(defaultFactoryName, res.proxySalt, res.logicAddress)
        txResponse = await factory.multiCall(...multiCallArgs);
        res.proxyAddress = await getEventVar(txResponse, DeployedProxyEvent, contractAddrVar);
        return res
    } else {
        console.error(`${contractName} contract missing salt`)
    }
    return res



}

export async function upgradeProxy(contractName:string, factoryAddress:string, constructorArgs?:string[]){
    let _MadnetFactory = await artifacts.require(defaultFactoryName);
    let factory = await _MadnetFactory.at(factoryAddress);
    let logicContractInterface = await ethers.getContractFactory(contractName);
    let deployBCode: BytesLike
    if (typeof constructorArgs !== "undefined" && constructorArgs.length >= 0) {
        deployBCode  = logicContractInterface.getDeployTransaction(...constructorArgs).data as BytesLike
    } else {
        deployBCode = logicContractInterface.getDeployTransaction().data as BytesLike
    }
    //instantiate the return object
    let txResponse = await factory.deployCreate(deployBCode)
    let res = {
        logicAddress: await getEventVar(txResponse, DeployedRawEvent, contractAddrVar),
        proxySalt: await getSalt(contractName)
    };
    //upgrade the proxy
    await factory.upgradeProxy(res.proxySalt as BytesLike, res.logicAddress, "0x");
    return res;
}

export async function deployStatic(contractName:string, factoryAddress:string){
    let MadnetFactory = await artifacts.require(defaultFactoryName);
    let logicContract = await artifacts.require(contractName);
    let factory: MadnetFactory = await MadnetFactory.at(factoryAddress);
    let deployBCode = logicContract.bytecode
    let receipt = await factory.deployTemplate(deployBCode);
    let templateAddress: string = await getEventVar(receipt, deployedTemplateEvent, contractAddrVar)
    let metaSalt = await getSalt(contractName)
    if (typeof metaSalt === "undefined") {
        throw "Couldn't get the salt for:" + contractName
    }
    receipt = await factory.deployStatic(metaSalt, "0x");
    let metaAddress: string = await getEventVar(receipt, deployedStaticEvent, contractAddrVar);
    return {
        templateAddress,
        metaSalt,
        metaAddress
    };
}

async function getFullyQualifiedName(contractName:string) {
    let artifactPaths = await artifacts.getAllFullyQualifiedNames();
    for (let i = 0; i < artifactPaths.length; i++){
        if (artifactPaths[i].split(":")[1] === contractName){
            return String(artifactPaths[i]);
        }
    }
    return undefined;
}

function extractPath(qualifiedName:string) {
    return qualifiedName.split(":")[0];
}

async function getDeployCreateArgs(contractName:string, constructorArgs:Array<any>, txParam?:any){
    //get an instance of the logic contract interface
    let contractInterface = await ethers.getContractFactory(contractName);
    //get the deployment bytecode from the interface
    let deployBCode = await contractInterface.getDeployTransaction(...constructorArgs);
    let deployCreateArgs;
    if(txParam === undefined){
        deployCreateArgs = [deployBCode.data];
    } else{
        deployCreateArgs = [deployBCode.data, txParam];
    }
    return deployCreateArgs;
}

async function getDeployUpgradeableMultiCallArgs(factoryName:string, Salt:string, logicAddress:string, initCallData?:string, txParam?:object){
    let MNFactory = await ethers.getContractFactory(factoryName);
    let deployProxy = await MNFactory.interface.encodeFunctionData("deployProxy", [Salt]);
    let upgradeProxy
    if (initCallData !== undefined){
        upgradeProxy = await MNFactory.interface.encodeFunctionData("upgradeProxy", [Salt, logicAddress, initCallData]);
    }else{
        upgradeProxy = await MNFactory.interface.encodeFunctionData("upgradeProxy", [Salt, logicAddress, "0x"]);
    }

    let res;
    if(txParam === undefined){
        res = [[deployProxy, upgradeProxy]];
    } else{
        res = [[deployProxy, upgradeProxy], txParam];
    }
    return res;
}

async function getSalt(contractName:string){
    let qualifiedName:any = await getFullyQualifiedName(contractName);
    let buildInfo= await artifacts.getBuildInfo(qualifiedName);
    let contractOutput:any
    let devdoc:any
    let salt
    if (buildInfo !== undefined){
      let path = extractPath(qualifiedName)
      contractOutput = buildInfo?.output.contracts[path][contractName];
      devdoc = contractOutput.devdoc;
      salt = devdoc["custom:salt"]
      if (salt !== undefined && salt !==""){
        return ethers.utils.formatBytes32String(salt);
      }

    }else{
        console.error("Missing custom:salt");
    }
}

async function getDeployTypeWithContractName(contractName:string){
    let qualifiedName:any = await getFullyQualifiedName(contractName);
    let buildInfo= await artifacts.getBuildInfo(qualifiedName);
    let deployType:any
    if (buildInfo !== undefined){
      let path = extractPath(qualifiedName)
      deployType = buildInfo?.output.contracts[path][contractName];
    }
    return deployType.devdoc["custom:deploy-type"]
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

module.exports = {deployUpgradeable, upgradeProxy, deployStatic};