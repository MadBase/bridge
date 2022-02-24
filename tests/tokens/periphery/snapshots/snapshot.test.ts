import {
  Fixture,
  getFixture,
  getTokenIdFromTx,
  PLACEHOLDER_ADDRESS,
  getValidatorEthAccount
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
    fixture = await getFixture(true, false)
    const [
      admin,
      notAdmin1,
      notAdmin2,
      notAdmin3,
      notAdmin4,
      randomer
    ] = fixture.namedSigners
    adminSigner = await getValidatorEthAccount(admin.address)
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

  it('Does not allow snapshot consensus is not running', async function () {
    let junkData =
      '0x0000000000000000000000000000000000000000000000000000006d6168616d'
    let validValidator = await getValidatorEthAccount(validatorsSnapshots[0])
    await expect(
      fixture.snapshots.connect(validValidator).snapshot(junkData, junkData)
    ).to.be.revertedWith(`Snapshots: Consensus is not running!`)
  })
})

describe('With successful ETHDKG round completed', () => {
  let fixture: Fixture
  let snapshots: Snapshots
  beforeEach(async function () {
    fixture = await getFixture(true, false)

    await completeETHDKGRound(validatorsSnapshots, {
      ethdkg: fixture.ethdkg,
      validatorPool: fixture.validatorPool
    })

    snapshots = fixture.snapshots as Snapshots
  })

  /*
  FYI this scenario is not possible to cover due to the fact that no validators can be registered but not participate in the ETHDKG round.
  
  it('Does not allow snapshot caller did not participate in the last ETHDKG round', async function () {
    await expect(
      snapshots
        .connect(await getValidatorEthAccount(validatorsSnapshots[0]))
        .snapshot(validSnapshot1024.GroupSignature, validSnapshot1024.BClaims)
    ).to.be.revertedWith(
      `Snapshots: Caller didn't participate in the last ethdkg round!`
    )
  })*/

  it('Reverts when validator not elected to do snapshot', async function () {
    let junkData =
      '0x0000000000000000000000000000000000000000000000000000006d6168616d'
    await expect(
      snapshots
        .connect(await getValidatorEthAccount(validatorsSnapshots[0]))
        .snapshot(junkData, junkData)
    ).to.be.revertedWith(`Snapshots: Validator not elected to do snapshot!`)
  })

  it('Reverts when snapshot data contains invalid height', async function () {
    await expect(
      snapshots
        .connect(
          await getValidatorEthAccount(
            validatorsSnapshots[invalidSnapshot500.validatorIndex]
          )
        )
        .snapshot(invalidSnapshot500.GroupSignature, invalidSnapshot500.BClaims)
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
  it('Reverts when snapshot data contains incorrect signature', async function () {
    await expect(
      snapshots
        .connect(
          await getValidatorEthAccount(
            validatorsSnapshots[invalidSnapshotIncorrectSig.validatorIndex]
          )
        )
        .snapshot(
          validSnapshot1024.GroupSignature,
          invalidSnapshotIncorrectSig.BClaims
        )
    ).to.be.revertedWith(`Snapshots: Signature verification failed!`)
  })

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

  describe('With successful snapshot completed', () => {
    let snapshotNumber: BigNumber

    beforeEach(async function () {
      await snapshots
        .connect(await getValidatorEthAccount(validatorsSnapshots[0]))
        .snapshot(validSnapshot1024.GroupSignature, validSnapshot1024.BClaims)
      snapshotNumber = BigNumber.from(1)
    })

    it('Does not allow snapshot with data from previous snapshot', async function () {
      let validValidator = await getValidatorEthAccount(validatorsSnapshots[0])
      await expect(
        fixture.snapshots
          .connect(validValidator)
          .snapshot(validSnapshot1024.GroupSignature, validSnapshot1024.BClaims)
      ).to.be.revertedWith(`Snapshots: Incorrect Madnet height for snapshot!`)
    })

    it('Does not allow snapshot if ETHDKG round is Running', async function () {
      await fixture.validatorPool.scheduleMaintenance()
      await snapshots
        .connect(await getValidatorEthAccount(validatorsSnapshots[0]))
        .snapshot(validSnapshot2048.GroupSignature, validSnapshot2048.BClaims)
      await fixture.validatorPool.initializeETHDKG()
      let junkData =
        '0x0000000000000000000000000000000000000000000000000000006d6168616d'
      let validValidator = await getValidatorEthAccount(validatorsSnapshots[0])
      await expect(
        fixture.snapshots.connect(validValidator).snapshot(junkData, junkData)
      ).to.be.revertedWith(`Snapshots: Consensus is not running!`)
    })

    it('getLatestSnapshot returns correct snapshot data', async function () {
      const expectedSignature = [
        BigNumber.from(
          '1255022359938341263552008964652785372053438514616831677297275448520908946987'
        ),
        BigNumber.from(
          '14701588978138831040868532458058035157389630420138682442198805011661026372629'
        )
      ]
      const expectedChainId = BigNumber.from(1)
      const expectedHeight = BigNumber.from(1024)
      const expectedTxCount = BigNumber.from(0)
      const expectedPrevBlock = BigNumber.from(
        '0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470'
      )
      const expectedTxRoot = BigNumber.from(
        '0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470'
      )
      const expectedStateRoot = BigNumber.from(
        '0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470'
      )
      const expectedHeaderRoot = BigNumber.from(
        '0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470'
      )

      const snapshotData = await snapshots
        .connect(await getValidatorEthAccount(validatorsSnapshots[0]))
        .getLatestSnapshot()

      await expect(snapshotData.signature[0]).to.be.equal(expectedSignature[0])
      await expect(snapshotData.signature[1]).to.be.equal(expectedSignature[1])

      const blockClaims = snapshotData.blockClaims
      await expect(blockClaims.chainId).to.be.equal(expectedChainId)
      await expect(blockClaims.height).to.be.equal(expectedHeight)
      await expect(blockClaims.txCount).to.be.equal(expectedTxCount)
      await expect(blockClaims.prevBlock).to.be.equal(expectedPrevBlock)
      await expect(blockClaims.txRoot).to.be.equal(expectedTxRoot)
      await expect(blockClaims.stateRoot).to.be.equal(expectedStateRoot)
      await expect(blockClaims.headerRoot).to.be.equal(expectedHeaderRoot)
    })

    it('getSignatureFromSnapshot returns correct snapshot data', async function () {
      const expectedSignature = [
        BigNumber.from(
          '1255022359938341263552008964652785372053438514616831677297275448520908946987'
        ),
        BigNumber.from(
          '14701588978138831040868532458058035157389630420138682442198805011661026372629'
        )
      ]

      const signature = await snapshots
        .connect(await getValidatorEthAccount(validatorsSnapshots[0]))
        .getSignatureFromSnapshot(snapshotNumber)

      await expect(signature[0]).to.be.equal(expectedSignature[0])
      await expect(signature[1]).to.be.equal(expectedSignature[1])
    })

    it('getSignatureFromLatestSnapshot returns correct snapshot data', async function () {
      const expectedSignature = [
        BigNumber.from(
          '1255022359938341263552008964652785372053438514616831677297275448520908946987'
        ),
        BigNumber.from(
          '14701588978138831040868532458058035157389630420138682442198805011661026372629'
        )
      ]

      const signature = await snapshots
        .connect(await getValidatorEthAccount(validatorsSnapshots[0]))
        .getSignatureFromLatestSnapshot()

      await expect(signature[0]).to.be.equal(expectedSignature[0])
      await expect(signature[1]).to.be.equal(expectedSignature[1])
    })

    it('getBlockClaimsFromSnapshot returns correct data', async function () {
      const expectedChainId = BigNumber.from(1)
      const expectedHeight = BigNumber.from(1024)
      const expectedTxCount = BigNumber.from(0)
      const expectedPrevBlock = BigNumber.from(
        '0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470'
      )
      const expectedTxRoot = BigNumber.from(
        '0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470'
      )
      const expectedStateRoot = BigNumber.from(
        '0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470'
      )
      const expectedHeaderRoot = BigNumber.from(
        '0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470'
      )

      const blockClaims = await snapshots
        .connect(await getValidatorEthAccount(validatorsSnapshots[0]))
        .getBlockClaimsFromSnapshot(snapshotNumber)

      await expect(blockClaims.chainId).to.be.equal(expectedChainId)
      await expect(blockClaims.height).to.be.equal(expectedHeight)
      await expect(blockClaims.txCount).to.be.equal(expectedTxCount)
      await expect(blockClaims.prevBlock).to.be.equal(expectedPrevBlock)
      await expect(blockClaims.txRoot).to.be.equal(expectedTxRoot)
      await expect(blockClaims.stateRoot).to.be.equal(expectedStateRoot)
      await expect(blockClaims.headerRoot).to.be.equal(expectedHeaderRoot)
    })

    it('getBlockClaimsFromLatestSnapshot returns correct data', async function () {
      const expectedChainId = BigNumber.from(1)
      const expectedHeight = BigNumber.from(1024)
      const expectedTxCount = BigNumber.from(0)
      const expectedPrevBlock = BigNumber.from(
        '0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470'
      )
      const expectedTxRoot = BigNumber.from(
        '0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470'
      )
      const expectedStateRoot = BigNumber.from(
        '0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470'
      )
      const expectedHeaderRoot = BigNumber.from(
        '0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470'
      )

      const blockClaims = await snapshots
        .connect(await getValidatorEthAccount(validatorsSnapshots[0]))
        .getBlockClaimsFromLatestSnapshot()

      await expect(blockClaims.chainId).to.be.equal(expectedChainId)
      await expect(blockClaims.height).to.be.equal(expectedHeight)
      await expect(blockClaims.txCount).to.be.equal(expectedTxCount)
      await expect(blockClaims.prevBlock).to.be.equal(expectedPrevBlock)
      await expect(blockClaims.txRoot).to.be.equal(expectedTxRoot)
      await expect(blockClaims.stateRoot).to.be.equal(expectedStateRoot)
      await expect(blockClaims.headerRoot).to.be.equal(expectedHeaderRoot)
    })

    it('getMadnetHeightFromSnapshot returns correct data', async function () {
      const expectedHeight = BigNumber.from(1024)

      const height = await snapshots
        .connect(await getValidatorEthAccount(validatorsSnapshots[0]))
        .getMadnetHeightFromSnapshot(snapshotNumber)

      await expect(height).to.be.equal(expectedHeight)
    })

    it('getMadnetHeightFromLatestSnapshot returns correct data', async function () {
      const expectedHeight = BigNumber.from(1024)

      const height = await snapshots
        .connect(await getValidatorEthAccount(validatorsSnapshots[0]))
        .getMadnetHeightFromLatestSnapshot()

      await expect(height).to.be.equal(expectedHeight)
    })

    it('getChainIdFromSnapshot returns correct chain id', async function () {
      const expectedChainId = 1
      const chainId = await snapshots
        .connect(await getValidatorEthAccount(validatorsSnapshots[0]))
        .getChainIdFromSnapshot(snapshotNumber)

      await expect(chainId).to.be.equal(expectedChainId)
    })

    it('getChainIdFromLatestSnapshot returns correct chain id', async function () {
      const expectedChainId = 1
      const chainId = await snapshots
        .connect(await getValidatorEthAccount(validatorsSnapshots[0]))
        .getChainIdFromLatestSnapshot()

      await expect(chainId).to.be.equal(expectedChainId)
    })
  })
})
