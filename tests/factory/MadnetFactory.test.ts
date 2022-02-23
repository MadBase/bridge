
//const { contracts } from"@openzeppelin/cli/lib/prompts/choices");
import { expectRevert} from'@openzeppelin/test-helpers';
import { expect } from"chai";
import {ethers, artifacts, contract, run} from"hardhat";
import { upgradeProxy, deployStatic, deployUpgradeable } from "../../scripts/lib/MadnetFactory";
import { FactoryConfig, FactoryData, getDefaultFactoryAddress } from"../../scripts/lib/factoryStateUtils";
import { ContractFactory } from 'ethers';



let firstOwner:string;
let secondOwner:string;
let firstDelegator:string;
let secondDelegator:string;
let unprivilegedAddress
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
const PROXY = "Proxy";
let madnetFactoryBase = artifacts.require(MADNET_FACTORY);
let proxyBase = artifacts.require(PROXY);
let endPointBase = artifacts.require(END_POINT);
let mockBase = artifacts.require(MOCK);
let mockInitBase = artifacts.require(MOCK_INITIALIZABLE);
let mockFactoryBase = artifacts.require("MockFactory");
let utilsBase = artifacts.require("utils");
    
    describe("MADNETFACTORY", () => {
        before(async () => {
            accounts = await getAccounts()
            firstOwner = accounts[0];
            secondOwner = accounts[1];
            firstDelegator = accounts[2];
            secondDelegator = accounts[3];
            unprivilegedAddress = accounts[4]; 
            //get a instance of a ethereum provider
            //this.provider = new ethers.providers.JsonRpcProvider();
            utilsContract = await utilsBase.new();
            factory = await deployFactory(MADNET_FACTORY);
            let cSize = await utilsContract.getCodeSize(factory.address);
            expect(cSize.toNumber()).to.be.greaterThan(0);
        });

        it("DEPLOY MOCK", async () => {
            let mock = await mockBase.new(2, "s");
            let size = await utilsContract.getCodeSize(mock.address)
            expect(size.toNumber()).to.be.greaterThan(0);
        });
        it("DEPLOY ENDPOINT", async () => {
            let endPoint = await endPointBase.new(factory.address);
            let size = await utilsContract.getCodeSize(endPoint.address)
            expect(size.toNumber()).to.be.greaterThan(0);
        });

        it("SETOWNER", async () => {
            //sets the second account as owner 
            let receipt = await factory.setOwner(accounts[1], {from: firstOwner});
            firstOwner = accounts[1];
            expect(await factory.owner.call()).to.equal(firstOwner);
            await factory.setOwner(accounts[0], {from: accounts[1]})
            firstOwner = accounts[0]; 
            expect(await factory.owner.call()).to.equal(firstOwner);
        });
    
        it("SETDELEGATOR", async () => {
            //sets the second account as delegator 
            await factory.setDelegator(firstDelegator, {from: firstOwner});
            expect(await factory.delegator()).to.equal(firstDelegator);
            await expectRevert(
                factory.setOwner(accounts[0], {from: firstDelegator}),
                "unauthorized"
            );
        });
    
        it("GET OWNER, DELEGATOR", async () => {
            let owner = await factory.owner.call();
            expect(owner).to.equal(firstOwner);
            let delegator = await factory.delegator.call();
            expect(delegator).to.equal(firstDelegator);
        });
    
        it("DEPLOY MOCK WITH DEPLOYTEMPLATE AS OWNER EXPECT SUCCEED", async () => {
            //ethers instance of Mock contract abstraction
            let mockCon = await ethers.getContractFactory("Mock");
            //deploy code for mock with constructor args i = 2
            let deployTx = mockCon.getDeployTransaction(2, "s");
            //deploy the mock Contract to deployTemplate
            let transactionCount = await ethers.provider.getTransactionCount(factory.address)
            let expectedMockTempAddress = getCreateAddress(factory.address, transactionCount);
            let receipt = await factory.deployTemplate(deployTx.data);
            expectTxSuccess(receipt);
            let mockTempAddress = await getEventVar(receipt, DEPLOYED_TEMPLATE, CONTRACT_ADDR);
            expect(mockTempAddress).to.equal(expectedMockTempAddress)
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
            receipt = await factory.deployStatic(deployStatic.salt, deployStatic.initCallData);
            let mockInitAddr = getEventVar(receipt, DEPLOYED_STATIC, CONTRACT_ADDR);
            checkMockInit(mockInitAddr, 2);
        });
        
        it("DEPLOYPROXY EXPECT SUCCESS", async () => {
            let proxySalt = getSalt();
            //the calculated proxy address 
            const expectedProxyAddr = getMetamorphicAddress(factory.address, proxySalt) 
            //deploy the proxy through the factory 
            let receipt = await factory.deployProxy(proxySalt);
            //check if transaction succeeds 
            expectTxSuccess(receipt);
            //get the deployed proxy contract address fom the DeployedProxy event 
            let proxyAddr = await getEventVar(receipt, DEPLOYED_PROXY, CONTRACT_ADDR);
            //check if the deployed contract address match the calculated address 
            expect(proxyAddr).to.equal(expectedProxyAddr);
            console.log("DEPLOYPROXY GASUSED: ", receipt["receipt"]["gasUsed"]);
            let cSize = await utilsContract.getCodeSize.call(proxyAddr)
            expect(cSize.toNumber()).to.equal((proxyBase.deployedBytecode.length-2)/2);
        });
    
        it("DEPLOY PROXY WITH UNAUTH ACC EXPECT FAIL", async () => {
            let Salt = getSalt();
            await expectRevert(
                factory.deployProxy(Salt, {from: firstDelegator}), 
                "unauthorized"
                );
        });
    
        it("DEPLOYCREATE MOCK LOGIC CONTRACT EXPECT SUCCESS", async () => {
            //use the ethers Mock contract abstraction to generate the deploy transaction data 
            let mockCon:ContractFactory = await ethers.getContractFactory("Mock");
            //get the init code with contructor args appended
            let deployTx = mockCon.getDeployTransaction(2, "s");
            let transactionCount = await ethers.provider.getTransactionCount(factory.address)
            //deploy Mock Logic through the factory
            // 27fe1822
            let receipt = await factory.deployCreate(deployTx.data);
            //check if the transaction is mined or failed 
            expectTxSuccess(receipt);
            let dcMockAddress = getEventVar(receipt, DEPLOYED_RAW, CONTRACT_ADDR);
            //calculate the deployed address 
            let expectedMockAddr = ethers.utils.getContractAddress({
                from: factory.address,
                nonce: transactionCount
            });
            expect(dcMockAddress).to.equal(expectedMockAddr);
            console.log("DEPLOYCREATE MOCK LOGIC GASUSED: ", receipt["receipt"]["gasUsed"]);
        });
        it("DEPLOYCREATE MOCK LOGIC CONTRACT W/ UNAUTH ACC EXPECT FAIL", async () => {
            //use the ethers Mock contract abstraction to generate the deploy transaction data 
            let mockCon = await ethers.getContractFactory("Mock");
            //get the init code with contructor args appended
            let deployTx = mockCon.getDeployTransaction(2, "s");
            //deploy Mock Logic through the factory
            // 27fe1822
            let receipt = factory.deployCreate(deployTx.data, {from: firstDelegator});
            await expectRevert(receipt, "unauthorized") 
        });
        it("UPGRADE PROXY TO POINT TO MOCKADDRESS W FACTORY EXPECT SUCCESS", async () => { 
            let proxySalt = getSalt();
            let txResponse = await factory.deployProxy(proxySalt);
            expectTxSuccess(txResponse);
            let mockContract = await mockBase.new(2, "s");
            txResponse = await factory.upgradeProxy(proxySalt, mockContract.address, "0x");
            expectTxSuccess(txResponse);
            console.log("UPGRADE PROXY GASUSED: ", txResponse["receipt"]["gasUsed"]);
            txResponse = factory.upgradeProxy(proxySalt, mockContract.address, "0x", {from: firstDelegator});
            await expectRevert(txResponse, "unauthorized")
        });
    
        it("CALL SETFACTORY IN MOCK THROUGH PROXY EXPECT SUCCESS", async () => {
            let endPoint = await endPointBase.new(factory.address);
            let mockContract = await mockBase.new(2, "s");
            let proxySalt = getSalt();
            let txResponse = await factory.deployProxy(proxySalt);
            let proxyAddr = await getEventVar(txResponse, "DeployedProxy", "contractAddr");
            txResponse = await factory.upgradeProxy(proxySalt, mockContract.address, "0x");
            expectTxSuccess(txResponse);
            //connect a Mock interface to the proxy contract 
            let proxyMock = await mockBase.at(proxyAddr);
            txResponse = await proxyMock.setFactory(accounts[0]);
            expectTxSuccess(txResponse);
            let mockFactoryAddress = await proxyMock.getFactory.call();
            expect(mockFactoryAddress).to.equal(accounts[0]); 
            console.log("SETFACTORY GASUSED: ", txResponse["receipt"]["gasUsed"]);
            //lock the proxy
            txResponse = await proxyMock.lock();
            expectTxSuccess(txResponse);
            console.log("LOCK UPGRADES GASUSED: ", txResponse["receipt"]["gasUsed"]);
            txResponse = factory.upgradeProxy(proxySalt, endPoint.address, "0x");
            expectRevert(txResponse, "revert");
            txResponse = await proxyMock.unlock();
            expectTxSuccess(txResponse);
            txResponse = await factory.upgradeProxy(proxySalt, endPoint.address, "0x");
            expectTxSuccess(txResponse);
        });
    
        //fail on bad code 
        it("DEPLOYCREATE WITH BAD CODE EXPECT FAIL", async () => {
            let receipt = factory.deployCreate("0x6000", {from: firstOwner});
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
            let mockInitable = await ethers.getContractFactory(MOCK_INITIALIZABLE);
            let initCallData = await mockInitable.interface.encodeFunctionData("initialize", [2]);
            let txResponse = await factory.initializeContract(mockInitAddr, initCallData);
            expectTxSuccess(txResponse);
            await checkMockInit(mockInitAddr, 2);
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
                let Salt = getSalt();
                let mockCon = await ethers.getContractFactory("Mock");
                let endPoint = await endPointBase.new(factory.address);
                //deploy code for mock with constructor args i = 2
                let deployTX = mockCon.getDeployTransaction(2, "s");
                const MadnetFactory = await ethers.getContractFactory("MadnetFactory");
                let transactionCount = await ethers.provider.getTransactionCount(factory.address);
                //calculate the deployCreate Address 
                let expectedMockLogicAddr = getCreateAddress(factory.address, transactionCount + 1)
                //encoded function call to deployProxy
                let deployProxy = MadnetFactory.interface.encodeFunctionData("deployProxy", [Salt]);
                //encoded function call to deployCreate 
                let deployCreate = MadnetFactory.interface.encodeFunctionData("deployCreate", [deployTX.data]);
                //encoded function call to upgradeProxy
                let upgradeProxy = MadnetFactory.interface.encodeFunctionData("upgradeProxy", [Salt, expectedMockLogicAddr, "0x"]);
                let receipt = await factory.multiCall([deployProxy, deployCreate, upgradeProxy]);
                let mockLogicAddr = await getEventVar(receipt, DEPLOYED_RAW, CONTRACT_ADDR);
                let proxyAddr = await getEventVar(receipt, DEPLOYED_PROXY, CONTRACT_ADDR);
                expect(mockLogicAddr).to.equal(expectedMockLogicAddr);
                console.log("MULTICALL DEPLOYPROXY, DEPLOYCREATE, UPGRADEPROXY GASUSED: ", receipt["receipt"]["gasUsed"]);
                //check the proxy behaviour 
                await proxyMockLogicTest(mockBase, Salt, proxyAddr, mockLogicAddr, endPoint.address, factory.address);
                
            });
        
            it("MULTICALL DEPLOYPROXY, DEPLOYTEMPLATE, DEPLOYSTATIC, UPGRADEPROXY, EXPECT SUCCESS", async () => {
                let endPoint = await endPointBase.new(factory.address);
                let proxySalt = getSalt();
                let mockCon:ContractFactory = await ethers.getContractFactory("Mock");
                //salt for deployStatic
                let metaSalt = getSalt();
                //deploy code for mock with constructor args i = 2, _p = "s"
                let deployTX = mockCon.getDeployTransaction(2, "s");
                let expectedMetaAddr = getMetamorphicAddress(factory.address, metaSalt);
                const MadnetFactory = await ethers.getContractFactory("MadnetFactory");
                //encoded function call to deployProxy
                let deployProxy = MadnetFactory.interface.encodeFunctionData("deployProxy", [proxySalt]);
                //encoded function call to deployTemplate 
                let deployTemplate = MadnetFactory.interface.encodeFunctionData("deployTemplate", [deployTX.data]);
                //encoded function call to deployStatic
                let deployStatic = MadnetFactory.interface.encodeFunctionData("deployStatic", [metaSalt, "0x"]);
                expect(proxySalt != metaSalt).to.equal(true);
                //encoded function call to upgradeProxy
                let upgradeProxy = MadnetFactory.interface.encodeFunctionData("upgradeProxy", [proxySalt, expectedMetaAddr, "0x"]);
                let receipt = await factory.multiCall([deployProxy, deployTemplate, deployStatic, upgradeProxy]);
                //get the deployed template contract address from the event 
                let templateAddress = await getEventVar(receipt, DEPLOYED_TEMPLATE, CONTRACT_ADDR);
                //get the deployed metamorphic contract address from the event 
                let metaAddr = await getEventVar(receipt, DEPLOYED_STATIC, CONTRACT_ADDR);
                let proxyAddr = await getEventVar(receipt, DEPLOYED_PROXY, CONTRACT_ADDR);
                let proxyCsize = await utilsContract.getCodeSize(proxyAddr);
                expect(proxyCsize.toNumber()).to.equal((proxyBase.deployedBytecode.length-2)/2);
                await proxyMockLogicTest(mockBase, proxySalt, proxyAddr, metaAddr, endPoint.address, factory.address);
                console.log("MULTICALL DEPLOYPROXY, DEPLOYTEMPLATE, DEPLOYSTATIC, UPGRADEPROXY GASUSED: ", receipt["receipt"]["gasUsed"]);
            });
            
        });
    
        describe("MULTICALL DEPLOY META", async () => {
            it("MULTICALL DEPLOYTEMPLATE, DEPLOYSTATIC", async () => { 
                let Salt = getSalt();
                //ethers instance of Mock contract abstraction
                let mockCon = await ethers.getContractFactory("Mock");
                //deploy code for mock with constructor args i = 2
                let deployTX = mockCon.getDeployTransaction(2, "s");
                const MadnetFactory = await ethers.getContractFactory("MadnetFactory");
                //encoded function call to deployTemplate 
                let deployTemplate = MadnetFactory.interface.encodeFunctionData("deployTemplate", [deployTX.data]);
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
        });

        describe("FRONTEND GETTER FUNCTIONS", async () => {
           
            it("FRONTEND GETTERS", async () => {
                let implAddr = await factory.implementation.call();
                expect(implAddr).to.not.be.undefined;
                let saltsArray = await factory.contracts.call();
                expect(saltsArray.length).to.be.greaterThan(0);
                let numContracts = await factory.getNumContracts.call();
                expect(numContracts.toNumber()).to.equal(saltsArray.length);
                let saltStrings = bytes32ArrayToStringArray(saltsArray);
                for(let i = 0; i < saltStrings.length; i++){
                    let address = await factory.lookup.call(saltStrings[i]);
                    expect(address).to.equal(getMetamorphicAddress(factory.address, saltsArray[i]))
                }
            });
        });
    });
    
    describe("CLI TASKS", async () => {
        before(async () => {
            accounts = await getAccounts();
            //set owner and delegator
            firstOwner = accounts[0];
            firstDelegator = accounts[1];
            utilsBase = await artifacts.require("utils");
            //get a instance of a ethereum provider
            //this.provider = new ethers.providers.JsonRpcProvider();            
            utilsContract = await utilsBase.new();         
            factory = await deployFactory(MADNET_FACTORY);
            let cSize = await utilsContract.getCodeSize(factory.address);
            expect(cSize.toNumber()).to.be.greaterThan(0);   
        });        
        it("DEPLOY FACTORY WITH CLI", async () => {                   
            let futureFactoryAddress = await predictFactoryAddress(firstOwner)            
            let factoryAddress = await run("deployFactory");
            //check if the address is the predicted
            expect(factoryAddress).to.equal(futureFactoryAddress);            
            let defaultFactoryAddress = await getDefaultFactoryAddress();
            expect(defaultFactoryAddress).to.equal(factoryAddress);
        });

        it("DEPLOY UPGRADEABLE PROXY", async () => {
            let receipt = await run("deployUpgradeableProxy", {contractName: MOCK, constructorArgs: ['2', 'peep']})
            console.log("pData: ", receipt);
        });
        it("DEPLOY MOCK WITH DEPLOYSTATIC", async () => {
            await run("deployMetamorphic", {contractName: "endPoint", constructorArgs: '0x92D3A65c5890a5623F3d73Bf3a30c973043eE90C'});
        });
        
    });

    describe("MADNETFACTORY API TEST", async () => {
        before(async () => {
            accounts = await getAccounts();
            //set owner and delegator
            firstOwner = accounts[0];
            firstDelegator = accounts[1];
            utilsBase = await artifacts.require("utils");
            //get a instance of a ethereum provider
            //this.provider = new ethers.providers.JsonRpcProvider();            
            utilsContract = await utilsBase.new();
            factory = await deployFactory(MADNET_FACTORY);
            let cSize = await utilsContract.getCodeSize(factory.address);
            expect(cSize.toNumber()).to.be.greaterThan(0);
        });

        it("DEPLOYUPGRADEABLE", async () => {
            let res = await deployUpgradeable("Mock", factory.address, ["2","s"]);
            if (res === undefined){
                console.error()
            }
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


async function getAccounts(){
    let signers = await ethers.getSigners();  
    let accounts = [];
    for (let signer of signers){
        accounts.push(signer.address)
    }
    return accounts;
  }

async function predictFactoryAddress(ownerAddress:string){
    let txCount = await ethers.provider.getTransactionCount(ownerAddress);
    console.log(txCount)
    let futureFactoryAddress = ethers.utils.getContractAddress({
        from: ownerAddress,
        nonce: txCount
      });
    return futureFactoryAddress;
}

async function proxyMockLogicTest(contract:any, salt:string, proxyAddress:string, mockLogicAddr:string, endPointAddr:string, factoryAddress:string){
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
    receipt = await factory.upgradeProxy(salt, endPointAddr, "0x");
    expectTxSuccess(receipt);
    //endpoint interface connected to proxy address 
    let proxyEndpoint = await endPointBase.at(proxyAddress);
    i = await proxyEndpoint.i.call();
    i = i.toNumber() + 2;
    receipt = await proxyEndpoint.addTwo();
    let i2p = await proxyEndpoint.i.call();
    let test = await getEventVar(receipt, "addedTwo", "i")
    expect(test.toNumber()).to.equal(i);
    //lock the proxy upgrade 
    receipt = await factory.upgradeProxy(salt, mockLogicAddr, "0x");
    expectTxSuccess(receipt);
    receipt = await mockProxy.setv(testArg+2);
    expectTxSuccess(receipt);
    v = await mockProxy.v.call();
    expect(v.toNumber()).to.equal(testArg+2);
    //lock the upgrade functionality 
    receipt = await mockProxy.lock();
    expectTxSuccess(receipt);
    receipt = factory.upgradeProxy(salt, endPointAddr, "0x");
    expectRevert(receipt, "revert");
    //unlock the proxy
    receipt = await mockProxy.unlock();
    expectTxSuccess(receipt);
    receipt = await factory.upgradeProxy(salt, endPointAddr, "0x");
    expectTxSuccess(receipt);
    i = await proxyEndpoint.i.call();
    i = i.toNumber() + 2;
    receipt = await proxyEndpoint.addTwo();
    test = await getEventVar(receipt, "addedTwo", "i")
    expect(test.toNumber()).to.equal(i);
}

async function metaMockLogicTest(contract:any, address:string, factoryAddress:string){
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

function getEventVar(receipt:any, eventName:string, varName:string){
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

function expectTxSuccess(receipt:any){
    expect(receipt["receipt"]["status"]).to.equal(true);
}
function expectTxFail(receipt:any){
    expect(receipt["receipt"]["status"]).to.equal(false);
}

function getCreateAddress(Address:string, nonce:number){
    return ethers.utils.getContractAddress({
        from: Address,
        nonce: nonce
    });
}
function bytes32ArrayToStringArray(bytes32Array:Array<any>){
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
     let Salt = salt.getTime();
     return ethers.utils.formatBytes32String(Salt.toString());
}

async function getDeployTemplateArgs(contractName:string){
     let contract = await ethers.getContractFactory(contractName);
     let deployByteCode = contract.getDeployTransaction();
     return deployByteCode.data;
}

type DeployStaticArgs = {
    salt:string;
    initCallData:string;
}
async function getDeployStaticArgs(contractName:string, argsArray:Array<any>){
    let contract = await ethers.getContractFactory(contractName);
    let ret:DeployStaticArgs = {
        salt: getSalt(),
        initCallData: contract.interface.encodeFunctionData("initialize", argsArray),
    }
    return ret;
}

async function checkMockInit(target:string, initVal:number){
    let mock = await mockInitBase.at(target);
    let i = await mock.i.call();
    expect(i.toNumber()).to.equal(initVal);
}
async function deployFactory(factoryName:string){
    let factoryInstance = await artifacts.require(factoryName);
    //gets the initial transaction count for the address 
    let transactionCount = await ethers.provider.getTransactionCount(firstOwner);
    //pre calculate the address of the factory contract 
    let futureFactoryAddress = ethers.utils.getContractAddress({
        from: firstOwner,
        nonce: transactionCount
    });
    //deploy the factory with its address as a constructor input
    let factory = await factoryInstance.new(futureFactoryAddress);
    expect(factory.address).to.equal(futureFactoryAddress);
    return factory;
}


async function deployCreate2Initable(factory:any){
     //set a new salt 
     let salt = new Date();
     //use the time as the salt 
     let Salt = ethers.utils.formatBytes32String(salt.getTime().toString())  
     let ret:{
         Salt:string;
         receipt:any;
        } = {
         Salt: Salt,
         receipt: await factory.deployCreate2(0, Salt, mockInitBase.bytecode),
        };
  
     return ret;
}

function getMetamorphicAddress(factoryAddress:string, salt:string ){
    let initCode = "0x6020363636335afa1536363636515af43d36363e3d36f3";
    return ethers.utils.getCreate2Address(factoryAddress, salt, ethers.utils.keccak256(initCode));
}