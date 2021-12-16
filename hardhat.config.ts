//import {HardhatUserConfig} from 'hardhat/types';
import 'hardhat-deploy';
import '@nomiclabs/hardhat-ethers';
import 'hardhat-deploy-ethers';
//import 'hardhat-upgrades';
import { HardhatUserConfig, task } from "hardhat/config";
import '@typechain/hardhat'
import '@nomiclabs/hardhat-waffle'
import 'hardhat-contract-sizer';
import "hardhat-gas-reporter";

/**
 * @type import('hardhat/config').HardhatUserConfig
 */

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

const config: HardhatUserConfig = {
  namedAccounts: {
    'admin': 0,
    'validator0': 1,
    'validator1': 3,
    'validator2': 4,
    'validator3': 5,
    'validator4': 0,
    'validator5': 6,
    'validator6': 7,
    'validator7': 8,
    'validator8': 9,
    'validator9': 10,
    'validator10': 11,
    // unassigned account index: 2
  },
  //unnamedAccounts: [],
  networks: {
    hardhat: {
      allowUnlimitedContractSize: true,
      mining: {
        auto: false,
        mempool: {
          order: "fifo"
        }
      },
      accounts: [
        {
          privateKey: "0x6aea45ee1273170fb525da34015e4f20ba39fe792f486ba74020bcacc9badfc1",
          balance: "10000000000000000000000", // 10000 eth
        },
        {
          privateKey: "0x8de84c4eb40a9d32804ebc4005075eed5d64efc92ba26b6ec04d399f5a9b7bd1",
          balance: "10000000000000000000000", // 10000 eth
        },
        {
          privateKey: "0xc62fd5e127b007a90478de7259b20b0281d20e8c8aa713bdbf819337cf8712df",
          balance: "10000000000000000000000", // 10000 eth
        },
        {
          privateKey: "0x65a81057728efda8858d5d53094a093203d35cb7437d16f7635594788517bdd2",
          balance: "10000000000000000000000", // 10000 eth
        },
        {
          privateKey: "0xd599743b90304946278b39c8d51b240c0bde4c6603fe47b2b6b131509feca7fc",
          balance: "10000000000000000000000", // 10000 eth
        },
        {
          privateKey: "0xa7b4595b0697fcae35046b6d532d17d2f134c9c5e9a5d202ae4b7c83fa85399e",
          balance: "10000000000000000000000", // 10000 eth
        },
        {
          privateKey: "0x7253354503676cad1165425f4a528369991ca6931afe88d3e82c2edfdbef64f7",
          balance: "10000000000000000000000", // 10000 eth
        },
        {
          privateKey: "0x32a7f91d96f1f2f9926e0e4ec3d6af78b54d679509853125a7d0259be438b41a",
          balance: "10000000000000000000000", // 10000 eth
        },
        {
          privateKey: "0x99e883ac5e9135559842aac297319914fb89efc066975b69bffe82697d10fd9b",
          balance: "10000000000000000000000", // 10000 eth
        },
        {
          privateKey: "0xbc676d5eb82c6356ac53d46124fa01755cb6268b6a5ad51a648d69f9411c3257",
          balance: "10000000000000000000000", // 10000 eth
        },
        {
          privateKey: "0x009ab9b374ada80e33c4efcf5a16ed4235b327d5319532ff8cf39024e36cf9b9",
          balance: "10000000000000000000000", // 10000 eth
        },
        {
          privateKey: "0x264d19b082060f127bdcf6bdee7db0244c4b5a762f686d0fc865bb6e64b3e743",
          balance: "10000000000000000000000", // 10000 eth
        },
      ],
    }
  },
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
  paths: {
    sources: "./src",
    tests: "./tests",
    cache: "./cache",
    artifacts: "./artifacts",
  },
  contractSizer: {
    alphaSort: true,
    disambiguatePaths: false,
    runOnCompile: true,
    // set `true` to raise exception when a contract
    // exceeds the 24KB limit, interrupting execution
    strict: false,
  },
  gasReporter: {
    currency: 'USD',
    gasPrice: 50
  }
};


export default config;
