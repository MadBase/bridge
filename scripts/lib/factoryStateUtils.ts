import { error } from "console";
import fs from "fs";
import {env} from  "./constants"
export interface FactoryData{
    name: string;
    address: string;
}

export type DeployCreateData = {
    name:string;
    address:string;
    factoryAddress:string;
    constructorArgs?:any
}
export type MetaContractData = {
    metaAddress:string;
    salt: string;
    templateName:string;
    templateAddress:string;
    factoryAddress:string;
    initCallData:string;
}
export type TemplateData = {
    name: string;
    address: string;
    factoryAddress: string;
    constructorArgs?: string;
}

export interface FactoryConfig{
    [key: string]: any
}
export type ProxyData = {
    proxyAddress: string;
    salt: string;
    logicName: string;
    logicAddress: string;
    factoryAddress: string;
    initCallData?: string;
}
//TODO: PUT THIS IN A CONFIG FILE AND IMPORT IN ALL UTILS

export async function getDefaultFactoryAddress(){
     //fetch whats in the factory config file
     let config = await readFactoryStateData();
     return config?.defaultFactoryData.address
}

export async function readFactoryStateData() {
    //this output object allows dynamic addition of fields
    let outputObj: FactoryConfig = {}
    //if there is a file or directory at that location
    if(fs.existsSync(`./deployments/${env}/factoryState.json`)){
        let rawData = fs.readFileSync(`./deployments/${env}/factoryState.json`);
        const output = await JSON.parse(rawData.toString("utf8"));
        outputObj = output;
    }
    return outputObj;
}

async function writeFactoryConfig(newFactoryConfig: FactoryConfig, lastFactoryConfig?: FactoryConfig) {
    let jsonString = JSON.stringify(newFactoryConfig);
    if(lastFactoryConfig !== undefined){
        let date = new Date();
        let timestamp = date.getMonth().toString() + "-" + date.getDate().toString() + "-" + date.getFullYear().toString() + "-" + date.getTime().toString()
        if(!fs.existsSync(`./deployments/${env}/archive`)){
            fs.mkdirSync(`./deployments/${env}/archive`)
        }
        fs.writeFileSync(`./deployments/${env}/archive/${timestamp}_factoryState.json`, jsonString);
    }
    fs.writeFileSync(`./deployments/${env}/factoryState.json`, jsonString);
}
async function getLastConfig(config: FactoryConfig){
    if (config.defaultFactoryData !== undefined && Object.keys(config.defaultFactoryData).length > 0){
        return config;
    } else{
        return undefined;
    }
}

export async function updateDefaultFactoryData(name: string, address: string) {
    let state = await readFactoryStateData();
    let lastConfig = await getLastConfig(state);
    if (state.defaultFactoryData !== undefined) {
        if(state.factories === undefined){
            state.factories = [];
            state.factories.push(state.defaultFactoryData);
        }else{
            state.factories.push(state.defaultFactoryData);
        }
    }
    state.defaultFactoryData = {
        name: name,
        address: address
    };
    await writeFactoryConfig(state, lastConfig);
}

export async function updateDeployCreateList(data:DeployCreateData) {
    //fetch whats in the factory config file
    //It is safe to use as
    let config = await readFactoryStateData();
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
    let config = await readFactoryStateData();
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
    let config = await readFactoryStateData();
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
    let config = await readFactoryStateData();
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
