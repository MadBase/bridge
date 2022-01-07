const {expect} = require("chai");
const { getCreate2Address } = require("ethers/lib/utils");
const { ethers } = require("hardhat");
const Web3 = require("web3");
let web3 = new Web3();
let logicAddr;
let proxyAddr;
describe("MadnetFactory", function () {
    //deploy endpoint for test (this is a test logic)
    it("DEPLOYMENT OF TEST LOGIC", async function(){
        const EndPoint = await ethers.getContractFactory("endPoint");        
        const endPoint = await EndPoint.deploy();
        console.log(endPoint.i)
        logicAddr = endPoint.address;
        expect(await endPoint.deployed());
    });

    //deploy an instance of the proxy 
    it("DEPLOYMENT OF PROXY: SUCCESS", async function(){
        const Proxy = await ethers.getContractFactory("Proxy");
        console.log(Proxy.getDeployTransaction(logicAddr, "0x"));
        const proxy = await Proxy.deploy(logicAddr, "0x");
        proxyAddr = proxy.address;
        expect(await proxy.deployed());
    });

    //call the proxy as owner 
    it("SHOULD: SUCCESS", async function(){
        const Proxy = await ethers.getContractFactory("Proxy");        
        const proxy = await Proxy.deploy();
        const provider = ethers.getDefaultProvider();
        unsignedTX = {
            to: ,
        }
        provider.sendTransaction()
        //console.log(JSON.stringify(madnetFactory))
        expect(await proxy.deployed());
    });*/
    //call the proxy with non owner account 
});