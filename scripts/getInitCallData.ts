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

async function main() {
    let contractFactory = await ethers.getContractFactory("MadByte");
    let initCallData = contractFactory.interface.encodeFunctionData("initialize");
    console.log(initCallData);
}

main()
    .then(()=> process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    })