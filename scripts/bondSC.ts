import Web3 from 'web3';

import HDWalletProvider from '@truffle/hdwallet-provider'
import * as dotenv from "dotenv";
import { TransactionReceipt } from "web3-core"

dotenv.config();

const { mnemonic, api_key } = require('../.secret.json');

const rinkeby_RPC = `https://eth-rinkeby.alchemyapi.io/v2/${api_key}`

const provider = new HDWalletProvider(mnemonic, rinkeby_RPC);
  
const web3 = new Web3(provider);

const BondTokenFactory = require("../artifacts/contracts/BondTokenFactory.sol/BondTokenFactory.json");

const BondMaker = require("../artifacts/contracts/BondMaker.sol/BondMaker.json");

// contract address
const testFactoryAddress = process.env.FACTORY_CONTRACT_ADDRESS;
console.log(testFactoryAddress)
const testMakerAddress = process.env.MAKER_CONTRACT_ADDRESS;
console.log(testMakerAddress)

let contInst = new web3.eth.Contract(
  BondTokenFactory.abi, testFactoryAddress
)

async function bondSC(baseURI:string) {
  let accounts: string[] = await web3.eth.getAccounts()
  console.log(accounts[0])
  
  //get latest nonce
  const nonce: number = await web3.eth.getTransactionCount(accounts[0], "latest")
  console.log(`nonce ${nonce}`)

  try {

    const sendOption = {
      from: accounts[0],
    };

    {
      let transactionResult: TransactionReceipt;  

    }
  
  } catch (err) {
    console.log(err)
  }
}

const comArgs = process.argv.slice(2)
console.log('Args: ', comArgs)
console.log(process.argv[2])

bondSC(process.argv[2])