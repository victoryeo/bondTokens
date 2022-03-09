const { expect } = require("chai");
import { ethers, waffle } from 'hardhat';
import { Contract, ContractFactory, Wallet } from "ethers";
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';


describe("bond maker", function () {
  let deployedBondMaker: Contract;
  let deployedBondTokenFactory: Contract;
  let wallet: SignerWithAddress;

  beforeEach(async () => {
    let contractInst:ContractFactory;
    [wallet] = await ethers.getSigners();
    contractInst = await ethers.getContractFactory("BondTokenFactory");
    deployedBondTokenFactory = await contractInst.deploy();
    await deployedBondTokenFactory.deployed();

    contractInst = await ethers.getContractFactory("BondMaker");
    deployedBondMaker = await contractInst.deploy(18, deployedBondTokenFactory.address);
    await deployedBondMaker.deployed();
  });

  describe("register new bond", async () => {
    it("emits new bond event", async () => {
      const newBond = await deployedBondMaker.registerNewBond(
        "Test", 
        "Test", 
        1000,
        1,
        2,
        5, //maturity
        0
      );
      await expect(newBond)
        .to.emit(deployedBondMaker, "LogRegisterNewBond")
    });

    it("event contains maturity argument", async () => {
      const newBond = await deployedBondMaker.registerNewBond(
        "Test", 
        "Test", 
        1000,
        1,
        2,
        9, //maturity
        0
      );
      const receipt = await newBond.wait()

      for (const event of receipt.events) {
        if (event.event !== undefined) {
          console.log(`Event ${event.event} with args ${event.args}`);
          expect(event.args[2]).to.deep.include({"_hex":"0x09"})
        }
      }
    });
  });
})
