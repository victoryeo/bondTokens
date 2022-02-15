// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./BondTokenInterface.sol";

interface BondMakerInterface {
    event LogIssueNewBonds(
        uint256 indexed bondGroupID,
        address indexed issuer,
        uint256 amount
    );

    function registerNewBond(
        string calldata name, 
        string calldata symbol, 
        uint256 maturity
    ) external
      returns (
            bytes32 bondID,
            address bondTokenAddress
        );

    function issueNewBonds(
        BondTokenInterface bondTokenContract,
        uint256 bondIDs,
        uint256 bondAmount
    ) external;
}