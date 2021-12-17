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
  console.log(`MadToken deployed at ${madToken.address}`);

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
  console.log(`MadByte deployed at ${madByte.address}`);

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
  console.log(`StakeNFT deployed at ${stakeNFT.address}`);

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
  console.log(`ValidatorNFT deployed at ${validatorNFT.address}`);

  // ValidatorPool
  const ValidatorPool = await ethers.getContractFactory("ValidatorPoolMock");
  const validatorPool = await ValidatorPool.deploy();
  await validatorPool.deployed();
  console.log(`ValidatorPool deployed at ${validatorPool.address}`);

  // ETHDKG
  const ETHDKG = await ethers.getContractFactory("ETHDKG");
  const ethdkg = await ETHDKG.deploy();
  await ethdkg.deployed();
  console.log(`ETHDKG deployed at ${ethdkg.address}`);

  await ethdkg.initialize(validatorPool.address);

  console.log("finished core deployment");

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

// distribute shares helpers

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
  let event = intrface.decodeEventLog(
    "RegistrationComplete",
    data,
    topics
  );
  expect(event.blockNumber).to.equal(blockNumber);
};

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

// submit key shares helpers

const assertEventKeyShareSubmitted = async (
  tx: ContractTransaction,
  account: string,
  index: string,
  nonce: string,
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
  expect(event.index.toString()).to.equal(index);
  expect(event.nonce.toString()).to.equal(nonce);
  assertEqKeyShareG1(event.keyShareG1, keyShareG1);
  assertEqKeyShareG1(
    event.keyShareG1CorrectnessProof,
    keyShareG1CorrectnessProof
  );
  assertEqKeyShareG2(event.keyShareG2, keyShareG2);
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

const assertEventKeyShareSubmissionComplete = async (
  tx: ContractTransaction,
  blockNumber: string
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

// submit MPK phase

const assertEventMPKSet = async (
  tx: ContractTransaction,
  blockNumber: string,
  nonce: string,
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
  nonce: string,
  epoch: string,
  index: string,
  gpkj: [BigNumberish, BigNumberish, BigNumberish, BigNumberish]
) => {
  let receipt = await ethers.provider.getTransactionReceipt(tx.hash);
  let intrface = new ethers.utils.Interface([
    "event ValidatorMemberAdded(address account, uint256 nonce, uint256 epoch, uint256 index, uint256 share0, uint256 share1, uint256 share2, uint256 share3)",
  ]);
  let data = receipt.logs[0].data;
  let topics = receipt.logs[0].topics;
  let event = intrface.decodeEventLog("ValidatorMemberAdded", data, topics);
  expect(event.account).to.equal(account);
  expect(event.nonce).to.equal(nonce);
  expect(event.epoch).to.equal(epoch);
  expect(event.index).to.equal(index);
  expect(event.share0).to.equal(gpkj[0]);
  expect(event.share1).to.equal(gpkj[1]);
  expect(event.share2).to.equal(gpkj[2]);
  expect(event.share3).to.equal(gpkj[3]);
};

const assertEventGPKJSubmissionComplete = async (
  tx: ContractTransaction,
  blockNumber: string
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
  validatorCount: string,
  nonce: string,
  epoch: string,
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

const registerValidators = async (
  ethdkg: ETHDKG,
  validatorPool: ValidatorPoolMock,
  validators: ValidatorRawData[],
  expectedNonce: number
) => {
  for (let [index, validator] of validators.entries()) {
    let tx = ethdkg
        .connect(await ethers.getSigner(validator.address))
        .register(validator.madNetPublicKey)
    expect(tx)
      .to.emit(ethdkg, "AddressRegistered")
      .withArgs(
        validator.address,
        index + 1,
        expectedNonce,
        validator.madNetPublicKey
      );
    let receipt = await tx
    // if all validators in the Pool participated in this round
    let numValidators = await validatorPool.getValidatorsCount();
    if (numValidators.eq(index + 1)) {
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
    if (numValidators.eq(index + 1)) {
      let bn = await ethers.provider.getBlockNumber();
      await assertEventShareDistributionComplete(tx, bn + 1);
    }
  }
};

const skipPhase = async (ethdkg: ETHDKG) => {
    // advance enough blocks to timeout DisputeShareDistribution phase
    let phaseStart = await ethdkg._phaseStartBlock();
    let phaseLength = await ethdkg._phaseLength();
    let bn = await ethers.provider.getBlockNumber();
    let endBlock = phaseStart.add(phaseLength);
    let blocksToMine = endBlock.sub(bn);
    await mineBlocks(blocksToMine.toNumber());
}

describe("ETHDKG", function () {
  it("completes happy path", async function () {
    const { ethdkg, validatorPool } = await getFixture();

    // add validators
    await validatorPool.setETHDKG(ethdkg.address);
    await addValidators(validatorPool, validators);

    // start ETHDKG
    await expect(validatorPool.initializeETHDKG())
      .to.emit(ethdkg, "RegistrationOpened")
      .withArgs(13, 1);

    // register all validators
    await registerValidators(ethdkg, validatorPool, validators, 1);

    // distribute shares for all validators
    await distributeValidatorsShares(ethdkg, validatorPool, validators, 1);

    // skipping the distribute shares accusation phase
    await skipPhase(ethdkg)

    //     // SUBMIT KEY SHARE

    //     // validator 0

    //     const keyShare0G1: [BigNumberish, BigNumberish] = [
    //       BigNumberish.from(
    //         "14511118167042528675574930772824577564139375654497172171770613265578464880069"
    //       ),
    //       BigNumberish.from(
    //         "4281385636039572914223175913030193035538972765692779067584267211901437038014"
    //       ),
    //     ];
    //     const keyShare0G1CorrectnessProof: [BigNumberish, BigNumberish] = [
    //       BigNumberish.from(
    //         "32190697818134781084219208952082390233237899046678379921600715642420183059269"
    //       ),
    //       BigNumberish.from(
    //         "7664687465898819482795586925141819311675275708351520264641055574270047836814"
    //       ),
    //     ];
    //     const keyShare0G2: [
    //       BigNumberish,
    //       BigNumberish,
    //       BigNumberish,
    //       BigNumberish
    //     ] = [
    //       BigNumberish.from(
    //         "6862447500913479849396672942209854440684932279062775061659244534362318043237"
    //       ),
    //       BigNumberish.from(
    //         "12383257596786324810812275760386036780191107208396362171628200292570693801239"
    //       ),
    //       BigNumberish.from(
    //         "19625803559679155265095284936356607172864151894815905116536454597629261203705"
    //       ),
    //       BigNumberish.from(
    //         "339652474899497641186594704275987641960854931094364930834928944851465531869"
    //       ),
    //     ];

    //     tx = await ethdkg
    //       .connect(validator0)
    //       .submitKeyShare(keyShare0G1, keyShare0G1CorrectnessProof, keyShare0G2);
    //     await assertEventKeyShareSubmitted(
    //       tx,
    //       validator0.address,
    //       "1",
    //       "1",
    //       keyShare0G1,
    //       keyShare0G1CorrectnessProof,
    //       keyShare0G2
    //     );

    //     // validator 1

    //     const keyShare1G1: [BigNumberish, BigNumberish] = [
    //       BigNumberish.from(
    //         "16452005780015038642154225865600792191009361037895374568282543820023983111955"
    //       ),
    //       BigNumberish.from(
    //         "9991721631229906070437922401616712458894126116153885859889548533495299414187"
    //       ),
    //     ];
    //     const keyShare1G1CorrectnessProof: [BigNumberish, BigNumberish] = [
    //       BigNumberish.from(
    //         "54307394935522975942131248751983519923961449199182605768146414293640561300732"
    //       ),
    //       BigNumberish.from(
    //         "5457659374325647914714446933487145937722284723197471623185885228082733079489"
    //       ),
    //     ];
    //     const keyShare1G2: [
    //       BigNumberish,
    //       BigNumberish,
    //       BigNumberish,
    //       BigNumberish
    //     ] = [
    //       BigNumberish.from(
    //         "15547383271857505102597525934108953935987126827111339975334382468015607410569"
    //       ),
    //       BigNumberish.from(
    //         "19346535887791867246335145401307703651877633726763296715776221177407884010282"
    //       ),
    //       BigNumberish.from(
    //         "15987515386699364624417114348795415938709985321558702796070616006492443857182"
    //       ),
    //       BigNumberish.from(
    //         "12575563991091381122278709401657611262883656556784772007965878815266409740007"
    //       ),
    //     ];

    //     tx = await ethdkg
    //       .connect(validator1)
    //       .submitKeyShare(keyShare1G1, keyShare1G1CorrectnessProof, keyShare1G2);
    //     await assertEventKeyShareSubmitted(
    //       tx,
    //       validator1.address,
    //       "2",
    //       "1",
    //       keyShare1G1,
    //       keyShare1G1CorrectnessProof,
    //       keyShare1G2
    //     );

    //     // validator 2

    //     const keyShare2G1: [BigNumberish, BigNumberish] = [
    //       BigNumberish.from(
    //         "277877110875626281546347103787389659672376230538924076484754901035393719222"
    //       ),
    //       BigNumberish.from(
    //         "17731704526788720133380907280443907693018138856320113804405927406869682439298"
    //       ),
    //     ];
    //     const keyShare2G1CorrectnessProof: [BigNumberish, BigNumberish] = [
    //       BigNumberish.from(
    //         "41106170364743287075116098774914352864522227363182183756980651463465114356359"
    //       ),
    //       BigNumberish.from(
    //         "13266479246556921656556278056792098154368260335020613704626182836616024127904"
    //       ),
    //     ];
    //     const keyShare2G2: [
    //       BigNumberish,
    //       BigNumberish,
    //       BigNumberish,
    //       BigNumberish
    //     ] = [
    //       BigNumberish.from(
    //         "14143533362538510889723699710028814502527578228880877258948513743258147057148"
    //       ),
    //       BigNumberish.from(
    //         "15202101187567813279221525061726239424218710483528728619565580114466281364114"
    //       ),
    //       BigNumberish.from(
    //         "16249007427734573859901389200400222383469860729564288420421470649457948729931"
    //       ),
    //       BigNumberish.from(
    //         "13468492528639982280741748189143537557299062464920847713123145940575026827364"
    //       ),
    //     ];

    //     tx = await ethdkg
    //       .connect(validator2)
    //       .submitKeyShare(keyShare2G1, keyShare2G1CorrectnessProof, keyShare2G2);
    //     await assertEventKeyShareSubmitted(
    //       tx,
    //       validator2.address,
    //       "3",
    //       "1",
    //       keyShare2G1,
    //       keyShare2G1CorrectnessProof,
    //       keyShare2G2
    //     );

    //     // validator 3

    //     const keyShare3G1: [BigNumberish, BigNumberish] = [
    //       BigNumberish.from(
    //         "16759374210872218724511648339068985647690738759076078886225046299034503093947"
    //       ),
    //       BigNumberish.from(
    //         "4833583617652984668349400410527702989087353801801157471226997656975750939224"
    //       ),
    //     ];
    //     const keyShare3G1CorrectnessProof: [BigNumberish, BigNumberish] = [
    //       BigNumberish.from(
    //         "12494664031143540379996291029539690957985022511972641532258762692611094353548"
    //       ),
    //       BigNumberish.from(
    //         "15200923952599656522984664436884782274876837979282907680664845267304080214800"
    //       ),
    //     ];
    //     const keyShare3G2: [
    //       BigNumberish,
    //       BigNumberish,
    //       BigNumberish,
    //       BigNumberish
    //     ] = [
    //       BigNumberish.from(
    //         "4855380431255440005608257924881214128781111884033369660214053561201802558549"
    //       ),
    //       BigNumberish.from(
    //         "246938594926441931990843619108284908473950076397732140545554135596970699372"
    //       ),
    //       BigNumberish.from(
    //         "7573455896980925764322698907104590225020743167488698676283335448887658526419"
    //       ),
    //       BigNumberish.from(
    //         "8704640877579021841414993750939894723657263252624903237873384477357823209453"
    //       ),
    //     ];

    //     tx = await ethdkg
    //       .connect(validator3)
    //       .submitKeyShare(keyShare3G1, keyShare3G1CorrectnessProof, keyShare3G2);
    //     await assertEventKeyShareSubmitted(
    //       tx,
    //       validator3.address,
    //       "4",
    //       "1",
    //       keyShare3G1,
    //       keyShare3G1CorrectnessProof,
    //       keyShare3G2
    //     );
    //     await assertEventKeyShareSubmissionComplete(tx, "65");

    //     // SUBMIT MPK

    //     // some random validator

    //     let mpk: [BigNumberish, BigNumberish, BigNumberish, BigNumberish] = [
    //       BigNumberish.from(
    //         "182041566987530386460457689390110300646219725596681074823642351218811754943"
    //       ),
    //       BigNumberish.from(
    //         "15433857467323273464215277543980063151586726157684062575916798612481721071846"
    //       ),
    //       BigNumberish.from(
    //         "3079016397239957076334248567008266049997899149795761996683726054324263689225"
    //       ),
    //       BigNumberish.from(
    //         "9841085592415752049891022641024051834767483513046137974674459109594919536275"
    //       ),
    //     ];

    //     tx = await ethdkg.submitMasterPublicKey(mpk);
    //     await assertEventMPKSet(tx, "66", "1", mpk);

    //     // SUBMIT GPKj

    //     // validator 0

    //     const gpkj0: [BigNumberish, BigNumberish, BigNumberish, BigNumberish] = [
    //       BigNumberish.from(
    //         "14395602319113363333690669395961581081803242358678131578916981232954633806960"
    //       ),
    //       BigNumberish.from(
    //         "300089735810954642595088127891607498572672898349379085034409445552605516765"
    //       ),
    //       BigNumberish.from(
    //         "17169409825226096532229555694191340178889298261881998623204757401596570351688"
    //       ),
    //       BigNumberish.from(
    //         "19780380227412019371988923760536598779715024137904246485146692590642474692882"
    //       ),
    //     ];

    //     tx = await ethdkg.connect(validator0).submitGPKj(gpkj0);
    //     await assertEventValidatorMemberAdded(
    //       tx,
    //       validator0.address,
    //       "1",
    //       "1",
    //       "1",
    //       gpkj0
    //     );

    //     // validator 1

    //     const gpkj1: [BigNumberish, BigNumberish, BigNumberish, BigNumberish] = [
    //       BigNumberish.from(
    //         "21154017404198718862920160130737623556546602199694661996869957208062851500379"
    //       ),
    //       BigNumberish.from(
    //         "19389833000731437962153734187923001234830293448701992540723746507685386979412"
    //       ),
    //       BigNumberish.from(
    //         "21289029302611008572663530729853170393569891172031986702208364730022339833735"
    //       ),
    //       BigNumberish.from(
    //         "15926764275937493411567546154328577890519582979565228998979506880914326856186"
    //       ),
    //     ];

    //     tx = await ethdkg.connect(validator1).submitGPKj(gpkj1);
    //     await assertEventValidatorMemberAdded(
    //       tx,
    //       validator1.address,
    //       "1",
    //       "1",
    //       "2",
    //       gpkj1
    //     );

    //     // validator 2

    //     const gpkj2: [BigNumberish, BigNumberish, BigNumberish, BigNumberish] = [
    //       BigNumberish.from(
    //         "15079629603150363557558188402860791995814736941924946256968815481986722866449"
    //       ),
    //       BigNumberish.from(
    //         "11164680325282976674805760467491699367894125557056167854003650409966070344792"
    //       ),
    //       BigNumberish.from(
    //         "18616624374737795490811424594534628399519274885945803292205658067710235197668"
    //       ),
    //       BigNumberish.from(
    //         "4331613963825409904165282575933135091483251249365224295595121580000486079984"
    //       ),
    //     ];

    //     tx = await ethdkg.connect(validator2).submitGPKj(gpkj2);
    //     await assertEventValidatorMemberAdded(
    //       tx,
    //       validator2.address,
    //       "1",
    //       "1",
    //       "3",
    //       gpkj2
    //     );

    //     // validator 3

    //     const gpkj3: [BigNumberish, BigNumberish, BigNumberish, BigNumberish] = [
    //       BigNumberish.from(
    //         "10875965504600753744265546216544158224793678652818595873355677460529088515116"
    //       ),
    //       BigNumberish.from(
    //         "7912658035712558991777053184829906144303269569825235765302768068512975453162"
    //       ),
    //       BigNumberish.from(
    //         "11324169944454120842956077363729540506362078469024985744551121054724657909930"
    //       ),
    //       BigNumberish.from(
    //         "11005450895245397587287710270721947847266013997080161834700568409163476112947"
    //       ),
    //     ];

    //     tx = await ethdkg.connect(validator3).submitGPKj(gpkj3);
    //     await assertEventValidatorMemberAdded(
    //       tx,
    //       validator3.address,
    //       "1",
    //       "1",
    //       "4",
    //       gpkj3
    //     );
    //     await assertEventGPKJSubmissionComplete(tx, "70");

    //     // COMPLETE ETHDKG

    //     // advance enough blocks to timeout DisputeShareDistribution phase
    //     phaseStart = await ethdkg._phaseStartBlock();
    //     phaseLength = await ethdkg._phaseLength();
    //     bn = await ethers.provider.getBlockNumber();
    //     // console.log("blocks", phaseStart.toString(), phaseLength.toString(), bn);
    //     endBlock = phaseStart.add(phaseLength);
    //     blocksToMine = endBlock.sub(bn);
    //     await mineBlocks(blocksToMine.toNumber());

    //     tx = await ethdkg.connect(validator0).complete();
    //     await assertEventValidatorSetCompleted(tx, "4", "1", "1", 1, 1, mpk);
  });
});
