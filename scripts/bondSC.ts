import Web3 from 'web3';

import HDWalletProvider from '@truffle/hdwallet-provider'
import * as dotenv from "dotenv";
import {resolve} from 'path'
import { TransactionReceipt } from "web3-core"
import util from 'util'

dotenv.config();

const { mnemonic, api_key } = require('../.secret.json');

const RPC = `https://rpc-mumbai.maticvigil.com/v1/${api_key}`;

const provider = new HDWalletProvider(mnemonic, RPC);
  
const web3 = new Web3(provider);

const bondMakerContract = require("../artifacts/contracts/BondMaker.sol/BondMaker.json");

// nft contract address
const testContAddress = process.env.CONTRACT_ADDRESS;
console.log(testContAddress)

let contInst = new web3.eth.Contract(
  bondMakerContract.abi, testContAddress
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