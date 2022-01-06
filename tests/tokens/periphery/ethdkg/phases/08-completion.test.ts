import { ethers } from "hardhat";
import { validators4 } from "../assets/4-validators-successful-case";
import {
  assertETHDKGPhase,
  assertEventValidatorSetCompleted,
  endCurrentPhase,
  expect,
  getValidatorEthAccount,
  Phase,
  PLACEHOLDER_ADDRESS,
  startAtGPKJ,
  submitValidatorsGPKJ,
} from "../setup";

describe("ETHDKG Completion", () => {
  it("should not allow completion until after the DisputeGPKj phase", async () => {
    let [ethdkg, validatorPool, expectedNonce] = await startAtGPKJ(validators4);

    await assertETHDKGPhase(ethdkg, Phase.GPKJSubmission);
    await submitValidatorsGPKJ(
      ethdkg,
      validatorPool,
      validators4,
      expectedNonce,
      1
    );

    await expect(
      ethdkg.connect(await getValidatorEthAccount(validators4[0].address)).complete()
    ).to.be.revertedWith("ETHDKG: cannot complete yet");

    await assertETHDKGPhase(ethdkg, Phase.DisputeGPKJSubmission);
    await endCurrentPhase(ethdkg);
    await assertETHDKGPhase(ethdkg, Phase.DisputeGPKJSubmission);

    let tx = await ethdkg
      .connect(await getValidatorEthAccount(validators4[0].address))
      .complete();

    await assertEventValidatorSetCompleted(
      tx,
      validators4.length,
      expectedNonce,
      1,
      1,
      1,
      validators4[0].mpk
    );
  });

  it("should not allow non-validators to complete ETHDKG", async () => {
    let [ethdkg, validatorPool, expectedNonce] = await startAtGPKJ(validators4);

    await assertETHDKGPhase(ethdkg, Phase.GPKJSubmission);
    await submitValidatorsGPKJ(
      ethdkg,
      validatorPool,
      validators4,
      expectedNonce,
      1
    );

    await expect(
      ethdkg.connect(await getValidatorEthAccount(validators4[0].address)).complete()
    ).to.be.revertedWith("ETHDKG: cannot complete yet");

    await assertETHDKGPhase(ethdkg, Phase.DisputeGPKJSubmission);
    await endCurrentPhase(ethdkg);
    await assertETHDKGPhase(ethdkg, Phase.DisputeGPKJSubmission);

    // non-validator tries to complete ethdkg
    await expect(
      ethdkg
        .connect(
          await getValidatorEthAccount("0x26D3D8Ab74D62C26f1ACc220dA1646411c9880Ac")
        )
        .complete()
    ).to.be.revertedWith("ETHDKG: Only validators allowed!");
  });

  it("should not allow double completion of ETHDKG", async () => {
    let [ethdkg, validatorPool, expectedNonce] = await startAtGPKJ(validators4);

    await assertETHDKGPhase(ethdkg, Phase.GPKJSubmission);
    await submitValidatorsGPKJ(
      ethdkg,
      validatorPool,
      validators4,
      expectedNonce,
      1
    );

    await expect(
      ethdkg.connect(await getValidatorEthAccount(validators4[0].address)).complete()
    ).to.be.revertedWith("ETHDKG: cannot complete yet");

    await assertETHDKGPhase(ethdkg, Phase.DisputeGPKJSubmission);
    await endCurrentPhase(ethdkg);
    await assertETHDKGPhase(ethdkg, Phase.DisputeGPKJSubmission);

    let tx = await ethdkg
      .connect(await getValidatorEthAccount(validators4[0].address))
      .complete();

    await assertEventValidatorSetCompleted(
      tx,
      validators4.length,
      expectedNonce,
      1,
      1,
      1,
      validators4[0].mpk
    );

    // try completing again
    await expect(
      ethdkg.connect(await getValidatorEthAccount(validators4[0].address)).complete()
    ).to.be.revertedWith("ETHDKG: cannot complete yet");
  });

  it("should not allow validators to participate in previous phases", async () => {
    let [ethdkg, validatorPool, expectedNonce] = await startAtGPKJ(validators4);

    await assertETHDKGPhase(ethdkg, Phase.GPKJSubmission);
    await submitValidatorsGPKJ(
      ethdkg,
      validatorPool,
      validators4,
      expectedNonce,
      1
    );

    await expect(
      ethdkg.connect(await getValidatorEthAccount(validators4[0].address)).complete()
    ).to.be.revertedWith("ETHDKG: cannot complete yet");

    await assertETHDKGPhase(ethdkg, Phase.DisputeGPKJSubmission);
    await endCurrentPhase(ethdkg);
    await assertETHDKGPhase(ethdkg, Phase.DisputeGPKJSubmission);

    let tx = await ethdkg
      .connect(await getValidatorEthAccount(validators4[0].address))
      .complete();

    await assertEventValidatorSetCompleted(
      tx,
      validators4.length,
      expectedNonce,
      1,
      1,
      1,
      validators4[0].mpk
    );

    // try participating in previous phases
    await expect(
      ethdkg
        .connect(await getValidatorEthAccount(validators4[0].address))
        .register(validators4[0].madNetPublicKey)
    ).to.be.revertedWith("ETHDKG: Cannot register at the moment");

    await expect(
      ethdkg
        .connect(await getValidatorEthAccount(validators4[0].address))
        .accuseParticipantNotRegistered([])
    ).to.be.revertedWith(
      "ETHDKG: should be in post-registration accusation phase!"
    );

    await expect(
      ethdkg
        .connect(await getValidatorEthAccount(validators4[0].address))
        .distributeShares(
          validators4[0].encryptedShares,
          validators4[0].commitments
        )
    ).to.be.revertedWith("ETHDKG: cannot participate on this phase");

    await expect(
      ethdkg
        .connect(await getValidatorEthAccount(validators4[0].address))
        .accuseParticipantDidNotDistributeShares([])
    ).to.be.revertedWith(
      "ETHDKG: should be in post-ShareDistribution accusation phase!"
    );

    await expect(
      ethdkg
        .connect(await getValidatorEthAccount(validators4[0].address))
        .accuseParticipantDistributedBadShares(
          PLACEHOLDER_ADDRESS,
          [],
          [
            [0, 0],
            [0, 0],
          ],
          [0, 0],
          [0, 0]
        )
    ).to.be.revertedWith("Dispute failed! Contract is not in dispute phase");

    await expect(
      ethdkg
        .connect(await getValidatorEthAccount(validators4[0].address))
        .submitKeyShare(
          validators4[0].keyShareG1,
          validators4[0].keyShareG1CorrectnessProof,
          validators4[0].keyShareG2
        )
    ).to.be.revertedWith(
      "ETHDKG: cannot participate on key share submission phase"
    );

    await expect(
      ethdkg
        .connect(await getValidatorEthAccount(validators4[0].address))
        .accuseParticipantDidNotSubmitKeyShares([])
    ).to.be.revertedWith("ETHDKG: should be in post-KeyShareSubmission phase!");

    await expect(
      ethdkg
        .connect(await getValidatorEthAccount(validators4[0].address))
        .submitMasterPublicKey([0, 0, 0, 0])
    ).to.be.revertedWith(
      "ETHDKG: cannot participate on master public key submission phase"
    );

    await expect(
      ethdkg
        .connect(await getValidatorEthAccount(validators4[0].address))
        .submitGPKj([0, 0, 0, 0])
    ).to.be.revertedWith("ETHDKG: Not in GPKJ submission phase");

    await expect(
      ethdkg
        .connect(await getValidatorEthAccount(validators4[0].address))
        .accuseParticipantDidNotSubmitGPKJ([])
    ).to.be.revertedWith("ETHDKG: should be in post-GPKJSubmission phase!");

    await expect(
      ethdkg
        .connect(await getValidatorEthAccount(validators4[0].address))
        .accuseParticipantSubmittedBadGPKj(
          [],
          [],
          [[[0, 0]]],
          PLACEHOLDER_ADDRESS
        )
    ).to.be.revertedWith("ETHDKG: should be in post-GPKJSubmission phase!");

    await expect(
      ethdkg.connect(await getValidatorEthAccount(validators4[0].address)).complete()
    ).to.be.revertedWith("ETHDKG: cannot complete yet");
  });
});
