import {
    factoryDeployment,
    staticDeployment,
    upgradeableDeployment,
} from "./lib/constants"
import {artifacts, ethers} from "hardhat";
import {
    deployFactory,
    getAllContracts,
    getContract,
    getSalt,
} from "./lib/deploymentUtils"
import fs from "fs";
import { FactoryConfig, FactoryData } from "./lib/factoryStateUtils";


async function main() {
    //read the file
    let rawData = fs.readFileSync("./deployments/testnet/factoryState.json");
    let State = await JSON.parse(rawData.toString("utf8"));
    let gas = 0; 
    let defaultFactory:FactoryData = State.defaultFactoryData 
    if(defaultFactory.gas !== undefined){
        gas += defaultFactory.gas;
    }
    for (let contract of State.templates){
        gas += contract.gas;
    }
    for (let contract of State.staticContracts){
        gas += contract.gas;
    }
    for (let contract of State.deployCreates){
        gas += contract.gas;
    }
    for (let contract of State.proxies){
        gas += contract.gas;
    }
    console.log(gas)
}

main()
    .then(()=> process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    })