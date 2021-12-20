import {ethers} from 'hardhat';
import fs from 'fs';

/*

This script prints the address, private and public keys for the wallets in MadNet repo.

*/

const MADNET_KEYS_PATH = "../MadNet/assets/test/keys/"

const loadAllWallets = () => {
    let jsonFiles = fs.readdirSync(MADNET_KEYS_PATH)

    jsonFiles.forEach((file) => {
        try {
            //console.log("File:", file);
            let jsonData = fs.readFileSync(MADNET_KEYS_PATH+file).toString()
            let wallet = ethers.Wallet.fromEncryptedJsonSync(jsonData, "abc123")
            console.log(wallet.address, ':', wallet.privateKey, ':', wallet.publicKey)
            //console.log(wallet.privateKey)
        } catch(e) {
            console.log('error reading file', file)
        }
    });
}

loadAllWallets()
