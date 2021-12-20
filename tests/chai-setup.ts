import chai from "chai";
import chaiAsPromised from "chai-as-promised"
import { solidity } from 'ethereum-waffle'
import { chaiEthers } from "chai-ethers";
chai.use(solidity)
chai.use(chaiEthers)
chai.use(chaiAsPromised)
export = chai;
