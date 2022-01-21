const {expect} = require("chai");
const { getCreate2Address } = require("ethers/lib/utils");
const { ethers } = require("hardhat");
const Web3 = require("web3");
let web3 = new Web3();
let logicAddr;
let proxyAddr;
const factoryPrivateKey = "9305771b3112a9a52cfcc4270bd0040ff5aefd2ae18cbbd972612bdb357a1074";
const provider = ethers.getDefaultProvider("http://127.0.0.1:8545");
const factoryWallet = new ethers.Wallet(factoryPrivateKey, provider);
const privateKey = "8441c5098bd9e6f06b5d2000176aec0d2332e6ac994a9c586aeb2dd8c4c20000";
const wallet = new ethers.Wallet(privateKey, provider);
const abiCoder = ethers.utils.defaultAbiCoder;
let EndPoint;

describe("PROXY", function () {
    //deploy endpoint for test (this is a test logic)
    it("DEPLOYMENT OF TEST LOGIC", async function(){
        EndPoint = await ethers.getContractFactory("endPoint");
        const endPoint = await EndPoint.deploy();
        console.log(endPoint.i)
        
        logicAddr = endPoint.address;
        expect(await endPoint.deployed());
    });
    
    it("CALL LOGIC", async function(){
        EndPoint = await ethers.getContractFactory("endPoint");
        const endPoint = await EndPoint.attach(logicAddr);
        expect(await endPoint.addOne());
        console.log("i:", await endPoint.i());
    });
    
    //deploy an instance of the proxy 
    it("DEPLOYMENT OF PROXY: SUCCESS", async function(){
        const Proxy = await ethers.getContractFactory("Proxy");
        console.log(Proxy.getDeployTransaction(logicAddr, "0x"));
        const proxy = await Proxy.deploy(logicAddr, "0x");
        proxyAddr = proxy.address;
        console.log("proxyaddr: ", proxyAddr)
        expect(await proxy.deployed());
    });
    //test changing implementation Address 
    it("CHANGE IMPLEMENTATION ADDRESS: SUCCESS", async function(){
        const Proxy = await ethers.getContractFactory("Proxy");
        console.log(Proxy.getDeployTransaction(logicAddr, "0x"));
        const proxy = await Proxy.deploy(logicAddr, "0x");
        proxyAddr = proxy.address;
        expect(await proxy.deployed());
    });
    

    //call the proxy as owner 
    it("SHOULD: SUCCESS", async function(){
        const Proxy = await ethers.getContractFactory("Proxy");        
        const proxyLogic = await EndPoint.attach(proxyAddr);
        
        //function selector for logic contract 
        let logicCallData = EndPoint.interface.encodeFunctionData("addOne", []);
        console.log("logicCallData: ", logicCallData);
        //Make a transaction object
        let callData = abiCoder.encode(["bytes4"], [logicCallData]);
        let txReq = {
            to: proxyAddr,
            from: wallet.address,
            nonce: wallet.getTransactionCount(),
            data: callData,
            value: BigInt(0)
        };
        console.log("call i var: ", EndPoint.interface.encodeFunctionData("i", []));
        txReq = wallet.populateTransaction(txReq);
        let signedTX = wallet.signTransaction(txReq);
        wallet.sendTransaction(signedTX).then(res =>{return res}).then(res=>{}).catch(err => {console.log(err)});     
        console.log("i:", await proxyLogic.i());
        expect(1);
    });
    //call the proxy with non owner account 
});