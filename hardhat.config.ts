import {HardhatUserConfig} from 'hardhat/types';
import 'hardhat-deploy';
import 'hardhat-deploy-ethers';

require("@nomiclabs/hardhat-waffle");
require('@openzeppelin/hardhat-upgrades');
//require('hardhat-deploy');
//require("@nomiclabs/hardhat-ethers");
require('hardhat-contract-sizer');

/**
 * @type import('hardhat/config').HardhatUserConfig
 */

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
/* task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
}); */

const config: HardhatUserConfig = {
  solidity: {
    compilers: [{
      version: "0.8.9",
      settings: {
        optimizer: {
          enabled: true,
          runs: 2000000,
        },
      },
    }],
  },
  namedAccounts: {
    admin: 0,
  },
  paths: {
    sources: "./src",
    tests: "./tests",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  /* contractSizer: {
    alphaSort: true,
    disambiguatePaths: false,
    runOnCompile: true,
    // set `true` to raise exception when a contract
    // exceeds the 24KB limit, interrupting execution
    strict: true,
  } */
};


export default config;
