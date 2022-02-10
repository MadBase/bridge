import {artifacts} from "hardhat";
import {
    deployFactory,
    deployStaticStakeNFT,
    getAllContracts,
    getContract,
    getSalt,
    getBytes32Salt,
    getDeployType,
    staticDeployment,
    upgradeableDeployment,
    extractName,
} from "./lib/contractUtils"

 



async function main() {
    //get an array of all contracts in the artifacts
    let contracts = await getAllContracts();
    for (let i = 0; i < contracts.length; i++){
        let contract = contracts[i]
        //check the contract for the @custom:deploy-type tag
        let deployType = await getDeployType(contract);
        if (deployType === staticDeployment){
            console.log("deployStatic:", extractName(contract))
        }else if(deployType === upgradeableDeployment){
            console.log("deployUpgradeable:", extractName(contract))
        }
    }

    // let fullName  = await getContract("MadByte");
    // let buildInfo = await artifacts.getBuildInfo(fullName as string);
    // //console.log(buildInfo);
    // let name = await getContract("MadByte") as string
    // console.log(name);
    // await getSalt(name);
    
    /*let contracts = await getAllContracts()
    for (let i = 0; i < contracts.length; i++){
        let contract = contracts[i]
        let deployType = await getDeployType();

    }*/
}



main()
    .then(()=> process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    })