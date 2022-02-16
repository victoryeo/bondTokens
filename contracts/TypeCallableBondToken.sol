// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./BondToken.sol";

contract TypeCallableBondToken is BondToken {

    uint256 internal immutable CALL_PROTECTION;
    uint256 internal immutable CALL_PRICE;

    constructor(
        string memory name,
        string memory symbol,
        uint8 decimals,
        uint256 maturity,
        uint256 callprotection,
        uint8 callprice
    ) BondToken(name, symbol, decimals, maturity) {
        CALL_PROTECTION = callprotection;
        CALL_PRICE = callprice;
    }
}