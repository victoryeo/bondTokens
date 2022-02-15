// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./BondTokenInterface.sol";
import "./BondMakerInterface.sol";
import "./BondTokenFactory.sol";

contract BondMaker is BondMakerInterface {
    BondTokenFactory internal immutable BOND_TOKEN_FACTORY;
    uint8 internal immutable DECIMALS_OF_BOND;

    constructor(
      uint8 decimalsOfBond,
      BondTokenFactory bondTokenFactoryAddress
    ) {
        DECIMALS_OF_BOND = decimalsOfBond;
        BOND_TOKEN_FACTORY = bondTokenFactoryAddress;
    }

    function registerNewBond(string calldata name, string calldata symbol, uint256 maturity) public override returns (bytes32, address) {
        bytes32 bondID = "0x0001";
        BondTokenInterface bondTokenContract = _createNewBondToken(
            name,
            symbol,
            maturity
        );
        return (bondID, address(bondTokenContract));
    }

    function issueNewBonds(
        BondTokenInterface bondTokenContract,
        uint256 bondIDs,
        uint256 bondAmount
    ) external override {
        require(bondAmount != 0, "the minting amount must be non-zero");
        
        _mintBond(bondTokenContract, msg.sender, bondAmount);
        
        emit LogIssueNewBonds(bondIDs, msg.sender, bondAmount);
    }

    function _createNewBondToken(string calldata name, string calldata symbol, uint256 maturity)
        internal
        returns (BondTokenInterface) {
        address bondAddress = BOND_TOKEN_FACTORY.createBondToken(
            name,
            symbol,
            DECIMALS_OF_BOND,
            maturity
        );
        return BondTokenInterface(bondAddress);
    }

    function _mintBond(
        BondTokenInterface bondTokenContract,
        address account,
        uint256 amount
    ) internal {
        require(
            bondTokenContract.mint(account, amount),
            "failed to mint bond token"
        );
    }
}