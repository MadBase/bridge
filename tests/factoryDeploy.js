const {expect} = require("chai");
const { getCreate2Address } = require("ethers/lib/utils");
const { ethers } = require("hardhat");
const Web3 = require("web3");
let web3 = new Web3();
let MNaddress;
describe("MadnetFactory", function () {
    //deploy MadnetFactory 
    it("DEPLOYMENT OF FACTORY: SUCCESS", async function(){
        const MadnetFactory = await ethers.getContractFactory("MadnetFactory");
        const madnetFactory = await MadnetFactory.deploy();
        MNaddress = madnetFactory.address;
        //console.log(JSON.stringify(madnetFactory))
        expect(await madnetFactory.deployed());
    });
    //deploy a contract
    it("should return address of contract", async function(){
        //get the instance of madnetFactory
        const MadnetFactory = await ethers.getContractFactory("MadnetFactory");
        //get the bytecode of the implementation contract
        const Implementation = await ethers.getContractFactory("foo");
        //connect to the deployed factory contract
        const madnetFactory = await MadnetFactory.attach(MNaddress);
        //deployTemplate        
        let deployTemp = MadnetFactory.interface.encodeFunctionData("deployTemplate", [Implementation.bytecode]);
        deployTemp = deployTemp + "00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000"
        //deploy, inputs salt, initiator
        let deploy = MadnetFactory.interface.encodeFunctionData("deploy", ["0x0000000000000000000000000000000000000000", ethers.utils.formatBytes32String("foo"), "0x"]);
        //destroy
        let  destroy = MadnetFactory.interface.encodeFunctionData("destroy", ["0x0000000000000000000000000000000000000000"]);
        let implementationInstance = await Implementation.deploy("0xf22EC8b8Fe42cc72A269eC588a13CfE312EE0B73", "0x");
        expect(implementationInstance.deployed());
        expect(await madnetFactory.multiCall([deployTemp, deploy, destroy]));
        expect(await madnetFactory.deployTemplate(Implementation.bytecode));
    });
});