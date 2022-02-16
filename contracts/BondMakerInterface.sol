// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./BondTokenInterface.sol";

interface BondMakerInterface {
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

    function registerNewBond(
        string calldata name, 
        string calldata symbol,
        uint256 faceValue,
        uint8 interval,
        uint8 coupon, 
        uint256 maturity
    ) external
      returns (
            bytes32 bondID,
            address bondTokenAddress
        );

    function issueNewBonds(
        bytes32 bondID,
        uint256 bondAmount
    ) external;

    function generateBondID(uint256 maturity)
        external
        view
      returns (bytes32 bondID);
}