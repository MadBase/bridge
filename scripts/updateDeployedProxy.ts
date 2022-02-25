
import { run} from "hardhat";
import { DeployCreateData, ProxyData } from "./lib/factoryStateUtils";

async function main() {
    let deployCreateData: DeployCreateData = await run("deployCreate", {
        contractName: "Snapshots",
        factoryName: "MadnetFactory",
        factoryAddress: "0x0b1F9c2b7bED6Db83295c7B5158E3806d67eC5bc", // CRITICAL: MAGIC
        constructorArgs: ["42", "16"]
    })

    let upgradedData: ProxyData = await run("upgradeDeployedProxy", {
        contractName: "Snapshots",
        factoryName: "MadnetFactory",
        factoryAddress: "0x0b1F9c2b7bED6Db83295c7B5158E3806d67eC5bc", // CRITICAL: MAGIC
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