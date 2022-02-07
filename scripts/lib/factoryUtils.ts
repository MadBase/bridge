import fs from "fs";

export interface FactoryData{
    name: string| any;
    address: string|any;
}

export interface TemplateData {
    name: string;
    address: string;
    factoryName?: string;
    factoryAddress?: string;
    constructorArgs?: string;
}

export interface FactoryConfig {
    [key: string]: any
}
export interface ProxyData {
    logicName: string;
    logicAddress: string;
    salt: string;
    proxyAddress: string;
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
        config.Factories.push(config.defaultFactoryData);
    }
    config.defaultFactoryData = {
        name: name,
        address: address
    };
    await writeFactoryConfig(config);
}

export async function updateTemplateList(data: TemplateData) {
    //fetch whats in the factory config file 
    let config = await getFactoryConfigData();
    //Add the proxy Data to the proxies array 
    config.Proxies.push(data);
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
    //Add the proxy Data to the proxies array 
    config.Proxies.push(data);
    // write new data to config file
    await writeFactoryConfig(config);
}


