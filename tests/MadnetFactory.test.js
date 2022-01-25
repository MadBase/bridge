//const { contracts } = require("@openzeppelin/cli/lib/prompts/choices");
const { BN, expectEvent, expectRevert} = require('@openzeppelin/test-helpers');
const { expect } = require("chai");
const { ethers, artifacts } = require("hardhat");
const Proxy = artifacts.require("Proxy");
const EndPoint = artifacts.require("endPoint");
const MadnetFactory = artifacts.require("MadnetFactory");
const Mock = artifacts.require("Mock");
const Utils = artifacts.require("utils");

contract("MADNET FACTORY", function (accounts){
    before(async function () {
        //get a instance of a ethereum provider
        this.provider = new ethers.providers.JsonRpcProvider();
        //gets the initial transaction count for the address 
        transactionCount = await this.provider.getTransactionCount(accounts[0]);
        //pre calculate the address of the factory contract 
        this.futureFactoryAddress = ethers.utils.getContractAddress({
            from: accounts[0],
            nonce: transactionCount
        });
        //deploy the factory with its address as a constructor input
        this.factory = await MadnetFactory.new(this.futureFactoryAddress);
        this.factoryOwner = accounts[0];
        this.endPoint = await EndPoint.new(this.factory.address);
        //deploy and instance of utils 
        this.utils = await Utils.new();
    })
    it("VERIFY CALCULATED FACTORY ADDRESS", async function(){
        expect(this.factory.address).to.equal(this.futureFactoryAddress);
    });

    it("setOwner: succeed", async function(){
        //sets the second account as owner 
        let receipt = await this.factory.setOwner(accounts[1], {from: this.factoryOwner});
        this.factoryOwner = accounts[1];
        expect(await this.factory.owner_()).to.equal(this.factoryOwner);
        await this.factory.setOwner(accounts[0], {from: accounts[1]})
        this.factoryOwner = accounts[0]; 
        expect(await this.factory.owner_()).to.equal(this.factoryOwner);
    });

    it("setDelegator: succeed", async function(){
        //sets the second account as delegator 
        await this.factory.setDelegator(accounts[1], {from: accounts[0]});
        this.factoryDelegator = accounts[1];
        expect(await this.factory.delegator_()).to.equal(this.factoryDelegator);
    });
    it("SET OWNER WITH UNAUTHORIZED ACCOUNT EXPECT FAIL", async function(){
        await expectRevert(
            this.factory.setOwner(accounts[0], {from: this.factoryDelegator}),
            "unauthorized"
        );
    });
/*
    it("DEPLOY MOCK WITH DEPLOYTEMPLATESD AS OWNER EXPECT SUCCEED", async function(){
        //ethers instance of Mock contract abstraction
        let mockSD = await ethers.getContractFactory("MockSD");
        //deploy code for mock with constructor args i = 2
        deployBCode = mockSD.getDeployTransaction(2);
        bCode = deployBcode.data + "00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000"
        //deploy the mock Contract to deployTemplate
        let receipt = await this.factory.deployTemplateSD(bCode);
        expectTxSuccess(receipt);
        //store the address of the deployedTemplate contract 
        this.MockDeploySD = await getEventVar(receipt, "DeployedTemplate", "contractAddr");
    });
*/
    it("DEPLOY MOCK WITH DEPLOYTEMPLATE AS OWNER EXPECT SUCCEED", async function(){
        //ethers instance of Mock contract abstraction
        let mockCon = await ethers.getContractFactory("Mock");
        //deploy code for mock with constructor args i = 2
        deployBCode = mockCon.getDeployTransaction(2);
        //deploy the mock Contract to deployTemplate
        let transactionCount = await this.provider.getTransactionCount(this.factory.address)
        let expectedMockTempAddress = getCreateAddress(this.factory.address, transactionCount);
        let receipt = await this.factory.deployTemplate(deployBCode.data);
        expectTxSuccess(receipt);
        this.mockTempAddress = await getEventVar(receipt, "DeployedTemplate", "contractAddr");
        expect(this.mockTempAddress).to.equal(expectedMockTempAddress)
    });

    it("DEPLOY MOCK WITH DEPLOYTEMPLATE AS DELEGATOR EXPECT FAIL", async function(){
        
    });

    it("DEPLOY MOCK CONTRACT WITH DEPLOY STATIC AS OWNER EXPECT SUCCEED", async function(){
        //set a new salt 
        let salt = new Date();
        //use the time as the salt 
        salt = salt.getTime();
        //get the utf8 bytes32 version of the salt 
        this.mockStaticSalt = ethers.utils.formatBytes32String(salt.toString());
        let expectedMockStaticAddress = getMetamorphicAddress(this.factory.address, this.mockStaticSalt);
        let receipt = await this.factory.deployStatic(this.mockStaticSalt);
        expectTxSuccess(receipt);
        this.mockStaticAddress = await getEventVar(receipt, "DeployedStatic", "contractAddr");
        expect(this.mockStaticAddress).to.equal(expectedMockStaticAddress);
    });

    it("DEPLOY MOCK CONTRACT WITH DEPLOY STATIC AS DELEGATOR EXPECT FAIL", async function(){

    });
    
    it("DEPLOY PROXY EXPECT SUCCESS", async function(){
        //set a new salt 
        let salt = new Date();
        //use the time as the salt 
        salt = salt.getTime();
        //get the utf8 bytes32 version of the salt 
        this.proxySalt = ethers.utils.formatBytes32String(salt.toString());
        //metamorphic contract init code for calculating address 
        let initCode = "0x6020363636335afa1536363636515af43d36363e3d36f3";
        //the calculated proxy address  
        const expectedProxyAddr = ethers.utils.getCreate2Address(this.factory.address, this.proxySalt, ethers.utils.keccak256(initCode));
        //deploy the proxy through the factory 
        let receipt = await this.factory.deployProxy(this.proxySalt);
        //check if transaction succeeds 
        expectTxSuccess(receipt);
        //get the deployed proxy contract address fom the DeployedProxy event 
        let proxyAddr = await getEventVar(receipt, "DeployedProxy", "contractAddr");
        //check if the deployed contract address match the calculated address 
        expect(proxyAddr).to.equal(expectedProxyAddr);
        this.proxyAddr = proxyAddr;
    });


    it("DEPLOY PROXY WITH UNAUTH ACC EXPECT FAIL", async function(){
        await expectRevert(
            this.factory.deployProxy(this.proxySalt, {from: this.factoryDelegator}), 
            "unauthorized"
            );
    });

    it("COMPARE DEPLOYED PROXY CODE SIZE WITH COMPILED PROXY RUNTIME CODE SIZE", async function(){
        let cSize = await this.utils.getCodeSize.call(this.proxyAddr)
        expect(cSize.toNumber()).to.equal((Proxy.deployedBytecode.length-2)/2);
    });

    it("DEPLOYCREATE MOCK LOGIC CONTRACT EXPECT SUCCESS", async function(){
        //use the ethers Mock contract abstraction to generate the deploy transaction data 
        let mockCon = await ethers.getContractFactory("Mock");
        //get the init code with contructor args appended
        deployBCode = mockCon.getDeployTransaction(2);
        let transactionCount = await this.provider.getTransactionCount(this.factory.address)
        //deploy Mock Logic through the factory
        // 27fe1822
        let receipt = await this.factory.deployCreate(deployBCode.data);
        //check if the transaction is mined or failed 
        expectTxSuccess(receipt);
        let dcMockAddress = getEventVar(receipt, "DeployedRaw", "contractAddr");
        //calculate the deployed address 
        let expectedMockAddr = ethers.utils.getContractAddress({
            from: this.factory.address,
            nonce: transactionCount
        });
        expect(dcMockAddress).to.equal(expectedMockAddr);
        this.dcMockAddress = dcMockAddress;
    });
    it("DEPLOYCREATE MOCK LOGIC CONTRACT W/ UNAUTH ACC EXPECT FAIL", async function(){
        //use the ethers Mock contract abstraction to generate the deploy transaction data 
        let mockCon = await ethers.getContractFactory("Mock");
        //get the init code with contructor args appended
        deployBCode = mockCon.getDeployTransaction(2);
        //deploy Mock Logic through the factory
        // 27fe1822
        let receipt = this.factory.deployCreate(deployBCode.data, {from: this.factoryDelegator});
        await expectRevert(receipt, "unauthorized") 
    });
    it("UPGRADE PROXY TO POINT TO DCMOCKADDRESS W FACTORY EXPECT SUCCESS", async function(){
       //Upgrade the proxy to the new implementation 
        //func sig 0a008a5d
        let receipt = await this.factory.upgradeProxy(this.proxySalt, this.dcMockAddress);
        expectTxSuccess(receipt);
    });

    it("UPGRADE PROXY TO POINT TO DCMOCKADDRESS W FACTORY USING UNAUTH ACC EXPECT FAIL", async function(){
        let receipt = this.factory.upgradeProxy(this.proxySalt, this.dcMockAddress, {from: this.factoryDelegator});
        await expectRevert(receipt, "unauthorized")
    });

    it("CALL SETFACTORY IN MOCK THROUGH PROXY EXPECT SUCCESS", async function(){
        //connect a Mock interface to the proxy contract 
        this.proxyMock = await Mock.at(this.proxyAddr);
        let receipt = await this.proxyMock.setFactory(accounts[0]);
        expectTxSuccess(receipt);
        let mockFactory = await this.proxyMock.getFactory.call();
        expect(mockFactory).to.equal(accounts[0]); 
    });

    it("LOCK UPGRADES FOR PROXY EXPECT SUCCESS", async function(){
        //lock the proxy
        let receipt = await this.proxyMock.lock();
        expectTxSuccess(receipt);
    });

    it("UPGRADE LOCKED PROXY EXPECT FAIL", async function(){
        let receipt = this.factory.upgradeProxy(this.proxySalt, this.endPoint.address);
        expectRevert(receipt, "revert");
    });

    it("UNLOCK PROXY EXPECT SUCCESS ", async function(){
        let receipt = await this.proxyMock.unlock();
        expectTxSuccess(receipt);
    });

    it("UPGRADE UNLOCKED PROXY EXPECT SUCCESS", async function(){
        let receipt = await this.factory.upgradeProxy(this.proxySalt, this.endPoint.address);
        expectTxSuccess(receipt);
    });

    //fail on bad code 
    it("DEPLOYCREATE WITH BAD CODE EXPECT FAIL", async function(){
        let receipt = this.factory.deployCreate("0x6000", {from: this.factoryOwner});
        await expectRevert(receipt, "csize0");
    });
    
    //fail on unauthorized with bad code 
    it("DEPLOY CREATE WITH BAD CODE, UNAUTHORIZED ACCOUNT EXPECT FAIL ", async function(){
        let receipt =  this.factory.deployCreate("0x6000", {from: accounts[2]});
        await expectRevert(receipt, "unauthorized")  
    });

    //fail on unauthorized with good code 
    it("DEPLOY CREATE WITH VALID CODE, UNAUTHORIZED ACCOUNT EXPECT FAIL", async function(){
        const receipt = this.factory.deployCreate(EndPoint.bytecode, {from: accounts[2]});
        await expectRevert(receipt, "unauthorized")     
    });

    it("MULTICALL DEPLOYTEMPLATE, DEPLOYSTATIC", async function(){
        //set a new salt 
        let salt = new Date();
        //use the time as the salt 
        salt = salt.getTime();
        //get the utf8 bytes32 version of the salt 
        this.mcSalt = ethers.utils.formatBytes32String(salt.toString());
        //ethers instance of Mock contract abstraction
        let mockCon = await ethers.getContractFactory("Mock");
        //deploy code for mock with constructor args i = 2
        deployBCode = mockCon.getDeployTransaction(2);
        const MadnetFactory = await ethers.getContractFactory("MadnetFactory");
        //encoded function call to deployTemplate 
        let deployTemplate = MadnetFactory.interface.encodeFunctionData("deployTemplate", [deployBCode.data]);
        //encoded function call to deployStatic
        let deployStatic = MadnetFactory.interface.encodeFunctionData("deployStatic", [this.mcSalt]);
        let receipt = await this.factory.multiCall([deployTemplate, deployStatic]);
        console.log(receipt);
    });
    
/*
    it("MULTICALL DEPLOYTEMPLATE, DEPLOYSTATIC", async function(){
        const deployCode =
        const MadnetFactory = await ethers.getContractFactory("MadnetFactory");
        let deployTemp = MadnetFactory.interface.encodeFunctionData("deployTemplate", ["00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000"]);
        //deployTemp = deployTemp + "00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000"
        //deploy, inputs salt, initiator
        let deploy = MadnetFactory.interface.encodeFunctionData("deploy", ["0x0000000000000000000000000000000000000000", ethers.utils.formatBytes32String("foo"), "0x"]);
        //destroy
        let  destroy = MadnetFactory.interface.encodeFunctionData("destroy", ["0x0000000000000000000000000000000000000000"]);
        receipt = this.factory.multicall(deployTemp, deploy, destroy)
    });
  */  
});



function getEventVar(receipt, eventName, varName){
    let result 
    for (let i = 0; i < receipt["logs"].length; i++) {
        //look for the event
        if(receipt["logs"][i]["event"] == eventName){
            //extract the deployed mock logic contract address from the event
            result = receipt["logs"][i]["args"][varName];
            //exit the loop
            break;
        }
    }
    return result;
}
function expectTxSuccess(receipt){
    expect(receipt["receipt"]["status"]).to.equal(true);
}
function expectTxFail(receipt){
    expect(receipt["receipt"]["status"]).to.equal(false);
}

function getCreateAddress(Address, nonce){
    return ethers.utils.getContractAddress({
        from: Address,
        nonce: nonce
    });
}
function getMetamorphicAddress(address, salt ){
    let initCode = "0x6020363636335afa1536363636515af43d36363e3d36f3";
    return ethers.utils.getCreate2Address(address, salt, ethers.utils.keccak256(initCode));
}