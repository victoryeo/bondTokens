// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./BondToken.sol";

contract TypeVanillaBondToken is BondToken {

    constructor(
        string memory name,
        string memory symbol,
        uint8 decimals,
        uint256 maturity
    ) BondToken(name, symbol, decimals, maturity) {

    }
}