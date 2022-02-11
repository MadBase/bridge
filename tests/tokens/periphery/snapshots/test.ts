import { Fixture, getFixture, getTokenIdFromTx } from '../setup'
import { ethers } from 'hardhat'
import { expect, assert } from '../../../chai-setup'
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers'
import {
  addValidators,
  initializeETHDKG,
  getValidatorEthAccount
} from '../ethdkg/setup'
import {
  BigNumber,
  BigNumberish,
  ContractTransaction,
  Signer,
  utils,
  Wallet
} from 'ethers'

describe('Tests Snapshots methods', () => {
  let fixture: Fixture
  let adminSigner: SignerWithAddress
  let notAdmin1Signer: SignerWithAddress
  let randomerSigner: SignerWithAddress
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
    adminSigner = await ethers.getSigner(admin.address)
    await fixture.validatorNFT
      .connect(adminSigner)
      .setAdmin(fixture.validatorPool.address)
    await fixture.validatorPool
      .connect(adminSigner)
      .setETHDKG(fixture.ethdkg.address)
    notAdmin1Signer = await ethers.getSigner(notAdmin1.address)
    randomerSigner = await ethers.getSigner(randomer.address)
    fixture.namedSigners.map(async signer => {
      if (validators.length < 5) {
        // maximum validators by default
        validators.push(signer.address)
        // console.log("Signer", validators.length, "MAD balance:", await fixture.madToken.balanceOf(signer.address))
        // console.log("Signer", validators.length, "ETH balance:", await ethers.provider.getBalance(signer.address))
      }
    })
    await fixture.madToken.approve(
      fixture.validatorPool.address,
      stakeAmountMadWei.mul(validators.length)
    )
    await fixture.madToken.approve(
      fixture.stakeNFT.address,
      stakeAmountMadWei.mul(validators.length)
    )

    for (const validator of validators) {
      let tx = await fixture.stakeNFT
        .connect(adminSigner)
        .mintTo(validator, stakeAmountMadWei, lockTime)
      let tokenId = getTokenIdFromTx(tx)
      stakingTokenIds.push(tokenId)
      await fixture.stakeNFT
        .connect(await ethers.getSigner(validator))
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
    let validValidator = await ethers.getSigner(validators[0])
    await expect(
      fixture.snapshots.connect(validValidator).snapshot(junkData, junkData)
    ).to.be.revertedWith(`Snapshots: There's an ETHDKG round running!`)
  })

  it('Does not allow snapshot if validator not elected to do snapshot', async function () {
    let junkData =
      '0x0000000000000000000000000000000000000000000000000000006d6168616d'
    let validValidator = await ethers.getSigner(validators[0])
    await expect(
      fixture.snapshots.connect(validValidator).snapshot(junkData, junkData)
    ).to.be.revertedWith(`Snapshots: Validator not elected to do snapshot!`)
  })

  it('Does not allow snapshot caller did not particopate in the last ETHDKG round', async function () {
    let junkData =
      '0x0000000000000000000000000000000000000000000000000000006d6168616d'
    let validValidator = await ethers.getSigner(validators[0])
    await expect(
      fixture.snapshots.connect(validValidator).snapshot(junkData, junkData)
    ).to.be.revertedWith(
      `Snapshots: Caller didn't participate in the last ethdkg round!`
    )
  })
})
