import { run, artifacts, ethers, contract} from "hardhat";
import { BuildInfo, CompilerOutputContract } from "hardhat/types";
import { 
    getFactoryConfigData,
    updateTemplateList, 
    updateDefaultFactoryData, 
    updateProxyList,
    updateDeployCreateList,
    FactoryData,
    TemplateData,
    ProxyData, 
    MetaContractData,
    updateMetaList,
    DeployCreateData,
  } from "./factoryUtils";

export interface InitData{
    constructorArgs: {[key:string]:any};
    initializerArgs: {[key:string]:any};
}
export interface ArgTemplate {
    [key:string]: any;
    type:string;
}

//deployment Types
export const staticDeployment:string = "deployStatic"
export const upgradeableDeployment:string = "deployUpgradeable"


//function to deploy the factory 
export async function deployFactory(){
    return await run("deployFactory", {factoryName: "MadnetFactory"});
}
//function to deploy stakenft.sol conArg factory
export async function deployStaticStakeNFT(factorAddress:string){
    return await run("deployMetamorphic", {contractName: "StakeNFT", constructorArgs: [factorAddress]})
}

export async function deployUpgradeableStakeNFT(factorAddress:string){
    return run("deployUpgradeableProxy", {contractName: "StakeNFT", constructorArgs: [factorAddress]})
}

export async function getContract(name:string) {
    let artifactPaths = await artifacts.getAllFullyQualifiedNames();
    for (let i = 0; i < artifactPaths.length; i++){
        if (artifactPaths[i].split(":")[1] === name){
            return String(artifactPaths[i]);
        } 
    }
}

export async function getAllContracts() {
    //get a list with all the contract names
    return await artifacts.getAllFullyQualifiedNames();
}
export interface ArgData{
    name:string;
    type:string;
}

export function parseArgsArray(args:ArgData[]){
    
    let output:Array<ArgTemplate> = [];
    //console.log(args)
    for(let i = 0; i < args.length; i++){
        let template = <ArgTemplate>{};
        template[args[i].name] = "UNDEFINED";
        template.type = args[i].type;
        output.push(template);
    }
    return output;
}

export async function getConstructorArgsABI(contractName: string){
    let args:Array<ArgData> = [];
    let fullName  = await getContract(contractName) as string;
    let buildInfo:any = await artifacts.getBuildInfo(fullName as string);
    let path = extractPath(fullName);
    let name = extractName(fullName)
    let methods = buildInfo.output.contracts[path][name].abi;
    for (let method of methods){
        
        if (method.type ==="constructor"){
            
            
            for(let input of method.inputs){
                let argData = <ArgData>{};
                argData.name = input.name;
                argData.type = input.type;
                args.push(argData);
            }
        }
    }
    return args
}


export async function getInitializerArgsABI(contractName: string){
    let args:Array<ArgData> = [];
    let fullName  = await getContract(contractName) as string;
    let buildInfo:any = await artifacts.getBuildInfo(fullName as string);
    let path = extractPath(fullName);
    let name = extractName(fullName)
    let methods = buildInfo.output.contracts[path][name].abi;
    for (let method of methods){
        if (method.name ==="initialize"){
            for(let input of method.inputs){
                let argData= <ArgData>{};
                argData.name = input.name;
                argData.type = input.type;
                args.push(argData);
            }
        }
    }
    return args
}

export function getConstructorArgCount(contract: any){
    for (let funcObj of contract.abi){
      if(funcObj.type === "constructor"){
        return funcObj.inputs.length;
      }
    }
    return 0;
}

export function extractPath(fullName: string) {
    return fullName.split(":")[0];
}

export function extractName(fullName: string) {
    return fullName.split(":")[1];
}

export async function getDeployType(fullName: string) {
    let buildInfo = await artifacts.getBuildInfo(fullName) as BuildInfo;
    let name = extractName(fullName);
    let path = extractPath(fullName);
    let info:any = buildInfo.output.contracts[path][name]
    return info["devdoc"]["custom:deploy-type"]
}

export async function getSalt(fullName: string) {
    let buildInfo:BuildInfo = await artifacts.getBuildInfo(fullName) as BuildInfo;
    if (buildInfo === undefined){
        console.error()
    }
    let name = extractName(fullName);
    let path = extractPath(fullName);
    let info:any = buildInfo.output.contracts[path][name]
    //console.log(info)
    return info["devdoc"]["custom:salt"]
}

export async function getBytes32Salt() {

}




export async function deployStatic() {

}

export async function deployUpgradeableProxy() {

}

export async function upgradeProxy(){

}