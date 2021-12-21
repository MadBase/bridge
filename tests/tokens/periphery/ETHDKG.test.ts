import { expect } from "../../chai-setup";
import { ethers, network, upgrades } from "hardhat";
import { BigNumber, BigNumberish, ContractTransaction } from "ethers";
import { assert } from "chai";
import { validators } from "./test-data/4-validators-successful-case";
import { ETHDKG, ValidatorPoolMock } from "../../../typechain-types";

const PLACEHOLDER_ADDRESS = "0x0000000000000000000000000000000000000000";

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

const assertRegistrationComplete = async (
  tx: ContractTransaction,
  blockNumber: number
) => {
  let receipt = await ethers.provider.getTransactionReceipt(tx.hash);
  let intrface = new ethers.utils.Interface([
    "event RegistrationComplete(uint256 blockNumber)",
  ]);
  let data = receipt.logs[1].data;
  let topics = receipt.logs[1].topics;
  let event = intrface.decodeEventLog("RegistrationComplete", data, topics);
  expect(event.blockNumber).to.equal(blockNumber);
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
  tx: ContractTransaction,
  blockNumber: number
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
  expect(event.blockNumber).to.equal(blockNumber);
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
  tx: ContractTransaction,
  blockNumber: number
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
  expect(event.blockNumber).to.equal(blockNumber);
};

const assertEventMPKSet = async (
  tx: ContractTransaction,
  blockNumber: number,
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
  expect(event.blockNumber).to.equal(blockNumber);
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

const assertEventGPKJSubmissionComplete = async (
  tx: ContractTransaction,
  blockNumber: number
) => {
  let receipt = await ethers.provider.getTransactionReceipt(tx.hash);
  let intrface = new ethers.utils.Interface([
    "event GPKJSubmissionComplete(uint256 blockNumber)",
  ]);
  let data = receipt.logs[1].data;
  let topics = receipt.logs[1].topics;
  let event = intrface.decodeEventLog("GPKJSubmissionComplete", data, topics);
  expect(event.blockNumber).to.equal(blockNumber);
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

const skipPhase = async (ethdkg: ETHDKG) => {
  // advance enough blocks to timeout a phase
  let phaseStart = await ethdkg.getPhaseStartBlock();
  let phaseLength = await ethdkg.getPhaseLength();
  let bn = await ethers.provider.getBlockNumber();
  let endBlock = phaseStart.add(phaseLength);
  let blocksToMine = endBlock.sub(bn);
  await mineBlocks(blocksToMine.toNumber());
};

const registerValidators = async (
  ethdkg: ETHDKG,
  validatorPool: ValidatorPoolMock,
  validators: ValidatorRawData[],
  expectedNonce: number
) => {
  for (let [index, validator] of validators.entries()) {
    let tx = ethdkg
      .connect(await ethers.getSigner(validator.address))
      .register(validator.madNetPublicKey);
    expect(tx)
      .to.emit(ethdkg, "AddressRegistered")
      .withArgs(
        validator.address,
        index + 1,
        expectedNonce,
        validator.madNetPublicKey
      );
    let receipt = await tx;
    // if all validators in the Pool participated in this round
    let numValidators = await validatorPool.getValidatorsCount();
    let numParticipants = await ethdkg.getNumParticipants();
    if (numParticipants == numValidators) {
      let bn = await ethers.provider.getBlockNumber();
      await assertRegistrationComplete(receipt, bn);
    }
  }
};

const distributeValidatorsShares = async (
  ethdkg: ETHDKG,
  validatorPool: ValidatorPoolMock,
  validators: ValidatorRawData[],
  expectedNonce: number
) => {
  for (let [index, validator] of validators.entries()) {
    let tx = await ethdkg
      .connect(await ethers.getSigner(validator.address))
      .distributeShares(validator.encryptedShares, validator.commitments);
    await assertEventSharesDistributed(
      tx,
      validator.address,
      index + 1,
      expectedNonce,
      validator.encryptedShares,
      validator.commitments
    );
    // if all validators in the Pool participated in this round
    let numValidators = await validatorPool.getValidatorsCount();
    let numParticipants = await ethdkg.getNumParticipants();
    if (numParticipants == numValidators) {
      let bn = await ethers.provider.getBlockNumber();
      await assertEventShareDistributionComplete(tx, bn);
    }
  }
};

const submitValidatorsKeyShares = async (
  ethdkg: ETHDKG,
  validatorPool: ValidatorPoolMock,
  validators: ValidatorRawData[],
  expectedNonce: number
) => {
  for (let [index, validator] of validators.entries()) {
    let tx = await ethdkg
      .connect(await ethers.getSigner(validator.address))
      .submitKeyShare(
        validator.keyShareG1,
        validator.keyShareG1CorrectnessProof,
        validator.keyShareG2
      );
    await assertEventKeyShareSubmitted(
      tx,
      validator.address,
      index + 1,
      expectedNonce,
      validator.keyShareG1,
      validator.keyShareG1CorrectnessProof,
      validator.keyShareG2
    );
    // if all validators in the Pool participated in this round
    let numValidators = await validatorPool.getValidatorsCount();
    let numParticipants = await ethdkg.getNumParticipants();
    if (numParticipants == numValidators) {
      let bn = await ethers.provider.getBlockNumber();
      await assertEventKeyShareSubmissionComplete(tx, bn);
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
  let bn = await ethers.provider.getBlockNumber();
  await assertEventMPKSet(tx, bn, expectedNonce, validators[index].mpk);
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
  for (let [index, validator] of validators.entries()) {
    let tx = await ethdkg
      .connect(await ethers.getSigner(validator.address))
      .submitGPKj(validator.gpkj);
    await assertEventValidatorMemberAdded(
      tx,
      validator.address,
      index + 1,
      expectedNonce,
      expectedEpoch,
      validator.gpkj
    );
    // if all validators in the Pool participated in this round
    let numValidators = await validatorPool.getValidatorsCount();
    let numParticipants = await ethdkg.getNumParticipants();
    if (numParticipants == numValidators) {
      let bn = await ethers.provider.getBlockNumber();
      await assertEventGPKJSubmissionComplete(tx, bn);
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
  let bn = await ethers.provider.getBlockNumber();
  await assertEventValidatorSetCompleted(
    tx,
    validators.length,
    expectedNonce,
    expectedEpoch,
    1,
    expectedMadHeight,
    validators[index].mpk
  );
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

describe("ETHDKG", function () {
  it("completes happy path", async function () {
    const { ethdkg, validatorPool } = await getFixture();

    const expectedNonce = 1;
    const expectedEpoch = 1;
    const expectedMadHeight = 1;

    // add validators
    await validatorPool.setETHDKG(ethdkg.address);
    await addValidators(validatorPool, validators);

    // start ETHDKG
    await expect(validatorPool.initializeETHDKG())
      .to.emit(ethdkg, "RegistrationOpened")
      .withArgs(13, 1);

    // register all validators
    await registerValidators(ethdkg, validatorPool, validators, expectedNonce);

    // distribute shares for all validators
    await distributeValidatorsShares(
      ethdkg,
      validatorPool,
      validators,
      expectedNonce
    );

    // skipping the distribute shares accusation phase
    await skipPhase(ethdkg);

    // Submit the Key shares for all validators
    await submitValidatorsKeyShares(
      ethdkg,
      validatorPool,
      validators,
      expectedNonce
    );

    // Submit the Master Public key
    await submitMasterPublicKey(ethdkg, validators, expectedNonce);

    // Submit GPKj for all validators
    await submitValidatorsGPKJ(
      ethdkg,
      validatorPool,
      validators,
      expectedNonce,
      expectedEpoch
    );

    // skipping the distribute shares accusation phase
    await skipPhase(ethdkg);

    // Complete ETHDKG
    await completeETHDKG(
      ethdkg,
      validators,
      expectedNonce,
      expectedEpoch,
      expectedMadHeight
    );
  });

  it("does not let registrations before ETHDKG Registration is open", async function () {
    const { ethdkg, validatorPool } = await getFixture();

    // add validators
    await validatorPool.setETHDKG(ethdkg.address);
    await addValidators(validatorPool, validators);

    // for this test, ETHDKG is not started

    // register validator0
    await expect(ethdkg
      .connect(await ethers.getSigner(validators[0].address))
      .register(validators[0].madNetPublicKey))
      .to.be.revertedWith("ETHDKG: Cannot register at the moment")

  });

  it("does not let validators to register more than once", async function () {
    const { ethdkg, validatorPool } = await getFixture();

    // add validators
    await validatorPool.setETHDKG(ethdkg.address);
    await addValidators(validatorPool, validators);

    // start ETHDKG
    await expect(validatorPool.initializeETHDKG())
      .to.emit(ethdkg, "RegistrationOpened")
      .withArgs(await ethers.provider.getBlockNumber()+1, 1);

    // register one validator
    await expect(ethdkg
      .connect(await ethers.getSigner(validators[0].address))
      .register(validators[0].madNetPublicKey))
      .to.emit(ethdkg, "AddressRegistered")

    // register that same validator again
    await expect(ethdkg
      .connect(await ethers.getSigner(validators[0].address))
      .register(validators[0].madNetPublicKey))
      .to.be.revertedWith("Participant is already participating in this ETHDKG round")

  });

  it("does not let validators to register with an incorrect key", async function () {
    const { ethdkg, validatorPool } = await getFixture();

    // add validators
    await validatorPool.setETHDKG(ethdkg.address);
    await addValidators(validatorPool, validators);

    // start ETHDKG
    await expect(validatorPool.initializeETHDKG())
      .to.emit(ethdkg, "RegistrationOpened")
      .withArgs(await ethers.provider.getBlockNumber()+1, 1);

    // register validator0 with invalid pubkey
    const signer0 = await ethers.getSigner(validators[0].address)
    await expect(ethdkg
      .connect(signer0)
      .register([BigNumber.from("0"), BigNumber.from("1")]))
      .to.be.revertedWith("registration failed - pubKey0 invalid")

    await expect(ethdkg
      .connect(signer0)
      .register([BigNumber.from("1"), BigNumber.from("0")]))
      .to.be.revertedWith("registration failed - pubKey1 invalid")

    await expect(ethdkg
      .connect(signer0)
      .register([BigNumber.from("1"), BigNumber.from("1")]))
      .to.be.revertedWith("registration failed - public key not on elliptic curve")
  });

  it("does not let non-validators to register", async function () {
    const { ethdkg, validatorPool } = await getFixture();

    // add validator0 as validator
    await validatorPool.setETHDKG(ethdkg.address);
    await addValidators(validatorPool, validators);

    // start ETHDKG
    await expect(validatorPool.initializeETHDKG())
      .to.emit(ethdkg, "RegistrationOpened")
      .withArgs(await ethers.provider.getBlockNumber()+1, 1);

    // register validator1, which is not a validator in ValidatorPool
    await expect(ethdkg
      .connect(await ethers.getSigner("0x26D3D8Ab74D62C26f1ACc220dA1646411c9880Ac"))
      .register([BigNumber.from("0"), BigNumber.from("0")]))
      .to.be.revertedWith("ETHDKG: Only validators allowed!")
  });

  it("allows accusation of missing validators in ETHDKG registration", async function () {
    const { ethdkg, validatorPool } = await getFixture();

    const expectedNonce = 1;

    // add validators
    await validatorPool.setETHDKG(ethdkg.address);
    await addValidators(validatorPool, validators);

    // start ETHDKG
    await expect(validatorPool.initializeETHDKG())
      .to.emit(ethdkg, "RegistrationOpened")
      .withArgs(await ethers.provider.getBlockNumber()+1, 1);

    // register validators 0 to 2. validator3 won't register
    await registerValidators(ethdkg, validatorPool, validators.slice(0,3), expectedNonce);

    // move to the end of RegistrationOpen phase
    await skipPhase(ethdkg);

    // now we can accuse the validator3 who did not participate.
    // keep in mind that when all missing validators are reported,
    // the ethdkg process will restart automatically and emit "RegistrationOpened" event
    expect(await ethdkg.getBadParticipants()).to.equal(0)

    await expect(ethdkg.accuseParticipantNotRegistered([validators[3].address]))
    .to.emit(ethdkg, "RegistrationOpened")
    .withArgs(await ethers.provider.getBlockNumber()+1, 2);

    expect(await ethdkg.getBadParticipants()).to.equal(0)
  });

  it("allows accusation of missing validators in ETHDKG registration 2", async function () {
    const { ethdkg, validatorPool } = await getFixture();

    const expectedNonce = 1;

    // add validators
    await validatorPool.setETHDKG(ethdkg.address);
    await addValidators(validatorPool, validators);

    // start ETHDKG
    await expect(validatorPool.initializeETHDKG())
      .to.emit(ethdkg, "RegistrationOpened")
      .withArgs(await ethers.provider.getBlockNumber()+1, 1);

    // register validators 0 to 1. validator2 and 3 won't register
    await registerValidators(ethdkg, validatorPool, validators.slice(0,2), expectedNonce);

    // move to the end of RegistrationOpen phase
    await skipPhase(ethdkg);

    // now we can accuse the validator2 and 3 who did not participate.
    // keep in mind that when all missing validators are reported,
    // the ethdkg process will restart automatically and emit "RegistrationOpened" event
    expect(await ethdkg.getBadParticipants()).to.equal(0)

    await ethdkg.accuseParticipantNotRegistered([validators[2].address])
    expect(await ethdkg.getBadParticipants()).to.equal(1)

    await expect(ethdkg.accuseParticipantNotRegistered([validators[3].address]))
    .to.emit(ethdkg, "RegistrationOpened")
    .withArgs(await ethers.provider.getBlockNumber()+1, 2);

    expect(await ethdkg.getBadParticipants()).to.equal(0)
  });
});