// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./BondTokenInterface.sol";
import "./BondMakerInterface.sol";
import "./BondTokenFactory.sol";

import "hardhat/console.sol";

contract BondMaker is BondMakerInterface {
    BondTokenFactory internal immutable BOND_TOKEN_FACTORY;
    uint8 internal immutable DECIMALS_OF_BOND;

    struct BondInfo {
        uint256 faceValue;
        uint8 interval;
        uint8 coupon;
        uint256 maturity;
        BondTokenInterface contractInstance;
        uint8 bondType;
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
      uint256 faceValue,     // FV of bond tokens
      uint8 interval,        // semi annual; 2 is one year, 4 is two year, etc
      uint8 coupon,          // percent
      uint256 maturity,      // years
      uint8 bondType         // 0: vanilla or 1: option bond
    ) public override returns (bytes32, address) {
        bytes32 bondID = generateBondID(maturity);
        
        BondTokenInterface bondTokenContract = _createNewBondToken(
            bondType,
            name,
            symbol,
            maturity
        );
        
        _bonds[bondID] = BondInfo({ 
          faceValue: faceValue, 
          interval: interval,
          coupon: coupon,
          maturity: maturity, 
          contractInstance: bondTokenContract,
          bondType: bondType
        });

        emit LogRegisterNewBond(bondID, address(bondTokenContract), maturity);

        return (bondID, address(bondTokenContract));
    }

    function issueNewBonds(
        bytes32 bondID,
        uint256 bondAmount      // issue amount of bond tokens
    ) external override {
        require(bondAmount != 0, "the minting amount must be non-zero");
        BondTokenInterface bondTokenContract = _bonds[bondID].contractInstance;

        // update bond maturity to solidity time unit
        _updateBondMaturity(bondTokenContract);
        _mintBond(bondTokenContract, msg.sender, bondAmount);
        
        emit LogIssueNewBonds(bondID, msg.sender, bondAmount);
    }

    function transferBond( 
        bytes32 bondID,       
        address toAccount,
        uint256 amount
    ) external {
        console.log('transferBond');
        console.log(msg.sender);
        require(amount > 0, "the transfer amount must be greater than zero");
        BondTokenInterface bondTokenContract = _bonds[bondID].contractInstance;
        _transferBond(bondTokenContract, msg.sender, toAccount, amount);
    }

    function burnBond( 
        bytes32 bondID,       
        address account,
        uint256 amount
    ) external {
        console.log('burnBond');
        console.log(msg.sender);
        require(amount > 0, "the burn amount must be greater than zero");
        BondTokenInterface bondTokenContract = _bonds[bondID].contractInstance;
        _burnBond(bondTokenContract, account, amount);
    }

    function getBondTokenBalance(bytes32 bondID, address account) external view 
        returns (uint256) {
      BondTokenInterface bondTokenContract = _bonds[bondID].contractInstance;
      return bondTokenContract.balanceOf(account);
    }

    function getBondTokenInstance(bytes32 bondID) external view returns (BondTokenInterface) {
      console.log("getBondTokenInstance");
      return _bonds[bondID].contractInstance;
    }

    function _createNewBondToken(
      uint8 bondType,
      string calldata name, 
      string calldata symbol, 
      uint256 maturity)
        internal
        returns (BondTokenInterface) {
        address bondAddress = BOND_TOKEN_FACTORY.createBondToken(
            bondType,
            name,
            symbol,
            DECIMALS_OF_BOND,
            maturity
        );
        return BondTokenInterface(bondAddress);
    }

    function _burnBond(
        BondTokenInterface bondTokenContract,
        address account,
        uint256 amount
    ) internal {
        require(
            bondTokenContract.simpleBurn(account, amount),
            "failed to burn bond token"
        );
    }

    function _transferBond(
        BondTokenInterface bondTokenContract,
        address fromAccount,
        address toAccount,
        uint256 amount
    ) internal {
        require(
            bondTokenContract.transferFrom(fromAccount, toAccount, amount),
            "failed to transfer bond token"
        );
    }

    function _updateBondMaturity(BondTokenInterface bondTokenContract) internal {
      bondTokenContract.updateBondMaturity();
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