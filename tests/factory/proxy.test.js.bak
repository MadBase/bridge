// const { contracts } = require("@openzeppelin/cli/lib/prompts/choices");
const { BN, expectEvent} = require('@openzeppelin/test-helpers');
const {expect} = require("chai");
const { ethers } = require("hardhat");
const Proxy = artifacts.require("Proxy");
const EndPoint = artifacts.require("endPoint");

contract("PROXY", function (accounts){
    before(async function () {
        //deploy an instance of the endpoint
        this.logic = await EndPoint.new();
        //deploy the proxy
        this.proxy = await Proxy.new(this.logic.address, "0x");
        //create a instance of the logic interface attached to the proxyAddr
        this.proxyCaller = await EndPoint.at(this.proxy.address);
        this.i = 0;
    })
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
    it("Factory calls proxy ", async function(){
        const receipt = await this.proxyCaller.addTwo({from: accounts[1]});
        this.i = this.i + 2;
        expectEvent(receipt, "addedTwo", {i: new BN(this.i)});
    });
    it();
});