import {
    deployFactory,
    deployStaticStakeNFT
} from "./lib/deploymentUtils"

 



async function main() {
    let factoryAddress = await deployFactory() as string;
    let proxy = await deployStaticStakeNFT(factoryAddress);
}



main()
    .then(()=> process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    })