import {HardhatRuntimeEnvironment} from 'hardhat/types';
import {DeployFunction} from 'hardhat-deploy/types';
import { ethers } from 'hardhat';

// hardhat-deploy scripts
// https://www.npmjs.com/package/hardhat-deploy#deploy-scripts

const deployFunction: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const {deployments, getNamedAccounts, getUnnamedAccounts, getChainId} = hre;
  const {deploy} = deployments;
  //const {admin, tokenOwner} = await getNamedAccounts();

  //const {admin, madStaking, minerStaking, lpStaking, foundation} = await getNamedAccounts();
  const [admin, madStaking, minerStaking, lpStaking, foundation, governance] = await getUnnamedAccounts();

  // MadToken

  let deployResultMadToken = await deploy('MadToken', {
    from: admin,
    args: ["MadToken", "MAD"],
    log: true,
    // proxy: false,
    // gasLimit: 4000000,
  });
  if (deployResultMadToken.newlyDeployed && deployResultMadToken.receipt) {
    console.log(
      `MadToken deployed at ${deployResultMadToken.address} using ${deployResultMadToken.receipt.gasUsed} gas`
    );
  }

  // MadByte

  let deployResultMadByte = await deploy('MadByte', {
    from: admin,
    args: [admin, madStaking, minerStaking, lpStaking, foundation],
    log: true,
    // proxy: false,
    // gasLimit: 4000000,
  });
  if (deployResultMadByte.newlyDeployed && deployResultMadByte.receipt) {
    console.log(
      `MadByte deployed at ${deployResultMadByte.address} using ${deployResultMadByte.receipt.gasUsed} gas`
    );
  }

  // StakeNFT

  let deployResultStakeNFT = await deploy('StakeNFT', {
    from: admin,
    args: ['StakeNFT', 'MADSTK', deployResultMadByte.address, admin, governance],
    log: true,
    // proxy: false,
    // gasLimit: 4000000,
  });
  if (deployResultStakeNFT.newlyDeployed && deployResultStakeNFT.receipt) {
    console.log(
      `StakeNFT deployed at ${deployResultStakeNFT.address} using ${deployResultStakeNFT.receipt.gasUsed} gas`
    );
  }

  // ValidatorNFT

  let deployResultValidatorNFT = await deploy('ValidatorNFT', {
    from: admin,
    args: ['ValidatorNFT', 'VALSTK', deployResultMadByte.address, admin, governance],
    log: true,
    // proxy: false,
    // gasLimit: 4000000,
  });
  if (deployResultValidatorNFT.newlyDeployed && deployResultValidatorNFT.receipt) {
    console.log(
      `ValidatorNFT deployed at ${deployResultValidatorNFT.address} using ${deployResultValidatorNFT.receipt.gasUsed} gas`
    );
  }

  // Validators
  //const art = await hre.artifacts.readArtifact("src/tokens/periphery/Validators.sol:Validators")
  //console.log('artifact contractName', art.contractName)

  let deployResultValidators = await deploy('ValidatorPool', {
    //contract: "src/tokens/periphery/Validators.sol:Validators",
    from: admin,
    //args: [deployResultStakeNFT.address, deployResultValidatorNFT.address, deployResultMadByte.address],
    args: [],
    log: true,
    proxy: false,
    // gasLimit: 4000000,
  });
  if (deployResultValidators.newlyDeployed && deployResultValidators.receipt) {
    console.log(
      `ValidatorPool deployed at ${deployResultValidators.address} using ${deployResultValidators.receipt.gasUsed} gas`
    );
  }

  const ValidatorPool = await ethers.getContract("ValidatorPool", admin);
  await ValidatorPool.initialize(deployResultStakeNFT.address, deployResultValidatorNFT.address, deployResultMadByte.address)

  console.log('finished core deployment')

};

export default deployFunction;
deployFunction.tags = ['MadByte', 'StakeNFT', 'Core'];
//deployFunction.dependencies = ['Token']; // this ensure the Token script above is executed first, so `deployments.get('Token')` succeeds

