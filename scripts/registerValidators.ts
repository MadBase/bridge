import { BigNumber } from "ethers";
import { ethers, network } from "hardhat";
import { getTokenIdFromTx } from "../tests/tokens/periphery/setup";


async function main() {
  const lockTime = 1;
  const validatorAddresses: string[] = process.argv
  const stakingTokenIds: BigNumber[] = []
  const stakeAmountMadWei: BigNumber = BigNumber.from(20000)

  const namedSigners = await ethers.getSigners();
  const [admin] = namedSigners;
  const adminSigner = await ethers.getSigner(admin.address);

  // todo: get factory address from args
  const factory = await ethers.getContractAt("MadnetFactory", "0x0b1f9c2b7bed6db83295c7b5158e3806d67ec5bc");

  const madToken = await ethers.getContractAt("MadToken", await factory.lookup("MadToken"));
  const stakeNFT = await ethers.getContractAt("StakeNFT", await factory.lookup("StakeNFT"));
  const validatorPool = await ethers.getContractAt("ValidatorPool", await factory.lookup("ValidatorPool"));

  // approve tokens
  // madToken.approve(validatorPool.address, stakeAmountMadWei.mul(validatorAddresses.length));
  await madToken.approve(stakeNFT.address, stakeAmountMadWei.mul(validatorAddresses.length));

  console.log("After creating");

  // mint StakeNFT positions to validators
  for (const validatorAddress of validatorAddresses) {
    let tx = await stakeNFT
      .mintTo(validatorAddress, stakeAmountMadWei, lockTime);
    let tokenId = BigNumber.from(getTokenIdFromTx(tx))
    stakingTokenIds.push(tokenId);
    await stakeNFT
      .connect(await ethers.getSigner(validatorAddress))
      .approve(validatorPool.address, tokenId);
  }

  // add validators to the ValidatorPool
  // await validatorPool.registerValidators(validatorAddresses, stakingTokenIds)
  let iface = new ethers.utils.Interface(["function registerValidators(address[],uint256[])"]);
  let input = iface.encodeFunctionData("registerValidators", [validatorAddresses, stakingTokenIds])
  await factory.connect(adminSigner).callAny(validatorPool.address, 0, input)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  })