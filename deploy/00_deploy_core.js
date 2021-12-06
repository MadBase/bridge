
// hardhat-deploy scripts
// https://www.npmjs.com/package/hardhat-deploy#deploy-scripts

module.exports = async ({
  getNamedAccounts,
  deployments,
  getChainId,
  getUnnamedAccounts,
}) => {
  const {deploy} = deployments;
  //const {admin, madStaking, minerStaking, lpStaking, foundation} = await getNamedAccounts();
  const [admin, madStaking, minerStaking, lpStaking, foundation, governance] = await getUnnamedAccounts();

  // MadByte

  let deployResultMadByte = await deploy('MadByte', {
    from: admin,
    args: [admin, madStaking, minerStaking, lpStaking, foundation],
    log: true,
    // proxy: false,
    // gasLimit: 4000000,
  });
  if (deployResultMadByte.newlyDeployed) {
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
  if (deployResultStakeNFT.newlyDeployed) {
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
  if (deployResultValidatorNFT.newlyDeployed) {
    console.log(
      `ValidatorNFT deployed at ${deployResultValidatorNFT.address} using ${deployResultValidatorNFT.receipt.gasUsed} gas`
    );
  }

  // Validators

  let deployResultValidators = await deploy('Validators', {
    from: admin,
    args: ['ValidatorNFT', 'VALSTK', deployResultMadByte.address, admin, governance],
    log: true,
    // proxy: false,
    // gasLimit: 4000000,
  });
  if (deployResultValidators.newlyDeployed) {
    console.log(
      `Validators deployed at ${deployResultValidators.address} using ${deployResultValidators.receipt.gasUsed} gas`
    );
  }

};

module.exports.tags = ['MadByte', 'StakeNFT', 'Core'];

