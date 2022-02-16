// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./BondTokenInterface.sol";
import "./BondMakerInterface.sol";
import "./BondTokenFactory.sol";

contract BondMaker is BondMakerInterface {
    BondTokenFactory internal immutable BOND_TOKEN_FACTORY;
    uint8 internal immutable DECIMALS_OF_BOND;

    struct BondInfo {
        uint256 faceValue;
        uint8 interval;
        uint8 coupon;
        uint256 maturity;
        BondTokenInterface contractInstance;
    }
    mapping(bytes32 => BondInfo) internal _bonds;

    constructor(
      uint8 decimalsOfBond,
      BondTokenFactory bondTokenFactoryAddress
    ) {
        DECIMALS_OF_BOND = decimalsOfBond;
        BOND_TOKEN_FACTORY = bondTokenFactoryAddress;
    }

    function registerNewBond(
      string calldata name, 
      string calldata symbol, 
      uint256 faceValue,
      uint8 interval,
      uint8 coupon,
      uint256 maturity
    ) public override returns (bytes32, address) {
        bytes32 bondID = generateBondID(maturity);
        BondTokenInterface bondTokenContract = _createNewBondToken(
            name,
            symbol,
            maturity
        );

        _bonds[bondID] = BondInfo({ 
          faceValue: faceValue, 
          interval: interval,
          coupon: coupon,
          maturity: maturity, 
          contractInstance: bondTokenContract});

        emit LogRegisterNewBond(bondID, address(bondTokenContract), maturity);

        return (bondID, address(bondTokenContract));
    }

    function issueNewBonds(
        bytes32 bondID,
        uint256 bondAmount
    ) external override {
        require(bondAmount != 0, "the minting amount must be non-zero");
        BondTokenInterface bondTokenContract = _bonds[bondID].contractInstance;

        _mintBond(bondTokenContract, msg.sender, bondAmount);
        
        emit LogIssueNewBonds(bondID, msg.sender, bondAmount);
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

    /**
     * @dev Returns a bond ID determined by this contract address, maturity
     */
    function generateBondID(uint256 maturity)
        public
        view
        override
        returns (bytes32 bondID)
    {
        return keccak256(abi.encodePacked(address(this), maturity));
    }
}