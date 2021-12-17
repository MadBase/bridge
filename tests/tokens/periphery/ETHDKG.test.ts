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

    // SUBMIT KEY SHARE

    // validator 0
    
  });
});
