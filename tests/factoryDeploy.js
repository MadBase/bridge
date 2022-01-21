const {expect} = require("chai");
const { ethers, artifacts } = require("hardhat");
const { BN, expectEvent} = require('@openzeppelin/test-helpers');
const ether = require("@openzeppelin/test-helpers/src/ether");
require("@nomiclabs/hardhat-waffle");

const Factory = artifacts.require("Factory");
const EndPoint = artifacts.require("endPoint");
const Proxy = artifacts.require("Proxy");
const Mock = artifacts.require("Mock")
const EndPointLockable = artifacts.require("endPointLockable");
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
        //get an instance of Factory contract
        let factory = await ethers.getContractFactory("Factory")
        //deploy the factory with its address as a constructor input
        this.factory = await factory.deploy(this.futureFactoryAddress);
        expect(await this.factory.deployed())
        //replace the factory instance 
        this.factory = factory.attach(this.factory.address)
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
        await receipt.wait(1)
            .then((res) => {
                console.log("TEMPLATE_LOG: ", res)
                for (let i = 0; i < res["logs"].length; i++) {
                    console.log("TEMPLATE_TOPIC", i, res["logs"][i]["topics"]);
                }
            })
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
        const receipt = await this.factory.deployProxy(salt);
        await receipt.wait(1);
         //check if the calculated proxy addr is the contract bytecode 
        await this.factory.once("DeployedProxy", (contractAddr)=>{
            // listener for the deployed proxy event 
            //compares the deployed proxy address with the expected Proxy address
            expect(contractAddr).to.equal(expectedProxyAddr);
        });
        this.proxy = await Proxy.at(expectedProxyAddr);
        //get an instance of the endPoint Contract 
        let ePoint = await ethers.getContractFactory("endPoint");
        //deploy the endpoint contract 
        this.endPoint = await ePoint.deploy(this.factory.address);
        //deployed logic for the proxy to point at 
        await this.endPoint.deployed();
        this.endPoint = ePoint.attach(this.endPoint.address)
        //point the proxy to the endPoint contract Address
        let upgrade = await this.factory.upgradeProxy(salt, this.endPoint.address);
        await upgrade.wait(1);
        //verify that the proxy is pointing to the endpoint contract 
        const proxyEndPoint = await EndPoint.at(this.proxy.address);
        //call the add two function that is in the endpoint contract through proxy
        await proxyEndPoint.addTwo();
        //query public state variable i through proxy
        const tx = await proxyEndPoint.i.call();
        expect( tx.toNumber()).to.equal(2);
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
        let v = await MockContract.v.call();
        expect(v.toNumber()).to.equal(2);
    });

    it("MOCK PROXY LOGIC", async function() {
        //deploy the mock
        let mockCon = await ethers.getContractFactory("Mock");
        deployBCode = mockCon.getDeployTransaction(2);
        
        await this.factory.once("DeployedRaw", (contractAddr) => {
            //upgrade the proxy endpoint to the mock contract address 
            console.log("deployedRaw: ", contractAddr);
        });
        //deploy Mock Logic through the factory
        // 27fe1822
        // 0x27fe18220000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000043c60a060405234801561001057600080fd5b5060405161041c38038061041c833981810160405281019061003291906100bb565b8060808181525050336000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550506100e8565b600080fd5b6000819050919050565b61009881610085565b81146100a357600080fd5b50565b6000815190506100b58161008f565b92915050565b6000602082840312156100d1576100d0610080565b5b60006100df848285016100a6565b91505092915050565b608051610319610103600039600061014e01526103196000f3fe608060405234801561001057600080fd5b50600436106100625760003560e01c80635bb47808146100675780637c2efcba14610083578063a69df4b5146100a1578063cd4c82f7146100ab578063e5aa3d58146100c7578063f83d08ba146100e5575b600080fd5b610081600480360381019061007c9190610229565b6100ef565b005b61008b610132565b604051610098919061026f565b60405180910390f35b6100a9610138565b005b6100c560048036038101906100c091906102b6565b610142565b005b6100cf61014c565b6040516100dc919061026f565b60405180910390f35b6100ed610170565b005b806000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555050565b60015481565b61014061017a565b565b8060018190555050565b7f000000000000000000000000000000000000000000000000000000000000000081565b61017861019a565b565b600019805473ffffffffffffffffffffffffffffffffffffffff16815550565b60001980547fca11c0de15dead10cced0000000000000000000000000000000000000000000017815550565b600080fd5b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b60006101f6826101cb565b9050919050565b610206816101eb565b811461021157600080fd5b50565b600081359050610223816101fd565b92915050565b60006020828403121561023f5761023e6101c6565b5b600061024d84828501610214565b91505092915050565b6000819050919050565b61026981610256565b82525050565b60006020820190506102846000830184610260565b92915050565b61029381610256565b811461029e57600080fd5b50565b6000813590506102b08161028a565b92915050565b6000602082840312156102cc576102cb6101c6565b5b60006102da848285016102a1565b9150509291505056fea2646970667358221220d25837193184009e65b34f88284f5eb76c895199d3d75f6e4016c48d6aa8f3c464736f6c634300080b0033000000000000000000000000000000000000000000000000000000000000000200000000
        let receipt = await this.factory.deployCreate(deployBCode.data);
        //grab the address from the event 
        console.log(receipt)
        await receipt.wait(1)
        .then((res) => {
            console.log("TEMPLATE_LOG: ", res)
            let g = res["events"][0]["args"]
            console.log(res["logs"][0])
            console.log(res["events"][0]["event"])
            console.log(g)
        })
        //func sig 0a008a5d
        await this.factory.upgradeProxy(this.proxySalt, this.mockAddress);
        //connect an instance of the lockable endpoint to proxy address
        this.proxyMock = await Mock.at(this.proxy.address);
        //extCodeSize func sig fc6f06f5
        let csize = await this.factory.extCodeSize(this.proxyMock.address);
        expect(csize.toNumber()).to.equal((Proxy.deployedBytecode.length-2)/2)
        console.log("proxyMock csize", csize.toNumber());
        console.log("proxy address: ", this.proxy.address);
        console.log("factory address: ", this.factory.address);
        console.log("Mock contract address: ", this.mockAddress);
        console.log(mockCon.interface.encodeFunctionData("setv", [4]))
        receipt = await this.proxyMock.setv(4, {from:accounts[0]});
        
        
        //verify the proxy is pointing to the correct logic 
        let res = await this.proxyMock.v.call();
        expect(res.toNumber()).to.equal(4);
        //lock the proxy
        await this.proxyMock.lock();
        await this.proxyMock.once("upgradeLocked", (lock)=>{
            // listener for the deployed proxy event 
            //compares the deployed proxy address with the expected Proxy address
            expect(lock).to.equal(true);
        });
        //attempt to upgrade the proxy through 
    });
    /*it("lock", async function() {
        //deploy a proxy with lock and unlock capability
        let EPLockable = await ethers.getContractFactory("endPointLockable");
        //deploy the lockable endpoint
        this.endPointLockable = await EPLockable.deploy(this.factory.address);
        expect(this.endPointLockable.deployed());
        //upgrade the proxy through the factory 
        await this.factory.upgradeProxy(this.proxySalt, this.endPointLockable.address);
        //connect an instance of the lockable endpoint to proxy address
        this.proxyEPLockable = await EndPointLockable.at(this.proxy.address);
        //lock the proxy
        await this.proxyEPLockable.upgradeLock();
        await this.proxyEPLockable.once("upgradeLocked", (lock)=>{
            // listener for the deployed proxy event 
            //compares the deployed proxy address with the expected Proxy address
            expect(lock).to.equal(true);
        });
        //attempt to upgrade the proxy through 
    });*/

});


/* 
VERIFY CONTRACT ADDRESS CORRECT FOR STATIC AND PROXY
VERIFY PROXY UPGRADE LOCK AND UNLOCK
*/