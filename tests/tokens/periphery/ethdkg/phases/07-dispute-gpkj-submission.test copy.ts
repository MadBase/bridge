// import { validators4 } from "../assets/4-validators-successful-case";
// import { ethers, network } from "hardhat";
// import {
//   endCurrentPhase,
//   endCurrentAccusationPhase,
//   distributeValidatorsShares,
//   startAtDistributeShares,
//   expect,
//   startAtGPKJ,
//   assertETHDKGPhase,
//   completeETHDKG,
//   mineBlocks,
//   Phase,
//   PLACEHOLDER_ADDRESS,
//   submitMasterPublicKey,
//   submitValidatorsGPKJ,
//   submitValidatorsKeyShares,
//   waitNextPhaseStartDelay,
//   getValidatorEthAccount,
//   completeETHDKGRound,
// } from "../setup";
// import { BigNumber, BigNumberish } from "ethers";
// import { validators4BadGPKJSubmission } from "../assets/4-validators-1-bad-gpkj-submission";
// import { validators10BadGPKJSubmission } from "../assets/10-validators-1-bad-gpkj-submission";
// import { validators20BadGPKJSubmission } from "../assets/20-validators-bad-gpkj-submission";
// import { validators50BadGPKJSubmission } from "../assets/50-validators-bad-gpkj-submission";
// import { validators15BadGPKJSubmission } from "../assets/15-validators-bad-gpkj-submission";
// import { validators30BadGPKJSubmission } from "../assets/30-validators-bad-gpkj-submission";
// import { validators40BadGPKJSubmission } from "../assets/40-validators-bad-gpkj-submission";
// import { validators55BadGPKJSubmission } from "../assets/55-validators-bad-gpkj-submission";
// import { validators60BadGPKJSubmission } from "../assets/60-validators-bad-gpkj-submission";

// describe("Dispute GPKj", () => {
//   it("accuse good and bad participants of sending bad gpkj shares with 30 validators", async function () {
//     await network.provider.send("evm_setBlockGasLimit", ["0x5F5E100"]);
//     // last validator is the bad one
//     let validators = validators60BadGPKJSubmission;
//     let [ethdkg, validatorPool, expectedNonce] = await completeETHDKGRound(
//       validators
//     );
//     await validatorPool.removeAllValidators();

//     await startAtGPKJ(validators, {ethdkg, validatorPool});

//     await assertETHDKGPhase(ethdkg, Phase.GPKJSubmission);

//     // all validators will send their gpkj. Validator 4 will send bad data
//     await submitValidatorsGPKJ(
//       ethdkg,
//       validatorPool,
//       validators,
//       expectedNonce+1,
//       1
//     );

//     await waitNextPhaseStartDelay(ethdkg);

//     await assertETHDKGPhase(ethdkg, Phase.DisputeGPKJSubmission);
//     expect(await ethdkg.getBadParticipants()).to.equal(0);

//     let groupCommits = validators[0].groupCommitments as [BigNumberish, BigNumberish][][]
//     // Accuse the last validator of bad GPKj
//     await ethdkg
//       .connect(await getValidatorEthAccount(validators[0]))
//       .accuseParticipantSubmittedBadGPKjEmpty(
//         validators.map((x) => x.address),
//         (validators[0].encryptedSharesHash as BigNumberish[]).map((x) =>
//           x.toString()
//         ),
//         validators[0].groupCommitments as [BigNumberish, BigNumberish][][],
//         validators[validators.length - 1].address
//       );
//     // expect(await ethdkg.getBadParticipants()).to.equal(1);
//     // expect(await validatorPool.isValidator(validators[0].address)).to.equal(
//     //   true
//     // );
//     // expect(
//     //   await validatorPool.isValidator(validators[validators.length - 1].address)
//     // ).to.equal(false);

//     // // Accuse the a valid validator of bad GPKj
//     await ethdkg
//       .connect(await getValidatorEthAccount(validators[0]))
//       .accuseParticipantSubmittedBadGPKJ(
//         validators.map((x) => x.address),
//         (validators[0].encryptedSharesHash as BigNumberish[]).map((x) =>
//           x.toString()
//         ),
//         validators[0].groupCommitments as [BigNumberish, BigNumberish][][],
//         validators[2].address
//       );
//     // expect(await ethdkg.getBadParticipants()).to.equal(2);
//     // // validator 0 ( the disputer) should be the one evicted!
//     // expect(await validatorPool.isValidator(validators[0].address)).to.equal(
//     //   false
//     // );
//     // expect(await validatorPool.isValidator(validators[2].address)).to.equal(
//     //   true
//     // );
//     // console.log("here")
//     // let tx = await ethdkg
//     // .connect(await getValidatorEthAccount(validators[1]))
//     // .accuseParticipantSubmittedBadGPKJ(
//     //   validators.map((x) => x.address),
//     //   (validators[0].encryptedSharesHash as BigNumberish[]).map((x) =>
//     //     x.toString()
//     //   ),
//     //   validators[0].groupCommitments as [BigNumberish, BigNumberish][][],
//     //   validators[validators.length - 1].address
//     // );
//     // console.log("Reverted:" + (await tx.wait()).gasUsed)
//     });
// });
