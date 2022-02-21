
//const { contracts } from"@openzeppelin/cli/lib/prompts/choices");
import { expectRevert} from'@openzeppelin/test-helpers';
import { expect } from"chai";
import {ethers, artifacts, contract} from"hardhat";
import { upgradeProxy, deployStatic, deployUpgradeable } from "../../scripts/lib/MadnetFactory";
import { getDefaultFactoryAddress } from"../../scripts/lib/factoryStateUtils";

let ownerAccount:string;
let delegatorAccount:string;
let accounts:Array<string> = [];
let utilsContract:any
let factory:any
const MOCK_INITIALIZABLE = "MockInitializable";
const LOGIC_ADDR = "LogicAddress";
const PROXY_ADDR = "ProxyAddress"
const META_ADDR = "MetaAddress"
const TEMPLATE_ADDR = "TemplateAddress"
const END_POINT = "endPoint"
const DEPLOYED_STATIC = "DeployedStatic";
const DEPLOYED_PROXY = "DeployedProxy";
const DEPLOYED_RAW = "DeployedRaw";
const DEPLOYED_TEMPLATE = "DeployedTemplate";
const CONTRACT_ADDR = "contractAddr";
const MADNET_FACTORY = "MadnetFactory";
const MOCK = "Mock";
const RECEIPT= "receipt";
let madnetFactoryBase = artifacts.require(MADNET_FACTORY);
let proxyBase = artifacts.require(PROXY_ADDR);
let endPointBase = artifacts.require(END_POINT);
let mockBase = artifacts.require(MOCK);
let mockInitBase = artifacts.require(MOCK_INITIALIZABLE);
let mockFactoryBase = artifacts.require("MockFactory");
let utilsBase = artifacts.require("utils");
contract("MadnetFactory", () => {
    let firstOwner = accounts[0];
    let secondOwner = accounts[1];
    let firstDelegator = accounts[2];
    let secondDelegator = accounts[3];
    let unprivilegedAddress = accounts[4];
    describe("ENDPOINT", () => {
        it("DEPLOY ENDPOINT", async () => {
            let endPoint = await endPointBase.new(factory.address);
            let size = await utilsContract.getCodeSize(endPoint.address)
            expect(size.toNumber()).to.be.greaterThan(0);
        });

        it("DEPLOY MOCK", async () => {
            let mock = await mockBase.new(2);
            let size = await utilsContract.getCodeSize(mock)
            expect(size.toNumber()).to.be.greaterThan(0);
        });
    });

    describe("MOCK", () => {
        it("DEPLOY ENDPOINT", async () => {
            let endPoint = await endPointBase.new(factory.address);
            let size = await utilsContract.getCodeSize(endPoint.address)
            expect(size.toNumber()).to.be.greaterThan(0);
        });
    });
    describe("MADNETFACTORY", () => {
        before(async () => {
            
            //set owner and delegator
            ownerAccount = accounts[0];
            delegatorAccount = accounts[1];
            
            
            //get a instance of a ethereum provider
            //this.provider = new ethers.providers.JsonRpcProvider();
            utilsContract = await utilsBase.new();
            factory = await deployFactory(MADNET_FACTORY);
        });

        it("DEPLOY FACTORY", async () => {
            let accounts = await getAccounts();
            ownerAccount = accounts[0];
            factory = await deployFactory(MADNET_FACTORY);
            let cSize = await utilsContract.getCodeSize(factory.address);
            expect(cSize.toNumber()).to.be.greaterThan(0);
        });
        
        it("SETOWNER", async () => {
            //sets the second account as owner 
            let receipt = await factory.setOwner(accounts[1], {from: ownerAccount});
            ownerAccount = accounts[1];
            expect(await factory.owner.call()).to.equal(ownerAccount);
            await factory.setOwner(accounts[0], {from: accounts[1]})
            ownerAccount = accounts[0]; 
            expect(await factory.owner.call()).to.equal(ownerAccount);
        });
    
        it("SETDELEGATOR", async () => {
            //sets the second account as delegator 
            await factory.setDelegator(accounts[1], {from: firstDelegator});
            expect(await factory.delegator()).to.equal(delegatorAccount);
            await expectRevert(
                factory.setOwner(accounts[0], {from: delegatorAccount}),
                "unauthorized"
            );
        });
    
        it("GET OWNER, DELEGATOR", async () => {
            let owner = await factory.owner.call();
            expect(owner).to.equal(ownerAccount);
            let delegator = await factory.delegator.call();
            expect(delegator).to.equal(delegatorAccount);
        });
    
        it("DEPLOY MOCK WITH DEPLOYTEMPLATE AS OWNER EXPECT SUCCEED", async () => {
            //ethers instance of Mock contract abstraction
            let mockCon = await ethers.getContractFactory("Mock");
            //deploy code for mock with constructor args i = 2
            let deployTx = mockCon.getDeployTransaction(2);
            //deploy the mock Contract to deployTemplate
            let transactionCount = await ethers.provider.getTransactionCount(factory.address)
            let expectedMockTempAddress = getCreateAddress(factory.address, transactionCount);
            let receipt = await factory.deployTemplate(deployTx.data);
            expectTxSuccess(receipt);
            this.mockTempAddress = await getEventVar(receipt, DEPLOYED_TEMPLATE, CONTRACT_ADDR);
            expect(this.mockTempAddress).to.equal(expectedMockTempAddress)
            console.log("DEPLOYTEMPLATE GASUSED: ", receipt["receipt"]["gasUsed"]);
        });
    
        it("DEPLOY MOCK CONTRACT WITH DEPLOY STATIC AS OWNER EXPECT SUCCEED", async () => {
            let Salt = getSalt();
            let expectedMetaAddress = getMetamorphicAddress(factory.address, Salt);
            let receipt = await factory.deployStatic(Salt, "0x");
            expectTxSuccess(receipt);
            let metaAddr = await getEventVar(receipt, DEPLOYED_STATIC, CONTRACT_ADDR);
            expect(metaAddr).to.equal(expectedMetaAddress);
            console.log("DEPLOYSTATIC GASUSED: ", receipt["receipt"]["gasUsed"]);
            metaMockLogicTest(mockBase, metaAddr, factory.address);
        });
    
        it("DEPLOYSTATIC MOCK INITIALIZABLE CONTRACT", async () => {
            //deploy a template of the mock Initializable 
            let byteCode = await getDeployTemplateArgs(MOCK_INITIALIZABLE);
            let receipt = await factory.deployTemplate(byteCode);
            let deployStatic = await getDeployStaticArgs(MOCK_INITIALIZABLE, [2])
            receipt = await factory.deployStatic(deployStatic.Salt, deployStatic.initCallData);
            let mockInitAddr = getEventVar(receipt, DEPLOYED_STATIC, CONTRACT_ADDR);
            checkMockInit(mockInitAddr, 2);
        });
        
        it("DEPLOYPROXY EXPECT SUCCESS", async () => {
            //set a new salt 
            let salt = new Date();
            //use the time as the salt 
            salt = salt.getTime();
            //get the utf8 bytes32 version of the salt 
            this.proxySalt = ethers.utils.formatBytes32String(salt.toString());
            //the calculated proxy address 
            const expectedProxyAddr = getMetamorphicAddress(factory.address, this.proxySalt) 
            //deploy the proxy through the factory 
            let receipt = await factory.deployProxy(this.proxySalt);
            //check if transaction succeeds 
            expectTxSuccess(receipt);
            //get the deployed proxy contract address fom the DeployedProxy event 
            let proxyAddr = await getEventVar(receipt, DEPLOYED_PROXY, CONTRACT_ADDR);
            //check if the deployed contract address match the calculated address 
            expect(proxyAddr).to.equal(expectedProxyAddr);
            this.proxyAddr = proxyAddr;
            console.log("DEPLOYPROXY GASUSED: ", receipt["receipt"]["gasUsed"]);
        });
    
        it("DEPLOY PROXY WITH UNAUTH ACC EXPECT FAIL", async () => {
            await expectRevert(
                factory.deployProxy(this.proxySalt, {from: delegatorAccount}), 
                "unauthorized"
                );
        });
    
        it("COMPARE DEPLOYED PROXY CODE SIZE WITH COMPILED PROXY RUNTIME CODE SIZE", async () => {
            let cSize = await utilsContract.getCodeSize.call(this.proxyAddr)
            expect(cSize.toNumber()).to.equal((proxyBase.deployedBytecode.length-2)/2);
        });
    
        it("DEPLOYCREATE MOCK LOGIC CONTRACT EXPECT SUCCESS", async () => {
            //use the ethers Mock contract abstraction to generate the deploy transaction data 
            let mockCon = await ethers.getContractFactory("Mock");
            //get the init code with contructor args appended
            deployBCode = mockCon.getDeployTransaction(2);
            let transactionCount = await ethers.provider.getTransactionCount(factory.address)
            //deploy Mock Logic through the factory
            // 27fe1822
            let receipt = await factory.deployCreate(deployBCode.data);
            //check if the transaction is mined or failed 
            expectTxSuccess(receipt);
            let dcMockAddress = getEventVar(receipt, DEPLOYED_RAW, CONTRACT_ADDR);
            //calculate the deployed address 
            let expectedMockAddr = ethers.utils.getContractAddress({
                from: factory.address,
                nonce: transactionCount
            });
            expect(dcMockAddress).to.equal(expectedMockAddr);
            this.dcMockAddress = dcMockAddress;
            console.log("DEPLOYCREATE MOCK LOGIC GASUSED: ", receipt["receipt"]["gasUsed"]);
        });
        it("DEPLOYCREATE MOCK LOGIC CONTRACT W/ UNAUTH ACC EXPECT FAIL", async () => {
            //use the ethers Mock contract abstraction to generate the deploy transaction data 
            let mockCon = await ethers.getContractFactory("Mock");
            //get the init code with contructor args appended
            deployBCode = mockCon.getDeployTransaction(2);
            //deploy Mock Logic through the factory
            // 27fe1822
            let receipt = factory.deployCreate(deployBCode.data, {from: delegatorAccount});
            await expectRevert(receipt, "unauthorized") 
        });
        it("UPGRADE PROXY TO POINT TO DCMOCKADDRESS W FACTORY EXPECT SUCCESS", async () => {
           //Upgrade the proxy to the new implementation 
            //func sig 0a008a5d
            let receipt = await factory.upgradeProxy(this.proxySalt, this.dcMockAddress);
            expectTxSuccess(receipt);
            console.log("UPGRADE PROXY GASUSED: ", receipt["receipt"]["gasUsed"]);
        });
    
        it("UPGRADE PROXY TO POINT TO DCMOCKADDRESS W FACTORY USING UNAUTH ACC EXPECT FAIL", async () => {
            let receipt = factory.upgradeProxy(this.proxySalt, this.dcMockAddress, {from: delegatorAccount});
            await expectRevert(receipt, "unauthorized")
        });
    
        it("CALL SETFACTORY IN MOCK THROUGH PROXY EXPECT SUCCESS", async () => {
            //connect a Mock interface to the proxy contract 
            this.proxyMock = await mockBase.at(this.proxyAddr);
            let receipt = await this.proxyMock.setFactory(accounts[0]);
            expectTxSuccess(receipt);
            let mockFactory = await this.proxyMock.getFactory.call();
            expect(mockFactory).to.equal(accounts[0]); 
            console.log("SETFACTORY GASUSED: ", receipt["receipt"]["gasUsed"]);
        });
    
        it("LOCK UPGRADES FOR PROXY EXPECT SUCCESS", async () => {
            //lock the proxy
            let receipt = await this.proxyMock.lock();
            expectTxSuccess(receipt);
            console.log("LOCK UPGRADES GASUSED: ", receipt["receipt"]["gasUsed"]);
        });
    
        it("UPGRADE LOCKED PROXY EXPECT FAIL", async () => {
            let receipt = factory.upgradeProxy(this.proxySalt, this.endPoint.address);
            expectRevert(receipt, "revert");
        });
    
        it("UNLOCK PROXY EXPECT SUCCESS ", async () => {
            let receipt = await this.proxyMock.unlock();
            expectTxSuccess(receipt);
        });
    
        it("UPGRADE UNLOCKED PROXY EXPECT SUCCESS", async () => {
            let receipt = await factory.upgradeProxy(this.proxySalt, this.endPoint.address);
            expectTxSuccess(receipt);
        });
    
        //fail on bad code 
        it("DEPLOYCREATE WITH BAD CODE EXPECT FAIL", async () => {
            let receipt = factory.deployCreate("0x6000", {from: ownerAccount});
            await expectRevert(receipt, "csize0");
        });
        
        //fail on unauthorized with bad code 
        it("DEPLOYCREATE WITH BAD CODE, UNAUTHORIZED ACCOUNT EXPECT FAIL ", async () => {
            let receipt =  factory.deployCreate("0x6000", {from: accounts[2]});
            await expectRevert(receipt, "unauthorized")  
        });
    
        //fail on unauthorized with good code 
        it("DEPLOYCREATE WITH VALID CODE, UNAUTHORIZED ACCOUNT EXPECT FAIL", async () => {
            const receipt = factory.deployCreate(endPointBase.bytecode, {from: accounts[2]});
            await expectRevert(receipt, "unauthorized")     
        });
    
        it("DEPLOYCREATE2 MOCKINITIALIZABLE", async () => {
            let receiptObj = await deployCreate2Initable(factory);
            let receipt = receiptObj[RECEIPT];
            expectTxSuccess(receipt);
            let mockInitAddr = await getEventVar(receipt, DEPLOYED_RAW, CONTRACT_ADDR);
            expect(mockInitAddr).to.not.be.undefined;
            this.mockInitAddr = mockInitAddr;
        });
    
        it("INITIALIZE MOCK CONTRACT", async () => {
            let mockInitable = await ethers.getContractFactory(MOCK_INITIALIZABLE);
            let initCallData = await mockInitable.interface.encodeFunctionData("initialize", [2]);
            let receipt = await factory.initializeContract(this.mockInitAddr, initCallData);
            expectTxSuccess(receipt);
            await checkMockInit(this.mockInitAddr, 2);
        });
    
        it("CALLANY", async () => {
            let receiptObj = await deployCreate2Initable(factory);
            let receipt = receiptObj[RECEIPT];
            expectTxSuccess(receipt);
            let mockInitAddr = await getEventVar(receipt, DEPLOYED_RAW, CONTRACT_ADDR);
            expect(mockInitAddr).to.not.be.undefined;
            // call data to initialize mockInitializable
            let mockInitable = await ethers.getContractFactory(MOCK_INITIALIZABLE);
            let initCallData = await mockInitable.interface.encodeFunctionData("initialize", [2]);
            receipt = await factory.callAny(mockInitAddr, 0, initCallData);
            await checkMockInit(mockInitAddr, 2)
        });
        it("DELEGATECALLANY", async () => {
            //deploy an instance of mock logic for factory 
            let mockFactoryInstance = await mockFactoryBase.new();
            //generate the call data for the factory instance 
            let mfEncode = await ethers.getContractFactory("MockFactory");
            let setOwner = await mfEncode.interface.encodeFunctionData("setOwner", [accounts[2]]);
            //delegate call into the factory and change the owner
            let receipt = await factory.delegateCallAny(mockFactoryInstance.address, setOwner);
            expectTxSuccess(receipt);
            let owner = await factory.owner.call();
            expect(owner).to.equal(accounts[2]);
            setOwner = await mfEncode.interface.encodeFunctionData("setOwner", [accounts[0]]);
            receipt = await factory.delegateCallAny(mockFactoryInstance.address, setOwner, {from: accounts[2]});
            expectTxSuccess(receipt);
            owner = await factory.owner.call();
            expect(owner).to.equal(accounts[0]); 
        });
        describe("MULTICALL DEPLOY PROXY", async () => {
            it("MULTICALL DEPLOYPROXY, DEPLOYCREATE, UPGRADEPROXY EXPECT SUCCESS", async () => {
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
                let transactionCount = await ethers.provider.getTransactionCount(factory.address);
                //calculate the deployCreate Address 
                let expectedMockLogicAddr = getCreateAddress(factory.address, transactionCount + 1)
                //encoded function call to deployProxy
                let deployProxy = MadnetFactory.interface.encodeFunctionData("deployProxy", [Salt]);
                //encoded function call to deployCreate 
                let deployCreate = MadnetFactory.interface.encodeFunctionData("deployCreate", [deployBCode.data]);
                //encoded function call to upgradeProxy
                let upgradeProxy = MadnetFactory.interface.encodeFunctionData("upgradeProxy", [Salt, expectedMockLogicAddr]);
                let receipt = await factory.multiCall([deployProxy, deployCreate, upgradeProxy]);
                let mockLogicAddr = await getEventVar(receipt, DEPLOYED_RAW, CONTRACT_ADDR);
                let proxyAddr = await getEventVar(receipt, DEPLOYED_PROXY, CONTRACT_ADDR);
                expect(mockLogicAddr).to.equal(expectedMockLogicAddr);
                console.log("MULTICALL DEPLOYPROXY, DEPLOYCREATE, UPGRADEPROXY GASUSED: ", receipt["receipt"]["gasUsed"]);
                //check the proxy behaviour 
                await proxyMockLogicTest(mockBase, Salt, proxyAddr, mockLogicAddr, this.endPoint.address, factory.address);
                
            });
        
            it("MULTICALL DEPLOYPROXY, DEPLOYTEMPLATE, DEPLOYSTATIC, UPGRADEPROXY, EXPECT SUCCESS", async () => {
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
                let expectedMetaAddr = getMetamorphicAddress(factory.address, metaSalt);
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
                let receipt = await factory.multiCall([deployProxy, deployTemplate, deployStatic, upgradeProxy]);
                //get the deployed template contract address from the event 
                let tempSDAddr = await getEventVar(receipt, DEPLOYED_TEMPLATE, CONTRACT_ADDR);
                //get the deployed metamorphic contract address from the event 
                let metaAddr = await getEventVar(receipt, DEPLOYED_STATIC, CONTRACT_ADDR);
                let proxyAddr = await getEventVar(receipt, DEPLOYED_PROXY, CONTRACT_ADDR);
                let proxyCsize = await utilsContract.getCodeSize(proxyAddr);
                expect(proxyCsize.toNumber()).to.equal((proxyBase.deployedBytecode.length-2)/2);
                await proxyMockLogicTest(mockBase, proxySalt, proxyAddr, metaAddr, this.endPoint.address, factory.address);
                console.log("MULTICALL DEPLOYPROXY, DEPLOYTEMPLATE, DEPLOYSTATIC, UPGRADEPROXY GASUSED: ", receipt["receipt"]["gasUsed"]);
            });
            
        });
    
        describe("MULTICALL DEPLOY META", async () => {
            it("MULTICALL DEPLOYTEMPLATE, DEPLOYSTATIC", async () => {
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
                let receipt = await factory.multiCall([deployTemplate, deployStatic]);
                //get the deployed template contract address from the event 
                let tempSDAddr = await getEventVar(receipt, DEPLOYED_TEMPLATE, CONTRACT_ADDR);
                //get the deployed metamorphic contract address from the event 
                let metaAddr = await getEventVar(receipt, DEPLOYED_STATIC, CONTRACT_ADDR);
                let tempCSize = await utilsContract.getCodeSize.call(tempSDAddr);
                let staticCSize = await utilsContract.getCodeSize.call(metaAddr);
                expect(tempCSize.toNumber()).to.be.greaterThan(0);
                expect(staticCSize.toNumber()).to.be.greaterThan(0);
                //test logic at deployed metamorphic location 
                await metaMockLogicTest(mockBase, metaAddr, factory.address);
                console.log("MULTICALL DEPLOYTEMPLATE, DEPLOYSTATIC GASUSED: ", receipt["receipt"]["gasUsed"]);
            });
            /*
            it("MULTICALL DEPLOYTEMPLATESD, DEPLOYSTATIC, DESTROY EXPECT SUCCESS", async () => {
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
                let transactionCount = await ethers.provider.getTransactionCount(factory.address);
                deployTemplateSDAddress = getCreateAddress(factory.address, transactionCount);
                let deployTemplateSD = MadnetFactory.interface.encodeFunctionData("deployTemplateWithSD", [deployBCode.data]);
                //encoded function call to deployStatic
                let deployStatic = MadnetFactory.interface.encodeFunctionData("deployStatic", [this.mcsdSalt]);
                let destroy = MadnetFactory.interface.encodeFunctionData("destroy", [deployTemplateSDAddress]);
                let receipt = await factory.multiCall([deployTemplateSD, deployStatic, destroy]);
                let tempSDAddr = await getEventVar(receipt, deployedTemplateKey, contractAddrKey);
                let metaAddr = await getEventVar(receipt, deployedStaticKey, contractAddrKey);
                let tempCSize = await utilsContract.getCodeSize.call(tempSDAddr);
                let staticCSize = await utilsContract.getCodeSize.call(metaAddr);
                expect(tempCSize.toNumber()).to.equal(0);
                expect(staticCSize.toNumber()).to.be.greaterThan(0);
                console.log("MULTICALL DEPLOYTEMPLATESD, DEPLOYSTATIC, DESTROY GASUSED: ", receipt["receipt"]["gasUsed"]);
                await metaMockLogicTest(MockSD, metaAddr, factory.address);
            });
            it("MULTICALL DEPLOYTEMPLATESD, DEPLOY, DESTROY", async () => {
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
                let transactionCount = await ethers.provider.getTransactionCount(factory.address);
                deployTemplateSDAddress = getCreateAddress(factory.address, transactionCount);
                let deployTemplateSD = MadnetFactory.interface.encodeFunctionData("deployTemplateWithSD", [deployBCode.data]);
    
                //encoded function call to deployStatic
                let deploy = MadnetFactory.interface.encodeFunctionData("deploy", ["0x0000000000000000000000000000000000000000", this.mcsdddSalt, "0x"]);
                let destroy = MadnetFactory.interface.encodeFunctionData("destroy", [deployTemplateSDAddress]);
                let receipt = await factory.multiCall([deployTemplateSD, deploy, destroy]);
                let tempSDAddr = await getEventVar(receipt, deployedTemplateKey, contractAddrKey);
                //metamorphic contract address
                let metaAddr = await getEventVar(receipt, deployedKey, contractAddrKey);
                //metamorphic contract salt
                let metaSalt = await getEventVar(receipt, deployedKey, salt);
                let tempCSize = await utilsContract.getCodeSize.call(tempSDAddr);
                let metaCSize = await utilsContract.getCodeSize.call(metaAddr);
                expect(tempCSize.toNumber()).to.equal(0);
                expect(metaCSize.toNumber()).to.be.greaterThan(0);
                console.log("MULTICALL DEPLOYTEMPLATESD, DEPLOY, DESTROY GASUSED: ", receipt["receipt"]["gasUsed"]);
                //test the logic at the metamorphic location 
                await metaMockLogicTest(MockSD, metaAddr, factory.address);
        
            });
            */
        });

        describe("FRONTEND GETTER FUNCTIONS", async () => {
            it("IMPLEMENTATION", async () => {
                let implAddr = await factory.implementation.call();
                expect(implAddr).to.not.be.undefined;
            });
            
            it("CONTRACTS", async () => {
                this.saltsArray = await factory.contracts.call();
                expect(this.saltsArray.length).to.be.greaterThan(0);
            });
        
            it("GETNUMCONTRACTS", async () => {
                let numContracts = await factory.getNumContracts.call();
                this.numContracts = numContracts.toNumber();
                expect(this.numContracts).to.equal(this.saltsArray.length);
            });
            it("LOOKUP", async () => {
                let saltStrings = bytes32ArrayToStringArray(this.saltsArray);
                for(let i = 0; i < saltStrings.length; i++){
                    let address = await factory.lookup.call(saltStrings[i]);
                    expect(address).to.equal(getMetamorphicAddress(factory.address, this.saltsArray[i]))
                }
            });
        });
    });
    
    describe("CLI TASKS", async () => {
        before(async () => {
            accounts = await getAccounts();
            //set owner and delegator
            ownerAccount = accounts[0];
            delegatorAccount = accounts[1];
            utilsBase = await artifacts.require("utils");
            //get a instance of a ethereum provider
            //this.provider = new ethers.providers.JsonRpcProvider();            
            utilsContract = await utilsBase.new();            
        });        
        it("DEPLOY FACTORY WITH CLI", async () => {                   
            let futureFactoryAddress = await predictFactoryAddress(ownerAccount)            
            let factoryAddress = await hre.run("deployFactory", {factoryName: MADNET_FACTORY});
            //check if the address is the predicted             
            expect(factoryAddress).to.equal(futureFactoryAddress);            
            let config = await getDefaultFactoryAddress();
            expect(config.defaultFactoryData.address).to.equal(factoryAddress);
        });

        it("DEPLOY UPGRADEABLE PROXY", async () => {
            let receipt = await hre.run("deployUpgradeableProxy", {contractName: MOCK, constructorArgs: ['2', 'peep']})
            console.log("pData: ", receipt);
        });
        it("DEPLOY MOCK WITH DEPLOYSTATIC", async () => {
            await hre.run("deployMetamorphic", {contractName: "endPoint", constructorArgs: ['0x92D3A65c5890a5623F3d73Bf3a30c973043eE90C']});
        });
        
    });

    describe("MADNETFACTORY API TEST", async () => {
        before(async () => {
            accounts = await getAccounts();
            //set owner and delegator
            ownerAccount = accounts[0];
            delegatorAccount = accounts[1];
            proxyBase = await artifacts.require("Proxy");
            endPointBase = await artifacts.require("endPoint");
            madnetFactoryBase = await artifacts.require("MadnetFactory");
            mockBase = await artifacts.require("Mock");
            MockSD = await artifacts.require("MockSD");
            mockInitBase = await artifacts.require("MockInitializable");
            mockFactoryBase = await artifacts.require("MockFactory");
            utilsBase = await artifacts.require("utils");
            //get a instance of a ethereum provider
            //this.provider = new ethers.providers.JsonRpcProvider();
            utilsContract = await utilsBase.new();
            factory = await deployFactory(MADNET_FACTORY);
        });

        it("DEPLOYUPGRADEABLE", async () => {
            let res = await deployUpgradeable("Mock", factory.address, [2]);
            let cSize = await utilsContract.getCodeSize(res.logicAddress)
            expect(cSize.toNumber()).to.be.greaterThan(0);
            cSize = await utilsContract.getCodeSize(res.proxyAddress)
            expect(cSize.toNumber()).to.be.greaterThan(0);
        });
    
        it("UPGRADEDEPLOYMENT", async () => {
            let res = await upgradeProxy(MADNET_FACTORY, factory.address);
            let logicSize = await utilsContract.getCodeSize(res.logicAddress)
            expect(logicSize.toNumber()).to.be.greaterThan(0);
        });
    
        it("DEPLOYSTATIC", async () => {
            let res = await deployStatic(END_POINT, factory.address);
            let cSize = await utilsContract.getCodeSize(res.templateAddress)
            expect(cSize.toNumber()).to.be.greaterThan(0);
            cSize = await utilsContract.getCodeSize(res.metaAddress)
            expect(cSize.toNumber()).to.be.greaterThan(0);
        });
    });
});

async function getAccounts(){
    let signers = await ethers.getSigners();  
    let accounts = [];
    for (let signer of signers){
        accounts.push(signer.address)
    }
    return accounts;
  }

async function predictFactoryAddress(ownerAddress){
    let txCount = await ethers.provider.getTransactionCount(ownerAddress);
    console.log(txCount)
    let futureFactoryAddress = ethers.utils.getContractAddress({
        from: ownerAddress,
        nonce: txCount
      });
    return futureFactoryAddress;
}

async function proxyMockLogicTest(contract, salt, proxyAddress, mockLogicAddr, endPointAddr, factoryAddress){
    const factory = await madnetFactoryBase.at(factoryAddress)
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
    let proxyEndpoint = await endPointBase.at(proxyAddress);
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

function getSalt(){
     //set a new salt 
     let salt = new Date();
     //use the time as the salt 
     salt = salt.getTime();
     return ethers.utils.formatBytes32String(salt.toString());
}

async function getDeployTemplateArgs(contractName){
     let contract = await ethers.getContractFactory(contractName);
     deployByteCode = contract.getDeployTransaction();
     return deployByteCode.data;
}

async function getDeployStaticArgs(contractName, argsArray){
    let ret = new Object();
    ret.Salt = getSalt();
    let contract = await ethers.getContractFactory(contractName);
    //get the function call to initialize the deployed contract 
    ret.initCallData = contract.interface.encodeFunctionData("initialize", argsArray);
    return ret;
}

async function checkMockInit(target, initVal){
    let mock = await mockInitBase.at(target);
    let i = await mock.i.call();
    expect(i.toNumber()).to.equal(initVal);
}
async function deployFactory(factoryName){
    let factoryInstance = await artifacts.require(factoryName);
    //gets the initial transaction count for the address 
    let transactionCount = await ethers.provider.getTransactionCount(ownerAccount);
    //pre calculate the address of the factory contract 
    let futureFactoryAddress = ethers.utils.getContractAddress({
        from: ownerAccount,
        nonce: transactionCount
    });
    //deploy the factory with its address as a constructor input
    let factory = await factoryInstance.new(futureFactoryAddress);
    expect(factory.address).to.equal(futureFactoryAddress);
    return factory;
}

async function deployCreate2Initable(factory){
     //set a new salt 
     let salt = new Date();
     //use the time as the salt 
     salt = salt.getTime();
     let ret = {};
     //get the utf8 bytes32 version of the salt 
     ret["Salt"] = ethers.utils.formatBytes32String(salt.toString());
     ret["receipt"] = await factory.deployCreate2(0, ret["Salt"], mockInitBase.bytecode);
     return ret;
}

function getMetamorphicAddress(factoryAddress, salt ){
    let initCode = "0x6020363636335afa1536363636515af43d36363e3d36f3";
    return ethers.utils.getCreate2Address(factoryAddress, salt, ethers.utils.keccak256(initCode));
}