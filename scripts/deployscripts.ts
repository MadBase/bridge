import {
    staticDeployment,
    upgradeableDeployment,
} from "./lib/constants"
import {
    deployFactory,
    getAllContracts,
    getDeployType,
    deployUpgradeableProxy,
    deployStatic,
} from "./lib/deploymentUtils"

async function main() {
    //deploy the factory firts
    await deployFactory();
    //get an array of all contracts in the artifacts
    let contracts = await getAllContracts();
    for (let i = 0; i < contracts.length; i++){
        let fullyQualifiedName = contracts[i]
        //check the contract for the @custom:deploy-type tag
        let deployType = await getDeployType(fullyQualifiedName);
        switch (deployType) {
            case staticDeployment :
                await deployStatic(fullyQualifiedName);
                break;
            case upgradeableDeployment :
                await deployUpgradeableProxy(fullyQualifiedName);
                break;
            default:
                break;
        }
    }
}

main()
    .then(()=> process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    })