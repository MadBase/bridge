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
  describe("Happy Path", () => {
    it("completes happy path with 4 validators", async function () {
      await completeETHDKGRound(validators4)
    });

    it("completes happy path with 10 validators", async function () {
      await completeETHDKGRound(validators10)
    });
  });

  describe("Registration Open", () => {
    it("does not let registrations before ETHDKG Registration is open", async function () {
      const { ethdkg, validatorPool } = await getFixture();

      // add validators
      await validatorPool.setETHDKG(ethdkg.address);
      await addValidators(validatorPool, validators4);

      // for this test, ETHDKG is not started
      // register validator0
      await expect(
        ethdkg
          .connect(await ethers.getSigner(validators4[0].address))
          .register(validators4[0].madNetPublicKey)
      ).to.be.revertedWith("ETHDKG: Cannot register at the moment");
    });

    it("does not let validators to register more than once", async function () {
      const { ethdkg, validatorPool } = await getFixture();

      // add validators
      await validatorPool.setETHDKG(ethdkg.address);
      await addValidators(validatorPool, validators4);
      await initializeETHDKG(ethdkg, validatorPool);

      // register one validator
      await expect(
        ethdkg
          .connect(await ethers.getSigner(validators4[0].address))
          .register(validators4[0].madNetPublicKey)
      ).to.emit(ethdkg, "AddressRegistered");

      // register that same validator again
      await expect(
        ethdkg
          .connect(await ethers.getSigner(validators4[0].address))
          .register(validators4[0].madNetPublicKey)
      ).to.be.revertedWith(
        "Participant is already participating in this ETHDKG round"
      );
    });

    it("does not let validators to register with an incorrect key", async function () {
      const { ethdkg, validatorPool } = await getFixture();

      // add validators
      await validatorPool.setETHDKG(ethdkg.address);
      await addValidators(validatorPool, validators4);

      // start ETHDKG
      await initializeETHDKG(ethdkg, validatorPool);

      // register validator0 with invalid pubkey
      const signer0 = await ethers.getSigner(validators4[0].address);
      await expect(
        ethdkg
          .connect(signer0)
          .register([BigNumber.from("0"), BigNumber.from("1")])
      ).to.be.revertedWith("registration failed - pubKey0 invalid");

      await expect(
        ethdkg
          .connect(signer0)
          .register([BigNumber.from("1"), BigNumber.from("0")])
      ).to.be.revertedWith("registration failed - pubKey1 invalid");

      await expect(
        ethdkg
          .connect(signer0)
          .register([BigNumber.from("1"), BigNumber.from("1")])
      ).to.be.revertedWith(
        "registration failed - public key not on elliptic curve"
      );
    });

    it("does not let non-validators to register", async function () {
      const { ethdkg, validatorPool } = await getFixture();

      // add validators
      await validatorPool.setETHDKG(ethdkg.address);
      await addValidators(validatorPool, validators4);

      // start ETHDKG
      await initializeETHDKG(ethdkg, validatorPool);

      // try to register with a non validator address
      await expect(
        ethdkg
          .connect(
            await ethers.getSigner("0x26D3D8Ab74D62C26f1ACc220dA1646411c9880Ac")
          )
          .register([BigNumber.from("0"), BigNumber.from("0")])
      ).to.be.revertedWith("ETHDKG: Only validators allowed!");
    });
  });

  describe("Missing registration Accusation", () => {
    it("allows accusation of all missing validators after ETHDKG registration", async function () {
      const { ethdkg, validatorPool } = await getFixture();

      const expectedNonce = 1;

      // add validators
      await validatorPool.setETHDKG(ethdkg.address);
      await addValidators(validatorPool, validators4);

      // start ETHDKG
      await initializeETHDKG(ethdkg, validatorPool);

      // register validators 0 to 2. validator3 won't register
      await registerValidators(
        ethdkg,
        validatorPool,
        validators4.slice(0, 2),
        expectedNonce
      );

      // move to the end of RegistrationOpen phase
      await endCurrentPhase(ethdkg);

      // now we can accuse the validator3 who did not participate.
      // keep in mind that when all missing validators are accused,
      // the ethdkg process will restart automatically
      // if there are enough validators registered (>=4 _minValidators)
      expect(await ethdkg.getBadParticipants()).to.equal(0);

      await expect(
        ethdkg.accuseParticipantNotRegistered([
          validators4[2].address,
          validators4[3].address,
        ])
      );

      expect(await ethdkg.getBadParticipants()).to.equal(2);
      await assertETHDKGPhase(ethdkg, Phase.RegistrationOpen);
    });

    it("allows accusation of some missing validators after ETHDKG registration", async function () {
      const { ethdkg, validatorPool } = await getFixture();

      const expectedNonce = 1;

      // add validators
      await validatorPool.setETHDKG(ethdkg.address);
      await addValidators(validatorPool, validators4);

      // start ETHDKG
      await initializeETHDKG(ethdkg, validatorPool);

      // register validators 0 to 1. validator2 and 3 won't register
      await registerValidators(
        ethdkg,
        validatorPool,
        validators4.slice(0, 2),
        expectedNonce
      );

      // move to the end of RegistrationOpen phase
      await endCurrentPhase(ethdkg);

      // now we can accuse the validator2 and 3 who did not participate.
      // keep in mind that when all missing validators are reported,
      // the ethdkg process will restart automatically and emit "RegistrationOpened" event if #validators >= 4
      expect(await ethdkg.getBadParticipants()).to.equal(0);

      await ethdkg.accuseParticipantNotRegistered([validators4[2].address]);
      expect(await ethdkg.getBadParticipants()).to.equal(1);

      await ethdkg.accuseParticipantNotRegistered([validators4[3].address]);

      expect(await ethdkg.getBadParticipants()).to.equal(2);
      await assertETHDKGPhase(ethdkg, Phase.RegistrationOpen);
    });

    // MISSING REGISTRATION ACCUSATION TESTS

    it("won't let non-registration accusations to take place while ETHDKG registration is open", async function () {
      const { ethdkg, validatorPool } = await getFixture();

      const expectedNonce = 1;

      // add validators
      await validatorPool.setETHDKG(ethdkg.address);
      await addValidators(validatorPool, validators4);

      // start ETHDKG
      await initializeETHDKG(ethdkg, validatorPool);

      // register validators 0 to 1. validator2 and 3 won't register
      await registerValidators(
        ethdkg,
        validatorPool,
        validators4.slice(0, 2),
        expectedNonce
      );

      await expect(
        ethdkg.accuseParticipantNotRegistered([validators4[2].address])
      ).to.be.revertedWith(
        "ETHDKG: should be in post-registration accusation phase!"
      );
      expect(await ethdkg.getBadParticipants()).to.equal(0);
      await assertETHDKGPhase(ethdkg, Phase.RegistrationOpen);
    });

    it("should not allow validators to proceed to next phase if 2 out of 4 did not register and the phase has finished", async function () {
      const { ethdkg, validatorPool } = await getFixture();

      const expectedNonce = 1;

      // add validators
      await validatorPool.setETHDKG(ethdkg.address);
      await addValidators(validatorPool, validators4);

      // start ETHDKG
      await initializeETHDKG(ethdkg, validatorPool);

      // register validators 0 to 1. validator2 and 3 won't register
      await registerValidators(
        ethdkg,
        validatorPool,
        validators4.slice(0, 2),
        expectedNonce
      );

      // move to the end of RegistrationOpen phase
      await endCurrentPhase(ethdkg);

      // validator0 should not be able to distribute shares
      let signer0 = await ethers.getSigner(validators4[0].address);
      await expect(
        ethdkg
          .connect(signer0)
          .distributeShares(
            validators4[0].encryptedShares,
            validators4[0].commitments
          )
      ).to.be.rejectedWith("ETHDKG: cannot participate on this phase");
    });

    it("should not allow validators who did not register in time to register on the accusation phase", async function () {
      const { ethdkg, validatorPool } = await getFixture();

      const expectedNonce = 1;

      // add validators
      await validatorPool.setETHDKG(ethdkg.address);
      await addValidators(validatorPool, validators4);

      // start ETHDKG
      await initializeETHDKG(ethdkg, validatorPool);

      // register validators 0 to 1. validator2 and 3 won't register
      await registerValidators(
        ethdkg,
        validatorPool,
        validators4.slice(0, 2),
        expectedNonce
      );

      // move to the end of RegistrationOpen phase
      await endCurrentPhase(ethdkg);

      const signer2 = await ethers.getSigner(validators4[2].address);
      await expect(
        ethdkg.connect(signer2).register(validators4[2].madNetPublicKey)
      ).to.be.revertedWith("ETHDKG: Cannot register at the moment");
    });

    it("should not allow validators who did not register in time to distribute shares", async function () {
      const { ethdkg, validatorPool } = await getFixture();
      const expectedNonce = 1;

      // add validators
      await validatorPool.setETHDKG(ethdkg.address);
      await addValidators(validatorPool, validators4);

      // start ETHDKG
      await initializeETHDKG(ethdkg, validatorPool);

      // register validators 0 to 1. validator2 and 3 won't register
      await registerValidators(
        ethdkg,
        validatorPool,
        validators4.slice(0, 2),
        expectedNonce
      );

      // move to the end of RegistrationOpen phase
      await endCurrentPhase(ethdkg);

      // validator2 should not be able to distribute shares
      let signer2 = await ethers.getSigner(validators4[2].address);
      await expect(
        ethdkg
          .connect(signer2)
          .distributeShares(
            validators4[0].encryptedShares,
            validators4[0].commitments
          )
      ).to.be.rejectedWith("ETHDKG: cannot participate on this phase");
    });

    it("should not allow accusation of validators that registered in ETHDKG", async function () {
      const { ethdkg, validatorPool } = await getFixture();
      const expectedNonce = 1;

      // add validators
      await validatorPool.setETHDKG(ethdkg.address);
      await addValidators(validatorPool, validators4);

      // start ETHDKG
      await initializeETHDKG(ethdkg, validatorPool);

      // register validators 0 to 1. validator2 and 3 won't register
      await registerValidators(
        ethdkg,
        validatorPool,
        validators4.slice(0, 2),
        expectedNonce
      );

      // move to the end of RegistrationOpen phase
      await endCurrentPhase(ethdkg);

      // accuse a participant validator
      await expect(
        ethdkg.accuseParticipantNotRegistered([validators4[0].address])
      ).to.be.rejectedWith(
        "Dispute failed! Issuer is participating in this ETHDKG round!"
      );

      expect(await ethdkg.getBadParticipants()).to.equal(0);
    });

    it("should not allow accusation of non-existent validators in ETHDKG", async function () {
      const { ethdkg, validatorPool } = await getFixture();
      const expectedNonce = 1;

      // add validators
      await validatorPool.setETHDKG(ethdkg.address);
      await addValidators(validatorPool, validators4);

      // start ETHDKG
      await initializeETHDKG(ethdkg, validatorPool);

      // register validators 0 to 1. validator2 and 3 won't register
      await registerValidators(
        ethdkg,
        validatorPool,
        validators4.slice(0, 2),
        expectedNonce
      );

      // move to the end of RegistrationOpen phase
      await endCurrentPhase(ethdkg);

      // accuse a non-existent validator
      await expect(
        ethdkg.accuseParticipantNotRegistered([
          "0x26D3D8Ab74D62C26f1ACc220dA1646411c9880Ac",
        ])
      ).to.be.rejectedWith("Dishonest Address is not a validator at the moment!");

      expect(await ethdkg.getBadParticipants()).to.equal(0);
    });

    it("should not allow accusations after the accusation window", async function () {
      const { ethdkg, validatorPool } = await getFixture();
      const expectedNonce = 1;

      // add validators
      await validatorPool.setETHDKG(ethdkg.address);
      await addValidators(validatorPool, validators4);

      // start ETHDKG
      await initializeETHDKG(ethdkg, validatorPool);

      // register validators 0 to 1. validator2 and 3 won't register
      await registerValidators(
        ethdkg,
        validatorPool,
        validators4.slice(0, 2),
        expectedNonce
      );

      // move to the end of RegistrationOpen phase
      await endCurrentPhase(ethdkg);

      // move to the end of RegistrationAccusation phase
      await endCurrentAccusationPhase(ethdkg);

      // accuse a non-participant validator
      await expect(
        ethdkg.accuseParticipantNotRegistered([validators4[2].address])
      ).to.be.rejectedWith(
        "ETHDKG: should be in post-registration accusation phase!"
      );

      expect(await ethdkg.getBadParticipants()).to.equal(0);
    });

    it("should not allow accusations of non-existent validators along with existent", async function () {
      const { ethdkg, validatorPool } = await getFixture();
      const expectedNonce = 1;

      // add validators
      await validatorPool.setETHDKG(ethdkg.address);
      await addValidators(validatorPool, validators4);

      // start ETHDKG
      await initializeETHDKG(ethdkg, validatorPool);

      // register validators 0 to 1. validator2 and 3 won't register
      await registerValidators(
        ethdkg,
        validatorPool,
        validators4.slice(0, 2),
        expectedNonce
      );

      // move to the end of RegistrationOpen phase
      await endCurrentPhase(ethdkg);

      // accuse a participant validator
      await expect(
        ethdkg.accuseParticipantNotRegistered([
          validators4[2].address,
          validators4[3].address,
          "0x26D3D8Ab74D62C26f1ACc220dA1646411c9880Ac",
        ])
      ).to.be.rejectedWith("Dishonest Address is not a validator at the moment!");

      expect(await ethdkg.getBadParticipants()).to.equal(0);
    });

    it("should not move to ShareDistribution phase when only 2 out of 4 validators have participated", async function () {
      // Accuse 1 participant that didn't participate and wait the window to expire and try to go to the next phase after accusation

      const { ethdkg, validatorPool } = await getFixture();
      const expectedNonce = 1;

      // add validators
      await validatorPool.setETHDKG(ethdkg.address);
      await addValidators(validatorPool, validators4);

      // start ETHDKG
      await initializeETHDKG(ethdkg, validatorPool);

      // register validators 0 to 1. validator 2 and 3 won't register
      await registerValidators(
        ethdkg,
        validatorPool,
        validators4.slice(0, 2),
        expectedNonce
      );

      // move to the end of RegistrationOpen phase
      await endCurrentPhase(ethdkg);

      // accuse a non-registered validator
      await ethdkg.accuseParticipantNotRegistered([validators4[2].address]);

      expect(await ethdkg.getBadParticipants()).to.equal(1);

      // move to the end of RegistrationAccusation phase
      await endCurrentAccusationPhase(ethdkg);

      // try to move into Distribute Shares phase
      await expect(
        ethdkg
          .connect(await ethers.getSigner(validators4[0].address))
          .distributeShares(
            validators4[0].encryptedShares,
            validators4[0].commitments
          )
      ).to.be.rejectedWith("ETHDKG: cannot participate on this phase");

      await assertETHDKGPhase(ethdkg, Phase.RegistrationOpen);
    });

    it("should move to ShareDistribution phase when all non-participant validators have been accused and #validators >= _minValidators", async function () {
      const { ethdkg, validatorPool } = await getFixture();
      const expectedNonce = 1;

      // validator 11
      const validator11 = "0x23EA3Bad9115d436190851cF4C49C1032fA7579A";

      // add validators
      await validatorPool.setETHDKG(ethdkg.address);
      await addValidators(validatorPool, validators10);

      // add validator 11
      await validatorPool.addValidator(validator11);
      expect(await validatorPool.isValidator(validator11)).to.equal(true);

      // start ETHDKG
      await initializeETHDKG(ethdkg, validatorPool);

      // register all 10 validators
      await registerValidators(
        ethdkg,
        validatorPool,
        validators10,
        expectedNonce
      );

      // move to the end of RegistrationOpen phase
      await endCurrentPhase(ethdkg);

      // accuse non-participant validator 11
      await expect(ethdkg.accuseParticipantNotRegistered([validator11]))
        .to.emit(ethdkg, "RegistrationComplete")
        .withArgs((await ethers.provider.getBlockNumber()) + 1);

      expect(await ethdkg.getBadParticipants()).to.equal(1);
      await waitNextPhaseStartDelay(ethdkg);
      await assertETHDKGPhase(ethdkg, Phase.ShareDistribution);

      // try distributing shares
      await expect(
        ethdkg
          .connect(await ethers.getSigner(validators10[0].address))
          .distributeShares(
            validators10[0].encryptedShares,
            validators10[0].commitments
          )
      ).to.emit(ethdkg, "SharesDistributed");

      await assertETHDKGPhase(ethdkg, Phase.ShareDistribution);
    });

    it("should not allow double accusation for missing registration", async function () {
      const { ethdkg, validatorPool } = await getFixture();
      const expectedNonce = 1;

      // add validators
      await validatorPool.setETHDKG(ethdkg.address);
      await addValidators(validatorPool, validators4);

      // start ETHDKG
      await initializeETHDKG(ethdkg, validatorPool);

      // register validators 0 to 1. validator2 and 3 won't register
      await registerValidators(
        ethdkg,
        validatorPool,
        validators4.slice(0, 2),
        expectedNonce
      );

      // move to the end of RegistrationOpen phase
      await endCurrentPhase(ethdkg);

      // accuse non-participant validator 2, twice
      await expect(
        ethdkg.accuseParticipantNotRegistered([
          validators4[2].address,
          validators4[2].address,
        ])
      ).to.be.rejectedWith("Dishonest Address is not a validator at the moment!");

      await assertETHDKGPhase(ethdkg, Phase.RegistrationOpen);
    });
  });

  describe("Distribute Shares", () => {
    it("does not let distribute shares before Distribute Share Phase is open", async function () {
      const { ethdkg, validatorPool } = await getFixture();

      const expectedNonce = 1;

      // add validators
      await validatorPool.setETHDKG(ethdkg.address);
      await addValidators(validatorPool, validators4);

      // start ETHDKG
      await initializeETHDKG(ethdkg, validatorPool);

      // register only validator 0, so the registration phase hasn't finished yet
      await registerValidators(
        ethdkg,
        validatorPool,
        validators4.slice(0, 1),
        expectedNonce
      );

      // distribute shares before the time
      await expect(
        distributeValidatorsShares(
          ethdkg,
          validatorPool,
          validators4.slice(0, 1),
          expectedNonce
        )
      ).to.be.rejectedWith("ETHDKG: cannot participate on this phase");
    });

    it("does not let non-validators to distribute shares", async function () {
      let [ethdkg, validatorPool, expectedNonce] =
        await startAtDistributeShares(validators4);

      // try to distribute shares with a non validator address
      await expect(
        ethdkg
          .connect(
            await ethers.getSigner("0x26D3D8Ab74D62C26f1ACc220dA1646411c9880Ac")
          )
          .distributeShares(
            [BigNumber.from("0")],
            [[BigNumber.from("0"), BigNumber.from("0")]]
          )
      ).to.be.revertedWith("ETHDKG: Only validators allowed!");
    });

    it("does not let validator to distribute shares more than once", async function () {
      let [ethdkg, validatorPool, expectedNonce] =
        await startAtDistributeShares(validators4);

      await distributeValidatorsShares(
        ethdkg,
        validatorPool,
        validators4.slice(0, 1),
        expectedNonce
      );

      // distribute shares before the time
      await expect(
        distributeValidatorsShares(
          ethdkg,
          validatorPool,
          validators4.slice(0, 1),
          expectedNonce
        )
      ).to.be.rejectedWith(
        "Participant already distributed shares this ETHDKG round"
      );
    });

    it("does not let validator send empty commitments or encrypted shares", async function () {
      let [ethdkg, validatorPool, expectedNonce] =
        await startAtDistributeShares(validators4);

      // distribute shares with empty data
      await expect(
        ethdkg
          .connect(await ethers.getSigner(validators4[0].address))
          .distributeShares([BigNumber.from("0")], validators4[0].commitments)
      ).to.be.rejectedWith(
        "share distribution failed, invalid number of encrypted shares provided"
      );

      await expect(
        ethdkg
          .connect(await ethers.getSigner(validators4[0].address))
          .distributeShares(validators4[0].encryptedShares, [
            [BigNumber.from("0"), BigNumber.from("0")],
          ])
      ).to.be.rejectedWith(
        "key sharing failed, invalid number of commitments provided"
      );

      await expect(
        ethdkg
          .connect(await ethers.getSigner(validators4[0].address))
          .distributeShares(validators4[0].encryptedShares, [
            [BigNumber.from("0"), BigNumber.from("0")],
            [BigNumber.from("0"), BigNumber.from("0")],
            [BigNumber.from("0"), BigNumber.from("0")],
          ])
      ).to.be.rejectedWith(
        "key sharing failed commitment not on elliptic curve"
      );

      // the user can send empty encrypted shares on this phase, the accusation window will be
      // handling this!
      let tx = await ethdkg
        .connect(await ethers.getSigner(validators4[0].address))
        .distributeShares(
          [BigNumber.from("0"), BigNumber.from("0"), BigNumber.from("0")],
          validators4[0].commitments
        );
      await assertEventSharesDistributed(
        tx,
        validators4[0].address,
        1,
        expectedNonce,
        [BigNumber.from("0"), BigNumber.from("0"), BigNumber.from("0")],
        validators4[0].commitments
      );
    });
  });

  describe("Missing distribute share accusation", () => {
    it("allows accusation of all missing validators after distribute shares Phase", async function () {
      let [ethdkg, validatorPool, expectedNonce] =
        await startAtDistributeShares(validators4);

      //Only validator 0 and 1 distributed shares
      await distributeValidatorsShares(
        ethdkg,
        validatorPool,
        validators4.slice(0, 2),
        expectedNonce
      );

      // move to the end of Distribute Share phase
      await endCurrentPhase(ethdkg);

      // now we can accuse the validator3 who did not participate.
      // keep in mind that when all missing validators are reported,
      // the ethdkg process will restart automatically and emit "RegistrationOpened" event
      expect(await ethdkg.getBadParticipants()).to.equal(0);

      await ethdkg.accuseParticipantDidNotDistributeShares([
        validators4[2].address,
        validators4[3].address,
      ]);

      await expect(await ethdkg.getBadParticipants()).to.equal(2);

      // move to the end of Distribute Share Dispute phase
      await endCurrentPhase(ethdkg);

      await expect(
        ethdkg
          .connect(await ethers.getSigner(validators4[0].address))
          .submitKeyShare(
            validators4[0].keyShareG1,
            validators4[0].keyShareG1CorrectnessProof,
            validators4[0].keyShareG2
          )
      ).to.be.revertedWith(
        "ETHDKG: cannot participate on key share submission phase"
      );
    });

    it("allows accusation of some missing validators after distribute shares Phase", async function () {
      let [ethdkg, validatorPool, expectedNonce] =
        await startAtDistributeShares(validators4);

      //Only validator 0 and 1 distributed shares
      await distributeValidatorsShares(
        ethdkg,
        validatorPool,
        validators4.slice(0, 2),
        expectedNonce
      );

      // move to the end of Distribute Share phase
      await endCurrentPhase(ethdkg);

      // now we can accuse the validator2 and 3 who did not participate.
      expect(await ethdkg.getBadParticipants()).to.equal(0);

      await ethdkg.accuseParticipantDidNotDistributeShares([
        validators4[2].address,
      ]);
      expect(await ethdkg.getBadParticipants()).to.equal(1);

      await ethdkg.accuseParticipantDidNotDistributeShares([
        validators4[3].address,
      ]);
      expect(await ethdkg.getBadParticipants()).to.equal(2);

      // move to the end of Distribute Share Dispute phase
      await endCurrentPhase(ethdkg);

      // user tries to go to the next phase
      await expect(
        ethdkg
          .connect(await ethers.getSigner(validators4[0].address))
          .submitKeyShare(
            validators4[0].keyShareG1,
            validators4[0].keyShareG1CorrectnessProof,
            validators4[0].keyShareG2
          )
      ).to.be.revertedWith(
        "ETHDKG: cannot participate on key share submission phase"
      );
    });

    it("do not allow validators to proceed to the next phase if not all validators distributed their shares", async function () {
      let [ethdkg, validatorPool, expectedNonce] =
        await startAtDistributeShares(validators4);

      //Only validator 0 and 1 distributed shares
      await distributeValidatorsShares(
        ethdkg,
        validatorPool,
        validators4.slice(0, 2),
        expectedNonce
      );

      // move to the end of Distribute Share phase
      await endCurrentPhase(ethdkg);

      // move to the end of Distribute Share Dispute phase
      await endCurrentPhase(ethdkg);

      // valid user tries to go to the next phase
      await expect(
        ethdkg
          .connect(await ethers.getSigner(validators4[0].address))
          .submitKeyShare(
            validators4[0].keyShareG1,
            validators4[0].keyShareG1CorrectnessProof,
            validators4[0].keyShareG2
          )
      ).to.be.revertedWith(
        "ETHDKG: cannot participate on key share submission phase"
      );
    });

    // MISSING REGISTRATION ACCUSATION TESTS

    it("won't let not-distributed shares accusations to take place while ETHDKG Distribute Share Phase is open", async function () {
      let [ethdkg, validatorPool, expectedNonce] =
        await startAtDistributeShares(validators4);

      //Only validator 0 and 1 distributed shares
      await distributeValidatorsShares(
        ethdkg,
        validatorPool,
        validators4.slice(0, 2),
        expectedNonce
      );

      await expect(
        ethdkg.accuseParticipantDidNotDistributeShares([validators4[2].address])
      ).to.be.revertedWith(
        "ETHDKG: should be in post-ShareDistribution accusation phase!"
      );
    });

    it("should not allow validators who did not distributed shares in time to distribute on the accusation phase", async function () {
      let [ethdkg, validatorPool, expectedNonce] =
        await startAtDistributeShares(validators4);

      //Only validator 0 and 1 distributed shares
      await distributeValidatorsShares(
        ethdkg,
        validatorPool,
        validators4.slice(0, 2),
        expectedNonce
      );

      // move to the end of Distribute Share phase
      await endCurrentPhase(ethdkg);

      await expect(
        ethdkg
          .connect(await ethers.getSigner(validators4[2].address))
          .distributeShares(
            validators4[2].encryptedShares,
            validators4[2].commitments
          )
      ).to.be.revertedWith("ETHDKG: cannot participate on this phase");
    });

    it("should not allow validators who did not distributed shares in time to submit Key shares", async function () {
      let [ethdkg, validatorPool, expectedNonce] =
        await startAtDistributeShares(validators4);

      //Only validator 0 and 1 distributed shares
      await distributeValidatorsShares(
        ethdkg,
        validatorPool,
        validators4.slice(0, 2),
        expectedNonce
      );

      // move to the end of Distribute Share phase
      await endCurrentPhase(ethdkg);

      // move to the end of Distribute Share Dispute phase
      await endCurrentPhase(ethdkg);

      // valid user tries to go to the next phase
      await expect(
        ethdkg
          .connect(await ethers.getSigner(validators4[0].address))
          .submitKeyShare(
            validators4[0].keyShareG1,
            validators4[0].keyShareG1CorrectnessProof,
            validators4[0].keyShareG2
          )
      ).to.be.revertedWith(
        "ETHDKG: cannot participate on key share submission phase"
      );

      // non-participant user tries to go to the next phase
      await expect(
        ethdkg
          .connect(await ethers.getSigner(validators4[3].address))
          .submitKeyShare(
            validators4[0].keyShareG1,
            validators4[0].keyShareG1CorrectnessProof,
            validators4[0].keyShareG2
          )
      ).to.be.revertedWith(
        "ETHDKG: cannot participate on key share submission phase"
      );
    });

    it("should not allow accusation of not distributing shares of validators that distributed shares", async function () {
      let [ethdkg, validatorPool, expectedNonce] =
        await startAtDistributeShares(validators4);

      //Only validator 0 and 1 distributed shares
      await distributeValidatorsShares(
        ethdkg,
        validatorPool,
        validators4.slice(0, 2),
        expectedNonce
      );

      // move to the end of Distribute Share phase
      await endCurrentPhase(ethdkg);

      // now we can accuse the validator2 and 3 who did not participate.
      expect(await ethdkg.getBadParticipants()).to.equal(0);

      await expect(
        ethdkg.accuseParticipantDidNotDistributeShares([validators4[0].address])
      ).to.be.revertedWith(
        "Dispute failed! Issuer distributed its share in this ETHDKG round!"
      );

      expect(await ethdkg.getBadParticipants()).to.equal(0);
    });

    it("should not allow accusation of not distributing shares for non-validators", async function () {
      let [ethdkg, validatorPool, expectedNonce] =
        await startAtDistributeShares(validators4);

      //Only validator 0 and 1 distributed shares
      await distributeValidatorsShares(
        ethdkg,
        validatorPool,
        validators4.slice(0, 2),
        expectedNonce
      );

      // move to the end of Distribute Share phase
      await endCurrentPhase(ethdkg);

      // now we can accuse the validator2 and 3 who did not participate.
      expect(await ethdkg.getBadParticipants()).to.equal(0);

      await expect(
        ethdkg.accuseParticipantDidNotDistributeShares([
          "0x26D3D8Ab74D62C26f1ACc220dA1646411c9880Ac",
        ])
      ).to.be.revertedWith(
        "Dishonest Address is not a validator at the moment!"
      );

      expect(await ethdkg.getBadParticipants()).to.equal(0);
    });

    it("should not allow not distributed shares accusations after accusation window has finished", async function () {
      let [ethdkg, validatorPool, expectedNonce] =
        await startAtDistributeShares(validators4);

      //Only validator 0 and 1 distributed shares
      await distributeValidatorsShares(
        ethdkg,
        validatorPool,
        validators4.slice(0, 2),
        expectedNonce
      );

      // move to the end of Distribute Share phase
      await endCurrentPhase(ethdkg);

      // now we can accuse the validator2 and 3 who did not participate.
      expect(await ethdkg.getBadParticipants()).to.equal(0);

      await endCurrentAccusationPhase(ethdkg);

      await expect(
        ethdkg.accuseParticipantDidNotDistributeShares([validators4[2].address])
      ).to.be.revertedWith(
        "ETHDKG: should be in post-ShareDistribution accusation phase!"
      );
    });

    it("should not allow accusing a user that distributed the shares in the middle of the ones that did not", async function () {
      let [ethdkg, validatorPool, expectedNonce] =
        await startAtDistributeShares(validators4);

      //Only validator 0 and 1 distributed shares
      await distributeValidatorsShares(
        ethdkg,
        validatorPool,
        validators4.slice(0, 2),
        expectedNonce
      );

      // move to the end of Distribute Share phase
      await endCurrentPhase(ethdkg);

      expect(await ethdkg.getBadParticipants()).to.equal(0);

      await expect(
        ethdkg.accuseParticipantDidNotDistributeShares([validators4[2].address, validators4[3].address, validators4[0].address])
      ).to.be.revertedWith(
        "Dispute failed! Issuer distributed its share in this ETHDKG round!"
      );

      expect(await ethdkg.getBadParticipants()).to.equal(0);
    });

    it("should not allow double accusation of a user that did not share his shares", async function () {
      let [ethdkg, validatorPool, expectedNonce] =
        await startAtDistributeShares(validators4);

      //Only validator 0 and 1 distributed shares
      await distributeValidatorsShares(
        ethdkg,
        validatorPool,
        validators4.slice(0, 2),
        expectedNonce
      );

      // move to the end of Distribute Share phase
      await endCurrentPhase(ethdkg);

      expect(await ethdkg.getBadParticipants()).to.equal(0);

      await expect(
        ethdkg.accuseParticipantDidNotDistributeShares([validators4[2].address])
      )

      await expect(
        ethdkg.accuseParticipantDidNotDistributeShares([validators4[2].address])
      ).to.be.revertedWith(
        "Dishonest Address is not a validator at the moment!"
      );

      expect(await ethdkg.getBadParticipants()).to.equal(1);
    });

  });

  describe("Distribute bad shares accusation", () => {});

  describe("Submit Key share", () => {

    it("should not allow submission of key shares when not in KeyShareSubmission phase", async () => {
      let [ethdkg, validatorPool, expectedNonce] = await startAtDistributeShares(
        validators4
      );
      // distribute shares for all validators
      await distributeValidatorsShares(
        ethdkg,
        validatorPool,
        validators4,
        expectedNonce
      );

      await expect(submitValidatorsKeyShares(
        ethdkg,
        validatorPool,
        validators4,
        expectedNonce
      ))
      .to.be.rejectedWith("ETHDKG: cannot participate on key share submission phase")
    })

    it("should allow submission of key shares", async function () {
      let [ethdkg, validatorPool, expectedNonce] = await startAtSubmitKeyShares(
        validators4
      );
      // Submit the Key shares for all validators
      await submitValidatorsKeyShares(
        ethdkg,
        validatorPool,
        validators4,
        expectedNonce
      );
      await waitNextPhaseStartDelay(ethdkg);
    });

    it("should not allow non-validator to submit key shares", async function () {
      let [ethdkg, validatorPool, expectedNonce] = await startAtSubmitKeyShares(
        validators4
      );

      // a non-validator tries to submit the Key shares
      const validator11 = "0x23EA3Bad9115d436190851cF4C49C1032fA7579A";
      // the following key shares are random
      const val11KeyShareG1: [BigNumberish, BigNumberish] = [
        "17035310766744831563591292029696192827665758482745443896273681135609364351966",
        "8801780341017589574914043621916619466439019492703882557005011145310693503950",
      ]
      const val11KeyShareG1CorrectnessProof: [BigNumberish, BigNumberish] = [
        "6543809733837281689024771115555619859286425076097977581554882983559941504331",
        "2641364196812055977500829600424881630686738586362647621109052312363561915812",
      ]
      const val11KeyShareG2: [BigNumberish, BigNumberish, BigNumberish, BigNumberish] = [
        "422853908170281277163470858333106055290638104506421291199546067593853935136",
        "9467833597932378734715085763545858869972930499954379185225159397601362594154",
        "8743598319810782186450993867080805497457018022200839730580834926549940363993",
        "19522351501097379178289251110843345007238019509263663307388430690023301219325",
      ]
      await expect(ethdkg
      .connect(await ethers.getSigner(validator11))
      .submitKeyShare(
        val11KeyShareG1,
        val11KeyShareG1CorrectnessProof,
        val11KeyShareG2
      ))
      .to.be.rejectedWith("ETHDKG: Only validators allowed!")
    });

    it("should not allow multiple submission of key shares by the same validator", async function () {
      let [ethdkg, validatorPool, expectedNonce] = await startAtSubmitKeyShares(
        validators4
      );
      // Submit the Key shares for all validators
      await submitValidatorsKeyShares(
        ethdkg,
        validatorPool,
        validators4.slice(0,1),
        expectedNonce
      );

      await expect(submitValidatorsKeyShares(
        ethdkg,
        validatorPool,
        validators4.slice(0,1),
        expectedNonce
      ))
      .to.be.revertedWith("Participant already submitted key shares this ETHDKG round")
    });

    it("should not allow submission of key shares with empty input data", async function () {
      let [ethdkg, validatorPool, expectedNonce] = await startAtSubmitKeyShares(
        validators4
      );

      // Submit empty Key shares for all validators
      await expect(ethdkg
      .connect(await ethers.getSigner(validators4[0].address))
      .submitKeyShare(
        ["0", "0"],
        ["0", "0"],
        ["0", "0", "0", "0"]
      ))
      .to.be.rejectedWith("key share submission failed invalid key share G1")

      await expect(ethdkg
        .connect(await ethers.getSigner(validators4[0].address))
        .submitKeyShare(
          validators4[0].keyShareG1,
          ["0", "0"],
          ["0", "0", "0", "0"]
        ))
        .to.be.rejectedWith("key share submission failed invalid key share G1")

      await expect(ethdkg
        .connect(await ethers.getSigner(validators4[0].address))
        .submitKeyShare(
          validators4[0].keyShareG1,
          validators4[0].keyShareG1CorrectnessProof,
          ["0", "0", "0", "0"]
        ))
        .to.be.rejectedWith("key share submission failed invalid key share G2")
    });
  });

  describe("Submit Master Public Key", () => {

    it("should not allow submission of master public key when not in MPKSubmission phase", async () => {
      let [ethdkg, validatorPool, expectedNonce] = await startAtSubmitKeyShares(
        validators4
      );
      // distribute shares for all but 1 validators
      await submitValidatorsKeyShares(
        ethdkg,
        validatorPool,
        validators4.slice(0,3),
        expectedNonce
      );

      await assertETHDKGPhase(ethdkg, Phase.KeyShareSubmission)
      await waitNextPhaseStartDelay(ethdkg)
      await assertETHDKGPhase(ethdkg, Phase.KeyShareSubmission)

      await expect(ethdkg.connect(await ethers.getSigner(validators4[3].address)).submitMasterPublicKey(validators4[3].mpk))
      .to.be.rejectedWith("ETHDKG: cannot participate on master public key submission phase")

    })

    it("should allow submission of master public key by a non-validator", async () => {
      let [ethdkg, validatorPool, expectedNonce] = await startAtMPKSubmission(
        validators4
      );

      // non-validator user tries to submit the Master Public key
      const validator11 = "0x23EA3Bad9115d436190851cF4C49C1032fA7579A";
      const val11MPK: [BigNumberish, BigNumberish, BigNumberish, BigNumberish] = validators4[0].mpk

      const tx = await ethdkg.connect(await ethers.getSigner(validator11)).submitMasterPublicKey(val11MPK)

      await assertEventMPKSet(tx, expectedNonce, val11MPK);
    })

    it("should not allow submission of master public key more than once", async () => {
      let [ethdkg, validatorPool, expectedNonce] = await startAtMPKSubmission(
        validators4
      );

      // non-validator user tries to submit the Master Public key
      const validator11 = "0x23EA3Bad9115d436190851cF4C49C1032fA7579A";
      const val11MPK: [BigNumberish, BigNumberish, BigNumberish, BigNumberish] = validators4[0].mpk

      const tx = await ethdkg.connect(await ethers.getSigner(validator11)).submitMasterPublicKey(val11MPK)

      await assertEventMPKSet(tx, expectedNonce, val11MPK);

      await expect(ethdkg.connect(await ethers.getSigner(validator11)).submitMasterPublicKey(val11MPK))
      .to.be.revertedWith("ETHDKG: cannot participate on master public key submission phase")
    })

    it("should not allow submission of empty master public key", async () => {
      let [ethdkg, validatorPool, expectedNonce] = await startAtMPKSubmission(
        validators4
      );

      // empty MPK
      const mpk: [BigNumberish, BigNumberish, BigNumberish, BigNumberish] = ["0", "0", "0", "0"]

      await expect(ethdkg.connect(await ethers.getSigner(validators4[0].address)).submitMasterPublicKey(mpk))
      .to.be.revertedWith("master key submission pairing check failed")
    })

  })

  describe("Accuse participant of not submitting key shares", () => {
    it("allows accusation of all missing validators after Key share phase", async function () {
      let [ethdkg, validatorPool, expectedNonce] = await startAtSubmitKeyShares(
        validators4
      );

      // distribute shares only for validators 0 and 1
      await submitValidatorsKeyShares(
        ethdkg,
        validatorPool,
        validators4.slice(0, 2),
        expectedNonce
      );

      // move to the end of Key Share phase
      await endCurrentPhase(ethdkg);

      await expect(await ethdkg.getBadParticipants()).to.equal(0);
      await ethdkg.accuseParticipantDidNotSubmitKeyShares([
        validators4[2].address,
        validators4[3].address,
      ]);

      await expect(await ethdkg.getBadParticipants()).to.equal(2);
      // move to the end of Key Share Accusation phase
      await endCurrentPhase(ethdkg);

      await expect(
        ethdkg
          .connect(await ethers.getSigner(validators4[0].address))
          .submitMasterPublicKey(validators4[0].mpk)
      ).to.be.revertedWith(
        "ETHDKG: cannot participate on master public key submission phase"
      );
    });

    it("allows accusation of some missing validators after Key share phase", async function () {
      let [ethdkg, validatorPool, expectedNonce] = await startAtSubmitKeyShares(
        validators4
      );

      // distribute shares only for validators 0 and 1
      await submitValidatorsKeyShares(
        ethdkg,
        validatorPool,
        validators4.slice(0, 2),
        expectedNonce
      );

      // move to the end of Key Share phase
      await endCurrentPhase(ethdkg);

      await expect(await ethdkg.getBadParticipants()).to.equal(0);
      await ethdkg.accuseParticipantDidNotSubmitKeyShares([
        validators4[2].address,
      ]);
      await expect(await ethdkg.getBadParticipants()).to.equal(1);
      await ethdkg.accuseParticipantDidNotSubmitKeyShares([
        validators4[3].address,
      ]);
      await expect(await ethdkg.getBadParticipants()).to.equal(2);

      // move to the end of Key Share Accusation phase
      await endCurrentPhase(ethdkg);

      await expect(
        ethdkg
          .connect(await ethers.getSigner(validators4[0].address))
          .submitMasterPublicKey(validators4[0].mpk)
      ).to.be.revertedWith(
        "ETHDKG: cannot participate on master public key submission phase"
      );
    });

    it("do not allow validators to proceed to the next phase if not all validators submitted their key shares", async function () {
      let [ethdkg, validatorPool, expectedNonce] = await startAtSubmitKeyShares(
        validators4
      );

      // distribute shares only for validators 0 and 1
      await submitValidatorsKeyShares(
        ethdkg,
        validatorPool,
        validators4.slice(0, 2),
        expectedNonce
      );

      // move to the end of Key Share phase
      await endCurrentPhase(ethdkg);

      await expect(
        ethdkg
          .connect(await ethers.getSigner(validators4[0].address))
          .submitMasterPublicKey(validators4[0].mpk)
      ).to.be.revertedWith(
        "ETHDKG: cannot participate on master public key submission phase"
      );
    });

    it("won't let not-distributed shares accusations to take place while ETHDKG Distribute Share Phase is open", async function () {
      let [ethdkg, validatorPool, expectedNonce] = await startAtSubmitKeyShares(
        validators4
      );

      // distribute shares only for validators 0 and 1
      await submitValidatorsKeyShares(
        ethdkg,
        validatorPool,
        validators4.slice(0, 2),
        expectedNonce
      );

      await expect(
        ethdkg.accuseParticipantDidNotSubmitKeyShares([validators4[2].address])
      ).to.be.revertedWith(
        "ETHDKG: should be in post-KeyShareSubmission phase!"
      );
    });

    it("should not allow validators who did not submit key shares in time to submit on the accusation phase", async function () {
      let [ethdkg, validatorPool, expectedNonce] = await startAtSubmitKeyShares(
        validators4
      );

      // distribute shares only for validators 0 and 1
      await submitValidatorsKeyShares(
        ethdkg,
        validatorPool,
        validators4.slice(0, 2),
        expectedNonce
      );

      // move to the end of Key Share Accusation phase
      await endCurrentPhase(ethdkg);

      expect(
        ethdkg
          .connect(await ethers.getSigner(validators4[2].address))
          .submitKeyShare(
            validators4[2].keyShareG1,
            validators4[2].keyShareG1CorrectnessProof,
            validators4[2].keyShareG2
          )
      ).to.revertedWith(
        "ETHDKG: cannot participate on key share submission phase"
      );

      // non-participant user tries to go to the next phase
      await expect(
        ethdkg
          .connect(await ethers.getSigner(validators4[3].address))
          .submitMasterPublicKey(validators4[3].mpk)
      ).to.be.revertedWith(
        "ETHDKG: cannot participate on master public key submission phase"
      );
    });
  });
});
