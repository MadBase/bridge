import { validators4 } from "../assets/4-validators-successful-case";
import { ethers } from "hardhat";
import {
  endCurrentPhase,
  endCurrentAccusationPhase,
  distributeValidatorsShares,
  startAtDistributeShares,
  expect,
  startAtGPKJ,
  assertETHDKGPhase,
  completeETHDKG,
  mineBlocks,
  Phase,
  PLACEHOLDER_ADDRESS,
  submitMasterPublicKey,
  submitValidatorsGPKJ,
  submitValidatorsKeyShares,
  waitNextPhaseStartDelay,
  getValidatorEthAccount,
} from "../setup";
import { BigNumber, BigNumberish } from "ethers";
import { validators4BadGPKJSubmission } from "../assets/4-validators-1-bad-gpkj-submission";
import { validators10BadGPKJSubmission } from "../assets/10-validators-1-bad-gpkj-submission";

describe("Dispute GPKj", () => {

    it("accuse good and bad participants of sending bad gpkj shares with 4 validators", async function () {
      // last validator is the bad one
      let validators = validators4BadGPKJSubmission;
      let [ethdkg, validatorPool, expectedNonce] = await startAtGPKJ(
        validators
      );

      await assertETHDKGPhase(ethdkg, Phase.GPKJSubmission);

      // all validators will send their gpkj. Validator 4 will send bad data
      await submitValidatorsGPKJ(
        ethdkg,
        validatorPool,
        validators,
        expectedNonce,
        1
      );

      await waitNextPhaseStartDelay(ethdkg);

      await assertETHDKGPhase(ethdkg, Phase.DisputeGPKJSubmission);
      expect(await ethdkg.getBadParticipants()).to.equal(0);
      // Accuse the 4th validator of bad GPKj
      await ethdkg
        .connect(await getValidatorEthAccount(validators[0]))
        .accuseParticipantSubmittedBadGPKj(
          validators.map((x) => x.address),
          (validators[0].encryptedSharesHash as BigNumberish[]).map((x) =>
            x.toString()
          ),
          validators[0].groupCommitments as [BigNumberish, BigNumberish][][],
          validators[3].address
        );
      expect(await ethdkg.getBadParticipants()).to.equal(1);
      expect(await validatorPool.isValidator(validators[0].address)).to.equal(
        true
      );
      expect(await validatorPool.isValidator(validators[3].address)).to.equal(
        false
      );

      // Accuse the a valid validator of bad GPKj
      await ethdkg
        .connect(await getValidatorEthAccount(validators[0]))
        .accuseParticipantSubmittedBadGPKj(
          validators.map((x) => x.address),
          (validators[0].encryptedSharesHash as BigNumberish[]).map((x) =>
            x.toString()
          ),
          validators[0].groupCommitments as [BigNumberish, BigNumberish][][],
          validators[2].address
        );
      expect(await ethdkg.getBadParticipants()).to.equal(2);
      // validator 0 ( the disputer) should be the one evicted!
      expect(await validatorPool.isValidator(validators[0].address)).to.equal(
        false
      );
      expect(await validatorPool.isValidator(validators[2].address)).to.equal(
        true
      );
    });

    it("accuse good and bad participants of sending bad gpkj shares with 10 validators", async function () {
      // last validator is the bad one
      let validators = validators10BadGPKJSubmission;
      let [ethdkg, validatorPool, expectedNonce] = await startAtGPKJ(
        validators
      );

      await assertETHDKGPhase(ethdkg, Phase.GPKJSubmission);

      // all validators will send their gpkj. Validator 4 will send bad data
      await submitValidatorsGPKJ(
        ethdkg,
        validatorPool,
        validators,
        expectedNonce,
        1
      );

      await waitNextPhaseStartDelay(ethdkg);

      await assertETHDKGPhase(ethdkg, Phase.DisputeGPKJSubmission);
      expect(await ethdkg.getBadParticipants()).to.equal(0);

      // Accuse the 10th validator of bad GPKj
      await ethdkg
        .connect(await getValidatorEthAccount(validators[0]))
        .accuseParticipantSubmittedBadGPKj(
          validators.map((x) => x.address),
          (validators[0].encryptedSharesHash as BigNumberish[]).map((x) =>
            x.toString()
          ),
          validators[0].groupCommitments as [BigNumberish, BigNumberish][][],
          validators[validators.length - 1].address
        );
      expect(await ethdkg.getBadParticipants()).to.equal(1);
      expect(await validatorPool.isValidator(validators[0].address)).to.equal(
        true
      );
      expect(
        await validatorPool.isValidator(
          validators[validators.length - 1].address
        )
      ).to.equal(false);

      // Accuse the a valid validator of bad GPKj
      await ethdkg
        .connect(await getValidatorEthAccount(validators[0]))
        .accuseParticipantSubmittedBadGPKj(
          validators.map((x) => x.address),
          (validators[0].encryptedSharesHash as BigNumberish[]).map((x) =>
            x.toString()
          ),
          validators[0].groupCommitments as [BigNumberish, BigNumberish][][],
          validators[2].address
        );
      expect(await ethdkg.getBadParticipants()).to.equal(2);
      // validator 0 ( the disputer) should be the one evicted!
      expect(await validatorPool.isValidator(validators[0].address)).to.equal(
        false
      );
      expect(await validatorPool.isValidator(validators[2].address)).to.equal(
        true
      );
    });

  it("should not allow accusations before time", async function () {
    let [ethdkg, validatorPool, expectedNonce] = await startAtGPKJ(
      validators4
    );

    await assertETHDKGPhase(ethdkg, Phase.GPKJSubmission);

    // try accusing bad GPKj
    await expect(ethdkg.connect(await ethers.getSigner(validators4[0].address)).accuseParticipantSubmittedBadGPKj([], [], [[[0,0]]], PLACEHOLDER_ADDRESS))
    .to.be.revertedWith("ETHDKG: should be in post-GPKJSubmission phase!")
  });

  it("should not allow accusations unless in DisputeGPKJSubmission phase, or expired GPKJSubmission phase", async function () {
    let [ethdkg, validatorPool, expectedNonce] = await startAtDistributeShares(
      validators4
    );

    await assertETHDKGPhase(ethdkg, Phase.ShareDistribution);

    // try accusing bad GPKj
    await expect(ethdkg.connect(await ethers.getSigner(validators4[0].address)).accuseParticipantSubmittedBadGPKj([], [], [[[0,0]]], PLACEHOLDER_ADDRESS))
    .to.be.revertedWith("ETHDKG: should be in post-GPKJSubmission phase!")

    // distribute shares
    await distributeValidatorsShares(
      ethdkg,
      validatorPool,
      validators4,
      expectedNonce
    );
    await assertETHDKGPhase(ethdkg, Phase.DisputeShareDistribution);

    // skipping the distribute shares accusation phase
    await endCurrentPhase(ethdkg);
    await assertETHDKGPhase(ethdkg, Phase.DisputeShareDistribution);

    // submit key shares phase
    await submitValidatorsKeyShares(ethdkg, validatorPool, validators4, expectedNonce)

    // try accusing bad GPKj
    await expect(ethdkg.connect(await ethers.getSigner(validators4[0].address)).accuseParticipantSubmittedBadGPKj([], [], [[[0,0]]], PLACEHOLDER_ADDRESS))
    .to.be.revertedWith("ETHDKG: should be in post-GPKJSubmission phase!")

    //await endCurrentPhase(ethdkg)
    await assertETHDKGPhase(ethdkg, Phase.MPKSubmission);

    // try accusing bad GPKj
    await expect(ethdkg.connect(await ethers.getSigner(validators4[0].address)).accuseParticipantSubmittedBadGPKj([], [], [[[0,0]]], PLACEHOLDER_ADDRESS))
    .to.be.revertedWith("ETHDKG: should be in post-GPKJSubmission phase!")

    // submit MPK
    await mineBlocks((await ethdkg.getConfirmationLength()).toNumber())
    await submitMasterPublicKey(ethdkg, validators4, expectedNonce)

    await assertETHDKGPhase(ethdkg, Phase.GPKJSubmission);

    // try accusing bad GPKj
    await expect(ethdkg.connect(await ethers.getSigner(validators4[0].address)).accuseParticipantSubmittedBadGPKj([], [], [[[0,0]]], PLACEHOLDER_ADDRESS))
    .to.be.revertedWith("ETHDKG: should be in post-GPKJSubmission phase!")

    // submit GPKj
    await submitValidatorsGPKJ(ethdkg, validatorPool, validators4, expectedNonce, 1)

    await assertETHDKGPhase(ethdkg, Phase.DisputeGPKJSubmission)

    // try accusing bad GPKj
    await expect(ethdkg.connect(await ethers.getSigner(validators4[0].address)).accuseParticipantSubmittedBadGPKj([], [], [[[0,0]]], PLACEHOLDER_ADDRESS))
    .to.be.revertedWith("ETHDKG: should be in post-GPKJSubmission phase!")

    await endCurrentPhase(ethdkg)

    // try accusing bad GPKj
    await expect(ethdkg.connect(await ethers.getSigner(validators4[0].address)).accuseParticipantSubmittedBadGPKj([], [], [[[0,0]]], PLACEHOLDER_ADDRESS))
    .to.be.revertedWith("ETHDKG: should be in post-GPKJSubmission phase!")

    // complete ethdkg
    await completeETHDKG(ethdkg, validators4, expectedNonce, 1, 1)

    await assertETHDKGPhase(ethdkg, Phase.Completion)

    // try accusing bad GPKj
    await expect(ethdkg.connect(await ethers.getSigner(validators4[0].address)).accuseParticipantSubmittedBadGPKj([], [], [[[0,0]]], PLACEHOLDER_ADDRESS))
    .to.be.revertedWith("ETHDKG: should be in post-GPKJSubmission phase!")
  });

  it("should not allow accusation of a non-participating validator", async function () {
    let [ethdkg, validatorPool, expectedNonce] = await startAtGPKJ(
      validators4
    );

    await assertETHDKGPhase(ethdkg, Phase.GPKJSubmission);

    // 3/4 validators will submit GPKj, 4th validator will not
    await submitValidatorsGPKJ(
      ethdkg,
      validatorPool,
      validators4.slice(0, 3),
      expectedNonce,
      1
    );

    await endCurrentPhase(ethdkg)

    // try accusing the 4th validator of bad GPKj, when it did not even submit it
    await expect(ethdkg.connect(await ethers.getSigner(validators4[0].address)).accuseParticipantSubmittedBadGPKj([], [], [[[0,0]]], validators4[3].address))
    .to.be.revertedWith("ETHDKG: Issuer didn't submit his GPKJ for this round!")
  });

  it("should not allow accusation from a non-participating validator", async function () {
    let [ethdkg, validatorPool, expectedNonce] = await startAtGPKJ(
      validators4
    );

    await assertETHDKGPhase(ethdkg, Phase.GPKJSubmission);

    // 3/4 validators will submit GPKj, 4th validator will not
    await submitValidatorsGPKJ(
      ethdkg,
      validatorPool,
      validators4.slice(0, 3),
      expectedNonce,
      1
    );

    await endCurrentPhase(ethdkg)

    // validator 4 will try accusing the 1st validator of bad GPKj, when it did not even submit it itself
    await expect(ethdkg.connect(await ethers.getSigner(validators4[3].address)).accuseParticipantSubmittedBadGPKj([], [], [[[0,0]]], validators4[0].address))
    .to.be.revertedWith("ETHDKG: Disputer didn't submit his GPKJ for this round!")
  });

  /*
  it("should not allow accusation with incorrect data length, or all zeros", async function () {
    let [ethdkg, validatorPool, expectedNonce] = await startAtGPKJ(
      validators4
    );

    await assertETHDKGPhase(ethdkg, Phase.GPKJSubmission);

    // all validators will submit GPKj
    await submitValidatorsGPKJ(
      ethdkg,
      validatorPool,
      validators4,
      expectedNonce,
      1
    );

    //await endCurrentPhase(ethdkg)
    await assertETHDKGPhase(ethdkg, Phase.DisputeGPKJSubmission)
    await mineBlocks((await ethdkg.getConfirmationLength()).toNumber())

    // accuse a validator using incorrect index
    await expect(ethdkg.connect(await ethers.getSigner(validators4[3].address)).accuseParticipantSubmittedBadGPKj([], [], [[[0,0]]], 1000, validators4[0].address))
    .to.be.revertedWith("gpkj acc comp failed: dishonest index does not match dishonest address")

    // length based tests

    // accuse a validator using incorrect validators length
    await expect(ethdkg.connect(await ethers.getSigner(validators4[3].address)).accuseParticipantSubmittedBadGPKj([], [], [[[0,0]]], 1, validators4[0].address))
    .to.be.revertedWith("gpkj acc comp failed: invalid submission of arguments")

    // accuse a validator using incorrect encryptedSharesHash length
    const placeholderBytes32 = "0x0000000000000000000000000000000000000000000000000000000000000000"
    await expect(ethdkg.connect(await ethers.getSigner(validators4[3].address)).accuseParticipantSubmittedBadGPKj(
      [PLACEHOLDER_ADDRESS, PLACEHOLDER_ADDRESS, PLACEHOLDER_ADDRESS, PLACEHOLDER_ADDRESS],
      [placeholderBytes32,placeholderBytes32,placeholderBytes32,placeholderBytes32],
      [[[0,0]]],
      1,
      validators4[0].address))
    .to.be.revertedWith("gpkj acc comp failed: invalid submission of arguments")

    // accuse a validator using incorrect commitments length
    await expect(ethdkg.connect(await ethers.getSigner(validators4[3].address)).accuseParticipantSubmittedBadGPKj(
      [PLACEHOLDER_ADDRESS, PLACEHOLDER_ADDRESS, PLACEHOLDER_ADDRESS, PLACEHOLDER_ADDRESS],
      [placeholderBytes32,placeholderBytes32,placeholderBytes32,placeholderBytes32],
      [[[0,0]],[[0,0]],[[0,0]],[[0,0]]],
      1,
      validators4[0].address))
    .to.be.revertedWith("gpkj acc comp failed: invalid number of commitments provided")

    // invalid index
    await expect(ethdkg.connect(await ethers.getSigner(validators4[3].address)).accuseParticipantSubmittedBadGPKj(
      [PLACEHOLDER_ADDRESS, PLACEHOLDER_ADDRESS, PLACEHOLDER_ADDRESS, PLACEHOLDER_ADDRESS],
      [placeholderBytes32,placeholderBytes32,placeholderBytes32,placeholderBytes32],
      [[[0,0]],[[0,0]],[[0,0]],[[0,0]]],
      10,
      validators4[0].address))
    .to.be.revertedWith("gpkj acc comp failed: dishonest index does not match dishonest address")

    // duplicated validator in `validators` input
    await expect(ethdkg.connect(await ethers.getSigner(validators4[3].address)).accuseParticipantSubmittedBadGPKj(
      [validators4[0].address, validators4[1].address, validators4[2].address, validators4[0].address],
      [validators4[0].encryptedShares, placeholderBytes32, placeholderBytes32, placeholderBytes32],
      [[[0,0]],[[0,0]],[[0,0]],[[0,0]]],
      10,
      validators4[0].address))
    .to.be.revertedWith("gpkj acc comp failed: dishonest index does not match dishonest address")
  });
  */

});