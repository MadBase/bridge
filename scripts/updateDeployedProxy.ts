
import { run} from "hardhat";
import { DeployCreateData, ProxyData } from "./lib/factoryStateUtils";

async function main() {
    // npx hardhat deployCreate --network dev --contract-name Snapshots --factory-name MadnetFactory --factory-address 0x0b1F9c2b7bED6Db83295c7B5158E3806d67eC5bc 42 16
    let deployCreateData: DeployCreateData = await run("deployCreate", {
        contractName: "Snapshots",
        factoryName: "MadnetFactory",
        factoryAddress: "0x0b1F9c2b7bED6Db83295c7B5158E3806d67eC5bc",
        constructorArgs: ["42", "16"]
    })

    let upgradedData: ProxyData = await run("upgradeDeployedProxy", {
        contractName: "Snapshots",
        factoryName: "MadnetFactory",
        factoryAddress: "0x0b1F9c2b7bED6Db83295c7B5158E3806d67eC5bc",
        logicAddress: deployCreateData.address,
        initCallData: "0x"
    })
    console.log(upgradedData)
}

main()
    .then(()=> process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    })