import { validators4 } from "../assets/4-validators-successful-case";
import { ethers } from "hardhat";
import {
  endCurrentPhase,
  endCurrentAccusationPhase,
  distributeValidatorsShares,
  startAtDistributeShares,
  expect,
} from "../setup";

