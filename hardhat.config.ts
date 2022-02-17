import "@typechain/hardhat"
import "hardhat-deploy";
import "@nomiclabs/hardhat-ethers";
import "@openzeppelin/hardhat-upgrades";
import { HardhatUserConfig, task } from "hardhat/config";
import "@nomiclabs/hardhat-waffle"
import "hardhat-contract-sizer";
import "hardhat-gas-reporter";
import "solidity-coverage";
import "@nomiclabs/hardhat-truffle5";
import "@nomiclabs/hardhat-ganache";
import "./scripts/lib/madnetFactoryTasks"



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
    'validator1': 2,
    'validator2': 3,
    'validator3': 4,
    'validator4': 0,
    'validator5': 5,
    'validator6': 6,
    'validator7': 7,
    'validator8': 8,
    'validator9': 9,
    'validator10': 10,
    'user': 11,
    // "user": 2
  },
  //unnamedAccounts: [],
  networks: {
    ganache: {
      url: "HTTP://127.0.0.1:8545"
    },
    hardhat: {
      allowUnlimitedContractSize: true,
      mining: {
        auto: false,
        interval: 15000,
      }
    }
  },
  solidity: {

    compilers: [{

      version: "0.8.11",
      settings: {
        outputSelection: {
          "*":{
            "*": [
              "metadata",
              "evm.bytecode",
              "evm.bytecode.sourceMap",
            ],
            "": [
              "ast" // Enable the AST output of every single file.
            ]
          },
          // Enable the abi and opcodes output of MyContract defined in file def.
          def: {
            MyContract: [ "abi", "evm.bytecode.opcodes" ]
          }
        },
        metadata: {
          useLiteralContent: true,
        },
        optimizer: {
          enabled: true,
          runs: 20000,
        },
      },
    }],
  },

  paths: {
    sources: "./src",
    //tests: "./tests",
    cache: "./cache",
    artifacts: "./artifacts",
  },

  contractSizer: {
    alphaSort: true,
    disambiguatePaths: false,
    runOnCompile: true,
    // set `true` to raise exception when a contract
    // exceeds the 24kB limit, interrupting execution
    strict: false,
  },
  gasReporter: {
    currency: "ETH",
    gasPrice: 1000000,
    excludeContracts: [
      "*.t.sol"
    ],
  },
  mocha: {
    timeout: 600000
  }
};


export default config;
