const {deployUpgradeable, upgradeDeployment, deployNonUpgradeable} = require("../scripts/lib/MadnetFactory");


//const { contracts } = require("@openzeppelin/cli/lib/prompts/choices");
const { BN, expectEvent, expectRevert} = require('@openzeppelin/test-helpers');
const { expect } = require("chai");
const { ethers, artifacts } = require("hardhat");
const { get } = require('http');
const { isTemplateExpression } = require('typescript');
const Proxy = artifacts.require("Proxy");
const EndPoint = artifacts.require("endPoint");
const MadnetFactory = artifacts.require("MadnetFactory");
const Mock = artifacts.require("Mock");
const MockSD = artifacts.require("MockSD")
const mockInitializable = artifacts.require("MockInitializable")
const Utils = artifacts.require("utils");


const logicAddrKey = "LogicAddress";
const proxyAddrKey = "ProxyAddress"
const metaAddrKey = "MetaAddress"
const templateAddrKey = "TemplateAddress"
const deployedStaticKey = "DeployedStatic";
const deployedProxyKey = "DeployedProxy";
const deployedRawKey = "DeployedRaw";
const deployedTemplateKey = "DeployedTemplate";
const deployedKey = "Deployed";
const contractAddrKey = "contractAddr";
const madnetFactoryKey = "MadnetFactory";
const mockContractKey = "Mock";
contract("MADNET FACTORY", function (accounts){
    before(async function () {
        //get a instance of a ethereum provider
        this.provider = new ethers.providers.JsonRpcProvider();
        this.utils = await Utils.new();
    })

    it("DEPLOY FACTORY", async function(){
        //gets the initial transaction count for the address
        let transactionCount = await this.provider.getTransactionCount(accounts[0]);
        //pre calculate the address of the factory contract
        this.futureFactoryAddress = ethers.utils.getContractAddress({
            from: accounts[0],
            nonce: transactionCount
        });
        //deploy the factory with its address as a constructor input
        this.factory = await MadnetFactory.new(this.futureFactoryAddress);
        this.factoryOwner = accounts[0];
        let cSize = await this.utils.getCodeSize(this.factory.address);
        expect(cSize.toNumber()).to.be.greaterThan(0);
    });

    it("DEPLOYUPGRADEABLE", async function(){
        let artifactPaths = await artifacts.getAllFullyQualifiedNames();
        let logicPath;
        for (let i = 0; i < artifactPaths.length; i++){
            if (artifactPaths[i].split(":")[1] === madnetFactoryKey){
                logicPath = artifactPaths[i].split(":")[0];
                break;
            }
        }
        let res = await deployUpgradeable(logicPath, madnetFactoryKey, this.factory.address);
        let cSize = await this.utils.getCodeSize(res[logicAddrKey])
        expect(cSize.toNumber()).to.be.greaterThan(0);
        cSize = await this.utils.getCodeSize(res[proxyAddrKey])
        expect(cSize.toNumber()).to.be.greaterThan(0);
    });

    it("UPGRADEDEPLOYMENT", async function(){
        let artifactPaths = await artifacts.getAllFullyQualifiedNames();
        let logicPath;
        for (let i = 0; i < artifactPaths.length; i++){
            if (artifactPaths[i].split(":")[1] === madnetFactoryKey){
                logicPath = artifactPaths[i].split(":")[0];
                console.log(logicPath)
                break;
            }
        }
        let res = await upgradeDeployment(logicPath, madnetFactoryKey, this.factory.address);
        let logicSize = await this.utils.getCodeSize(res[logicAddrKey])
        expect(logicSize.toNumber()).to.be.greaterThan(0);

    });

    it("UPGRADENONUPGRADEABLE", async function(){
        let artifactPaths = await artifacts.getAllFullyQualifiedNames();
        let logicPath;
        for (let i = 0; i < artifactPaths.length; i++){
            if (artifactPaths[i].split(":")[1] === mockContractKey){
                logicPath = artifactPaths[i].split(":")[0];
                break;
            }
        }
        let res = await deployNonUpgradeable(logicPath, mockContractKey, this.factory.address);
        let cSize = await this.utils.getCodeSize(res[templateAddrKey])
        expect(cSize.toNumber()).to.be.greaterThan(0);
        cSize = await this.utils.getCodeSize(res[metaAddrKey])
        expect(cSize.toNumber()).to.be.greaterThan(0);
    });


    it("DEPLOY ENDPOINT", async function(){
        this.endPoint = await EndPoint.new(this.factory.address);
        let size = await this.utils.getCodeSize(this.endPoint.address)
        expect(size.toNumber()).to.be.greaterThan(0);
    });

    it("DEPLOY MOCK", async function(){
        this.mock = await Mock.new(2);
        let size = await this.utils.getCodeSize(this.mock.address)
        expect(size.toNumber()).to.be.greaterThan(0);
    });
    it("VERIFY CALCULATED FACTORY ADDRESS", async function(){
        expect(this.factory.address).to.equal(this.futureFactoryAddress);
    });

    it("setOwner: succeed", async function(){
        //sets the second account as owner
        let receipt = await this.factory.setOwner(accounts[1], {from: this.factoryOwner});
        this.factoryOwner = accounts[1];
        expect(await this.factory.owner.call()).to.equal(this.factoryOwner);
        await this.factory.setOwner(accounts[0], {from: accounts[1]})
        this.factoryOwner = accounts[0];
        expect(await this.factory.owner.call()).to.equal(this.factoryOwner);
    });

    it("setDelegator: succeed", async function(){
        //sets the second account as delegator
        await this.factory.setDelegator(accounts[1], {from: accounts[0]});
        this.factoryDelegator = accounts[1];
        expect(await this.factory.delegator()).to.equal(this.factoryDelegator);
    });
    it("SET OWNER WITH UNAUTHORIZED ACCOUNT EXPECT FAIL", async function(){
        await expectRevert(
            this.factory.setOwner(accounts[0], {from: this.factoryDelegator}),
            "unauthorized"
        );
    });



    it("GET OWNER", async function(){
        let owner = await this.factory.owner.call();
        expect(owner).to.equal(this.factoryOwner);
    });

    it("GET DELEGATOR", async function(){
        let delegator = await this.factory.delegator.call();
        expect(delegator).to.equal(this.factoryDelegator);
    });





    it("REQUIREAUTH", async function(){

    });

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
        this.mockTempAddress = await getEventVar(receipt, deployedTemplateKey, contractAddrKey);
        expect(this.mockTempAddress).to.equal(expectedMockTempAddress)
        console.log("DEPLOYTEMPLATE GASUSED: ", receipt["receipt"]["gasUsed"]);
    });

    it("DEPLOY MOCK WITH DEPLOYTEMPLATE AS DELEGATOR EXPECT FAIL", async function(){

    });

    it("DEPLOY MOCK CONTRACT WITH DEPLOY STATIC AS OWNER EXPECT SUCCEED", async function(){
        //set a new salt
        let salt = new Date();
        //use the time as the salt
        salt = salt.getTime();
        //get the utf8 bytes32 version of the salt
        Salt = ethers.utils.formatBytes32String(salt.toString());
        let expectedMetaAddress = getMetamorphicAddress(this.factory.address, Salt);
        let receipt = await this.factory.deployStatic(Salt, "0x");
        expectTxSuccess(receipt);
        let metaAddr = await getEventVar(receipt, deployedStaticKey, contractAddrKey);
        expect(metaAddr).to.equal(expectedMetaAddress);
        console.log("DEPLOYSTATIC GASUSED: ", receipt["receipt"]["gasUsed"]);
        metaMockLogicTest(Mock, metaAddr, this.factory.address);
    });

    it("DEPLOY MOCK CONTRACT WITH DEPLOY STATIC AS DELEGATOR EXPECT FAIL", async function(){

    });

    it("DEPLOYPROXY EXPECT SUCCESS", async function(){
        //set a new salt
        let salt = new Date();
        //use the time as the salt
        salt = salt.getTime();
        //get the utf8 bytes32 version of the salt
        this.proxySalt = ethers.utils.formatBytes32String(salt.toString());
        //the calculated proxy address
        const expectedProxyAddr = getMetamorphicAddress(this.factory.address, this.proxySalt)
        //deploy the proxy through the factory
        let receipt = await this.factory.deployProxy(this.proxySalt);
        //check if transaction succeeds
        expectTxSuccess(receipt);
        //get the deployed proxy contract address fom the DeployedProxy event
        let proxyAddr = await getEventVar(receipt, deployedProxyKey, contractAddrKey);
        //check if the deployed contract address match the calculated address
        expect(proxyAddr).to.equal(expectedProxyAddr);
        this.proxyAddr = proxyAddr;
        console.log("DEPLOYPROXY GASUSED: ", receipt["receipt"]["gasUsed"]);
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
        let dcMockAddress = getEventVar(receipt, deployedRawKey, contractAddrKey);
        //calculate the deployed address
        let expectedMockAddr = ethers.utils.getContractAddress({
            from: this.factory.address,
            nonce: transactionCount
        });
        expect(dcMockAddress).to.equal(expectedMockAddr);
        this.dcMockAddress = dcMockAddress;
        console.log("DEPLOYCREATE MOCK LOGIC GASUSED: ", receipt["receipt"]["gasUsed"]);
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
        console.log("UPGRADE PROXY GASUSED: ", receipt["receipt"]["gasUsed"]);
    });
/*
    it("DEPLOYTEMPLATEWITHSD ", async function(){
         //ethers instance of Mock contract abstraction
         let mockCon = await ethers.getContractFactory("MockSD");
         //deploy code for mock with constructor args i = 2
         deployBCode = mockCon.getDeployTransaction(2, "0x");
         //deploy the mock Contract to deployTemplate
         let transactionCount = await this.provider.getTransactionCount(this.factory.address)
         let expectedMockTempAddress = getCreateAddress(this.factory.address, transactionCount);
         let receipt = await this.factory.deployTemplateWithSD(deployBCode.data);
         expectTxSuccess(receipt);
         this.mockTempSDAddress = await getEventVar(receipt, deployedTemplateKey, contractAddrKey);
         expect(this.mockTempSDAddress).to.equal(expectedMockTempAddress)

         expectTxSuccess(receipt);
         console.log("DEPLOYTEMPLATEWITHSD GASUSED: ", receipt["receipt"]["gasUsed"]);
    });

    it("DEPLOY META CONTRACT WITH DEPLOY AS OWNER EXPECT SUCCEED", async function(){
        //set a new salt
        let salt = new Date();
        //use the time as the salt
        salt = salt.getTime();
        //get the utf8 bytes32 version of the salt
        Salt = ethers.utils.formatBytes32String(salt.toString());
        let expectedMetaAddress = getMetamorphicAddress(this.factory.address, Salt);
        let receipt = await this.factory.deploy("0x0000000000000000000000000000000000000000", Salt, "0x");
        expectTxSuccess(receipt);
        let metaAddr = await getEventVar(receipt, deployedKey, contractAddrKey);
        expect(metaAddr).to.equal(expectedMetaAddress);
        console.log("DEPLOY GASUSED: ", receipt["receipt"]["gasUsed"]);
        await metaMockLogicTest(Mock, metaAddr, this.factory.address);
    });

    it("DESTROY TEMPLATE CONTRACT EXPECT SUCCEED", async function(){
        let receipt = await this.factory.destroy(this.mockTempSDAddress);
        expectTxSuccess(receipt);
        let tempSDCSize = await this.utils.getCodeSize(this.mockTempSDAddress);
        expect(tempSDCSize.toNumber()).to.equal(0);
        console.log("DESTROY GASUSED: ", receipt["receipt"]["gasUsed"]);
    });
*/
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
        console.log("SETFACTORY GASUSED: ", receipt["receipt"]["gasUsed"]);
    });

    it("LOCK UPGRADES FOR PROXY EXPECT SUCCESS", async function(){
        //lock the proxy
        let receipt = await this.proxyMock.lock();
        expectTxSuccess(receipt);
        console.log("LOCK UPGRADES GASUSED: ", receipt["receipt"]["gasUsed"]);
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

    it("DEPLOYCREATE2 MOCKINITIALIZABLE", async function(){

    });

    it("INITIALIZE MOCK CONTRACT", async function(){

    });

    it("CALLANY", async function(){

    });
    it("DELEGATECALLANY", async function(){

    });

    describe("MULTICALL DEPLOY PROXY", async function(){
        it("MULTICALL DEPLOYPROXY, DEPLOYCREATE, UPGRADEPROXY EXPECT SUCCESS", async function(){
            //set a new salt
            let salt = new Date();
            //use the time as the salt
            salt = salt.getTime();
            //get the utf8 bytes32 version of the salt
            let Salt = ethers.utils.formatBytes32String(salt.toString());
            let mockCon = await ethers.getContractFactory("Mock");
            //deploy code for mock with constructor args i = 2
            deployBCode = mockCon.getDeployTransaction(2);
            const MadnetFactory = await ethers.getContractFactory("MadnetFactory");
            let transactionCount = await this.provider.getTransactionCount(this.factory.address);
            //calculate the deployCreate Address
            let expectedMockLogicAddr = getCreateAddress(this.factory.address, transactionCount + 1)
            //encoded function call to deployProxy
            let deployProxy = MadnetFactory.interface.encodeFunctionData("deployProxy", [Salt]);
            //encoded function call to deployCreate
            let deployCreate = MadnetFactory.interface.encodeFunctionData("deployCreate", [deployBCode.data]);
            //encoded function call to upgradeProxy
            let upgradeProxy = MadnetFactory.interface.encodeFunctionData("upgradeProxy", [Salt, expectedMockLogicAddr]);
            let receipt = await this.factory.multiCall([deployProxy, deployCreate, upgradeProxy]);
            let mockLogicAddr = await getEventVar(receipt, deployedRawKey, contractAddrKey);
            let proxyAddr = await getEventVar(receipt, deployedProxyKey, contractAddrKey);
            expect(mockLogicAddr).to.equal(expectedMockLogicAddr);
            console.log("MULTICALL DEPLOYPROXY, DEPLOYCREATE, UPGRADEPROXY GASUSED: ", receipt["receipt"]["gasUsed"]);
            //check the proxy behaviour
            await proxyMockLogicTest(Mock, Salt, proxyAddr, mockLogicAddr, this.endPoint.address, this.factory.address);

        });

        it("MULTICALL DEPLOYPROXY, DEPLOYTEMPLATE, DEPLOYSTATIC, UPGRADEPROXY, EXPECT SUCCESS", async function(){
            //set a new salt
            let salt1 = new Date();
            //use the time as the salt
            salt1 = salt1.getTime();
            //get the utf8 bytes32 version of the salt
            //salt for proxy
            let proxySalt = ethers.utils.formatBytes32String(salt1.toString());
            let mockCon = await ethers.getContractFactory("Mock");
            let salt2 = new Date();
            salt2 = salt2.getTime();
            //salt for deployStatic
            let metaSalt = ethers.utils.formatBytes32String(salt2.toString());
            //deploy code for mock with constructor args i = 2
            deployBCode = mockCon.getDeployTransaction(2);
            let expectedMetaAddr = getMetamorphicAddress(this.factory.address, metaSalt);
            const MadnetFactory = await ethers.getContractFactory("MadnetFactory");
            //encoded function call to deployProxy
            let deployProxy = MadnetFactory.interface.encodeFunctionData("deployProxy", [proxySalt]);
            //encoded function call to deployTemplate
            let deployTemplate = MadnetFactory.interface.encodeFunctionData("deployTemplate", [deployBCode.data]);
            //encoded function call to deployStatic
            let deployStatic = MadnetFactory.interface.encodeFunctionData("deployStatic", [metaSalt, "0x"]);
            expect(proxySalt != metaSalt).to.equal(true);
            //encoded function call to upgradeProxy
            let upgradeProxy = MadnetFactory.interface.encodeFunctionData("upgradeProxy", [proxySalt, expectedMetaAddr]);
            let receipt = await this.factory.multiCall([deployProxy, deployTemplate, deployStatic, upgradeProxy]);
            //get the deployed template contract address from the event
            let tempSDAddr = await getEventVar(receipt, deployedTemplateKey, contractAddrKey);
            //get the deployed metamorphic contract address from the event
            let metaAddr = await getEventVar(receipt, deployedStaticKey, contractAddrKey);
            let proxyAddr = await getEventVar(receipt, deployedProxyKey, contractAddrKey);
            let proxyCsize = await this.utils.getCodeSize(proxyAddr);
            expect(proxyCsize.toNumber()).to.equal((Proxy.deployedBytecode.length-2)/2);
            await proxyMockLogicTest(Mock, proxySalt, proxyAddr, metaAddr, this.endPoint.address, this.factory.address);
            console.log("MULTICALL DEPLOYPROXY, DEPLOYTEMPLATE, DEPLOYSTATIC, UPGRADEPROXY GASUSED: ", receipt["receipt"]["gasUsed"]);
        });

    });

    describe("MULTICALL DEPLOY META", async function(){
        it("MULTICALL DEPLOYTEMPLATE, DEPLOYSTATIC", async function(){
            //set a new salt
            let salt = new Date();
            //use the time as the salt
            salt = salt.getTime();
            //get the utf8 bytes32 version of the salt
            let Salt = ethers.utils.formatBytes32String(salt.toString());
            //ethers instance of Mock contract abstraction
            let mockCon = await ethers.getContractFactory("Mock");
            //deploy code for mock with constructor args i = 2
            deployBCode = mockCon.getDeployTransaction(2);
            const MadnetFactory = await ethers.getContractFactory("MadnetFactory");
            //encoded function call to deployTemplate
            let deployTemplate = MadnetFactory.interface.encodeFunctionData("deployTemplate", [deployBCode.data]);
            //encoded function call to deployStatic
            let deployStatic = MadnetFactory.interface.encodeFunctionData("deployStatic", [Salt, "0x"]);
            let receipt = await this.factory.multiCall([deployTemplate, deployStatic]);
            //get the deployed template contract address from the event
            let tempSDAddr = await getEventVar(receipt, deployedTemplateKey, contractAddrKey);
            //get the deployed metamorphic contract address from the event
            let metaAddr = await getEventVar(receipt, deployedStaticKey, contractAddrKey);
            let tempCSize = await this.utils.getCodeSize.call(tempSDAddr);
            let staticCSize = await this.utils.getCodeSize.call(metaAddr);
            expect(tempCSize.toNumber()).to.be.greaterThan(0);
            expect(staticCSize.toNumber()).to.be.greaterThan(0);
            //test logic at deployed metamorphic location
            await metaMockLogicTest(Mock, metaAddr, this.factory.address);
            console.log("MULTICALL DEPLOYTEMPLATE, DEPLOYSTATIC GASUSED: ", receipt["receipt"]["gasUsed"]);
        });
        /*
        it("MULTICALL DEPLOYTEMPLATESD, DEPLOYSTATIC, DESTROY EXPECT SUCCESS", async function(){
            //set a new salt
            let salt = new Date();
            //use the time as the salt
            salt = salt.getTime();
            //get the utf8 bytes32 version of the salt
            this.mcsdSalt = ethers.utils.formatBytes32String(salt.toString());
            //ethers instance of Mock contract abstraction
            let mockSD = await ethers.getContractFactory("MockSD");
            //deploy code for mock with constructor args i = 2
            deployBCode = mockSD.getDeployTransaction(2, "0x");
            const MadnetFactory = await ethers.getContractFactory("MadnetFactory");
            //encoded function call to deployTemplate
            let transactionCount = await this.provider.getTransactionCount(this.factory.address);
            deployTemplateSDAddress = getCreateAddress(this.factory.address, transactionCount);
            let deployTemplateSD = MadnetFactory.interface.encodeFunctionData("deployTemplateWithSD", [deployBCode.data]);
            //encoded function call to deployStatic
            let deployStatic = MadnetFactory.interface.encodeFunctionData("deployStatic", [this.mcsdSalt]);
            let destroy = MadnetFactory.interface.encodeFunctionData("destroy", [deployTemplateSDAddress]);
            let receipt = await this.factory.multiCall([deployTemplateSD, deployStatic, destroy]);
            let tempSDAddr = await getEventVar(receipt, deployedTemplateKey, contractAddrKey);
            let metaAddr = await getEventVar(receipt, deployedStaticKey, contractAddrKey);
            let tempCSize = await this.utils.getCodeSize.call(tempSDAddr);
            let staticCSize = await this.utils.getCodeSize.call(metaAddr);
            expect(tempCSize.toNumber()).to.equal(0);
            expect(staticCSize.toNumber()).to.be.greaterThan(0);
            console.log("MULTICALL DEPLOYTEMPLATESD, DEPLOYSTATIC, DESTROY GASUSED: ", receipt["receipt"]["gasUsed"]);
            await metaMockLogicTest(MockSD, metaAddr, this.factory.address);
        });
        it("MULTICALL DEPLOYTEMPLATESD, DEPLOY, DESTROY", async function(){
            //set a new salt
            let salt = new Date();
            //use the time as the salt
            salt = salt.getTime();
            //get the utf8 bytes32 version of the salt
            this.mcsdddSalt = ethers.utils.formatBytes32String(salt.toString());
            //ethers instance of Mock contract abstraction
            let mockSD = await ethers.getContractFactory("MockSD");
            //deploy code for mock with constructor args i = 2
            deployBCode = mockSD.getDeployTransaction(2, "0x");
            const MadnetFactory = await ethers.getContractFactory("MadnetFactory");
            //encoded function call to deployTemplate
            let transactionCount = await this.provider.getTransactionCount(this.factory.address);
            deployTemplateSDAddress = getCreateAddress(this.factory.address, transactionCount);
            let deployTemplateSD = MadnetFactory.interface.encodeFunctionData("deployTemplateWithSD", [deployBCode.data]);

            //encoded function call to deployStatic
            let deploy = MadnetFactory.interface.encodeFunctionData("deploy", ["0x0000000000000000000000000000000000000000", this.mcsdddSalt, "0x"]);
            let destroy = MadnetFactory.interface.encodeFunctionData("destroy", [deployTemplateSDAddress]);
            let receipt = await this.factory.multiCall([deployTemplateSD, deploy, destroy]);
            let tempSDAddr = await getEventVar(receipt, deployedTemplateKey, contractAddrKey);
            //metamorphic contract address
            let metaAddr = await getEventVar(receipt, deployedKey, contractAddrKey);
            //metamorphic contract salt
            let metaSalt = await getEventVar(receipt, deployedKey, salt);
            let tempCSize = await this.utils.getCodeSize.call(tempSDAddr);
            let metaCSize = await this.utils.getCodeSize.call(metaAddr);
            expect(tempCSize.toNumber()).to.equal(0);
            expect(metaCSize.toNumber()).to.be.greaterThan(0);
            console.log("MULTICALL DEPLOYTEMPLATESD, DEPLOY, DESTROY GASUSED: ", receipt["receipt"]["gasUsed"]);
            //test the logic at the metamorphic location
            await metaMockLogicTest(MockSD, metaAddr, this.factory.address);

        });
        */
    });

    describe("FRONTEND GETTER FUNCTIONS", async function(){
        it("CONTRACTS", async function(){
            this.saltsArray = await this.factory.contracts.call();
            expect(this.saltsArray.length).to.be.greaterThan(0);
        });

        it("GETNUMCONTRACTS", async function(){
            let numContracts = await this.factory.getNumContracts.call();
            this.numContracts = numContracts.toNumber();
            expect(this.numContracts).to.equal(this.saltsArray.length);
        });
        it("LOOKUP", async function(){
            let saltStrings = bytes32ArrayToStringArray(this.saltsArray);
            for(let i = 0; i < saltStrings.length; i++){
                let address = await this.factory.lookup.call(saltStrings[i]);
                expect(address).to.equal(getMetamorphicAddress(this.factory.address, this.saltsArray[i]))
            }
        });
    });
});

async function proxyMockLogicTest(contract, salt, proxyAddress, mockLogicAddr, endPointAddr, factoryAddress){
    const factory = await MadnetFactory.at(factoryAddress)
    const mockProxy = await contract.at(proxyAddress);
    let receipt = await mockProxy.setFactory(factoryAddress);
    const testArg = 4;
    expectTxSuccess(receipt);
    let fa = await mockProxy.getFactory.call();
    expect(fa).to.equal(factoryAddress);
    receipt = await mockProxy.setv(testArg);
    expectTxSuccess(receipt);
    let v = await mockProxy.v.call();
    expect(v.toNumber()).to.equal(testArg);
    let i = await mockProxy.i.call();
    expect(i.toNumber()).to.equal(2);
    //upgrade the proxy
    receipt = await factory.upgradeProxy(salt, endPointAddr);
    expectTxSuccess(receipt);
    //endpoint interface connected to proxy address
    let proxyEndpoint = await EndPoint.at(proxyAddress);
    i = await proxyEndpoint.i.call();
    i = i.toNumber() + 2;
    receipt = await proxyEndpoint.addTwo();
    let i2p = await proxyEndpoint.i.call();
    test = await getEventVar(receipt, "addedTwo", "i")
    expect(test.toNumber()).to.equal(i);
    //lock the proxy upgrade
    receipt = await factory.upgradeProxy(salt, mockLogicAddr);
    expectTxSuccess(receipt);
    receipt = await mockProxy.setv(testArg+2);
    expectTxSuccess(receipt);
    v = await mockProxy.v.call();
    expect(v.toNumber()).to.equal(testArg+2);
    //lock the upgrade functionality
    receipt = await mockProxy.lock();
    expectTxSuccess(receipt);
    receipt = factory.upgradeProxy(salt, endPointAddr);
    expectRevert(receipt, "revert");
    //unlock the proxy
    receipt = await mockProxy.unlock();
    expectTxSuccess(receipt);
    receipt = await factory.upgradeProxy(salt, endPointAddr);
    expectTxSuccess(receipt);
    i = await proxyEndpoint.i.call();
    i = i.toNumber() + 2;
    receipt = await proxyEndpoint.addTwo();
    test = await getEventVar(receipt, "addedTwo", "i")
    expect(test.toNumber()).to.equal(i);
}

async function metaMockLogicTest(contract, address, factoryAddress){
        const Contract = await contract.at(address);
        let receipt = await Contract.setFactory(factoryAddress);
        const test = 4;
        expectTxSuccess(receipt);
        let fa = await Contract.getFactory.call();
        expect(fa).to.equal(factoryAddress);
        receipt = await Contract.setv(test);
        expectTxSuccess(receipt);
        let v = await Contract.v.call();
        expect(v.toNumber()).to.equal(test);
        let i = await Contract.i.call();
        expect(i.toNumber()).to.equal(2);
}

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
function bytes32ArrayToStringArray(bytes32Array){
    let ret = [];
    for(let i = 0; i < bytes32Array.length; i++){
        ret.push(ethers.utils.parseBytes32String(bytes32Array[i]));
    }
    return ret;
}

function getMetamorphicAddress(factoryAddress, salt ){
    let initCode = "0x6020363636335afa1536363636515af43d36363e3d36f3";
    return ethers.utils.getCreate2Address(factoryAddress, salt, ethers.utils.keccak256(initCode));
}