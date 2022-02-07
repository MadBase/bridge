import fs from "fs";

export interface FactoryData{
    name: string| any;
    address: string|any;
}

export interface DeployCreateData{
    name:string;
    address:string;
    factoryName:string;
    factoryAddress:string;
    constructorArgs?:any
}
export interface MetaContractData{
    metaAddress:string;
    salt: string;
    factoryName:string;
    templateName:string;
    templateAddress:string;
    factoryAddress:string;
}
export interface TemplateData {
    name: string;
    address: string;
    factoryName: string;
    factoryAddress: string;
    constructorArgs?: string;
}

export interface FactoryConfig {
    [key: string]: any
}
export interface ProxyData {
    proxyAddress: string;
    salt: string;
    factoryAddress: string;
    logicName: string;
    logicAddress: string;
    
}

export async function getFactoryConfigData() {
    //this output object allows dynamic addition of fields 
    let outputObj: FactoryConfig = {}
    let rawData = fs.readFileSync("./factoryConfig.json");
    const output = await JSON.parse(rawData.toString("utf8"));
    outputObj = output;
    return outputObj;
}

async function writeFactoryConfig(factoryConfig: FactoryConfig) {
    let jsonString = JSON.stringify(factoryConfig);
    fs.writeFileSync("./factoryConfig.json", jsonString);
}

export async function updateDefaultFactoryData(name: string, address: string) {
    let config = await getFactoryConfigData();
    if (config.defaultFactoryData !== undefined) {
        if(config.factories === undefined){
            config.factories = [];
            config.factories.push(config.defaultFactoryData);
        }else{
            config.factories.push(config.defaultFactoryData);
        }
    }
    config.defaultFactoryData = {
        name: name,
        address: address
    };
    await writeFactoryConfig(config);
}

export async function updateDeployCreateList(data:DeployCreateData) {
    //fetch whats in the factory config file 
    let config = await getFactoryConfigData();
    if(config.deployCreates === undefined){
        config.deployCreates = [];
        //Add the proxy Data to theoxies array 
        config.deployCreates.push(data);
    }else{
        config.deployCreates.push(data);
    }
    // write new data to config file
    await writeFactoryConfig(config);
}

export async function updateTemplateList(data: TemplateData) {
    //fetch whats in the factory config file 
    let config = await getFactoryConfigData();
    if(config.templates === undefined){
        
        config.templates = [];
        //Add the proxy Data to the proxies array 
        config.templates.push(data);
    }else{
        config.templates.push(data);
    }
    // write new data to config file
    await writeFactoryConfig(config);
}

/**
 * @description pulls in the factory config data and adds proxy data
 * to the proxy array 
 * @param data object that contains the proxies 
 * logic contract name, address, and proxy address
 */
export async function updateProxyList(data: ProxyData) {
    //fetch whats in the factory config file 
    let config = await getFactoryConfigData();
    if(config.proxies === undefined){
        
        config.proxies = [];
        //Add the proxy Data to the proxies array 
        config.proxies.push(data);
    }else{
        config.proxies.push(data);
    }
    // write new data to config file
    await writeFactoryConfig(config);
}

export async function updateMetaList(data: MetaContractData) {
    //fetch whats in the factory config file 
    let config = await getFactoryConfigData();
    if(config.staticContracts === undefined){
        
        config.staticContracts = [];
        //Add the proxy Data to the proxies array 
        config.staticContracts.push(data);
    }else{
        config.staticContracts.push(data);
    }
    // write new data to config file
    await writeFactoryConfig(config);
}
