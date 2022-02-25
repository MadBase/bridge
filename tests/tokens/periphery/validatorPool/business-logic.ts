import {
  Fixture,
  getTokenIdFromTx,
  getValidatorEthAccount,
  getFixture,
  factoryCallAny,
  factoryCallAnyFrom
} from "../setup";
import {
  completeETHDKGRound,
  initializeETHDKG,
  ValidatorRawData,
} from '../ethdkg/setup'
import { ethers } from "hardhat";
import { expect, assert } from "../../../chai-setup";
import {
  validatorsSnapshots,
  validSnapshot1024,
} from '../snapshots/assets/4-validators-snapshots-1'
import {
  BigNumber,
  ContractTransaction,
  Signer,
} from "ethers";

describe("Testing ValidatorPool Business Logic ", () => {

  let fixture: Fixture
  let adminSigner: Signer;
  let maxNumValidators = 4; //default number
  let stakeAmount = 20000;
  let stakeAmountMadWei = ethers.utils.parseUnits(stakeAmount.toString(), 18);
  let lockTime = 0;
  let validators = new Array()
  let originalValidatorsSnapshots = new Array()
  let stakingTokenIds = new Array();
  let validatorPool: Fixture["validatorPool"]
  let dummyAddress = '0x000000000000000000000000000000000000dEaD'


  interface state {
    Admin: {
      StakeNFT: number | null, ValidatorNFT: number, MAD: number, ETH: number
    },
    StakeNFT: {
      StakeNFT: number, ValidatorNFT: number, MAD: number, ETH: number
    },
    ValidatorNFT: {
      StakeNFT: number, ValidatorNFT: number, MAD: number, ETH: number
    },
    ValidatorPool: {
      StakeNFT: number, ValidatorNFT: number, MAD: number, ETH: number
    },
    Factory: {
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

    fixture = await getFixture(false, true)
    const [admin, notAdmin1, notAdmin2, notAdmin3, notAdmin4] =
      fixture.namedSigners
    adminSigner = await getValidatorEthAccount(admin.address)

    await createValidators(validatorsSnapshots)
    await stakeValidators(validatorsSnapshots)

    // //We don't need all the validators for testing purposes so trimming arrays
    // validators.length = maxNumValidators
    // stakingTokenIds.length = maxNumValidators
  });

  describe("ETHDKG:", async function () {
    it("Schedule maintenance", async function () {
      await factoryCallAny(fixture, "validatorPool",
        "scheduleMaintenance")
    });

    it("Initialize ETHDKG", async function () {
      await factoryCallAny(fixture, "validatorPool",
        "registerValidators", [validators, stakingTokenIds])
      await factoryCallAny(fixture, "validatorPool",
        "initializeETHDKG")
    });

    xit("Should not allow pausing “consensus” before 1.5 without snapshots.", async function () {
      await fixture.validatorPool.
        connect(await getValidatorEthAccount(validatorsSnapshots[0])).
        pauseConsensus();

      // await expect(factoryCallAny(fixture, "snapshots",
      //   "pauseConsensus"))
      //   .to.be.revertedWith("ValidatorPool: Condition not met to stop consensus!");
    });

    it("Complete ETHDKG and check if the necessary state was set properly", async function () {
      await factoryCallAny(fixture, "validatorPool",
        "registerValidators", [validators, stakingTokenIds])
      let expectedState: state = await getCurrentState()
      // Complete ETHDKG Round
      await factoryCallAny(fixture, "validatorPool",
        "initializeETHDKG")
      await completeETHDKGRound(validatorsSnapshots, {
        ethdkg: fixture.ethdkg,
        validatorPool: fixture.validatorPool
      })
      expect(await fixture.validatorPool.isMaintenanceScheduled()).to.be.false
      //Consensus Running should be true
      await expect(factoryCallAny(fixture, "validatorPool",
        "registerValidators", [validators, stakingTokenIds]))
        .to.be.revertedWith("ValidatorPool: Error Madnet Consensus should be halted!")
    })

    it("Should not allow start ETHDKG if consensus is true or and ETHDKG round is running.", async function () {
      await factoryCallAny(fixture, "validatorPool",
        "registerValidators", [validators, stakingTokenIds])
      let expectedState: state = await getCurrentState()
      // Complete ETHDKG Round
      await factoryCallAny(fixture, "validatorPool",
        "initializeETHDKG")
      await completeETHDKGRound(validatorsSnapshots, {
        ethdkg: fixture.ethdkg,
        validatorPool: fixture.validatorPool
      })
      await expect(factoryCallAny(fixture, "validatorPool",
        "initializeETHDKG"))
        .to.be.revertedWith("ValidatorPool: Error Madnet Consensus should be halted!")
    })

    xit("Register validators, run ETHDKG to completion, schedule maintenance, do a snapshot, and see if the consensus is halted.", async function () {
      await factoryCallAny(fixture, "validatorPool",
        "registerValidators", [validators, stakingTokenIds])
      let expectedState: state = await getCurrentState()
      // Complete ETHDKG Round
      await factoryCallAny(fixture, "validatorPool",
        "initializeETHDKG")
      await completeETHDKGRound(validatorsSnapshots, {
        ethdkg: fixture.ethdkg,
        validatorPool: fixture.validatorPool
      })
      await factoryCallAny(fixture, "validatorPool",
        "scheduleMaintenance")
      await getSnapshots(4)
      //Consensus Running should be false
      factoryCallAny(fixture, "validatorPool",
        "registerValidators", [validators, stakingTokenIds])
    })

    xit("Test running ETHDKG with the arbitrary height sent as input, see if the value (the arbitrary height) is correctly added to the ethdkg completion event.", async function () {
      await factoryCallAny(fixture, "validatorPool",
        "registerValidators", [validators, stakingTokenIds])
      let expectedState: state = await getCurrentState()
      // Complete ETHDKG Round
      await factoryCallAnyFrom(fixture, "validatorPool", "ethdkg",
        "initializeETHDKG")
      await completeETHDKGRound(validatorsSnapshots, {
        ethdkg: fixture.ethdkg,
        validatorPool: fixture.validatorPool
      })
      await factoryCallAny(fixture, "validatorPool",
        "scheduleMaintenance")
      await getSnapshots(4)

      await expect(
        // fixture.ethdkg.
        //   connect(await getValidatorEthAccount(validatorsSnapshots[0])).
        //   setCustomMadnetHeight(4)
        factoryCallAny(fixture, "validatorPool",
          "setCustomMadnetHeight", [4])
      )
        .to.emit(fixture.ethdkg, 'ValidatorSetCompleted')
        .withArgs(
          0,
          0,
          fixture.snapshots.getEpoch(),
          fixture.snapshots.getCommittedHeightFromLatestSnapshot(),
          fixture.snapshots.getMadnetHeightFromSnapshot(await fixture.snapshots.getEpoch()),
          0x0,
          0x0,
          0x0,
          0x0
        );
    })


  })

  describe("Registration:", async function () {

    it("Should not allow registering validators if the STAKENFT position doesn’t have enough MADTokens staked", async function () {
      let rcpt = await factoryCallAny(fixture, "validatorPool",
        "setStakeAmount", [stakeAmountMadWei.add(1)]) //Add 1 to max amount allowed
      expect(rcpt.status).to.equal(1)
      await expect(
        factoryCallAny(fixture, "validatorPool",
          "registerValidators", [validators, stakingTokenIds])).
        to.be.revertedWith("ValidatorStakeNFT: Error, the Stake position doesn't have enough funds!")
    })

    it("Should not allow registering more validators that the current number of free spots in the pool", async function () {
      let rcpt = await factoryCallAny(fixture, "validatorPool",
        "setMaxNumValidators", [maxNumValidators - 1]) // Set maxNumValidators to 1 under default number of validators
      await expect(
        factoryCallAny(fixture, "validatorPool",
          "registerValidators", [validators, stakingTokenIds])).
        to.be.revertedWith("ValidatorPool: There are not enough free spots for all new validators!")
    })

    it("Should not allow registering validators if the size of the input data is not correct", async function () {

      validators.length = maxNumValidators
      stakingTokenIds.length = maxNumValidators - 1
      await expect(
        factoryCallAny(fixture, "validatorPool",
          "registerValidators", [validators, stakingTokenIds])).
        to.be.revertedWith("ValidatorPool: Both input array should have same length!")
    })

    it('Should not allow registering validators if "Madnet consensus is running" or ETHDKG round is running', async function () {
      await factoryCallAny(fixture, "validatorPool",
        "registerValidators", [validators, stakingTokenIds])
      let expectedState: state = await getCurrentState()
      // Complete ETHDKG Round
      await factoryCallAny(fixture, "validatorPool",
        "initializeETHDKG")
      await completeETHDKGRound(validatorsSnapshots, {
        ethdkg: fixture.ethdkg,
        validatorPool: fixture.validatorPool
      })
      await expect(factoryCallAny(fixture, "validatorPool",
        "registerValidators", [validators, stakingTokenIds]))
        .to.be.revertedWith("ValidatorPool: Error Madnet Consensus should be halted!")
    })

    it("Should not allow registering validators if the STAKENFT position was not given permissions for the ValidatorPool contract burn it", async function () {
      for (const tokenID of stakingTokenIds) {
        //Disallow validatorPool to withdraw validator's NFT from StakeNFT
        await factoryCallAny(fixture, "stakeNFT",
          "approve", [dummyAddress, tokenID])
      }
      await expect(
        factoryCallAny(fixture, "validatorPool",
          "registerValidators", [validators, stakingTokenIds]))
        .to.be.revertedWith("ERC721: transfer caller is not owner nor approved")
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
        factoryCallAny(fixture, "validatorPool",
          "registerValidators", [validators, stakingTokenIds]))
        .to.be.revertedWith("ValidatorPool: Address is already a validator or it is in the exiting line!")
    })

    it("Should not allow registering an address that is in the exiting queue", async function () {
      await
        factoryCallAny(fixture, "validatorPool",
          "registerValidators", [validators, stakingTokenIds])
      showState("after registering", await getCurrentState())
      await
        factoryCallAny(fixture, "validatorPool",
          "unregisterValidators", [validators])
      showState("after un-registering", await getCurrentState())
      await createValidators(validatorsSnapshots)
      await stakeValidators(validatorsSnapshots)
      await expect(
        factoryCallAny(fixture, "validatorPool",
          "registerValidators", [validators, stakingTokenIds]))
        .to.be.revertedWith("ValidatorPool: Address is already a validator or it is in the exiting line!")
    })

    it("Should successfully register validators if all conditions are met", async function () {
      let expectedState: state = await getCurrentState()
      //Expect that NFTs are transferred from each validator to ValidatorPool sd ValidatorNFTs
      validators.map((element, index) => {
        expectedState.Factory.StakeNFT--
        expectedState.ValidatorPool.ValidatorNFT++
      })
      //Expect that all validators funds are transferred from StakeNFT to ValidatorNFT
      expectedState.StakeNFT.MAD -= stakeAmount * validators.length
      expectedState.ValidatorNFT.MAD += stakeAmount * validators.length
      // Register validators
      await factoryCallAny(fixture, "validatorPool",
        "registerValidators", [validators, stakingTokenIds])
      let currentState: state = await getCurrentState()
      await showState("after registering", currentState)
      await showState("Expected state after claiming exiting NFT position", expectedState)
      await showState("Current state after claiming exiting NFT position", currentState)

      expect(currentState).
        to.be.deep.equal(expectedState)
    });

    it("Set and get the validator's location after registering", async function () {
      await factoryCallAny(fixture, "validatorPool",
        "registerValidators", [validators, stakingTokenIds])
      let currentState: state = await getCurrentState()
      await showState("after registering", currentState)
      await fixture.validatorPool.
        connect(await getValidatorEthAccount(validatorsSnapshots[0])).
        setLocation("1.1.1.1")
      expect(await fixture.validatorPool.
        getLocation(await validators[0])).
        to.be.equal("1.1.1.1")
    });

    it("Should not allow non-validator to set an IP location", async function () {
      await factoryCallAny(fixture, "validatorPool",
        "registerValidators", [validators, stakingTokenIds])
      let currentState: state = await getCurrentState()
      await showState("after registering", currentState)
      // Original Validators has all the validators not only the maximun to register
      // Position 5 is not a register validator
      await expect(fixture.validatorPool.
        connect(adminSigner).
        setLocation("1.1.1.1"))
        .to.be.revertedWith('ValidatorPool: Only validators allowed!')
    });

  })

  describe("Unregistration:", async function () {

    it("Should not allow unregistering of non-validators (even in the middle of array of validators)", async function () {
      await
        factoryCallAny(fixture, "validatorPool",
          "registerValidators", [validators, stakingTokenIds])
      //Set a non validator address in the middle of array for un-registering
      validators[1] = '0x000000000000000000000000000000000000dEaD'
      await expect(
        factoryCallAny(fixture, "validatorPool",
          "unregisterValidators", [validators]))
        .to.be.revertedWith("ValidatorPool: Address is not a validator_!")
    })

    it("Should not allow unregistering if consensus or an ETHDKG round is running", async function () {
      await factoryCallAny(fixture, "validatorPool",
        "registerValidators", [validators, stakingTokenIds])
      let expectedState: state = await getCurrentState()
      // Complete ETHDKG Round
      await factoryCallAny(fixture, "validatorPool",
        "initializeETHDKG")
      await completeETHDKGRound(validatorsSnapshots, {
        ethdkg: fixture.ethdkg,
        validatorPool: fixture.validatorPool
      })
      await expect(factoryCallAny(fixture, "validatorPool",
        "unregisterValidators", [validators]))
        .to.be.revertedWith("ValidatorPool: Error Madnet Consensus should be halted!")
    })

    it("Should not allow unregistering more addresses that in the pool", async function () {
      await
        factoryCallAny(fixture, "validatorPool",
          "registerValidators", [validators, stakingTokenIds])
      showState("after registering", await getCurrentState())
      //Add an extraother validator to unregister array
      validators.push('0x000000000000000000000000000000000000dEaD')
      stakingTokenIds.push(0)
      await expect(
        factoryCallAny(fixture, "validatorPool",
          "unregisterValidators", [validators]))
        .to.be.revertedWith("ValidatorPool: There are not enough validators to be removed!")
    })

    it("Should not allow registering an address that was unregistered and didn’t claim is stakeNFT position (i.e still in the exitingQueue).", async function () {
      await
        factoryCallAny(fixture, "validatorPool",
          "registerValidators", [validators, stakingTokenIds])
      showState("after registering", await getCurrentState())
      await
        factoryCallAny(fixture, "validatorPool",
          "unregisterValidators", [validators])
      showState("after un-registering", await getCurrentState())
      await createValidators(validatorsSnapshots)
      await stakeValidators(validatorsSnapshots)
      await expect(
        factoryCallAny(fixture, "validatorPool",
          "registerValidators", [validators, stakingTokenIds]))
        .to.be.revertedWith("ValidatorPool: Address is already a validator or it is in the exiting line!")
    })

    it("Should successfully unregister validators if all conditions are met", async function () {
      let expectedState: state = await getCurrentState()
      //Expect that NFT are transferred from ValidatorPool to Factory
      validators.map((element, index) => {
        expectedState.ValidatorPool.StakeNFT++
        expectedState.Factory.StakeNFT--
      })
      await factoryCallAny(fixture, "validatorPool",
        "registerValidators", [validators, stakingTokenIds])
      //  await showState("Current state after registering", await getCurrentState())
      await showState("after registering", expectedState)
      await factoryCallAny(fixture, "validatorPool",
        "unregisterValidators", [validators])
      await showState("after unregistering", expectedState)
      let currentState: state = await getCurrentState()
      await showState("Expected state after registering/un-registering", expectedState)
      await showState("Current state after registering/un-registering", currentState)
      expect(currentState).
        to.be.deep.equal(expectedState)
    });

    it("The validatorNFT position was correctly burned and the state of the contract was correctly set (e.g user should not be a validator but should be accusable).", async function () {
      let expectedState: state = await getCurrentState()
      //Expect that NFT are transferred to ValidatorPool as StakeNFTs
      validators.map((element, index) => {
        expectedState.ValidatorPool.StakeNFT++
        expectedState.Factory.StakeNFT--
      })
      await factoryCallAny(fixture, "validatorPool",
        "registerValidators", [validators, stakingTokenIds])
      await factoryCallAny(fixture, "validatorPool",
        "unregisterAllValidators")
      let currentState: state = await getCurrentState()
      await showState("Expected state after unregister all validators", currentState)
      await showState("Expected state after unregister all validators", expectedState)
      expect(currentState).
        to.be.deep.equal(expectedState)
      expect((await
        fixture.validatorPool
          .isAccusable(validatorsSnapshots[0].address))
      ).to.be.true
    });

  })
  describe("Claim stakeNFT position after unregistering :", async function () {

    it("Should successfully claim exiting NFT positions of all validators", async function () {
      //As this is a complete cycle, expect the initial state to be exactly the same as the final state
      let expectedState: state = await getCurrentState()
      validators.map((element, index) => {
        expectedState.Factory.StakeNFT--
        expectedState.validators[index].NFT++
      })
      await factoryCallAny(fixture, "validatorPool",
        "registerValidators", [validators, stakingTokenIds])
      await factoryCallAny(fixture, "validatorPool",
        "unregisterValidators", [validators])
      await getSnapshots(4)
      for (const validatorsSnapshot of validatorsSnapshots) {
        await fixture.validatorPool
          .connect(await getValidatorEthAccount(validatorsSnapshot))
          .claimExitingNFTPosition()
        // await factoryCallAny(fixture, "validatorPool",
        // "claimExitingNFTPosition")
      }
      let currentState: state = await getCurrentState()
      await showState("Expected state after claiming exiting NFT position", expectedState)
      await showState("Current state after claiming exiting NFT position", currentState)
      expect(currentState).
        to.be.deep.equal(expectedState)
    })

    it("After claiming, register the user again with a new stakenft position.", async function () {
      //As this is a complete cycle, expect the initial state to be exactly the same as the final state
      let expectedState: state = await getCurrentState()
      validators.map((element, index) => {
        expectedState.Factory.StakeNFT--
        expectedState.validators[index].NFT++
        //New Staking
        expectedState.ValidatorPool.ValidatorNFT++
        expectedState.Admin.MAD -= stakeAmount
      })
      await factoryCallAny(fixture, "validatorPool",
        "registerValidators", [validators, stakingTokenIds])
      await factoryCallAny(fixture, "validatorPool",
        "unregisterValidators", [validators])
      await getSnapshots(4)
      for (const validatorsSnapshot of validatorsSnapshots) {
        await fixture.validatorPool
          .connect(await getValidatorEthAccount(validatorsSnapshot))
          .claimExitingNFTPosition()
        // await factoryCallAny(fixture, "validatorPool",
        // "claimExitingNFTPosition")
      }
      await showState("After claiming:", await getCurrentState())
      //Re-initialize validators
      await createValidators(validatorsSnapshots)
      await stakeValidators(validatorsSnapshots)
      await factoryCallAny(fixture, "validatorPool",
        "registerValidators", [validators, stakingTokenIds])
      let currentState: state = await getCurrentState()
      //Expect that validators funds are transfered again to ValidatorNFT  
      expectedState.ValidatorNFT.MAD += stakeAmount * validators.length
      await showState("Expected state after claiming exiting NFT position", expectedState)
      await showState("Current state after claiming exiting NFT position", currentState)
      expect(currentState).
        to.be.deep.equal(expectedState)
    })

    xit("Should not allow users to claim stakenft position before claim period has passed", async function () {
      await factoryCallAny(fixture, "validatorPool",
        "registerValidators", [validators, stakingTokenIds])
      await factoryCallAny(fixture, "validatorPool",
        "unregisterValidators", [validators])
      await getSnapshots(4)
      stakingTokenIds = []
      for (const validator of validatorsSnapshots) {
        let tx = await fixture.validatorPool
          .connect(await getValidatorEthAccount(validator))
          .claimExitingNFTPosition() as ContractTransaction
        let receipt = await ethers.provider.getTransactionReceipt(tx.hash)
        //When a token is claimed it gets burned an minted so gets a new tokenId so we need to update array for re-registration
        const tokenId = BigNumber.from(receipt.logs[0].topics[3])
        stakingTokenIds.push(tokenId)
      }
      await showState("After claiming:", await getCurrentState())
      // After claiming, position is locked for a period of 172800 Madnet epochs
      // To perform this test with no revert, POSITION_LOCK_PERIOD can be set to 3
      // in ValidatorPool and then take 4 snapshots
      // await getSnapshots(4)
      await expect(
        factoryCallAny(fixture, "validatorPool",
          "registerValidators", [validators, stakingTokenIds]))
        .to.be.revertedWith("StakeNFT: The position is not ready to be burned!")
    })

  })
  describe("Collecting:", async function () {

    it("Should successfully collect profit of validators", async function () {
      await factoryCallAny(fixture, "validatorPool",
        "registerValidators", [validators, stakingTokenIds])
      let expectedState: state = await getCurrentState()
      //Simulate 4 ETH from admin earned by pool after validators registration
      expectedState.Admin.ETH -= 4
      await fixture.validatorNFT
        .connect(adminSigner)
        .depositEth(42, {
          value: ethers.utils.parseEther("4.0")
        })
      //Expect ValidatorNFT balance to increment by earnings
      expectedState.ValidatorNFT.ETH += 4
      // Complete ETHDKG Round
      await showState("After deposit:", expectedState)
      await factoryCallAny(fixture, "validatorPool",
        "initializeETHDKG")
      await completeETHDKGRound(validatorsSnapshots, {
        ethdkg: fixture.ethdkg,
        validatorPool: fixture.validatorPool
      })
      await fixture.validatorPool
        .connect(await getValidatorEthAccount(validatorsSnapshots[0]))
        .collectProfits()
      // Expect that a fraction of the earnings (1/4 validators) to be transfer from ValidatorNFT to collecting validator
      expectedState.ValidatorNFT.ETH -= 1
      expectedState.validators[0].ETH += 1
      let currentState: state = await getCurrentState()
      await showState("Expected state after collect profit", expectedState)
      await showState("Current state after collect profit", currentState)
      expect(currentState).
        to.be.deep.equal(expectedState)
    })
  })
  describe("Slashing:", async function () {

    xit("Minor slash a validator then major slash it", async function () {

      let expectedState: state = await getCurrentState()
      // Complete ETHDKG Round

      await factoryCallAnyFrom(fixture, "ethdkg", "validatorPool",
        "minorSlash", [validators[0], validators[1]])
    })

  })

  const getSnapshots = (async (numberOfSnapshots: number) => {
    if (process.env.npm_config_detailed == "true") console.log("Taking", numberOfSnapshots, "snapshots");
    let mock = await completeETHDKGRound(validatorsSnapshots)
    for (let i = 0; i <= numberOfSnapshots; i++) {
      let tx = await fixture.snapshots
        .connect(await getValidatorEthAccount(validatorsSnapshots[0]))
        .snapshot(validSnapshot1024.GroupSignature, validSnapshot1024.BClaims)
    }
  })

  async function getCurrentState() {
    // System state
    let state: state = {
      Admin: {
        StakeNFT: null, ValidatorNFT: 0, MAD: 0, ETH: 0
      },
      StakeNFT: {
        StakeNFT: 0, ValidatorNFT: 0, MAD: 0, ETH: 0
      },
      ValidatorNFT: {
        StakeNFT: 0, ValidatorNFT: 0, MAD: 0, ETH: 0
      },
      ValidatorPool: {
        StakeNFT: 0, ValidatorNFT: 0, MAD: 0, ETH: 0
      },
      Factory: {
        StakeNFT: 0, ValidatorNFT: 0, MAD: 0, ETH: 0
      },
      validators: [
        { NFT: 0, MAD: 0, ETH: 0 },
        { NFT: 0, MAD: 0, ETH: 0 },
        { NFT: 0, MAD: 0, ETH: 0 },
        { NFT: 0, MAD: 0, ETH: 0 },
      ],
    }
    // Get state for admin
    state.Admin.StakeNFT = parseFloat((await fixture.stakeNFT.balanceOf(
      await adminSigner.getAddress())).toString())
    state.Admin.ValidatorNFT = parseFloat((await fixture.validatorNFT.balanceOf(
      await adminSigner.getAddress())).toString())
    state.Admin.MAD = parseFloat(ethers.utils.formatEther(await fixture.madToken.balanceOf(
      await adminSigner.getAddress())))
    state.Admin.ETH = parseFloat((+ethers.utils.formatEther(await ethers.provider.getBalance(
      await adminSigner.getAddress()))).toFixed(0))
    // Get state for validators
    for (let i = 0; i < state.validators.length; i++) {
      state.validators[i].NFT = parseFloat((await fixture.stakeNFT.balanceOf(
        validators[i])).toString())
      state.validators[i].MAD = parseFloat(ethers.utils.formatEther(await fixture.madToken.balanceOf(
        validators[i])))
      state.validators[i].ETH = parseFloat((+ethers.utils.formatEther(await ethers.provider.getBalance(validators[i]))).toFixed(0))
    }
    // Contract data
    let contractData = [
      { contractState: state.StakeNFT, contractAddress: fixture.stakeNFT.address },
      { contractState: state.ValidatorNFT, contractAddress: fixture.validatorNFT.address },
      { contractState: state.ValidatorPool, contractAddress: fixture.validatorPool.address },
      { contractState: state.Factory, contractAddress: fixture.factory.address },
    ]
    // Get state for contracts
    for (let i = 0; i < contractData.length; i++) {
      contractData[i].contractState.StakeNFT = parseInt((await fixture.stakeNFT.balanceOf(
        contractData[i].contractAddress)).toString())
      contractData[i].contractState.ValidatorNFT = parseInt((await fixture.validatorNFT.balanceOf(
        contractData[i].contractAddress)).toString())
      contractData[i].contractState.MAD = parseFloat(ethers.utils.formatEther(await fixture.madToken.balanceOf(
        contractData[i].contractAddress)))
      contractData[i].contractState.ETH = parseFloat((+ethers.utils.formatEther(
        await ethers.provider.getBalance(contractData[i].contractAddress))).toFixed(0))
    }
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
    // Approve ValidatorPool to withdraw MAD tokens of validators
    await fixture.madToken.
      approve(fixture.validatorPool.address,
        stakeAmountMadWei.mul(_validatorsSnapshots.length));
    for (const validator of _validatorsSnapshots) {
      await getValidatorEthAccount(validator)
      validators.push(validator.address)
      // //Send MAD tokens to each validator
      // await fixture.madToken.
      //   transfer(validator.address, stakeAmountMadWei);
    }
    await fixture.madToken.
      connect(adminSigner).
      approve(fixture.stakeNFT.address, stakeAmountMadWei.mul(_validatorsSnapshots.length));
    await showState("After creating:", await getCurrentState())
  }

  async function stakeValidators(_validatorsSnapshots: ValidatorRawData[]) {
    stakingTokenIds = []
    for (const validator of _validatorsSnapshots) {
      // Stake all MAD tokens
      let tx = await fixture.stakeNFT.
        connect(adminSigner).
        mintTo(fixture.factory.address, stakeAmountMadWei, lockTime);
      // Get the proof of staking (NFT's tokenID)
      let tokenID = await getTokenIdFromTx(tx)
      stakingTokenIds.push(tokenID);
      //Allow validatorPool to withdraw NFT from StakeNFT
      // await fixture.stakeNFT.
      //   connect(adminSigner).
      //   approve(fixture.validatorPool.address, tokenID);

      await factoryCallAny(fixture, "stakeNFT",
        "approve", [fixture.validatorPool.address, tokenID])

    }
    await showState("After staking:", await getCurrentState())
  }

});





