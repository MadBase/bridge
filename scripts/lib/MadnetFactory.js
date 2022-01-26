//separate deploy of template from deploy of deterministic address 

//assume you have to divide the transaction 
//estimate gas, observe gas limit, 

//return all addresses 

//return the logs
const { ethers, artifacts } = require("hardhat");
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
const MadnetFactory = artifacts.require(factoryName);

async function deployUpgradeable(logicContractPath, logicContractName, factoryAddress){
    let logicContract = await artifacts.readArtifact(logicContractPath + ":" + logicContractName);
    let factory = await MadnetFactory.at(factoryAddress); 
    let MNFactory = await ethers.getContractFactory(factoryName);
    let logicContractInterface = await ethers.getContractFactory(logicContractName);
    let deployBCode = await logicContractInterface.getDeployTransaction(factoryAddress);
    let receipt = await factory.deployCreate(deployBCode.data);
    let logicAddr = await getEventVar(receipt, DeployedRawEvent, contractAddrVar);
    let res = {};
    res[logicAddrKey] = logicAddr;
    //multicall
    let proxySalt = await getSalt(logicContractPath, logicContractName);
    let deployProxy = await MNFactory.interface.encodeFunctionData("deployProxy", [proxySalt]);    
    let upgradeProxy = await MNFactory.interface.encodeFunctionData("upgradeProxy", [proxySalt, logicAddr]);    
    receipt = await factory.multiCall([deployProxy, upgradeProxy]);
    res[ProxyAddrKey] = await getEventVar(receipt, DeployedProxyEvent, contractAddrVar);
    return res
}

async function upgradeDeployment(logicContractPath, logicContractName, factoryAddress){
    //let logicContract = await artifacts.readArtifact(logicContractPath + ":" + logicContractName);
    let factory = await MadnetFactory.at(factoryAddress); 
    let logicContractInterface = await ethers.getContractFactory(logicContractName);
    let deployBCode = await logicContractInterface.getDeployTransaction(factoryAddress);
    let receipt = await factory.deployCreate(deployBCode.data);
    let logicAddr = await getEventVar(receipt, DeployedRawEvent, contractAddrVar);
    let res = {};
    res[logicAddrKey] = logicAddr;
    let proxySalt = await getSalt(logicContractPath, logicContractName);
    receipt = await factory.upgradeProxy(proxySalt, logicAddr);
    return res;
}

async function deployNonUpgradeable(logicContractPath, logicContractName, factoryAddress){
    let logicContract = await artifacts.readArtifact(logicContractPath + ":" + logicContractName);
    let factory = await MadnetFactory.at(factoryAddress); 
    let deployBCode = logicContract.bytecode
    let receipt = await factory.deployTemplate(deployBCode);
    let templateAddr = await getEventVar(receipt, deployedTemplateEvent, contractAddrVar);
    let res = {};
    res[templateAddrKey] = templateAddr ;
    let Salt = await getSalt(logicContractPath, logicContractName);
    receipt = await factory.deployStatic(Salt, "0x");
    res[MetaAddrKey] = await getEventVar(receipt, deployedStaticEvent, contractAddrVar);
    return res;
}

async function getSalt(filePath, contractName){
    let buildInfo = await artifacts.getBuildInfo(filePath + ":" + contractName);
    //wrap this in a try catch block
    let salt = buildInfo["output"]["contracts"][filePath][contractName]["devdoc"]["custom:salt"];
    return ethers.utils.formatBytes32String(salt.toString());
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

module.exports = {deployUpgradeable, upgradeDeployment, deployNonUpgradeable};