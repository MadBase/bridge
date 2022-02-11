import { ethers, network } from "hardhat";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";


import {
  MadToken,
  MadByte,
  StakeNFT,
  ValidatorNFT,
  ETHDKG,
  ValidatorPool,
  Snapshots,
} from "../../../typechain-types";

export const PLACEHOLDER_ADDRESS = "0x0000000000000000000000000000000000000000";

export { expect, assert } from "../../chai-setup";


export interface Snapshot {
    BClaims: string,
    GroupSignature: string,
  }

export interface Fixture {
  madToken: MadToken;
  madByte: MadByte;
  stakeNFT: StakeNFT;
  validatorNFT: ValidatorNFT;
  validatorPool: ValidatorPool;
  snapshots: Snapshots;
  ethdkg: ETHDKG;
  namedSigners: SignerWithAddress[];
}

export const getFixture = async (): Promise<Fixture> => {
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
    madToken.address,
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
    madToken.address,
    admin.address,
    PLACEHOLDER_ADDRESS
  );
  await validatorNFT.deployed();
   console.log(`ValidatorNFT deployed at ${validatorNFT.address}`);

  // ETHDKG Accusations
  const ETHDKGAccusations = await ethers.getContractFactory(
    "ETHDKGAccusations"
  );
  const ethdkgAccusations = await ETHDKGAccusations.deploy();
  await ethdkgAccusations.deployed();

  // ETHDKG Phases
  const ETHDKGPhases = await ethers.getContractFactory("ETHDKGPhases");
  const ethdkgPhases = await ETHDKGPhases.deploy();
  await ethdkgPhases.deployed();

  // ETHDKG
  const ETHDKG = await ethers.getContractFactory("ETHDKG");
  const ethdkg = await ETHDKG.deploy(PLACEHOLDER_ADDRESS);
  await ethdkg.deployed();
  // console.log(`ETHDKG deployed at ${ethdkg.address}`);
  // console.log("finished core deployment");

  // ValidatorPoolTrue
  const ValidatorPool = await ethers.getContractFactory(
    "ValidatorPool"
  );
  const validatorPool = await ValidatorPool.deploy(
    stakeNFT.address,
    validatorNFT.address,
    madToken.address,
    ethdkg.address,
    PLACEHOLDER_ADDRESS,
    PLACEHOLDER_ADDRESS
  );
  await validatorPool.deployed();
  console.log(`ValidatorPool deployed at ${validatorPool.address}`);

  const Snapshots = await ethers.getContractFactory("Snapshots");
  const snapshots = await Snapshots.deploy(
    ethdkg.address,
    validatorPool.address,
    1,
    PLACEHOLDER_ADDRESS
  );
  await snapshots.deployed();
  
  await validatorPool.setSnapshot(snapshots.address)

  await ethdkg.initialize(
    validatorPool.address,
    snapshots.address,
    ethdkgAccusations.address,
    ethdkgPhases.address
  );

  return {
    madToken,
    madByte,
    stakeNFT,
    validatorNFT,
    validatorPool,
    snapshots,
    ethdkg,
    namedSigners,
  };
};

export async function getTokenIdFromTx(tx: any) {
  let abi = [
    "event Transfer(address indexed from, address indexed to, uint256 indexed tokenId)",
  ];
  let iface = new ethers.utils.Interface(abi);
  let receipt = await ethers.provider.getTransactionReceipt(tx.hash);
  let log = iface.parseLog(receipt.logs[2]);
  const { from, to, tokenId } = log.args;
  return tokenId
}
