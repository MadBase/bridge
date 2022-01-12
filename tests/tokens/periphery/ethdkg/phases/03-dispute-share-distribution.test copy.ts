// import { validators4 } from "../assets/4-validators-successful-case";
// import { validators4BadDistributeShares } from "../assets/4-validators-bad-distribute-shares";
// import { ethers } from "hardhat";
// import {
//   endCurrentPhase,
//   endCurrentAccusationPhase,
//   distributeValidatorsShares,
//   startAtDistributeShares,
//   expect,
//   assertETHDKGPhase,
//   Phase,
//   PLACEHOLDER_ADDRESS,
//   submitValidatorsKeyShares,
//   submitMasterPublicKey,
//   mineBlocks,
//   submitValidatorsGPKJ,
//   completeETHDKG,
//   getValidatorEthAccount,
//   waitNextPhaseStartDelay,
// } from "../setup";
// import { BigNumberish } from "ethers";

// describe("Dispute bad shares", () => {
//   it("should not allow accusations before time", async function () {
//     let validators = validators4BadDistributeShares;
//     let [ethdkg, validatorPool, expectedNonce] = await startAtDistributeShares(
//       validators
//     );

//     await assertETHDKGPhase(ethdkg, Phase.ShareDistribution);

//     await distributeValidatorsShares(
//       ethdkg,
//       validatorPool,
//       validators,
//       expectedNonce
//     );

//     await waitNextPhaseStartDelay(ethdkg);

//     // try accusing bad shares
//     await ethdkg
//       .connect(await getValidatorEthAccount(validators[3]))
//       .accuseParticipantDistributedBadShares(
//         validators[0].address,
//         validators[0].encryptedShares,
//         validators[0].commitments,
//         validators[3].sharedKey as [BigNumberish, BigNumberish],
//         validators[3].sharedKeyProof as [BigNumberish, BigNumberish]
//       );

//     expect(await ethdkg.getBadParticipants()).to.equal(1);
//     expect(await validatorPool.isValidator(validators[0].address)).to.equal(
//       false
//     );
//     expect(await validatorPool.isValidator(validators[3].address)).to.equal(
//       true
//     );
//   });
// });
