// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./BondToken.sol";

contract BondTokenFactory {

    function createBondToken(
        string calldata name,
        string calldata symbol,
        uint8 decimals,
        uint256 maturity
    ) external returns (address createdBondAddress) {
       
        BondToken bond = new BondToken(
            name,
            symbol,
            decimals,
            maturity
        );
        bond.transferOwnership(msg.sender);
        return address(bond);
    }
}
