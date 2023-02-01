// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {BondTokenFactory} from "../../contracts/BondTokenFactory.sol";
import {BondMaker} from "../../contracts/BondMaker.sol";

contract TestSetup is Test {
    BondTokenFactory internal bondTokenFactory;
    BondMaker internal bondMaker;

    function setUp() public virtual{
        bondTokenFactory = new BondTokenFactory();
        bondMaker = new BondMaker(18, bondTokenFactory);
    }
}

contract BondTest is TestSetup {
    event LogRegisterNewBond(
        bytes32 indexed bondID,
        address indexed bondTokenAddress,
        uint256 indexed maturity
    );

    event LogIssueNewBonds(
        bytes32 indexed bondID,
        address indexed issuer,
        uint256 amount
    );

    // can obtain the bond id from 
    // forge test -vvvv
    bytes32 bondId = 0xff4172fa271937340825c79e87b121467861836a4645de0bbec56ff53ffddfae;

    address internal owner = address(0x1);

    function setUp() public override {
       super.setUp();
    }
        
    function testRegisterBond() public {
      // only check the maturity
      vm.expectEmit(false,false,true,false); 
      emit LogRegisterNewBond(bondId, owner, 10);
      bondMaker.registerNewBond("Testname","Testsymbol",100,1,4,
        10/*maturity*/,0);
    }

    function testIssueBond() public {
      bondMaker.registerNewBond("Testname","Testsymbol",100,1,4,10,0);
      // only check amount
      vm.expectEmit(true,false,false,true);
      emit LogIssueNewBonds(bondId, owner, 1000);
      console.logBytes32((bondId));
      bondMaker.issueNewBonds(bondId, 1000);
    }
}
