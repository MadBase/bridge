
import { run, artifacts, ethers, contract} from "hardhat";
import { BuildInfo, CompilerOutputContract } from "hardhat/types";
 



async function main() {
    let contracts = await getAllContracts();
    console.log(contracts)
    let fullName  = await getContract("MadByte");
    let buildInfo = await artifacts.getBuildInfo(fullName as string);
    //console.log(buildInfo);
    let name = await getContract("MadByte") as string
    console.log(name);
    await getSalt(name);
    
    /*let contracts = await getAllContracts()
    for (let i = 0; i < contracts.length; i++){
        let contract = contracts[i]
        let deployType = await getDeployType();

    }*/
}

//function to deploy the factory 

//function to deploy stakenft.sol conArg factory

async function getContract(name:string) {
    let artifactPaths = await artifacts.getAllFullyQualifiedNames();
    for (let i = 0; i < artifactPaths.length; i++){
        if (artifactPaths[i].split(":")[1] === name){
            return String(artifactPaths[i]);
        } 
    }
}

async function getAllContracts() {
    //get a list with all the contract names
    return artifacts.getAllFullyQualifiedNames();
}

function extractPath(fullName: string) {
    return fullName.split(":")[0];
}
function extractName(fullName: string) {
    return fullName.split(":")[1];
}

async function getDeployType(fullName: string) {
    let buildInfo = await artifacts.getBuildInfo(fullName) as BuildInfo;
    let name = extractName(fullName);
    let path = extractPath(fullName);
    let info:any = buildInfo.output.contracts[path][name]
    return info["devdoc"]["custom:deploy-type"]
}

async function getSalt(fullName: string) {
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

async function getBytes32Salt() {

}

async function getConstructorArgs() {

}

async function getInitiatorArgs() {

}

async function deployStatic() {

}

async function deployUpgradeableProxy() {

}

async function upgradeProxy(){

}

main()
    .then(()=> process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    })