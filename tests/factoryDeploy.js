const {expect} = require("chai");
const { ethers, artifacts } = require("hardhat");
const { BN, expectEvent, expectRevert} = require('@openzeppelin/test-helpers');
const ether = require("@openzeppelin/test-helpers/src/ether");
require("@nomiclabs/hardhat-waffle");
const Factory = artifacts.require("Factory");
const EndPoint = artifacts.require("endPoint");
const Proxy = artifacts.require("Proxy");
const Mock = artifacts.require("Mock")
const Utils = artifacts.require("utils");
contract("Factory", function (accounts) {
    before(async function () {
        //get a instance of a ethereum provider
        const provider = new ethers.providers.JsonRpcProvider();
        //gets the initial transaction count for the address 
        transactionCount = await provider.getTransactionCount(accounts[0]);
        //pre calculate the address of the factory contract 
        this.futureFactoryAddress = ethers.utils.getContractAddress({
            from: accounts[0],
            nonce: transactionCount
        });
        //deploy the factory with its address as a constructor input
        this.factory = await Factory.new(this.futureFactoryAddress);
        //create a utilities instance for testing 
        this.utils = Utils.new();
    });
    it("VERIFY CALCULATED FACTORY ADDRESS", async function(){
        expect(this.factory.address).to.equal(this.futureFactoryAddress);
    });
    it("DEPLOY STATIC FROM FACTORY", async function(){
        try {
        let salty = new Date();
        salty = salty.getTime();
        salty = ethers.utils.formatBytes32String(salty.toString());
        const bcode = EndPoint.bytecode;
        let receipt = await this.factory.deployTemplate(bcode);
        //call the factory for the template address 
        let templateAddr = await this.factory.template_.call();
        let size = await this.factory.extCodeSize(templateAddr);
        console.log("template_", size.toNumber(), templateAddr);
        //deploy metamorphic with a salt 
        receipt = await this.factory.deployStatic(salty, {gasPrice: 0});
        //gets the address of the most recent deplyed metamorphic contract using deployStatic
        let initCode = "0x6020363636335afa1536363636515af43d36363e3d36f3";
        const calcStaticDeployAddr = ethers.utils.getCreate2Address(this.factory.address, salty, ethers.utils.keccak256(initCode)); 
        let staticAddr = await this.factory.static_.call()
        //check if the deployedStatic address matches the calculated deployStatic address
        expect(staticAddr).to.equal(calcStaticDeployAddr)
        //check if there is code at the staticAddr
        size = await this.factory.extCodeSize(staticAddr);
        expect(size.toNumber()).to.be.greaterThan(0);
        console.log("static_", size.toNumber(), staticAddr);
        await receipt.wait(1)            
            .then((res) => {
                console.log("STATIC_LOG: ", res)
                for (let i = 0; i < res["logs"].length; i++) {
                    console.log("STATIC_TOPIC ", i, res["logs"][i]["topics"])
                }
        })
       //expect(true)
        } catch(ex) {
            console.trace(ex)
            expect(false)
        }
        //gets the metamorphic contract address 
        const tmpl0 = await this.factory.static_.call();
        console.log(tmpl0);
        //the contract should contain logic deployed from This.factory.depployTemplate()
        this.endPoint = await EndPoint.at(tmpl0);
        //call the metamorphic contract for the public factory address variable 
        const fa = await this.endPoint.factory_.call();
        //compare if the address is set correctly 
        expect(fa).to.equal(this.factory.address);
    });

    it("DEPLOY PROXY FROM FACTORY", async function(){
        let salt = new Date();
        salt = salt.getTime();
        salt = ethers.utils.formatBytes32String(salt.toString());
        this.proxySalt = salt;
        let initCode = "0x6020363636335afa1536363636515af43d36363e3d36f3";
        const expectedProxyAddr = ethers.utils.getCreate2Address(this.factory.address, salt, ethers.utils.keccak256(initCode));
        //deploy the proxy metamorphic
        let receipt = await this.factory.deployProxy(salt);
         //check if the calculated proxy addr is the contract bytecode 
        this.proxy = await Proxy.at(expectedProxyAddr);
        //get an instance of the endPoint Contract 
        let ePoint = await ethers.getContractFactory("endPoint");
        //deploy the endpoint contract 
        this.endPoint = await ePoint.deploy(this.factory.address);
        //deployed logic for the proxy to point at 
        await this.endPoint.deployed();
        this.endPoint = ePoint.attach(this.endPoint.address)
        //point the proxy to the endPoint contract Address
        receipt = await this.factory.upgradeProxy(salt, this.endPoint.address);
        expect(receipt["receipt"]["status"]).to.equal(true);
        //verify that the proxy is pointing to the endpoint contract 
        this.proxyEndPoint = await EndPoint.at(this.proxy.address);
        //call the add two function that is in the endpoint contract through proxy
        await this.proxyEndPoint.addTwo();
        this.i = this.i + 2;
        //query public state variable i through proxy
        const tx = await this.proxyEndPoint.i.call();
        expect(tx.toNumber()).to.equal(this.i);
        /*
        this.endPoint2 = await EndPoint.new(this.factory.address);
        await this.factory.upgradeProxy(salt, this.endPoint2.address);
        await LogicCaller.addOne();
        const tx0 = await LogicCaller.i.call();
        expect( tx0.toNumber()).to.equal(3);
        */
    });

    it("TEST MOCK LOGIC", async function(){
        let MockContract = await Mock.new(1);
        await MockContract.setv(2);
        this.v = 2;
        let v = await MockContract.v.call();
        expect(v.toNumber()).to.equal(this.v);
    });
    //Deploys a mock logic contract and points the proxy contract to it 
    it("MOCK PROXY LOGIC", async function() {
        //get an instance of the mock contract
        //mockCon is a ether contract instance
        let mockCon = await ethers.getContractFactory("Mock");
        //get the init code with contructor args appended
        deployBCode = mockCon.getDeployTransaction(2);
        //deploy Mock Logic through the factory
        // 27fe1822
        let receipt = await this.factory.deployCreate(deployBCode.data);
        //loop through all the events from that transaction
        for (let i = 0; i < receipt["logs"].length; i++) {
            //look for the event DeployedRaw
            if(receipt["logs"][i]["event"] == "DeployedRaw"){
                //extract the deployed mock logic contract address from the event
                this.mockAddress = receipt["logs"][i]["args"]["contractAddr"]
                console.log(this.mockAddress)
                //exit the loop
                break;
            }  
        }
        //Upgrade the proxy to the new implementation 
        //func sig 0a008a5d
        await this.factory.upgradeProxy(this.proxySalt, this.mockAddress);
        //create a interface of logic contract connected to the proxy
        //Mock is a truffle contract object 
        this.proxyMock = await Mock.at(this.proxy.address);
        //extCodeSize func sig fc6f06f5
        let csize = await this.factory.extCodeSize(this.proxyMock.address);
        expect(csize.toNumber()).to.equal((Proxy.deployedBytecode.length-2)/2)
        receipt = await this.proxyMock.setv(4, {from:accounts[0]});
        //verify the proxy is pointing to the correct logic 
        let res = await this.proxyMock.v.call();
        expect(res.toNumber()).to.equal(4);
        //lock the proxy
        receipt = await this.proxyMock.lock();
        //attempt to upgrade the proxy through factory 
        receipt = this.factory.upgradeProxy(this.proxySalt, this.mockAddress);
        await expectRevert(receipt, "revert");
        //unlock the upgrade lock 
        receipt = await this.proxyMock.unlock();
        //check if the transaction went through
        expect(receipt["receipt"]["status"]).to.equal(true);
        //change the proxy to point at a different implementation 
        receipt = await this.factory.upgradeProxy(this.proxySalt, this.endPoint.address);
        expect(receipt["receipt"]["status"]).to.equal(true);
        receipt = await this.proxyEndPoint.addTwo();
        this.i = this.i + 2;
        console.log(receipt);
        let result 
        for (let i = 0; i < receipt["logs"].length; i++) {
            //look for the event DeployedRaw
            if(receipt["logs"][i]["event"] == "addedTwo"){
                //extract the deployed mock logic contract address from the event
                this.i = receipt["logs"][i]["args"]["i"].toNumber();
                result = await this.proxyEndPoint.i.call();
                //exit the loop
                break;
            }
        }
        expect(result.toNumber()).to.equal(this.i)
    });


});


/* 
VERIFY CONTRACT ADDRESS CORRECT FOR STATIC AND PROXY
VERIFY PROXY UPGRADE LOCK AND UNLOCK
*/