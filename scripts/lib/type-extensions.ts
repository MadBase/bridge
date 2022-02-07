import "hardhat/types/config";
import "hardhat/types/runtime";
import { defaultFactoryField } from "./hardhatRuntimeEnvFields";
import "./madnetFactoryTasks"

type FactoryField = {
    name:string;
    address:string;
}

declare module "hardhat/types/config" {
    export interface HardhatUserConfig {
        defaultFactory?:FactoryField;
    }
    export interface HardhatConfig {
        defaultFactory:FactoryField;
    }
}

declare module "hardhat/types/runtime"{
    export interface HardhatRuntimeEnvironment {
        defaultFactory: defaultFactoryField
    }
}

