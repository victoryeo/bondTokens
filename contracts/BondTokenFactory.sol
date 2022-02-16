// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./BondToken.sol";
import "./TypeCallableBondToken.sol";
import "./TypeVanillaBondToken.sol";

contract BondTokenFactory {

    function createBondToken(
        uint8 bondType,
        string calldata name,
        string calldata symbol,
        uint8 decimals,
        uint256 maturity
    ) external returns (address createdBondAddress) {
        if (bondType == 0) {
          BondToken bond = new TypeVanillaBondToken(
              name,
              symbol,
              decimals,
              maturity
          );
          bond.transferOwnership(msg.sender);
          return address(bond);
        } else {
          BondToken bond = new TypeCallableBondToken(
              name,
              symbol,
              decimals,
              maturity,
              0,
              0
          );
          bond.transferOwnership(msg.sender);
          return address(bond);
        }
    }
}
