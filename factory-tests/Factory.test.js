const { contracts } = require("@openzeppelin/cli/lib/prompts/choices");
const { BN, expectEvent, expectRevert} = require('@openzeppelin/test-helpers');
const {expect} = require("chai");
const { ethers } = require("hardhat");
const Proxy = artifacts.require("Proxy");
const EndPoint = artifacts.require("endPoint");
const MadnetFactory = artifacts.require("MadnetFactory")
contract("MADNET FACTORY", function (accounts){
    before(async function () {
        //deploy an instance of the factory
        this.madnetFactory = await MadnetFactory.new();
    })
    it("setOwner: succeed", async function(){
        //sets the second account as owner
        const receipt = await this.madnetFactory.setOwner(accounts[1], {from: accounts[0]});
        expect(await this.madnetFactory.owner_()).to.equal(accounts[1]);
        await this.madnetFactory.setOwner(accounts[0], {from: accounts[1]})
    });
    it("setDelegator: succeed", async function(){
        //sets the second account as delegator
        await this.madnetFactory.setDelegator(accounts[1], {from: accounts[0]});
        expect(await this.madnetFactory.delegator_()).to.equal(accounts[1]);
    });
    it("setOwner: failed", async function(){
        await expectRevert(
            this.madnetFactory.setOwner(accounts[0], {from: accounts[1]}),
            "unauthorized"
        );
    });
    //TODO: check result
    //deploy test logic
    it("deployCreate, endpoint: succeed", async function(){
        const receipt = await this.madnetFactory.deployCreate(EndPoint.bytecode, {from: accounts[0]});
        console.log(receipt)
    });
    //fail on bad code
    it("deployTemplate bad code: fail", async function(){
        const receipt = this.madnetFactory.deployCreate("0x604000", {from: accounts[0]});
        await expectRevert(receipt, "csize0")
    });
    //fail on unauthorized with bad code
    it("deployTemplate bad code unauthorized : fail", async function(){
        const receipt =  this.madnetFactory.deployCreate("0x604000", {from: accounts[2]});
        await expectRevert(receipt, "unauthorized")
    });
    //fail on unauthorized with good code
    it("deployTemplate good code unauthorized user: fail", async function(){
        const receipt = this.madnetFactory.deployCreate(EndPoint.bytecode, {from: accounts[2]});
        await expectRevert(receipt, "unauthorized")
    });
    it("Multicall, deployTemplate, deploy, : should succeed", async function(){
        const deployCode = this.Proxy.bytecode
        const MadnetFactory = await ethers.getContractFactory("MadnetFactory");
        let deployTemp = MadnetFactory.interface.encodeFunctionData("deployTemplate", [this.P"00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000"]);
        //deployTemp = deployTemp + "00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000"
        //deploy, inputs salt, initiator
        let deploy = MadnetFactory.interface.encodeFunctionData("deploy", ["0x0000000000000000000000000000000000000000", ethers.utils.formatBytes32String("foo"), "0x"]);
        //destroy
        let  destroy = MadnetFactory.interface.encodeFunctionData("destroy", ["0x0000000000000000000000000000000000000000"]);
        receipt = this.madnetFactory.multicall(deployTemp, deploy, destroy)
    });



    /*
    it("call addOne on logic ", async function(){
        const receipt = await this.logic.addOne({from: accounts[0]});
        this.i = this.i + 1;
        expectEvent(receipt, "addedOne", {i: new BN(this.i)});
    });
    it("call addTwo on logic", async function(){
        const receipt = await this.logic.addTwo({from: accounts[0]});
        this.i = this.i + 2;
        expectEvent(receipt, "addedTwo", {i: new BN(this.i)});
    });
    it("call addOne on Proxy", async function(){
        const receipt = await this.proxyCaller.addOne({from: accounts[1]});
        this.i = 1;
        expectEvent(receipt, "addedOne", {i: new BN(this.i)});
    });
    it("call addTwo on Proxy", async function(){
        const receipt = await this.proxyCaller.addTwo({from: accounts[1]});
        this.i = this.i + 2;
        expectEvent(receipt, "addedTwo", {i: new BN(this.i)});
    });
   */
});