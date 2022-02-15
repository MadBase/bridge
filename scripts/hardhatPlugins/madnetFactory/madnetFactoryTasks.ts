import { task } from "hardhat/config";
import { deployUpgradeable, deployNonUpgradeable, upgradeProxy } from "../../lib/MadnetFactory"

task("deployUpgradeableProxy", )
    .addParam("contractName", "Name of logic contract to point the proxy at")
    .addParam("factoryAddress", "the address of the factory contract")
    .setAction(async (taskArgs) => {
        let result = await deployUpgradeable(taskArgs.contractName, taskArgs.factoryAddress);
        console.log("Deployed logic address :", result.logicAddress)
        console.log("Deployed proxy address :", result.proxyAddress)
    });

task("upgradeProxy", )
    .addParam("contractName", "Name of logic contract to deploy")
    .addParam("factoryAddress", "the address of the factory contract")
    .setAction(async (taskArgs) => {
        let result = await upgradeProxy(taskArgs.contractName, taskArgs.factoryAddress);
        console.log("Deployed logic address :", result.logicAddress)
        
    });

    module.exports = {};