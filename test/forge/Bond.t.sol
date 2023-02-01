// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
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

    bytes32 bondId = 0x7465737400000000000000000000000000000000000000000000000000000000;

    function setUp() public override {
       super.setUp();
    }
        
    function testRegisterBond() public {
      // only check the maturity
      vm.expectEmit(false,false,true,false); 
      emit LogRegisterNewBond(bondId,address(0), 10);
      bondMaker.registerNewBond("Testname","Testsymbol",100,1,4,
        10/*maturity*/,0);
    }
}
