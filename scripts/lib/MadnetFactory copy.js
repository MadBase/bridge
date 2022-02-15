//separate deploy of template from deploy of deterministic address 

//import { string } from "hardhat/internal/core/params/argumentTypes";

//assume you have to divide the transaction 
//estimate gas, observe gas limit, 

//return all addresses 

//return the logs
import hre from "hardhat"
const factoryName = "MadnetFactory";
const DeployedRawEvent = "DeployedRaw";
const contractAddrVar = "contractAddr";
const DeployedProxyEvent = "DeployedProxy";
const logicAddrKey = "LogicAddress";
const ProxyAddrKey = "ProxyAddress"
const deployedStaticEvent = "DeployedStatic";
const deployedTemplateEvent ="DeployedTemplate";
const MetaAddrKey = "MetaAddress"
const templateAddrKey = "TemplateAddress"


export async function deployUpgradeable(hre, contractName, factoryAddress, txParam){
    const artifacts = hre.artifacts;
    const ethers = hre.ethers;
    let MadnetFactory = await artifacts.require(factoryName);
    let factory = await MadnetFactory.at(factoryAddress); 
    let MNFactory = await ethers.getContractFactory(factoryName);
    //get an instance of the logic contract interface
    let logicContractInterface = await ethers.getContractFactory(contractName);
    //get the deployment bytecode from the interface 
    let deployBCode = await logicContractInterface.getDeployTransaction(factoryAddress);
    //deploy the bytecode using the factory
    let receipt = await factory.deployCreate(deployBCode.data, txParam);
    let res = {
        logicAddress: await getEventVar(receipt, DeployedRawEvent, contractAddrVar),
        proxyAddress: null,
        proxySalt: await getSalt(hre, contractName)
    };
    //multicall
    let deployProxy = await MNFactory.interface.encodeFunctionData("deployProxy", [res.proxySalt]);    
    let upgradeProxy = await MNFactory.interface.encodeFunctionData("upgradeProxy", [res.proxySalt, res.logicAddress]);    
    receipt = await factory.multiCall([deployProxy, upgradeProxy], txParam);
    res.proxyAddress = await getEventVar(receipt, DeployedProxyEvent, contractAddrVar);
    return res
}

export async function upgradeProxy(hre, contractName, factoryAddress){
    const artifacts = hre.artifacts;
    const ethers = hre.ethers;
    //let logicContract = await artifacts.readArtifact(logicContractPath + ":" + logicContractName);
    let MadnetFactory = await artifacts.require(factoryName);
    let factory = await MadnetFactory.at(factoryAddress); 
    let logicContractInterface = await ethers.getContractFactory(contractName);
    let deployBCode = await logicContractInterface.getDeployTransaction(factoryAddress);
    //deploy the new logic contract from the factory
    let receipt = await factory.deployCreate(deployBCode.data);
    //instantiate the return object 
    let res = {
        logicAddress: await getEventVar(receipt, DeployedRawEvent, contractAddrVar),
        proxySalt: await getSalt(hre, contractName)
    };
    //upgrade the proxy 
    receipt = await factory.upgradeProxy(res.proxySalt, res.logicAddress);
    return res;
}

export async function deployStatic(hre, contractName, factoryAddress){
    const artifacts = hre.artifacts;
    const ethers = hre.ethers;
    let MadnetFactory = await artifacts.require(factoryName);
    let logicContract = await artifacts.require(contractName);
    let factory = await MadnetFactory.at(factoryAddress); 
    let deployBCode = logicContract.bytecode
    let receipt = await factory.deployTemplate(deployBCode);
    let res = {
        templateAddress: await getEventVar(receipt, deployedTemplateEvent, contractAddrVar),
        metaAddress: null,
        metaSalt: await getSalt(hre, contractName)
    };
    receipt = await factory.deployStatic(res.metaSalt, "0x");
    res.metaAddress = await getEventVar(receipt, deployedStaticEvent, contractAddrVar);
    return res;
}

async function getFullyQaulifiedName(hre, contractName) {
    const artifacts = hre.artifacts;
    let artifactPaths = await artifacts.getAllFullyQualifiedNames();
    for (let i = 0; i < artifactPaths.length; i++){
        if (artifactPaths[i].split(":")[1] === contractName){
            return String(artifactPaths[i]);
        } 
    }
    return "";

}

function extractPath(qualifiedName) {
    return qualifiedName.split(":")[0];
}

async function getSalt(hre, contractName){
    const artifacts = hre.artifacts;
    const ethers = hre.ethers;
    let qualifiedName = await getFullyQaulifiedName(hre, contractName);
    let buildInfo = await artifacts.getBuildInfo(qualifiedName);
    //buildInfo.resolve()
    let contractPath = qualifiedName.split(":")[0]
    //wrap this in a try catch block
    console.log(buildInfo?.id);
    //let salt = await buildInfo["output"]["contracts"][contractPath][contractName]["devdoc"]["custom:salt"];
    //return ethers.utils.formatBytes32String(salt.toString());
    //set a new salt 
    let salt = new Date();
    //use the time as the salt 
    let saltDate = salt.getTime();
    return ethers.utils.formatBytes32String(saltDate.toString());
}

function getEventVar(receipt, eventName, varName){
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


