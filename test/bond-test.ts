const { expect } = require("chai");
import { ethers, waffle } from 'hardhat';
import { Contract, ContractFactory, Wallet } from "ethers";
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';


describe("bond maker", function () {
  let deployedBondMaker: Contract;
  let deployedBondTokenFactory: Contract;
  let wallet: SignerWithAddress;
  let customer: SignerWithAddress;

  beforeEach(async () => {
    let contractInst:ContractFactory;
    [wallet, customer] = await ethers.getSigners();
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

  describe("issue new bond", async () => {  

    it("issue bond event contains issue amount", async () => {
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

      //console.log(newBond, " ----- ", receipt )

      for (const event of receipt.events) {
        if (event.event !== undefined) {
          console.log(`Event ${event.event} with args ${event.args}`);

          const bondID = event.args[0]
          const bondAmount = 1000
          const newIssue = await deployedBondMaker.issueNewBonds(
            bondID,
            bondAmount
          )
          const receipt2 = await newIssue.wait()

          for (const event of receipt2.events) {
            if (event.event !== undefined) {
              console.log(`Event ${event.event} with args ${event.args}`);
              expect(event.args[2]).to.deep.include({"_hex":"0x03e8"})  
                                        //0x03e8 is hex value of 1000
            }
          }
        }
      }
    });
  });

  describe("transfer bond", async () => {  

    it("transfer bond to customer", async () => {
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

      //console.log(newBond, " ----- ", receipt )

      for (const event of receipt.events) {
        if (event.event !== undefined) {
          console.log(`Event ${event.event} with args ${event.args}`);

          const bondID = event.args[0]
          const bondTokenContract = event.args[1]
          const bondAmount = 1000
          const transferAmount = 100
          const newIssue = await deployedBondMaker.issueNewBonds(
            bondID,
            bondAmount
          )
          const receipt2 = await newIssue.wait()

          for (const event of receipt2.events) {
            if (event.event !== undefined) {
              console.log(`Event ${event.event} with args ${event.args}`);
            }
          }

          console.log(wallet.address)
          console.log(customer.address)
          console.log(bondTokenContract)

          const bal1 = await deployedBondMaker.getBondTokenBalance(bondID, wallet.address);
          const bal2 = await deployedBondMaker.getBondTokenBalance(bondID, customer.address);
          console.log(bal1, bal2)

          await deployedBondMaker.transferBond(bondID, customer.address, transferAmount);

          const bal3 = await deployedBondMaker.getBondTokenBalance(bondID, customer.address);
          console.log(bal3)
          expect(bal3).to.equal(transferAmount)
        }
      }
    });
  });

  describe("redeem bond", async () => {  

    it("redeem bond before maturity", async () => {
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

      //console.log(newBond, " ----- ", receipt )

      for (const event of receipt.events) {
        if (event.event !== undefined) {
          console.log(`Event ${event.event} with args ${event.args}`);

          const bondID = event.args[0]
          const bondTokenContract = event.args[1]
          const bondAmount = 1000
          const burnAmount = 100;
          const newIssue = await deployedBondMaker.issueNewBonds(
            bondID,
            bondAmount
          )
          const receipt2 = await newIssue.wait()

          // burn the bond token
          const bal1 = await deployedBondMaker.getBondTokenBalance(bondID, wallet.address);
          console.log(bal1);
          await deployedBondMaker.burnBond(bondID, wallet.address,burnAmount);
          const bal3 = await deployedBondMaker.getBondTokenBalance(bondID, wallet.address);
          console.log(bal3);
          expect(bal3).to.equal(bondAmount-burnAmount);
        }
      }
    });
  });
})
