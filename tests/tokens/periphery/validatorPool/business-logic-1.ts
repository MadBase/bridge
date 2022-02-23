import { getTokenIdFromTxReceipt, getFixture } from "../setup";
import {
  addValidators,
  initializeETHDKG,
  getValidatorEthAccount,
  completeETHDKGRound,
  ValidatorRawData,
} from '../ethdkg/setup'
import { ethers } from "hardhat";
import { expect, assert } from "../../../chai-setup";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import {
  validatorsSnapshots,
  validSnapshot1024,
  invalidSnapshot500,
  invalidSnapshotChainID2,
  invalidSnapshotIncorrectSig,
  validSnapshot2048
} from '../snapshots/assets/4-validators-snapshots-1'
import {
  BigNumber,
  BigNumberish,
  ContractTransaction,
  Signer,
  utils,
  Wallet,
} from "ethers";

import { IValidatorPool, Snapshots } from "../../../../typechain-types";
import exp from "constants";

describe("Testing ValidatorPool Business Logic ", () => {

  let fixture: any;
  let adminSigner: Signer;
  let maxNumValidators = 4; //default number
  let stakeAmount = 20000;
  let stakeAmountMadWei = ethers.utils.parseUnits(stakeAmount.toString(), 18);
  let lockTime = 0;
  let validators = new Array()
  let stakingTokenIds = new Array();

  interface state {
    StakeNFT: {
      StakeNFT: number, ValidatorNFT: number, MAD: number, ETH: number
    },
    ValidatorNFT: {
      StakeNFT: number, ValidatorNFT: number, MAD: number, ETH: number
    },
    ValidatorPool: {
      StakeNFT: number, ValidatorNFT: number, MAD: number, ETH: number
    },
    validators: [
      { NFT: number, MAD: number, ETH: number },
      { NFT: number, MAD: number, ETH: number },
      { NFT: number, MAD: number, ETH: number },
      { NFT: number, MAD: number, ETH: number }
    ],
  }

  beforeEach(async function () {

    fixture = await getFixture()
    const [admin, notAdmin1, notAdmin2, notAdmin3, notAdmin4] =
      fixture.namedSigners
    adminSigner = await getValidatorEthAccount(admin.address)
    await fixture.validatorNFT
      .connect(adminSigner)
      .setAdmin(fixture.validatorPool.address)
    await fixture.validatorPool
      .connect(adminSigner)
      .setETHDKG(fixture.ethdkg.address)

    // Shrink validators array to max permitted 
    validatorsSnapshots.length = maxNumValidators

    // await createValidators(validatorsSnapshots)

    // await createValidators(validatorsSnapshots)
    // //We don't need all the validators for testing purposes so trimming arrays
    // validators.length = maxNumValidators
    // stakingTokenIds.length = maxNumValidators

  });

  describe("Settings:", async function () {

    it("Should not allow registering validators if the STAKENFT position doesn’t have enough MADTokens staked", async function () {
      await createValidators(validatorsSnapshots)
      await stakeValidators(validatorsSnapshots)
      await fixture.validatorPool
        .connect(adminSigner)
        .setStakeAmount(stakeAmountMadWei.add(1)); // Set minimum to 1 over default MAD funds (20000)
      await expect(
        fixture.validatorPool
          .connect(adminSigner)
          .registerValidators(validators, stakingTokenIds)).
        to.be.revertedWith("ValidatorStakeNFT: Error, the Stake position doesn't have enough founds!")
    });

    it("Should not allow registering more validators that the current number of free spots in the pool", async function () {
      await createValidators(validatorsSnapshots)
      await stakeValidators(validatorsSnapshots)
      await fixture.validatorPool
        .connect(adminSigner)
        .setMaxNumValidators(maxNumValidators - 1); // Set maximum to 1 under default number of validators
      await expect(
        fixture.validatorPool
          .connect(adminSigner)
          .registerValidators(validators, stakingTokenIds)).
        to.be.revertedWith("There are not enough free spots for all new validators!")
    })

    it("Should not allow registering validators if the size of the input data is not correct", async function () {
      await createValidators(validatorsSnapshots)
      await stakeValidators(validatorsSnapshots)
      validators.length = maxNumValidators
      stakingTokenIds.length = maxNumValidators - 1
      await expect(
        fixture.validatorPool
          .connect(adminSigner)
          .registerValidators(validators, stakingTokenIds)).
        to.be.revertedWith("ValidatorPool: Both input array should have same length!")
    })

    it("Should not allow registering validators if the STAKENFT position was not given permissions for the ValidatorPool contract burn it", async function () {
      await createValidators(validatorsSnapshots)
      await stakeValidators(validatorsSnapshots)
      for (const validator of validatorsSnapshots) {
        //Allow validatorPool to withdraw NFT from StakeNFT
        await fixture.stakeNFT.
          connect(await getValidatorEthAccount(validator)).
          setApprovalForAll(fixture.validatorPool.address, false);
      }
      await expect(
        fixture.validatorPool
          .connect(adminSigner)
          .registerValidators(validators, stakingTokenIds)).
        to.be.revertedWith("ERC721: transfer caller is not owner nor approved")
    })

    it("Should not allow registering an address that is already a validator", async function () {
      //Clone validators array
      let _validatorsSnapshots = validatorsSnapshots.slice()
      //Repeat the first validator
      _validatorsSnapshots[1] = _validatorsSnapshots[0]
      await createValidators(_validatorsSnapshots)
      //Approve first validator for twice the amount
      await fixture.madToken
        .connect(await getValidatorEthAccount(validatorsSnapshots[0]))
        .approve(fixture.stakeNFT.address, stakeAmountMadWei.mul(2))
      await stakeValidators(_validatorsSnapshots)
      await expect(
        fixture.validatorPool
          .connect(adminSigner)
          .registerValidators(validators, stakingTokenIds))
        .to.be.revertedWith("ValidatorPool: Address is already a validator or it is in the exiting line!")
    })

    it("Should not allow registering an address that is in the exiting queue", async function () {
      await createValidators(validatorsSnapshots)
      await stakeValidators(validatorsSnapshots)
      await
        fixture.validatorPool
          .connect(adminSigner)
          .registerValidators(validators, stakingTokenIds)
      showState("after registering", await getCurrentState())
      await
        fixture.validatorPool
          .connect(adminSigner)
          .unregisterValidators(validators)
      showState("after un-registering", await getCurrentState())
      await createValidators(validatorsSnapshots)
      await stakeValidators(validatorsSnapshots)
      await expect(
        fixture.validatorPool
          .connect(adminSigner)
          .registerValidators(validators, stakingTokenIds)).
        to.be.revertedWith("ValidatorPool: Address is already a validator or it is in the exiting line!")
    })

    it("Should not allow unregistering of non-validators (even in the middle of array of validators)", async function () {
      await createValidators(validatorsSnapshots)
      await stakeValidators(validatorsSnapshots)
      await
        fixture.validatorPool
          .connect(adminSigner)
          .registerValidators(validators, stakingTokenIds)
      //Set a non validator address in the middle of array for un-sregistering
      validators[1] = '0x000000000000000000000000000000000000dEaD'
      await expect(
        fixture.validatorPool
          .connect(adminSigner)
          .unregisterValidators(validators)).
        to.be.revertedWith("ValidatorPool: Address is not a validator_!")
    })

    it("Should not allow unregistering more addresses that in the pool", async function () {
      await createValidators(validatorsSnapshots)
      await stakeValidators(validatorsSnapshots)
      await
        fixture.validatorPool
          .connect(adminSigner)
          .registerValidators(validators, stakingTokenIds)
          showState("after registering", await getCurrentState())

          //Add another validator to unregister array
          validators.push('0x000000000000000000000000000000000000dEaD')
          stakingTokenIds.push(0)
          await expect(
        fixture.validatorPool
          .connect(adminSigner)
          .unregisterValidators(validators))
        .to.be.revertedWith("alidatorPool: There are not enough validators to be removed!")
    })

    it("Set snapshot", async function () {
      await fixture.validatorPool
        .connect(adminSigner)
        .setSnapshot(fixture.snapshots.address);
    });

    it("Set ETHDKG", async function () {
      await fixture.validatorPool
        .connect(adminSigner)
        .setETHDKG(fixture.ethdkg.address);
    });

  })

  describe("ETHDKG:", async function () {
    it("Schedule maintenance", async function () {
      await fixture.validatorPool.
        connect(adminSigner).
        scheduleMaintenance();
    });

    xit("Initialize ETHDKG", async function () {
      await fixture.validatorPool
        .connect(adminSigner)
        .registerValidators(validators, stakingTokenIds);
      await fixture.validatorPool.
        connect(adminSigner).
        initializeETHDKG();
    });

    it("Pause consensus", async function () {
      await getSnapshots(4)
      await expect(
        fixture.validatorPool
          .connect(adminSigner)
          .pauseConsensusOnArbitraryHeight(1)
      ).to.be.revertedWith("ValidatorPool: Condition not met to stop consensus!");
      // await fixture.validatorPool
      //   .connect(adminSigner)
      //   .unregisterValidators(validators);
    });

  })
  describe("Business:", async function () {

    it("Register validators", async function () {
      await createValidators(validatorsSnapshots)
      await stakeValidators(validatorsSnapshots)
      let expectedState: state = await getCurrentState()
      //Expect that NFTs are transferred from each validator to ValidatorPool sd ValidatorNFTs
      validators.map((element, index) => {
        expectedState.validators[index].NFT--
        expectedState.ValidatorPool.ValidatorNFT++
      })
      //Expect that all validators funds are transferred from StakeNFT to ValidatorNFT
      expectedState.StakeNFT.MAD -= stakeAmount * validators.length
      expectedState.ValidatorNFT.MAD += stakeAmount * validators.length
      // Register validators
      await fixture.validatorPool
        .connect(adminSigner)
        .registerValidators(validators, stakingTokenIds);
      let currentState: state = await getCurrentState()
      await showState("after registering", currentState)
      expect(currentState).
        to.be.deep.equal(expectedState)
    });

    it("Unregister validators", async function () {
      await createValidators(validatorsSnapshots)
      await stakeValidators(validatorsSnapshots)
      let expectedState: state = await getCurrentState()
      //Expect that NFT are transferred from validators to ValidatorPool and then back to Staking
      validators.map((element, index) => {
        expectedState.validators[index].NFT--
        expectedState.ValidatorPool.StakeNFT++
      })
      await showState("Expected state after registering/un-registering", expectedState)
      await fixture.validatorPool
        .connect(adminSigner)
        .registerValidators(validators, stakingTokenIds);
      //  await showState("Current state after registering", await getCurrentState())
      await fixture.validatorPool
        .connect(adminSigner)
        .unregisterValidators(validators);
      let currentState: state = await getCurrentState()
      await showState("Current state after registering/un-registering", currentState)
      expect(currentState).
        to.be.deep.equal(expectedState)
    });

    it('Unregister all validators', async function () {
      await createValidators(validatorsSnapshots)
      await stakeValidators(validatorsSnapshots)
      let expectedState: state = await getCurrentState()
      //Expect that NFT are transferred to ValidatorPool as StakeNFTs
      validators.map((element, index) => {
        expectedState.validators[index].NFT--
        expectedState.ValidatorPool.StakeNFT++
      })
      await showState("Expected state after unregister all validators", expectedState)
      await fixture.validatorPool
        .connect(adminSigner)
        .registerValidators(validators, stakingTokenIds);
      await fixture.validatorPool
        .connect(adminSigner)
        .unregisterAllValidators();
      let currentState: state = await getCurrentState()
      await showState("Expected state after unregister all validators", currentState)
      expect(currentState).
        to.be.deep.equal(expectedState)
    });

    it("Claim exiting NFT position", async function () {
      await createValidators(validatorsSnapshots)
      await stakeValidators(validatorsSnapshots)
      //As this is a complete cycle, expect the initial state to be exactly the same as the final state
      let expectedState: state = await getCurrentState()
      await fixture.validatorPool
        .connect(adminSigner)
        .registerValidators(validators, stakingTokenIds);
      await fixture.validatorPool
        .connect(adminSigner)
        .unregisterValidators(validators);
      await getSnapshots(4)
      for (const validatorsSnapshot of validatorsSnapshots) {
        await fixture.validatorPool
          .connect(await getValidatorEthAccount(validatorsSnapshot))
          .claimStakeNFTPosition()
      }
      let currentState: state = await getCurrentState()
      //Ignore transactions gas costs
      // currentState.validators.map(async (validator, index) => {
      //   expectedState.validators[index].ETH = validator.ETH
      // })
      await showState("Expected state after claiming exiting NFT position", expectedState)
      await showState("Current state after claiming exiting NFT position", currentState)
      expect(currentState).
        to.be.deep.equal(expectedState)
    })

    it("Should fail to re-register validators before 172800 epochs after claiming NFT positions", async function () {
      await createValidators(validatorsSnapshots)
      await stakeValidators(validatorsSnapshots)
      await fixture.validatorPool
        .connect(adminSigner)
        .registerValidators(validators, stakingTokenIds);
      await fixture.validatorPool
        .connect(adminSigner)
        .unregisterValidators(validators);
      await getSnapshots(4)
      stakingTokenIds = []
      for (const validator of validatorsSnapshots) {
        let tx = await fixture.validatorPool
          .connect(await getValidatorEthAccount(validator))
          .claimStakeNFTPosition()
        //When a token is claimed it gets a new tokenId so we need to update array for re-registration
        let receipt = await ethers.provider.getTransactionReceipt(tx.hash)
        const tokenId = BigNumber.from(receipt.logs[0].topics[3])
        stakingTokenIds.push(tokenId)
      }
      // After claiming, position is locked for a period of 172800 Madnet epochs
      // To perform this test with no revert, POSITION_LOCK_PERIOD can be set to 3
      // in ValidatorPool and then take 4 snapshots
      // await getSnapshots(4)
      await expect(fixture.validatorPool
        .connect(adminSigner)
        .registerValidators(validators, stakingTokenIds))
        .to.be.revertedWith("StakeNFT: The position is not ready to be burned!")
    })

    it("Collect profit", async function () {
      await createValidators(validatorsSnapshots)
      await stakeValidators(validatorsSnapshots)
      await fixture.validatorPool
        .connect(adminSigner)
        .registerValidators(validators, stakingTokenIds);
      let expectedState: state = await getCurrentState()
      //Simulate 4 ETH earned by pool after validators registration
      await fixture.validatorNFT
        .connect(adminSigner)
        .depositEth(42, {
          value: ethers.utils.parseEther("4.0")
        })
      //Expect ValidatorNFT balance to increment by earnings
      expectedState.ValidatorNFT.ETH += 4
      //Complete ETHDKG Round
      // await completeETHDKGRound(validatorsSnapshots, {
      //   ethdkg: fixture.ethdkg,
      //   validatorPool: fixture.validatorPool
      // })
      await fixture.validatorPool
        .connect(await getValidatorEthAccount(validatorsSnapshots[0]))
        .collectProfits()
      // Expect that a fraction of the earnings (1/4 validators) to be transfer from ValidatorNFT to collecting validator
      expectedState.ValidatorNFT.ETH -= 1
      expectedState.validators[0].ETH += 1
      let currentState: state = await getCurrentState()
      //Ignore transactions gas costs
      currentState.validators.map(async (validator, index) => {
        expectedState.validators[index].ETH = validator.ETH
      })
      await showState("Expected state after collect profit", expectedState)
      await showState("Current state after collect profit", currentState)
      expect(currentState).
        to.be.deep.equal(expectedState)
    })

    xit("Unregister validators after earn  (ERROR: Transfer failed)", async function () {
      await createValidators(validatorsSnapshots)
      await stakeValidators(validatorsSnapshots)
      await fixture.validatorPool
        .connect(adminSigner)
        .registerValidators(validators, stakingTokenIds);
      let expectedState: state = await getCurrentState()
      //Simulate 4 ETH earned by pool after validators registration
      //Expect ValidatorNFT balance to increment by earnings
      expectedState.ValidatorNFT.ETH += 4
      await fixture.validatorNFT
        .connect(adminSigner)
        .depositEth(42, {
          value: ethers.utils.parseEther("4.0")
        })
      //Complete ETHDKG Round
      // await completeETHDKGRound(validatorsSnapshots, {
      //   ethdkg: fixture.ethdkg,
      //   validatorPool: fixture.validatorPool
      // })
      // Expect a fraction of the earnings (1/validators) to be transfer from ValidatorNFT to collecting validator
      expectedState.ValidatorNFT.ETH -= 1
      expectedState.validators[0].ETH += 1
      await fixture.validatorPool
        .connect(await getValidatorEthAccount(validatorsSnapshots[0]))
        .collectProfits()
      let currentState: state = await getCurrentState()
      //Ignore transactions gas costs
      currentState.validators.map(async (validator, index) => {
        expectedState.validators[index].ETH = validator.ETH
      })
      await showState("Expected state after collect profit", expectedState)
      await showState("Current state after collect profit", currentState)
      expect(currentState).
        to.be.deep.equal(expectedState)
    })

  })

  const getSnapshots = (async (numberOfSnapshots: number) => {
    if (process.env.npm_config_detailed == "true") console.log("Taking", numberOfSnapshots, "snapshots");
    let mock = await completeETHDKGRound(validatorsSnapshots)
    const Snapshots = await ethers.getContractFactory('Snapshots')
    const snapshots = await Snapshots.deploy(
      mock[0].address,
      mock[1].address,
      1,
      mock[1].address
    )
    await snapshots.deployed()
    for (let i = 0; i <= numberOfSnapshots; i++) {
      let tx = await snapshots
        .connect(await getValidatorEthAccount(validatorsSnapshots[0]))
        .snapshot(validSnapshot1024.GroupSignature, validSnapshot1024.BClaims)
      // let receipt = await ethers.provider.getTransactionReceipt(tx.hash)
      // console.log(receipt)
      // consumedWei += receipt.cumulativeGasUsed.toNumber() * receipt.effectiveGasPrice.toNumber()

      // console.log("consumedGas", consumedWei)

    }
    fixture.validatorPool.setSnapshot(snapshots.address);
    // const result = await tx.wait(); // 0ms, as tx is already confirmed
    // console.log(result)
    // const events = result.events?.find(event => event.event === 'SnapshotTaken');
    // if (events?.args) {
    //   const [chainId, epoch, height, validator, safeToProceedConsensus] = events.args
    //   console.log(chainId, epoch, height, validator, safeToProceedConsensus);
    // }

  })



  async function getCurrentState() {
    // System state
    let state: state = {
      StakeNFT: {
        StakeNFT: 0, ValidatorNFT: 0, MAD: 0, ETH: 0
      },
      ValidatorNFT: {
        StakeNFT: 0, ValidatorNFT: 0, MAD: 0, ETH: 0
      },
      ValidatorPool: {
        StakeNFT: 0, ValidatorNFT: 0, MAD: 0, ETH: 0
      },
      validators: [
        { NFT: 0, MAD: 0, ETH: 0 },
        { NFT: 0, MAD: 0, ETH: 0 },
        { NFT: 0, MAD: 0, ETH: 0 },
        { NFT: 0, MAD: 0, ETH: 0 },
      ],
    }
    // Get state for validators
    for (let i = 0; i < state.validators.length; i++) {
      state.validators[i].NFT = parseFloat(await fixture.stakeNFT.balanceOf(
        validators[i]))
      state.validators[i].MAD = parseFloat(ethers.utils.formatEther(await fixture.madToken.balanceOf(
        validators[i])))
      state.validators[i].ETH = parseFloat((+ethers.utils.formatEther(await ethers.provider.getBalance(validators[i]))).toFixed(0))
    }

    // Contract data
    let contractData = [
      { contractState: state.StakeNFT, contractAddress: fixture.stakeNFT.address },
      { contractState: state.ValidatorNFT, contractAddress: fixture.validatorNFT.address },
      { contractState: state.ValidatorPool, contractAddress: fixture.validatorPool.address },
    ]

    // Get state for contracts
    for (let i = 0; i < contractData.length; i++) {
      contractData[i].contractState.StakeNFT = parseInt(await fixture.stakeNFT.balanceOf(
        contractData[i].contractAddress))
      contractData[i].contractState.ValidatorNFT = parseInt(await fixture.validatorNFT.balanceOf(
        contractData[i].contractAddress))
      contractData[i].contractState.MAD = parseFloat(ethers.utils.formatEther(await fixture.madToken.balanceOf(
        contractData[i].contractAddress)))
      contractData[i].contractState.ETH = parseFloat((+ethers.utils.formatEther(
        await ethers.provider.getBalance(contractData[i].contractAddress))).toFixed(0))
    }

    // Get state for ValidatorPool
    // state.ValidatorPool.NFT = parseInt(await fixture.validatorPool.balanceOf(
    //   fixture.validatorPool.address))
    // state.ValidatorPool.StakeNFT = parseInt(await fixture.stakeNFT.balanceOf(
    //   fixture.validatorPool.address))
    // state.ValidatorPool.ValidatorNFT = parseInt(await fixture.validatorNFT.balanceOf(
    //   fixture.validatorPool.address))
    // state.ValidatorPool.MAD = parseFloat(ethers.utils.formatEther(await fixture.madToken.balanceOf(
    //   fixture.validatorPool.address)))
    //   state.ValidatorPool.ETH = parseFloat(ethers.utils.formatEther(
    //   await ethers.provider.getBalance(fixture.validatorPool.address)))

    return state
  }

  async function showState(title: string, state: state) {
    if (process.env.npm_config_detailed == "true") { // execute "npm --detailed=true  run test" to see this showBalancess
      console.log(title)
      console.log(state)
    }
  }

  async function createValidators(_validatorsSnapshots: ValidatorRawData[]) {
    validators = []
    stakingTokenIds = []
    // Approve ValidatorPool to withdraw MAD tokens of validators
    await fixture.madToken.
      approve(fixture.validatorPool.address,
        stakeAmountMadWei.mul(_validatorsSnapshots.length));
    for (const validator of _validatorsSnapshots) {
      validators.push(validator.address)
      //Send MAD tokens to each validator
      await fixture.madToken.
        transfer(validator.address, stakeAmountMadWei);
      // Approve to Stake all MAD tokens
      await fixture.madToken.
        connect(await getValidatorEthAccount(validator)).
        approve(fixture.stakeNFT.address, stakeAmountMadWei);
    }
    await showState("After creating:", await getCurrentState())
  }

  async function stakeValidators(_validatorsSnapshots: ValidatorRawData[]) {
    for (const validator of _validatorsSnapshots) {
      // Stake all MAD tokens
      let tx = await fixture.stakeNFT.
        connect(await getValidatorEthAccount(validator)).
        mintTo(validator.address, stakeAmountMadWei, lockTime);
      // Get the proof of staking (NFT's tokenID)
      let tokenID = await getTokenIdFromTxReceipt(tx)
      stakingTokenIds.push(tokenID);
      //Allow validatorPool to withdraw NFT from StakeNFT
      await fixture.stakeNFT.
        connect(await getValidatorEthAccount(validator)).
        setApprovalForAll(fixture.validatorPool.address, true);
    }
    await showState("After staking:", await getCurrentState())
  }

});





