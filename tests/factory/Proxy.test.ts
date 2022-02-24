import { BN, expectEvent} from '@openzeppelin/test-helpers';
import { ethers } from 'hardhat';
import { EndPoint, MadnetFactory, Proxy } from '../../typechain-types';
import { expect } from '../chai-setup';
import { deployFactory, MADNET_FACTORY } from './Setup.test';


describe("PROXY", async () => {
    let proxy: Proxy
    let endPoint: EndPoint
    let factory: MadnetFactory

    beforeEach(async () => {
        let Proxy = await ethers.getContractFactory("Proxy");
        proxy = await Proxy.deploy()
        let EndPoint = await ethers.getContractFactory("EndPoint");
        factory = await deployFactory(MADNET_FACTORY);
        endPoint = await EndPoint.deploy(factory.address)
    });

    //deploy endpoint for test (this is a test logic)
    it("deployment of test logic", async function(){
        expect(await endPoint.deployed()).to.be.equal(endPoint.address)
    });

    it("call function via logic function", async function(){
        expect(await endPoint.addOne());
        console.log("i:", await endPoint.i());
    });

    // //test changing implementation Address
    // it("change implementation address", async function(){
    //     const Endpoint = await ethers.getContractFactory("EndPoint");
    //     const endPoint2 =

    // });


    // //call the proxy as owner
    // it("SHOULD: SUCCESS", async function(){
    //     const Proxy = await ethers.getContractFactory("Proxy");
    //     const proxyLogic = await EndPoint.attach(proxyAddr);

    //     //function selector for logic contract
    //     let logicCallData = EndPoint.interface.encodeFunctionData("addOne", []);
    //     console.log("logicCallData: ", logicCallData);
    //     //Make a transaction object
    //     let callData = abiCoder.encode(["bytes4"], [logicCallData]);
    //     let txReq = {
    //         to: proxyAddr,
    //         from: wallet.address,
    //         nonce: wallet.getTransactionCount(),
    //         data: callData,
    //         value: BigInt(0)
    //     };
    //     console.log("call i var: ", EndPoint.interface.encodeFunctionData("i", []));
    //     txReq = wallet.populateTransaction(txReq);
    //     let signedTX = wallet.signTransaction(txReq);
    //     wallet.sendTransaction(signedTX).then(res =>{return res}).then(res=>{}).catch(err => {console.log(err)});
    //     console.log("i:", await proxyLogic.i());
    //     expect(1);
    // });

    // it("call addOne on logic contract via proxy", async function(){
    //     const receipt = await this.logic.addOne({from: accounts[0]});
    //     this.i = this.i + 1;
    //     expectEvent(receipt, "addedOne", {i: new BN(this.i)});
    // });
    // it("call addTwo on logic contract via proxy", async function(){
    //     const receipt = await this.logic.addTwo({from: accounts[0]});
    //     this.i = this.i + 2;
    //     expectEvent(receipt, "addedTwo", {i: new BN(this.i)});
    // });

    // it("call addOne on Proxy", async function(){
    //     const receipt = await this.proxyCaller.addOne({from: accounts[1]});
    //     this.i = 1;
    //     expectEvent(receipt, "addedOne", {i: new BN(this.i)});
    // });

    // it("call addTwo on Proxy", async function(){
    //     const receipt = await this.proxyCaller.addTwo({from: accounts[1]});
    //     this.i = this.i + 2;
    //     expectEvent(receipt, "addedTwo", {i: new BN(this.i)});
    // });

    // it("Factory calls proxy ", async function(){
    //     const receipt = await this.proxyCaller.addTwo({from: accounts[1]});
    //     this.i = this.i + 2;
    //     expectEvent(receipt, "addedTwo", {i: new BN(this.i)});
    // });
});