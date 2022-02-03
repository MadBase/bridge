import { expect, assert } from "../../chai-setup";
import { ethers, network } from "hardhat";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";

import {
  BigNumber,
  BigNumberish,
  ContractTransaction,
  Signer,
  utils,
  Wallet,
} from "ethers";

import {
  MadToken,
  MadByte,
  StakeNFT,
  ValidatorNFT,
  ETHDKG,
  ValidatorPoolTrue,
  ValidatorPool,
} from "../../../typechain-types";

export const PLACEHOLDER_ADDRESS = "0x0000000000000000000000000000000000000000";

export { expect, assert } from "../../chai-setup";

export interface Fixture {
  madToken: MadToken;
  madByte: MadByte;
  stakeNFT: StakeNFT;
  validatorNFT: ValidatorNFT;
  validatorPool: ValidatorPool;
  validatorPoolTrue: ValidatorPoolTrue;
  ethdkg: ETHDKG;
  namedSigners: SignerWithAddress[];
}

export enum Phase {
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
  privateKey?: string;
  address: string;
  madNetPublicKey: [BigNumberish, BigNumberish];
  encryptedShares: BigNumberish[];
  commitments: [BigNumberish, BigNumberish][];
  keyShareG1: [BigNumberish, BigNumberish];
  keyShareG1CorrectnessProof: [BigNumberish, BigNumberish];
  keyShareG2: [BigNumberish, BigNumberish, BigNumberish, BigNumberish];
  mpk: [BigNumberish, BigNumberish, BigNumberish, BigNumberish];
  gpkj: [BigNumberish, BigNumberish, BigNumberish, BigNumberish];
  sharedKey?: [BigNumberish, BigNumberish];
  sharedKeyProof?: [BigNumberish, BigNumberish];
  encryptedSharesHash?: BigNumberish[],
  groupCommitments?: [BigNumberish, BigNumberish][][],

}


export const getFixture = async () => {
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
  // console.log(`StakeNFT deployed at ${stakeNFT.address}`);

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
  // console.log(`ValidatorNFT deployed at ${validatorNFT.address}`);

  //ValidatorPool
  const ValidatorPool = await ethers.getContractFactory("ValidatorPool");
  const validatorPool = await ValidatorPool.deploy(
    PLACEHOLDER_ADDRESS
  );
  await validatorPool.deployed();
  // console.log(`ValidatorPool deployed at ${validatorPool.address}`);

  // ETHDKG Accusations
  const ETHDKGAccusations = await ethers.getContractFactory("ETHDKGAccusations");
  const ethdkgAccusations = await ETHDKGAccusations.deploy();
  await ethdkgAccusations.deployed();

  // ETHDKG Phases
  const ETHDKGPhases = await ethers.getContractFactory("ETHDKGPhases");
  const ethdkgPhases = await ETHDKGPhases.deploy();
  await ethdkgPhases.deployed();

  // ETHDKG
  const ETHDKG = await ethers.getContractFactory("ETHDKG");
  const ethdkg = await ETHDKG.deploy(
    PLACEHOLDER_ADDRESS
  );
  await ethdkg.deployed();
  // console.log(`ETHDKG deployed at ${ethdkg.address}`);
  // console.log("finished core deployment");

  // ValidatorPoolTrue
  const ValidatorPoolTrue = await ethers.getContractFactory("ValidatorPoolTrue");
  const validatorPoolTrue = await ValidatorPoolTrue.deploy(
    stakeNFT.address,
    validatorNFT.address,
    madToken.address,
    ethdkg.address,
    PLACEHOLDER_ADDRESS,
    PLACEHOLDER_ADDRESS
  );
  await validatorPoolTrue.deployed();
  // console.log(`ValidatorPool deployed at ${validatorPool.address}`);
  await ethdkg.initialize(
    validatorPoolTrue.address,
    ethdkgAccusations.address,
    ethdkgPhases.address)


  return {
    madToken,
    madByte,
    stakeNFT,
    validatorNFT,
    validatorPool,
    validatorPoolTrue,
    ethdkg,
    namedSigners,
  };
};