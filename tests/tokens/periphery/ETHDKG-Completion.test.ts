import { expect } from "../../chai-setup";
import { ethers, network, upgrades } from "hardhat";
import { BigNumber, BigNumberish, ContractTransaction } from "ethers";
import { assert } from "chai";
import { validators4 } from "./test-data/4-validators-successful-case";
import { validators10 } from "./test-data/10-validators-successful-case";
import { ETHDKG, ValidatorPoolMock } from "../../../typechain-types";

const PLACEHOLDER_ADDRESS = "0x0000000000000000000000000000000000000000";
enum Phase {
  RegistrationOpen,
  ShareDistribution,
  DisputeShareDistribution,
  KeyShareSubmission,
  MPKSubmission,
  GPKJSubmission,
  DisputeGPKJSubmission,
  Completion,
}

export interface ValidatorRawData {
  address: string;
  madNetPublicKey: [BigNumberish, BigNumberish];
  encryptedShares: BigNumberish[];
  commitments: [BigNumberish, BigNumberish][];
  keyShareG1: [BigNumberish, BigNumberish];
  keyShareG1CorrectnessProof: [BigNumberish, BigNumberish];
  keyShareG2: [BigNumberish, BigNumberish, BigNumberish, BigNumberish];
  mpk: [BigNumberish, BigNumberish, BigNumberish, BigNumberish];
  gpkj: [BigNumberish, BigNumberish, BigNumberish, BigNumberish];
}

/**
 * Shuffles array in place. ES6 version
 * https://stackoverflow.com/questions/6274339/how-can-i-shuffle-an-array/6274381#6274381
 * @param {Array} a items An array containing the items.
 */
function shuffle(a: ValidatorRawData[]) {
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [a[i], a[j]] = [a[j], a[i]];
  }
  return a;
}

const mineBlocks = async (nBlocks: number) => {
  while (nBlocks > 0) {
    nBlocks--;
    await network.provider.request({
      method: "evm_mine",
    });
  }
};

const getBlockByNumber = async () => {
  return await network.provider.send("eth_getBlockByNumber", [
    "pending",
    false,
  ]);
};

const getPendingTransactions = async () => {
  return await network.provider.send("eth_pendingTransactions");
};

const getFixture = async () => {
  await network.provider.send("evm_setAutomine", [true]);

  const namedSigners = await ethers.getSigners();
  const [admin] = namedSigners;

  // MadToken
  const MadToken = await ethers.getContractFactory("MadToken");
  const madToken = await MadToken.deploy("MadToken", "MAD");
  await madToken.deployed();
  // console.log(`MadToken deployed at ${madToken.address}`);

  // MadByte
  const MadByte = await ethers.getContractFactory("MadByte");
  const madByte = await MadByte.deploy(
    admin.address,
    PLACEHOLDER_ADDRESS,
    PLACEHOLDER_ADDRESS,
    PLACEHOLDER_ADDRESS,
    PLACEHOLDER_ADDRESS
  );
  await madByte.deployed();
  // console.log(`MadByte deployed at ${madByte.address}`);

  // StakeNFT
  const StakeNFT = await ethers.getContractFactory("StakeNFT");
  const stakeNFT = await StakeNFT.deploy(
    "StakeNFT",
    "MADSTK",
    madByte.address,
    admin.address,
    PLACEHOLDER_ADDRESS
  );
  await stakeNFT.deployed();
  // console.log(`StakeNFT deployed at ${stakeNFT.address}`);

  // ValidatorNFT
  const ValidatorNFT = await ethers.getContractFactory("ValidatorNFT");
  const validatorNFT = await ValidatorNFT.deploy(
    "ValidatorNFT",
    "VALSTK",
    madByte.address,
    admin.address,
    PLACEHOLDER_ADDRESS
  );
  await validatorNFT.deployed();
  // console.log(`ValidatorNFT deployed at ${validatorNFT.address}`);

  // ValidatorPool
  const ValidatorPool = await ethers.getContractFactory("ValidatorPoolMock");
  const validatorPool = await ValidatorPool.deploy();
  await validatorPool.deployed();
  // console.log(`ValidatorPool deployed at ${validatorPool.address}`);

  // ETHDKG
  const ETHDKG = await ethers.getContractFactory("ETHDKG");
  const ethdkg = await ETHDKG.deploy();
  await ethdkg.deployed();
  // console.log(`ETHDKG deployed at ${ethdkg.address}`);

  await ethdkg.initialize(validatorPool.address);

  // console.log("finished core deployment");

  return {
    madToken,
    madByte,
    stakeNFT,
    validatorNFT,
    validatorPool,
    ethdkg,
    namedSigners,
  };
};

// Event asserts

const assertRegistrationComplete = async (tx: ContractTransaction) => {
  let receipt = await ethers.provider.getTransactionReceipt(tx.hash);
  let intrface = new ethers.utils.Interface([
    "event RegistrationComplete(uint256 blockNumber)",
  ]);
  let data = receipt.logs[1].data;
  let topics = receipt.logs[1].topics;
  let event = intrface.decodeEventLog("RegistrationComplete", data, topics);
  expect(event.blockNumber).to.equal(receipt.blockNumber);
};

const assertEventSharesDistributed = async (
  tx: ContractTransaction,
  account: string,
  index: number,
  nonce: number,
  encryptedShares: BigNumberish[],
  commitments: [BigNumberish, BigNumberish][]
) => {
  let receipt = await ethers.provider.getTransactionReceipt(tx.hash);
  let intrface = new ethers.utils.Interface([
    "event SharesDistributed(address account, uint256 index, uint256 nonce, uint256[] encryptedShares, uint256[2][] commitments)",
  ]);
  let data = receipt.logs[0].data;
  let topics = receipt.logs[0].topics;
  let event = intrface.decodeEventLog("SharesDistributed", data, topics);
  expect(event.account).to.equal(account);
  expect(event.index).to.equal(index);
  expect(event.nonce).to.equal(nonce);
  assertEqEncryptedShares(event.encryptedShares, encryptedShares);
  assertEqCommitments(event.commitments, commitments);
};

const assertEventShareDistributionComplete = async (
  tx: ContractTransaction
) => {
  let receipt = await ethers.provider.getTransactionReceipt(tx.hash);
  let intrface = new ethers.utils.Interface([
    "event ShareDistributionComplete(uint256 blockNumber)",
  ]);
  let data = receipt.logs[1].data;
  let topics = receipt.logs[1].topics;
  let event = intrface.decodeEventLog(
    "ShareDistributionComplete",
    data,
    topics
  );
  expect(event.blockNumber).to.equal(receipt.blockNumber);
};

const assertEventKeyShareSubmitted = async (
  tx: ContractTransaction,
  account: string,
  index: number,
  nonce: number,
  keyShareG1: [BigNumberish, BigNumberish],
  keyShareG1CorrectnessProof: [BigNumberish, BigNumberish],
  keyShareG2: [BigNumberish, BigNumberish, BigNumberish, BigNumberish]
) => {
  let receipt = await ethers.provider.getTransactionReceipt(tx.hash);
  let intrface = new ethers.utils.Interface([
    "event KeyShareSubmitted(address account, uint256 index, uint256 nonce, uint256[2] keyShareG1, uint256[2] keyShareG1CorrectnessProof, uint256[4] keyShareG2)",
  ]);
  let data = receipt.logs[0].data;
  let topics = receipt.logs[0].topics;
  let event = intrface.decodeEventLog("KeyShareSubmitted", data, topics);
  expect(event.account).to.equal(account);
  expect(event.index).to.equal(index);
  expect(event.nonce).to.equal(nonce);
  assertEqKeyShareG1(event.keyShareG1, keyShareG1);
  assertEqKeyShareG1(
    event.keyShareG1CorrectnessProof,
    keyShareG1CorrectnessProof
  );
  assertEqKeyShareG2(event.keyShareG2, keyShareG2);
};

const assertEventKeyShareSubmissionComplete = async (
  tx: ContractTransaction
) => {
  let receipt = await ethers.provider.getTransactionReceipt(tx.hash);
  let intrface = new ethers.utils.Interface([
    "event KeyShareSubmissionComplete(uint256 blockNumber)",
  ]);
  let data = receipt.logs[1].data;
  let topics = receipt.logs[1].topics;
  let event = intrface.decodeEventLog(
    "KeyShareSubmissionComplete",
    data,
    topics
  );
  expect(event.blockNumber).to.equal(receipt.blockNumber);
};

const assertEventMPKSet = async (
  tx: ContractTransaction,
  nonce: number,
  mpk: [BigNumberish, BigNumberish, BigNumberish, BigNumberish]
) => {
  let receipt = await ethers.provider.getTransactionReceipt(tx.hash);
  let intrface = new ethers.utils.Interface([
    "event MPKSet(uint256 blockNumber, uint256 nonce, uint256[4] mpk)",
  ]);
  let data = receipt.logs[0].data;
  let topics = receipt.logs[0].topics;
  let event = intrface.decodeEventLog("MPKSet", data, topics);
  expect(event.blockNumber).to.equal(receipt.blockNumber);
  expect(event.nonce).to.equal(nonce);
  expect(event.mpk[0]).to.equal(mpk[0]);
  expect(event.mpk[1]).to.equal(mpk[1]);
  expect(event.mpk[2]).to.equal(mpk[2]);
  expect(event.mpk[3]).to.equal(mpk[3]);
};

// submit GPKj phase
const assertEventValidatorMemberAdded = async (
  tx: ContractTransaction,
  account: string,
  index: number,
  nonce: number,
  epoch: number,
  gpkj: [BigNumberish, BigNumberish, BigNumberish, BigNumberish]
) => {
  let receipt = await ethers.provider.getTransactionReceipt(tx.hash);
  let intrface = new ethers.utils.Interface([
    "event ValidatorMemberAdded(address account, uint256 index, uint256 nonce, uint256 epoch, uint256 share0, uint256 share1, uint256 share2, uint256 share3)",
  ]);
  let data = receipt.logs[0].data;
  let topics = receipt.logs[0].topics;
  let event = intrface.decodeEventLog("ValidatorMemberAdded", data, topics);
  expect(event.account).to.equal(account);
  expect(event.index).to.equal(index);
  expect(event.nonce).to.equal(nonce);
  expect(event.epoch).to.equal(epoch);
  expect(event.share0).to.equal(gpkj[0]);
  expect(event.share1).to.equal(gpkj[1]);
  expect(event.share2).to.equal(gpkj[2]);
  expect(event.share3).to.equal(gpkj[3]);
};

const assertEventGPKJSubmissionComplete = async (tx: ContractTransaction) => {
  let receipt = await ethers.provider.getTransactionReceipt(tx.hash);
  let intrface = new ethers.utils.Interface([
    "event GPKJSubmissionComplete(uint256 blockNumber)",
  ]);
  let data = receipt.logs[1].data;
  let topics = receipt.logs[1].topics;
  let event = intrface.decodeEventLog("GPKJSubmissionComplete", data, topics);
  expect(event.blockNumber).to.equal(receipt.blockNumber);
};

// COMPLETE PHASE

const assertEventValidatorSetCompleted = async (
  tx: ContractTransaction,
  validatorCount: number,
  nonce: number,
  epoch: number,
  ethHeight: number,
  madHeight: number,
  mpk: [BigNumberish, BigNumberish, BigNumberish, BigNumberish]
) => {
  let receipt = await ethers.provider.getTransactionReceipt(tx.hash);
  let intrface = new ethers.utils.Interface([
    "event ValidatorSetCompleted(uint256 validatorCount, uint256 nonce, uint256 epoch, uint32 ethHeight, uint32 madHeight, uint256 groupKey0, uint256 groupKey1, uint256 groupKey2, uint256 groupKey3)",
  ]);
  let data = receipt.logs[0].data;
  let topics = receipt.logs[0].topics;
  let event = intrface.decodeEventLog("ValidatorSetCompleted", data, topics);
  expect(event.validatorCount).to.equal(validatorCount);
  expect(event.nonce).to.equal(nonce);
  expect(event.epoch).to.equal(epoch);
  expect(event.ethHeight).to.equal(ethHeight);
  expect(event.madHeight).to.equal(madHeight);
  expect(event.groupKey0).to.equal(mpk[0]);
  expect(event.groupKey1).to.equal(mpk[1]);
  expect(event.groupKey2).to.equal(mpk[2]);
  expect(event.groupKey3).to.equal(mpk[3]);
};

// Special asserts
const assertEqEncryptedShares = (
  actualEncryptedShares: BigNumberish[],
  expectedEncryptedShares: BigNumberish[]
) => {
  actualEncryptedShares.forEach((element, i) => {
    assert(BigNumber.from(element).eq(expectedEncryptedShares[i]));
  });
};

const assertEqCommitments = (
  actualCommitments: [BigNumberish, BigNumberish][],
  expectedCommitments: [BigNumberish, BigNumberish][]
) => {
  actualCommitments.forEach((element, i) => {
    assert(BigNumber.from(element[0]).eq(expectedCommitments[i][0]));
    assert(BigNumber.from(element[1]).eq(expectedCommitments[i][1]));
  });
};

const assertEqKeyShareG1 = (
  actualKeySharesG1: [BigNumberish, BigNumberish],
  expectedKeySharesG1: [BigNumberish, BigNumberish]
) => {
  assert(BigNumber.from(actualKeySharesG1[0]).eq(expectedKeySharesG1[0]));
  assert(BigNumber.from(actualKeySharesG1[1]).eq(expectedKeySharesG1[1]));
};

const assertEqKeyShareG2 = (
  actualKeySharesG2: [BigNumberish, BigNumberish, BigNumberish, BigNumberish],
  expectedKeySharesG2: [BigNumberish, BigNumberish, BigNumberish, BigNumberish]
) => {
  assert(BigNumber.from(actualKeySharesG2[0]).eq(expectedKeySharesG2[0]));
  assert(BigNumber.from(actualKeySharesG2[1]).eq(expectedKeySharesG2[1]));
  assert(BigNumber.from(actualKeySharesG2[2]).eq(expectedKeySharesG2[2]));
  assert(BigNumber.from(actualKeySharesG2[3]).eq(expectedKeySharesG2[3]));
};

const assertETHDKGPhase = async (ethdkg: ETHDKG, expectedPhase: Phase) => {
  let actualPhase = await ethdkg.getETHDKGPhase();
  assert(actualPhase === expectedPhase, "Incorrect Phase");
};

// Aux functions
const addValidators = async (
  validatorPool: ValidatorPoolMock,
  validators: ValidatorRawData[]
) => {
  for (let validator of validators) {
    expect(await validatorPool.isValidator(validator.address)).to.equal(false);
    await validatorPool.addValidator(validator.address);
    expect(await validatorPool.isValidator(validator.address)).to.equal(true);
  }
};

const endCurrentPhase = async (ethdkg: ETHDKG) => {
  // advance enough blocks to timeout a phase
  let phaseStart = await ethdkg.getPhaseStartBlock();
  let phaseLength = await ethdkg.getPhaseLength();
  let bn = await ethers.provider.getBlockNumber();
  let endBlock = phaseStart.add(phaseLength);
  let blocksToMine = endBlock.sub(bn);
  await mineBlocks(blocksToMine.toNumber());
};

const endCurrentAccusationPhase = async (ethdkg: ETHDKG) => {
  // advance enough blocks to timeout a phase
  let phaseStart = await ethdkg.getPhaseStartBlock();
  let phaseLength = await ethdkg.getPhaseLength();
  let bn = await ethers.provider.getBlockNumber();
  let endBlock = phaseStart.add(phaseLength.mul(2));
  let blocksToMine = endBlock.sub(bn);
  await mineBlocks(blocksToMine.toNumber());
};

const waitNextPhaseStartDelay = async (ethdkg: ETHDKG) => {
  // advance enough blocks to timeout a phase
  let phaseStart = await ethdkg.getPhaseStartBlock();
  let bn = await ethers.provider.getBlockNumber();
  let blocksToMine = phaseStart.sub(bn).add(1);
  await mineBlocks(blocksToMine.toNumber());
};

const initializeETHDKG = async (
  ethdkg: ETHDKG,
  validatorPool: ValidatorPoolMock
) => {
  let nonce = await ethdkg.getNonce();
  await expect(validatorPool.initializeETHDKG())
    .to.emit(ethdkg, "RegistrationOpened")
    .withArgs((await ethers.provider.getBlockNumber()) + 1, 1);
  expect(await ethdkg.getNonce()).to.eq(nonce.add(1));
  await assertETHDKGPhase(ethdkg, Phase.RegistrationOpen);
};

const registerValidators = async (
  ethdkg: ETHDKG,
  validatorPool: ValidatorPoolMock,
  validators: ValidatorRawData[],
  expectedNonce: number
) => {
  validators = shuffle(validators);
  for (let validator of validators) {
    let numParticipantsBefore = await ethdkg.getNumParticipants();
    let tx = ethdkg
      .connect(await ethers.getSigner(validator.address))
      .register(validator.madNetPublicKey);
    let receipt = await tx;
    let participant = await ethdkg.getParticipantInternalState(
      validator.address
    );
    expect(tx)
      .to.emit(ethdkg, "AddressRegistered")
      .withArgs(
        validator.address,
        participant.index,
        expectedNonce,
        validator.madNetPublicKey
      );
    let numValidators = await validatorPool.getValidatorsCount();
    let numParticipants = await ethdkg.getNumParticipants();
    // if all validators in the Pool participated in this round
    if (numParticipantsBefore.add(1).eq(numValidators)) {
      await assertRegistrationComplete(receipt);
      expect(await ethdkg.getNumParticipants()).to.eq(0);
      await assertETHDKGPhase(ethdkg, Phase.ShareDistribution);
    } else {
      expect(numParticipants).to.eq(numParticipantsBefore.add(1));
    }
  }
};

const distributeValidatorsShares = async (
  ethdkg: ETHDKG,
  validatorPool: ValidatorPoolMock,
  validators: ValidatorRawData[],
  expectedNonce: number
) => {
  validators = shuffle(validators);
  for (let validator of validators) {
    let numParticipantsBefore = await ethdkg.getNumParticipants();
    let tx = await ethdkg
      .connect(await ethers.getSigner(validator.address))
      .distributeShares(validator.encryptedShares, validator.commitments);
    let participant = await ethdkg.getParticipantInternalState(
        validator.address
    );
    await assertEventSharesDistributed(
      tx,
      validator.address,
      participant.index,
      expectedNonce,
      validator.encryptedShares,
      validator.commitments
    );
    // if all validators in the Pool participated in this round
    let numValidators = await validatorPool.getValidatorsCount();
    let numParticipants = await ethdkg.getNumParticipants();
    if (numParticipantsBefore.add(1).eq(numValidators)) {
      await assertEventShareDistributionComplete(tx);
      expect(await ethdkg.getNumParticipants()).to.eq(0);
      await assertETHDKGPhase(ethdkg, Phase.DisputeShareDistribution);
    } else {
      expect(numParticipants).to.eq(numParticipantsBefore.add(1));
    }
  }
};

const submitValidatorsKeyShares = async (
  ethdkg: ETHDKG,
  validatorPool: ValidatorPoolMock,
  validators: ValidatorRawData[],
  expectedNonce: number
) => {
  validators = shuffle(validators);
  for (let validator of validators) {
    let numParticipantsBefore = await ethdkg.getNumParticipants();
    let tx = await ethdkg
      .connect(await ethers.getSigner(validator.address))
      .submitKeyShare(
        validator.keyShareG1,
        validator.keyShareG1CorrectnessProof,
        validator.keyShareG2
      );
    let participant = await ethdkg.getParticipantInternalState(
        validator.address
    );
    await assertEventKeyShareSubmitted(
      tx,
      validator.address,
      participant.index,
      expectedNonce,
      validator.keyShareG1,
      validator.keyShareG1CorrectnessProof,
      validator.keyShareG2
    );
    //
    // if all validators in the Pool participated in this round
    let numValidators = await validatorPool.getValidatorsCount();
    if (numValidators.eq(1)) {
      await assertETHDKGPhase(ethdkg, Phase.KeyShareSubmission);
    }
    let numParticipants = await ethdkg.getNumParticipants();
    if (numParticipantsBefore.add(1).eq(numValidators)) {
      await assertEventKeyShareSubmissionComplete(tx);
      expect(await ethdkg.getNumParticipants()).to.eq(0);
      await assertETHDKGPhase(ethdkg, Phase.MPKSubmission);
    } else {
      expect(numParticipants).to.eq(numParticipantsBefore.add(1));
    }
  }
};

const submitMasterPublicKey = async (
  ethdkg: ETHDKG,
  validators: ValidatorRawData[],
  expectedNonce: number
) => {
  // choose an random validator from the list to send the mpk
  var index = Math.floor(Math.random() * validators.length);
  let tx = await ethdkg
    .connect(await ethers.getSigner(validators[index].address))
    .submitMasterPublicKey(validators[index].mpk);
  await assertEventMPKSet(tx, expectedNonce, validators[index].mpk);
  expect(await ethdkg.getNumParticipants()).to.eq(0);
  await assertETHDKGPhase(ethdkg, Phase.GPKJSubmission);
  // The other validators should fail
  for (let validator of validators) {
    await expect(
      ethdkg
        .connect(await ethers.getSigner(validator.address))
        .submitMasterPublicKey(validator.mpk)
    ).to.be.revertedWith(
      "ETHDKG: cannot participate on master public key submission phase"
    );
  }
};

const submitValidatorsGPKJ = async (
  ethdkg: ETHDKG,
  validatorPool: ValidatorPoolMock,
  validators: ValidatorRawData[],
  expectedNonce: number,
  expectedEpoch: number
) => {
  validators = shuffle(validators);
  for (let validator of validators) {
    let numParticipantsBefore = await ethdkg.getNumParticipants();
    let tx = await ethdkg
      .connect(await ethers.getSigner(validator.address))
      .submitGPKj(validator.gpkj);
    let participant = await ethdkg.getParticipantInternalState(
        validator.address
    );
    await assertEventValidatorMemberAdded(
      tx,
      validator.address,
      participant.index,
      expectedNonce,
      expectedEpoch,
      validator.gpkj
    );
    // if all validators in the Pool participated in this round
    let numValidators = await validatorPool.getValidatorsCount();
    let numParticipants = await ethdkg.getNumParticipants();
    if (numParticipantsBefore.add(1).eq(numValidators)) {
      await assertEventGPKJSubmissionComplete(tx);
      expect(await ethdkg.getNumParticipants()).to.eq(0);
      await assertETHDKGPhase(ethdkg, Phase.DisputeGPKJSubmission);
    } else {
      expect(numParticipants).to.eq(numParticipantsBefore.add(1));
    }
  }
};

const completeETHDKG = async (
  ethdkg: ETHDKG,
  validators: ValidatorRawData[],
  expectedNonce: number,
  expectedEpoch: number,
  expectedMadHeight: number
) => {
  // choose an random validator from the list to send the mpk
  var index = Math.floor(Math.random() * validators.length);
  let tx = await ethdkg
    .connect(await ethers.getSigner(validators[index].address))
    .complete();
  await assertEventValidatorSetCompleted(
    tx,
    validators.length,
    expectedNonce,
    expectedEpoch,
    1,
    expectedMadHeight,
    validators[index].mpk
  );
  await assertETHDKGPhase(ethdkg, Phase.Completion);
  // The other validators should fail
  for (let validator of validators) {
    await expect(
      ethdkg
        .connect(await ethers.getSigner(validator.address))
        .submitMasterPublicKey(validator.mpk)
    ).to.be.revertedWith(
      "ETHDKG: cannot participate on master public key submission phase"
    );
  }
};

const startAtDistributeShares = async (
  validators: ValidatorRawData[]
): Promise<[ETHDKG, ValidatorPoolMock, number]> => {
  const { ethdkg, validatorPool } = await getFixture();
  const expectedNonce = 1;
  // add validators
  await validatorPool.setETHDKG(ethdkg.address);
  await addValidators(validatorPool, validators);

  // start ETHDKG
  await initializeETHDKG(ethdkg, validatorPool);

  // register all validators
  await registerValidators(ethdkg, validatorPool, validators, expectedNonce);
  await waitNextPhaseStartDelay(ethdkg);
  return [ethdkg, validatorPool, expectedNonce];
};

const startAtSubmitKeyShares = async (
  validators: ValidatorRawData[]
): Promise<[ETHDKG, ValidatorPoolMock, number]> => {
  let [ethdkg, validatorPool, expectedNonce] = await startAtDistributeShares(
    validators
  );
  // distribute shares for all validators
  await distributeValidatorsShares(
    ethdkg,
    validatorPool,
    validators,
    expectedNonce
  );

  // skipping the distribute shares accusation phase
  await endCurrentPhase(ethdkg);
  await assertETHDKGPhase(ethdkg, Phase.DisputeShareDistribution);
  return [ethdkg, validatorPool, expectedNonce];
};

const startAtMPKSubmission = async (
  validators: ValidatorRawData[]
): Promise<[ETHDKG, ValidatorPoolMock, number]> => {
  let [ethdkg, validatorPool, expectedNonce] = await startAtSubmitKeyShares(
    validators
  );
  // distribute shares for all validators
  await submitValidatorsKeyShares(
    ethdkg,
    validatorPool,
    validators,
    expectedNonce
  );

  await waitNextPhaseStartDelay(ethdkg);
  await assertETHDKGPhase(ethdkg, Phase.MPKSubmission);
  return [ethdkg, validatorPool, expectedNonce];
};

const startAtGPKJ = async (
  validators: ValidatorRawData[]
): Promise<[ETHDKG, ValidatorPoolMock, number]> => {
  let [ethdkg, validatorPool, expectedNonce] = await startAtMPKSubmission(
    validators
  );

  // Submit the Master Public key
  await submitMasterPublicKey(ethdkg, validators, expectedNonce);
  await waitNextPhaseStartDelay(ethdkg);

  return [ethdkg, validatorPool, expectedNonce];
};

const completeETHDKGRound = async (
  validators: ValidatorRawData[]
): Promise<[ETHDKG, ValidatorPoolMock, number, number, number]> => {

  let [ethdkg, validatorPool, expectedNonce] = await startAtGPKJ(validators);
  const expectedEpoch = 1;
  const expectedMadHeight = 1;
  // Submit GPKj for all validators
  await submitValidatorsGPKJ(
    ethdkg,
    validatorPool,
    validators,
    expectedNonce,
    expectedEpoch
  );

  // skipping the distribute shares accusation phase
  await endCurrentPhase(ethdkg);
  await assertETHDKGPhase(ethdkg, Phase.DisputeGPKJSubmission);

  // Complete ETHDKG
  await completeETHDKG(
    ethdkg,
    validators,
    expectedNonce,
    expectedEpoch,
    expectedMadHeight
  );
  return [
    ethdkg,
    validatorPool,
    expectedNonce,
    expectedEpoch,
    expectedMadHeight,
  ];
};

describe("ETHDKG", function () {

  describe("ETHDKG Completion", () => {
    it("should not allow completion until after the DisputeGPKj phase", async () => {
      let [ethdkg, validatorPool, expectedNonce] = await startAtGPKJ(
        validators4
      );

      await assertETHDKGPhase(ethdkg, Phase.GPKJSubmission)
      await submitValidatorsGPKJ(ethdkg, validatorPool, validators4, expectedNonce, 1)

      await expect(ethdkg.connect(await ethers.getSigner(validators4[0].address)).complete())
      .to.be.revertedWith("ETHDKG: cannot complete yet")

      await assertETHDKGPhase(ethdkg, Phase.DisputeGPKJSubmission)
      await endCurrentPhase(ethdkg)
      await assertETHDKGPhase(ethdkg, Phase.DisputeGPKJSubmission)

      let tx = await ethdkg.connect(await ethers.getSigner(validators4[0].address)).complete()

      await assertEventValidatorSetCompleted(
        tx,
        validators4.length,
        expectedNonce,
        1,
        1,
        1,
        validators4[0].mpk
      );
    })

    it("should not allow non-validators to complete ETHDKG", async () => {
      let [ethdkg, validatorPool, expectedNonce] = await startAtGPKJ(
        validators4
      );

      await assertETHDKGPhase(ethdkg, Phase.GPKJSubmission)
      await submitValidatorsGPKJ(ethdkg, validatorPool, validators4, expectedNonce, 1)

      await expect(ethdkg.connect(await ethers.getSigner(validators4[0].address)).complete())
      .to.be.revertedWith("ETHDKG: cannot complete yet")

      await assertETHDKGPhase(ethdkg, Phase.DisputeGPKJSubmission)
      await endCurrentPhase(ethdkg)
      await assertETHDKGPhase(ethdkg, Phase.DisputeGPKJSubmission)

      // non-validator tries to complete ethdkg
      await expect(ethdkg.connect(await ethers.getSigner("0x26D3D8Ab74D62C26f1ACc220dA1646411c9880Ac")).complete())
      .to.be.revertedWith("ETHDKG: Only validators allowed!")

    })

    it("should not allow double completion of ETHDKG", async () => {
      let [ethdkg, validatorPool, expectedNonce] = await startAtGPKJ(
        validators4
      );

      await assertETHDKGPhase(ethdkg, Phase.GPKJSubmission)
      await submitValidatorsGPKJ(ethdkg, validatorPool, validators4, expectedNonce, 1)

      await expect(ethdkg.connect(await ethers.getSigner(validators4[0].address)).complete())
      .to.be.revertedWith("ETHDKG: cannot complete yet")

      await assertETHDKGPhase(ethdkg, Phase.DisputeGPKJSubmission)
      await endCurrentPhase(ethdkg)
      await assertETHDKGPhase(ethdkg, Phase.DisputeGPKJSubmission)

      let tx = await ethdkg.connect(await ethers.getSigner(validators4[0].address)).complete()

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
      await expect(ethdkg.connect(await ethers.getSigner(validators4[0].address)).complete())
      .to.be.revertedWith("ETHDKG: cannot complete yet")
    })

    it("should not allow validators to participate in previous phases", async () => {
      let [ethdkg, validatorPool, expectedNonce] = await startAtGPKJ(
        validators4
      );

      await assertETHDKGPhase(ethdkg, Phase.GPKJSubmission)
      await submitValidatorsGPKJ(ethdkg, validatorPool, validators4, expectedNonce, 1)

      await expect(ethdkg.connect(await ethers.getSigner(validators4[0].address)).complete())
      .to.be.revertedWith("ETHDKG: cannot complete yet")

      await assertETHDKGPhase(ethdkg, Phase.DisputeGPKJSubmission)
      await endCurrentPhase(ethdkg)
      await assertETHDKGPhase(ethdkg, Phase.DisputeGPKJSubmission)

      let tx = await ethdkg.connect(await ethers.getSigner(validators4[0].address)).complete()

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
      await expect(ethdkg.connect(await ethers.getSigner(validators4[0].address)).register(validators4[0].madNetPublicKey))
      .to.be.revertedWith("ETHDKG: Cannot register at the moment")

      await expect(ethdkg.connect(await ethers.getSigner(validators4[0].address)).accuseParticipantNotRegistered([]))
      .to.be.revertedWith("ETHDKG: should be in post-registration accusation phase!")
      
      await expect(ethdkg.connect(await ethers.getSigner(validators4[0].address)).distributeShares(validators4[0].encryptedShares, validators4[0].commitments))
      .to.be.revertedWith("ETHDKG: cannot participate on this phase")

      await expect(ethdkg.connect(await ethers.getSigner(validators4[0].address)).accuseParticipantDidNotDistributeShares([]))
      .to.be.revertedWith("ETHDKG: should be in post-ShareDistribution accusation phase!")

      await expect(ethdkg.connect(await ethers.getSigner(validators4[0].address)).accuseParticipantDistributedBadShares(PLACEHOLDER_ADDRESS, 0,0, [], [[0,0],[0,0]], [0,0], [0,0]))
      .to.be.revertedWith("Dispute failed! Contract is not in dispute phase")

      await expect(ethdkg.connect(await ethers.getSigner(validators4[0].address)).submitKeyShare(validators4[0].keyShareG1, validators4[0].keyShareG1CorrectnessProof, validators4[0].keyShareG2))
      .to.be.revertedWith("ETHDKG: cannot participate on key share submission phase")

      await expect(ethdkg.connect(await ethers.getSigner(validators4[0].address)).accuseParticipantDidNotSubmitKeyShares([]))
      .to.be.revertedWith("ETHDKG: should be in post-KeyShareSubmission phase!")

      await expect(ethdkg.connect(await ethers.getSigner(validators4[0].address)).submitMasterPublicKey([0,0,0,0]))
      .to.be.revertedWith("ETHDKG: cannot participate on master public key submission phase")

      await expect(ethdkg.connect(await ethers.getSigner(validators4[0].address)).submitGPKj([0,0,0,0]))
      .to.be.revertedWith("ETHDKG: Not in GPKJ submission phase")

      await expect(ethdkg.connect(await ethers.getSigner(validators4[0].address)).accuseParticipantDidNotSubmitGPKJ([]))
      .to.be.revertedWith("ETHDKG: should be in post-GPKJSubmission phase!")

      await expect(ethdkg.connect(await ethers.getSigner(validators4[0].address)).accuseParticipantSubmittedBadGPKj([], [], [[[0,0]]], 0, PLACEHOLDER_ADDRESS))
      .to.be.revertedWith("ETHDKG: should be in post-GPKJSubmission phase!")

      await expect(ethdkg.connect(await ethers.getSigner(validators4[0].address)).complete())
      .to.be.revertedWith("ETHDKG: cannot complete yet")

    })

  })

});
