import {HardhatRuntimeEnvironment} from 'hardhat/types';
import {DeployFunction} from 'hardhat-deploy/types';
import { ethers } from 'hardhat';

// hardhat-deploy scripts
// https://www.npmjs.com/package/hardhat-deploy#deploy-scripts

const deployFunction: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
};

export default deployFunction;
deployFunction.tags = ['Core'];
//deployFunction.dependencies = ['Token']; // this ensure the Token script above is executed first, so `deployments.get('Token')` succeeds

