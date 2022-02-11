import { Fixture, getFixture, getTokenIdFromTx, PLACEHOLDER_ADDRESS } from '../setup'
import { ethers } from 'hardhat'
import { expect, assert } from '../../../chai-setup'
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers'
import {
  addValidators,
  initializeETHDKG,
  getValidatorEthAccount,
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
import { validatorsSnapshots, validSnapshot1024 } from './assets/4-validators-snapshots-1'

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
    await fixture.validatorPool
      .connect(adminSigner)
      .setETHDKG(fixture.ethdkg.address)
    notAdmin1Signer = await getValidatorEthAccount(notAdmin1.address)
    randomerSigner = await getValidatorEthAccount(randomer.address)

    for (const validator of validatorsSnapshots ) {
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

  it('Does not allow snapshot caller did not particopate in the last ETHDKG round', async function () {
    let junkData =
      '0x0000000000000000000000000000000000000000000000000000006d6168616d'
    let validValidator = await getValidatorEthAccount(validatorsSnapshots[0])
    await expect(
      fixture.snapshots.connect(validValidator).snapshot(junkData, junkData)
    ).to.be.revertedWith(
      `Snapshots: Caller didn't participate in the last ethdkg round!`
    )
  })

  it('Do a snapshot', async function () {
    let mock = await completeETHDKGRound(validatorsSnapshots);

    const Snapshots = await ethers.getContractFactory("Snapshots");
    const snapshots = await Snapshots.deploy(
        mock[0].address,
        mock[1].address,
        1,
        mock[1].address
    );
    await snapshots.deployed();

    let tx = await snapshots.connect(await getValidatorEthAccount(validatorsSnapshots[0])).snapshot(validSnapshot1024.GroupSignature, validSnapshot1024.BClaims)
  })
})
