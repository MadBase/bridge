import {
  Fixture,
  getFixture,
  getTokenIdFromTx,
  getValidatorEthAccount,
  PLACEHOLDER_ADDRESS
} from '../setup'
import { ethers } from 'hardhat'
import { expect, assert } from '../../../chai-setup'
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers'
import {
  addValidators,
  initializeETHDKG,
  completeETHDKGRound
} from '../ethdkg/setup'
import {
  BigNumber,
  BigNumberish,
  ContractTransaction,
  Signer,
  utils,
  Wallet
} from 'ethers'
import {
  validatorsSnapshots,
  validSnapshot1024,
  invalidSnapshot500,
  invalidSnapshotChainID2,
  invalidSnapshotIncorrectSig,
  validSnapshot2048
} from './assets/4-validators-snapshots-1'
import { IValidatorPool, Snapshots } from '../../../../typechain-types'

describe('Tests Snapshots methods', () => {
  let fixture: Fixture
  let adminSigner: Signer
  let notAdmin1Signer: Signer
  let randomerSigner: Signer
  // let minimunStake = ethers.utils.parseUnits("20001", 18);
  let maxNumValidators = 5
  let stakeAmount = 20000
  let minimunStake = ethers.utils.parseUnits(stakeAmount.toString(), 18)
  let stakeAmountMadWei = ethers.utils.parseUnits(stakeAmount.toString(), 18)
  let lockTime = 1
  let validators = new Array()
  let stakingTokenIds = new Array()

  beforeEach(async function () {
    validators = []
    stakingTokenIds = []
    fixture = await getFixture()
    const [
      admin,
      notAdmin1,
      notAdmin2,
      notAdmin3,
      notAdmin4,
      randomer
    ] = fixture.namedSigners
    adminSigner = await getValidatorEthAccount(admin.address)
    await fixture.validatorNFT
      .connect(adminSigner)
      .setAdmin(fixture.validatorPool.address)
    notAdmin1Signer = await getValidatorEthAccount(notAdmin1.address)
    randomerSigner = await getValidatorEthAccount(randomer.address)

    for (const validator of validatorsSnapshots) {
      validators.push(validator.address)
    }

    await fixture.madToken.approve(
      fixture.validatorPool.address,
      stakeAmountMadWei.mul(validators.length)
    )
    await fixture.madToken.approve(
      fixture.stakeNFT.address,
      stakeAmountMadWei.mul(validators.length)
    )

    for (const validator of validatorsSnapshots) {
      let tx = await fixture.stakeNFT
        .connect(adminSigner)
        .mintTo(validator.address, stakeAmountMadWei, lockTime)
      let tokenId = getTokenIdFromTx(tx)
      stakingTokenIds.push(tokenId)
      await fixture.stakeNFT
        .connect(await getValidatorEthAccount(validator))
        .setApprovalForAll(fixture.validatorPool.address, true)
    }

    await fixture.validatorPool
      .connect(adminSigner)
      .registerValidators(validators, stakingTokenIds)
  })

  it('Does not allow snapshot if sender is not validator', async function () {
    let junkData =
      '0x0000000000000000000000000000000000000000000000000000006d6168616d'
    await expect(
      fixture.snapshots.connect(randomerSigner).snapshot(junkData, junkData)
    ).to.be.revertedWith('Snapshots: Only validators allowed!')
  })

  it('Does not allow snapshot if ETHDKG round is Running', async function () {
    await fixture.validatorPool.connect(adminSigner).initializeETHDKG()
    let junkData =
      '0x0000000000000000000000000000000000000000000000000000006d6168616d'
    let validValidator = await getValidatorEthAccount(validatorsSnapshots[0])
    await expect(
      fixture.snapshots.connect(validValidator).snapshot(junkData, junkData)
    ).to.be.revertedWith(`Snapshots: There's an ETHDKG round running!`)
  })

  it('Does not allow snapshot if validator not elected to do snapshot', async function () {
    let junkData =
      '0x0000000000000000000000000000000000000000000000000000006d6168616d'
    let validValidator = await getValidatorEthAccount(validatorsSnapshots[0])
    await expect(
      fixture.snapshots.connect(validValidator).snapshot(junkData, junkData)
    ).to.be.revertedWith(`Snapshots: Validator not elected to do snapshot!`)
  })

  describe('With successful ETHDKG round completed', () => {
    let snapshots: Snapshots
    beforeEach(async function () {
      let mock = await completeETHDKGRound(validatorsSnapshots, {
        ethdkg: fixture.ethdkg,
        validatorPool: fixture.validatorPool
      })

      const Snapshots = await ethers.getContractFactory('Snapshots')
    //   snapshots = await Snapshots.deploy(
    //     mock[0].address,
    //     mock[1].address,
    //     1,
    //     mock[1].address
    //   )
    //   await snapshots.deployed()
    })

    // it('Does not allow snapshot caller did not participate in the last ETHDKG round', async function () {
    //   await expect(
    //     snapshots
    //       .connect(await getValidatorEthAccount(validatorsSnapshots[0]))
    //       .snapshot(validSnapshot1024.GroupSignature, validSnapshot1024.BClaims)
    //   ).to.be.revertedWith(
    //     `Snapshots: Caller didn't participate in the last ethdkg round!`
    //   )
    // })

    it('Reverts when snapshot data contains invalid height', async function () {
      await expect(
        snapshots
          .connect(
            await getValidatorEthAccount(
              validatorsSnapshots[invalidSnapshot500.validatorIndex]
            )
          )
          .snapshot(
            invalidSnapshot500.GroupSignature,
            invalidSnapshot500.BClaims
          )
      ).to.be.revertedWith(`Snapshots: Incorrect Madnet height for snapshot!`)
    })

    it('Reverts when snapshot data contains invalid chain id', async function () {
      await expect(
        snapshots
          .connect(
            await getValidatorEthAccount(
              validatorsSnapshots[invalidSnapshotChainID2.validatorIndex]
            )
          )
          .snapshot(
            invalidSnapshotChainID2.GroupSignature,
            invalidSnapshotChainID2.BClaims
          )
      ).to.be.revertedWith(`Snapshots: Incorrect chainID for snapshot!`)
    })

    // todo wrong public key failure happens first with this data
    // it('Reverts when snapshot data contains incorrect signature', async function () {
    //   await expect(
    //     snapshots
    //       .connect(await getValidatorEthAccount(validatorsSnapshots[invalidSnapshotIncorrectSig.validatorIndex]))
    //       .snapshot(
    //         invalidSnapshotIncorrectSig.GroupSignature,
    //         invalidSnapshotIncorrectSig.BClaims
    //       )
    //   ).to.be.revertedWith(`Snapshots: Signature verification failed!`)
    // })

    it('Reverts when snapshot data contains incorrect public key', async function () {
      await expect(
        snapshots
          .connect(
            await getValidatorEthAccount(
              validatorsSnapshots[invalidSnapshotIncorrectSig.validatorIndex]
            )
          )
          .snapshot(
            invalidSnapshotIncorrectSig.GroupSignature,
            invalidSnapshotIncorrectSig.BClaims
          )
      ).to.be.revertedWith(`Snapshots: Wrong master public key!`)
    })

    it('Successfully performs snapshot', async function () {
      const expectedChainId = 1
      const expectedEpoch = 1
      const expectedHeight = validSnapshot1024.height
      const expectedSafeToProceedConsensus = true

      await expect(
        snapshots
          .connect(await getValidatorEthAccount(validatorsSnapshots[0]))
          .snapshot(validSnapshot1024.GroupSignature, validSnapshot1024.BClaims)
      )
        .to.emit(snapshots, `SnapshotTaken`)
        .withArgs(
          expectedChainId,
          expectedEpoch,
          expectedHeight,
          ethers.utils.getAddress(validatorsSnapshots[0].address),
          expectedSafeToProceedConsensus
        )
    })
  })
})
