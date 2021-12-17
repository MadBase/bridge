import { expect } from "../../chai-setup";
import { ethers, network, upgrades } from "hardhat";
import { BigNumberish, BigNumber, ContractTransaction } from "ethers";
import { assert } from "chai";


const PLACEHOLDER_ADDRESS = "0x0000000000000000000000000000000000000000";

const mineBlocks = async (nBlocks: number) => {
  while (nBlocks > 0) {
    nBlocks--;
    await network.provider.request({
      method: "evm_mine",
      // params: [],
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

  const namedSigners = await ethers.getSigners()
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

const assertEventSharesDistributed = async (tx: ContractTransaction, account: string, index: string, nonce: string, encryptedShares: BigNumber[], commitments: [BigNumber,BigNumber][]) => {
  let receipt = await ethers.provider.getTransactionReceipt(tx.hash);
  let intrface = new ethers.utils.Interface(["event SharesDistributed(address account, uint256 index, uint256 nonce, uint256[] encryptedShares, uint256[2][] commitments)"]);
  let data = receipt.logs[0].data;
  let topics = receipt.logs[0].topics;
  let event = intrface.decodeEventLog("SharesDistributed", data, topics);
  expect(event.account).to.equal(account);
  expect(event.index.toString()).to.equal(index);
  expect(event.nonce.toString()).to.equal(nonce);
  assertEqEncryptedShares(event.encryptedShares, encryptedShares)
  assertEqCommitments(event.commitments, commitments)
}

const assertEventShareDistributionComplete = async (tx: ContractTransaction, blockNumber: string) => {
  let receipt = await ethers.provider.getTransactionReceipt(tx.hash);
  let intrface = new ethers.utils.Interface(["event ShareDistributionComplete(uint256 blockNumber)"]);
  let data = receipt.logs[1].data;
  let topics = receipt.logs[1].topics;
  let event = intrface.decodeEventLog("ShareDistributionComplete", data, topics);
  expect(event.blockNumber).to.equal(blockNumber);
}

const assertEqEncryptedShares = (actualEncryptedShares: BigNumber[], expectedEncryptedShares: BigNumber[]) => {
  actualEncryptedShares.forEach((element, i) => {
    assert(element.eq(expectedEncryptedShares[i]))
  });
}

const assertEqCommitments = (actualCommitments: [BigNumber,BigNumber][], expectedCommitments: [BigNumber,BigNumber][]) => {
  actualCommitments.forEach((element, i) => {
    assert(element[0].eq(expectedCommitments[i][0]))
    assert(element[1].eq(expectedCommitments[i][1]))
  });
}

// submit key shares helpers

const assertEventKeyShareSubmitted = async (tx: ContractTransaction, account: string, index: string, nonce: string, keyShareG1: [BigNumber,BigNumber], keyShareG1CorrectnessProof: [BigNumber,BigNumber], keyShareG2: [BigNumber,BigNumber,BigNumber,BigNumber]) => {
  let receipt = await ethers.provider.getTransactionReceipt(tx.hash);
  let intrface = new ethers.utils.Interface(["event KeyShareSubmitted(address account, uint256 index, uint256 nonce, uint256[2] keyShareG1, uint256[2] keyShareG1CorrectnessProof, uint256[4] keyShareG2)"]);
  let data = receipt.logs[0].data;
  let topics = receipt.logs[0].topics;
  let event = intrface.decodeEventLog("KeyShareSubmitted", data, topics);
  expect(event.account).to.equal(account);
  expect(event.index.toString()).to.equal(index);
  expect(event.nonce.toString()).to.equal(nonce);
  assertEqKeyShareG1(event.keyShareG1, keyShareG1)
  assertEqKeyShareG1(event.keyShareG1CorrectnessProof, keyShareG1CorrectnessProof)
  assertEqKeyShareG2(event.keyShareG2, keyShareG2)
}

const assertEqKeyShareG1 = (actualKeySharesG1: [BigNumber,BigNumber], expectedKeySharesG1: [BigNumber,BigNumber]) => {
    assert(actualKeySharesG1[0].eq(expectedKeySharesG1[0]))
    assert(actualKeySharesG1[1].eq(expectedKeySharesG1[1]))
}

const assertEqKeyShareG2 = (actualKeySharesG2: [BigNumber,BigNumber,BigNumber,BigNumber], expectedKeySharesG2: [BigNumber,BigNumber,BigNumber,BigNumber]) => {
    assert(actualKeySharesG2[0].eq(expectedKeySharesG2[0]))
    assert(actualKeySharesG2[1].eq(expectedKeySharesG2[1]))
    assert(actualKeySharesG2[2].eq(expectedKeySharesG2[2]))
    assert(actualKeySharesG2[3].eq(expectedKeySharesG2[3]))
}

const assertEventKeyShareSubmissionComplete = async (tx: ContractTransaction, blockNumber: string) => {
  let receipt = await ethers.provider.getTransactionReceipt(tx.hash);
  let intrface = new ethers.utils.Interface(["event KeyShareSubmissionComplete(uint256 blockNumber)"]);
  let data = receipt.logs[1].data;
  let topics = receipt.logs[1].topics;
  let event = intrface.decodeEventLog("KeyShareSubmissionComplete", data, topics);
  expect(event.blockNumber).to.equal(blockNumber);
}

// submit MPK phase

const assertEventMPKSet = async (tx: ContractTransaction, blockNumber: string, nonce: string, mpk: [BigNumber, BigNumber, BigNumber, BigNumber]) => {
  let receipt = await ethers.provider.getTransactionReceipt(tx.hash);
  let intrface = new ethers.utils.Interface(["event MPKSet(uint256 blockNumber, uint256 nonce, uint256[4] mpk)"]);
  let data = receipt.logs[0].data;
  let topics = receipt.logs[0].topics;
  let event = intrface.decodeEventLog("MPKSet", data, topics);
  expect(event.blockNumber).to.equal(blockNumber);
  expect(event.nonce).to.equal(nonce);
  expect(event.mpk[0]).to.equal(mpk[0]);
  expect(event.mpk[1]).to.equal(mpk[1]);
  expect(event.mpk[2]).to.equal(mpk[2]);
  expect(event.mpk[3]).to.equal(mpk[3]);
}

// submit GPKj phase

const assertEventValidatorMemberAdded = async (tx: ContractTransaction, account: string, nonce: string, epoch: string, index: string, gpkj: [BigNumber, BigNumber, BigNumber, BigNumber]) => {
  let receipt = await ethers.provider.getTransactionReceipt(tx.hash);
  let intrface = new ethers.utils.Interface(["event ValidatorMemberAdded(address account, uint256 nonce, uint256 epoch, uint256 index, uint256 share0, uint256 share1, uint256 share2, uint256 share3)"]);
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
}

const assertEventGPKJSubmissionComplete = async (tx: ContractTransaction, blockNumber: string) => {
  let receipt = await ethers.provider.getTransactionReceipt(tx.hash);
  let intrface = new ethers.utils.Interface(["event GPKJSubmissionComplete(uint256 blockNumber)"]);
  let data = receipt.logs[1].data;
  let topics = receipt.logs[1].topics;
  let event = intrface.decodeEventLog("GPKJSubmissionComplete", data, topics);
  expect(event.blockNumber).to.equal(blockNumber);
}

// COMPLETE PHASE

const assertEventValidatorSetCompleted = async (tx: ContractTransaction, validatorCount: string, nonce: string, epoch: string, ethHeight: number, madHeight: number, mpk: [BigNumber, BigNumber, BigNumber, BigNumber]) => {
  let receipt = await ethers.provider.getTransactionReceipt(tx.hash);
  let intrface = new ethers.utils.Interface(["event ValidatorSetCompleted(uint256 validatorCount, uint256 nonce, uint256 epoch, uint32 ethHeight, uint32 madHeight, uint256 groupKey0, uint256 groupKey1, uint256 groupKey2, uint256 groupKey3)"]);
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
}

describe("ETHDKG", function () {
  it("completes happy path", async function () {
    const { ethdkg, validatorPool, namedSigners } = await getFixture();
    const [ admin, validator0, validator1, validator2, validator3 ] =
      namedSigners;

    // add validators
    await validatorPool.setETHDKG(ethdkg.address);
    await validatorPool.addValidator(validator0.address);
    await validatorPool.addValidator(validator1.address);
    await validatorPool.addValidator(validator2.address);
    await validatorPool.addValidator(validator3.address);

    expect(await validatorPool.isValidator(validator0.address)).to.equal(true);
    expect(await validatorPool.isValidator(validator1.address)).to.equal(true);
    expect(await validatorPool.isValidator(validator2.address)).to.equal(true);
    expect(await validatorPool.isValidator(validator3.address)).to.equal(true);

    // start ETHDKG
    await expect(validatorPool.initializeETHDKG())
      .to.emit(ethdkg, "RegistrationOpened")
      .withArgs(13, 1);

    // register validator0
    await expect(
      ethdkg
        .connect(validator0)
        .register([
          "0x23bc3a063e898eb1f5f8e856fca12f4e7d87eab069b053bf96f8cbaf8ad98884",
          "0x0e97501434da93e87f9a7badf3c99078f9bed24616f47f0267bd3d4dab7a4f11",
        ])
    )
      .to.emit(ethdkg, "AddressRegistered")
      .withArgs(validator0.address, 1, 1, [
        "0x23bc3a063e898eb1f5f8e856fca12f4e7d87eab069b053bf96f8cbaf8ad98884",
        "0x0e97501434da93e87f9a7badf3c99078f9bed24616f47f0267bd3d4dab7a4f11",
      ]);

    // register validator1
    await expect(
      ethdkg
        .connect(validator1)
        .register([
          "0x05bbe20b28faf3c4c96fef2796d0c77b235de62119c663e4a125755a1d0025d7",
          "0x0599e9e116636921ccb9c44bd609d78e02473c2f8d67769f6dce5c70a4434230",
        ])
    )
      .to.emit(ethdkg, "AddressRegistered")
      .withArgs(validator1.address, 2, 1, [
        "0x05bbe20b28faf3c4c96fef2796d0c77b235de62119c663e4a125755a1d0025d7",
        "0x0599e9e116636921ccb9c44bd609d78e02473c2f8d67769f6dce5c70a4434230",
      ]);

    // register validator2
    let bn = await ethers.provider.getBlockNumber();
    console.log("bn", bn);
    await expect(
      ethdkg
        .connect(validator2)
        .register([
          "0x2f74907761d553f40bde96cc6459b22488e16df0878dcf96c53bf98a387b2c99",
          "0x0fffb58eb894f542aae6bee6a8c7aa8b3dbb7162ace24ab995321679f8e1c3fe",
        ])
    )
      .to.emit(ethdkg, "AddressRegistered")
      .withArgs(validator2.address, 3, 1, [
        "0x2f74907761d553f40bde96cc6459b22488e16df0878dcf96c53bf98a387b2c99",
        "0x0fffb58eb894f542aae6bee6a8c7aa8b3dbb7162ace24ab995321679f8e1c3fe",
      ]);

    // register validator3
    bn = await ethers.provider.getBlockNumber();
    console.log("bn", bn);
    await expect(
      ethdkg
        .connect(validator3)
        .register([
          "0x18acfb61c62db84c8e502d8b1abf5fc4309eeedc64f2bbd2639b281d6c207cab",
          "0x09a300e6ffd862c99c2078df4160f20c3ed41b2b4af5497a0e8b50aaa5db35ca",
        ])
    )
      .to.emit(ethdkg, "AddressRegistered")
      .withArgs(validator3.address, 4, 1, [
        "0x18acfb61c62db84c8e502d8b1abf5fc4309eeedc64f2bbd2639b281d6c207cab",
        "0x09a300e6ffd862c99c2078df4160f20c3ed41b2b4af5497a0e8b50aaa5db35ca",
      ])
      .to.emit(ethdkg, "RegistrationComplete")
      .withArgs(bn + 1);

    // DISTRIBUTE SHARES

    // validator0

    const encryptedShares0: BigNumber[] = [
      BigNumber.from("101479263853556359543079846893402770202053661006871570257617036291953578015365"), 
      BigNumber.from("40128805102689395197679485451028457131042100567537583265935780362318857357706"),
      BigNumber.from("112413131880225670452773455843412929059184316682164951156813707748611584117611")
    ]
    const commitments0: [BigNumber,BigNumber][]= [
      [
        BigNumber.from("1783211698028361718757824636778910326055504787199958233704380825403003615351"),
        BigNumber.from("4813535512924931799387436871268923060410099043318010115139859876235634173072"),
      ],
      [
        BigNumber.from("9908331726222453969394687904794707240427110680137394215714921897563253772995"),
        BigNumber.from("7450042496560290895715608438563093012441891205514589008115849399550602640156"),
      ],
      [
        BigNumber.from("9376988119665619727677707985158451529382983850633751079314397808580584705964"),
        BigNumber.from("12374569562457840602066501161729073052564917278461046533423284864014915240166"),
      ]
    ]
    
    let tx = await ethdkg.connect(validator0).distributeShares(encryptedShares0, commitments0)
    await assertEventSharesDistributed(tx, validator0.address, "1", "1", encryptedShares0, commitments0)

    // validator1

    const encryptedShares1: BigNumber[] = [
      BigNumber.from("60168887983330268281278235073646566704871405964119110948110945204998906715711"), 
      BigNumber.from("34953823557162667997073233110360425747743386201913430070383340816705724018558"),
      BigNumber.from("23676739033484132375320926053313873118998040850290057970862334573872864262404")
    ]
    const commitments1: [BigNumber,BigNumber][]= [
      [
        BigNumber.from("12197268559460291526861904937831050907056947844791245383683779849087238619726"),
        BigNumber.from("4963336221324172392779698051269831534539882418459408925574591319568956845817"),
      ],
      [
        BigNumber.from("6641768367106645999673653681215009534635261306654840479830041454311652557408"),
        BigNumber.from("788000638810031935386699129529032702123217436522976972650223388832193993388"),
      ],
      [
        BigNumber.from("20218694188448503337493362924104183590733189962784068893722848553677377561336"),
        BigNumber.from("4624849729043789397009099917182767962186212993713885107139173938469363639126"),
      ]
    ]
    
    tx = await ethdkg.connect(validator1).distributeShares(encryptedShares1, commitments1)
    await assertEventSharesDistributed(tx, validator1.address, "2", "1", encryptedShares1, commitments1)

    // validator2

    const encryptedShares2: BigNumber[] = [
      BigNumber.from("60272694898259667130925174406397009649127678451568460989743351528021103380731"), 
      BigNumber.from("101860957726922899670564145688845615079146259035390373867429339241674916405414"),
      BigNumber.from("109865223673156685441661735865485060278726700803594262715606961946009133040973")
    ]
    const commitments2: [BigNumber,BigNumber][]= [
      [
        BigNumber.from("2731469091596801506046184453221234149819589345238358978876786898753460074139"),
        BigNumber.from("21443580311197540430363293840536589469082984258284369737811944874019589441291"),
      ],
      [
        BigNumber.from("6010096585116769291758945771623797507298742732439696679176887058586637370132"),
        BigNumber.from("16769452436022151262117961498630463129255345363340311985598159629785455529031"),
      ],
      [
        BigNumber.from("8457507764567179495024524953511690192414441472615176491546473591421140355719"),
        BigNumber.from("14659274911035264284563966726991138794870994209300185483531652801489583714818"),
      ]
    ]
    
    tx = await ethdkg.connect(validator2).distributeShares(encryptedShares2, commitments2)
    await assertEventSharesDistributed(tx, validator2.address, "3", "1", encryptedShares2, commitments2)

    // validator3

    const encryptedShares3: BigNumber[] = [
      BigNumber.from("80432781824334213667803703185685952158072047816906535490461271099401507732163"), 
      BigNumber.from("57706054291318317476554256425310758850998046686381175918069876603594797791665"),
      BigNumber.from("17823318828579847420561063684214986848603401647132341834960335353518522176376")
    ]
    const commitments3: [BigNumber,BigNumber][]= [
      [
        BigNumber.from("21393122675825704463638246930962192226205609333217257430697422745989037197761"),
        BigNumber.from("6055694545185531501095389176971474351730649893389077674412538703142884276898"),
      ],
      [
        BigNumber.from("8239681974906087640834517961422578863320022365103547838118531013162254554907"),
        BigNumber.from("13038087108844080933763217921652715772865121478618420120890000163795360750198"),
      ],
      [
        BigNumber.from("13326474714421310059593996058718419554285867797089578337241228579948596020812"),
        BigNumber.from("21172559909836820907771526924273162815926107524072738185936930107372208643142"),
      ]
    ]
    
    tx = await ethdkg.connect(validator3).distributeShares(encryptedShares3, commitments3)
    await assertEventSharesDistributed(tx, validator3.address, "4", "1", encryptedShares3, commitments3)
    await assertEventShareDistributionComplete(tx, "21")

    // advance enough blocks to timeout DisputeShareDistribution phase
    let phaseStart = await ethdkg._phaseStartBlock()
    let phaseLength = await ethdkg._phaseLength()
    bn = await ethers.provider.getBlockNumber();
    // console.log("blocks", phaseStart.toString(), phaseLength.toString(), bn);
    let endBlock = phaseStart.add(phaseLength)
    let blocksToMine = endBlock.sub(bn)
    await mineBlocks(blocksToMine.toNumber())

    // SUBMIT KEY SHARE

    // validator 0

    const keyShare0G1: [BigNumber,BigNumber] = [
      BigNumber.from("14511118167042528675574930772824577564139375654497172171770613265578464880069"),
      BigNumber.from("4281385636039572914223175913030193035538972765692779067584267211901437038014")
    ]
    const keyShare0G1CorrectnessProof: [BigNumber,BigNumber] = [
      BigNumber.from("32190697818134781084219208952082390233237899046678379921600715642420183059269"),
      BigNumber.from("7664687465898819482795586925141819311675275708351520264641055574270047836814"),
    ]
    const keyShare0G2: [BigNumber,BigNumber,BigNumber,BigNumber] = [
      BigNumber.from("6862447500913479849396672942209854440684932279062775061659244534362318043237"),
      BigNumber.from("12383257596786324810812275760386036780191107208396362171628200292570693801239"),
      BigNumber.from("19625803559679155265095284936356607172864151894815905116536454597629261203705"),
      BigNumber.from("339652474899497641186594704275987641960854931094364930834928944851465531869"),
    ]

    tx = await ethdkg.connect(validator0).submitKeyShare(keyShare0G1, keyShare0G1CorrectnessProof, keyShare0G2)
    await assertEventKeyShareSubmitted(tx, validator0.address, "1", "1", keyShare0G1, keyShare0G1CorrectnessProof, keyShare0G2)

    // validator 1

    const keyShare1G1: [BigNumber,BigNumber] = [
      BigNumber.from("16452005780015038642154225865600792191009361037895374568282543820023983111955"),
      BigNumber.from("9991721631229906070437922401616712458894126116153885859889548533495299414187")
    ]
    const keyShare1G1CorrectnessProof: [BigNumber,BigNumber] = [
      BigNumber.from("54307394935522975942131248751983519923961449199182605768146414293640561300732"),
      BigNumber.from("5457659374325647914714446933487145937722284723197471623185885228082733079489"),
    ]
    const keyShare1G2: [BigNumber,BigNumber,BigNumber,BigNumber] = [
      BigNumber.from("15547383271857505102597525934108953935987126827111339975334382468015607410569"),
      BigNumber.from("19346535887791867246335145401307703651877633726763296715776221177407884010282"),
      BigNumber.from("15987515386699364624417114348795415938709985321558702796070616006492443857182"),
      BigNumber.from("12575563991091381122278709401657611262883656556784772007965878815266409740007"),
    ]

    tx = await ethdkg.connect(validator1).submitKeyShare(keyShare1G1, keyShare1G1CorrectnessProof, keyShare1G2)
    await assertEventKeyShareSubmitted(tx, validator1.address, "2", "1", keyShare1G1, keyShare1G1CorrectnessProof, keyShare1G2)

    // validator 2

    const keyShare2G1: [BigNumber,BigNumber] = [
      BigNumber.from("277877110875626281546347103787389659672376230538924076484754901035393719222"),
      BigNumber.from("17731704526788720133380907280443907693018138856320113804405927406869682439298")
    ]
    const keyShare2G1CorrectnessProof: [BigNumber,BigNumber] = [
      BigNumber.from("41106170364743287075116098774914352864522227363182183756980651463465114356359"),
      BigNumber.from("13266479246556921656556278056792098154368260335020613704626182836616024127904"),
    ]
    const keyShare2G2: [BigNumber,BigNumber,BigNumber,BigNumber] = [
      BigNumber.from("14143533362538510889723699710028814502527578228880877258948513743258147057148"),
      BigNumber.from("15202101187567813279221525061726239424218710483528728619565580114466281364114"),
      BigNumber.from("16249007427734573859901389200400222383469860729564288420421470649457948729931"),
      BigNumber.from("13468492528639982280741748189143537557299062464920847713123145940575026827364"),
    ]

    tx = await ethdkg.connect(validator2).submitKeyShare(keyShare2G1, keyShare2G1CorrectnessProof, keyShare2G2)
    await assertEventKeyShareSubmitted(tx, validator2.address, "3", "1", keyShare2G1, keyShare2G1CorrectnessProof, keyShare2G2)

    // validator 3

    const keyShare3G1: [BigNumber,BigNumber] = [
      BigNumber.from("16759374210872218724511648339068985647690738759076078886225046299034503093947"),
      BigNumber.from("4833583617652984668349400410527702989087353801801157471226997656975750939224")
    ]
    const keyShare3G1CorrectnessProof: [BigNumber,BigNumber] = [
      BigNumber.from("12494664031143540379996291029539690957985022511972641532258762692611094353548"),
      BigNumber.from("15200923952599656522984664436884782274876837979282907680664845267304080214800"),
    ]
    const keyShare3G2: [BigNumber,BigNumber,BigNumber,BigNumber] = [
      BigNumber.from("4855380431255440005608257924881214128781111884033369660214053561201802558549"),
      BigNumber.from("246938594926441931990843619108284908473950076397732140545554135596970699372"),
      BigNumber.from("7573455896980925764322698907104590225020743167488698676283335448887658526419"),
      BigNumber.from("8704640877579021841414993750939894723657263252624903237873384477357823209453"),
    ]

    tx = await ethdkg.connect(validator3).submitKeyShare(keyShare3G1, keyShare3G1CorrectnessProof, keyShare3G2)
    await assertEventKeyShareSubmitted(tx, validator3.address, "4", "1", keyShare3G1, keyShare3G1CorrectnessProof, keyShare3G2)
    await assertEventKeyShareSubmissionComplete(tx, "65")

    // SUBMIT MPK

    // some random validator

    let mpk: [BigNumber, BigNumber, BigNumber, BigNumber] = [
      BigNumber.from("182041566987530386460457689390110300646219725596681074823642351218811754943"),
      BigNumber.from("15433857467323273464215277543980063151586726157684062575916798612481721071846"),
      BigNumber.from("3079016397239957076334248567008266049997899149795761996683726054324263689225"),
      BigNumber.from("9841085592415752049891022641024051834767483513046137974674459109594919536275"),
    ]
    
    tx = await ethdkg.submitMasterPublicKey(mpk)
    await assertEventMPKSet(tx, "66", "1", mpk)

    // SUBMIT GPKj

    // validator 0

    const gpkj0: [BigNumber,BigNumber,BigNumber,BigNumber] = [
      BigNumber.from("14395602319113363333690669395961581081803242358678131578916981232954633806960"),
      BigNumber.from("300089735810954642595088127891607498572672898349379085034409445552605516765"),
      BigNumber.from("17169409825226096532229555694191340178889298261881998623204757401596570351688"),
      BigNumber.from("19780380227412019371988923760536598779715024137904246485146692590642474692882"),
    ]

    tx = await ethdkg.connect(validator0).submitGPKj(gpkj0)
    await assertEventValidatorMemberAdded(tx, validator0.address, "1", "1", "1", gpkj0)

    // validator 1

    const gpkj1: [BigNumber,BigNumber,BigNumber,BigNumber] = [
      BigNumber.from("21154017404198718862920160130737623556546602199694661996869957208062851500379"),
      BigNumber.from("19389833000731437962153734187923001234830293448701992540723746507685386979412"),
      BigNumber.from("21289029302611008572663530729853170393569891172031986702208364730022339833735"),
      BigNumber.from("15926764275937493411567546154328577890519582979565228998979506880914326856186"),
    ]

    tx = await ethdkg.connect(validator1).submitGPKj(gpkj1)
    await assertEventValidatorMemberAdded(tx, validator1.address, "1", "1", "2", gpkj1)

    // validator 2

    const gpkj2: [BigNumber,BigNumber,BigNumber,BigNumber] = [
      BigNumber.from("15079629603150363557558188402860791995814736941924946256968815481986722866449"),
      BigNumber.from("11164680325282976674805760467491699367894125557056167854003650409966070344792"),
      BigNumber.from("18616624374737795490811424594534628399519274885945803292205658067710235197668"),
      BigNumber.from("4331613963825409904165282575933135091483251249365224295595121580000486079984"),
    ]

    tx = await ethdkg.connect(validator2).submitGPKj(gpkj2)
    await assertEventValidatorMemberAdded(tx, validator2.address, "1", "1", "3", gpkj2)

    // validator 3

    const gpkj3: [BigNumber,BigNumber,BigNumber,BigNumber] = [
      BigNumber.from("10875965504600753744265546216544158224793678652818595873355677460529088515116"),
      BigNumber.from("7912658035712558991777053184829906144303269569825235765302768068512975453162"),
      BigNumber.from("11324169944454120842956077363729540506362078469024985744551121054724657909930"),
      BigNumber.from("11005450895245397587287710270721947847266013997080161834700568409163476112947"),
    ]

    tx = await ethdkg.connect(validator3).submitGPKj(gpkj3)
    await assertEventValidatorMemberAdded(tx, validator3.address, "1", "1", "4", gpkj3)
    await assertEventGPKJSubmissionComplete(tx, "70")

    // COMPLETE ETHDKG

    // advance enough blocks to timeout DisputeShareDistribution phase
    phaseStart = await ethdkg._phaseStartBlock()
    phaseLength = await ethdkg._phaseLength()
    bn = await ethers.provider.getBlockNumber();
    // console.log("blocks", phaseStart.toString(), phaseLength.toString(), bn);
    endBlock = phaseStart.add(phaseLength)
    blocksToMine = endBlock.sub(bn)
    await mineBlocks(blocksToMine.toNumber())

    tx = await ethdkg.connect(validator0).complete()
    await assertEventValidatorSetCompleted(tx, "4", "1", "1", 1, 1, mpk)

  });
});
