// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./BondTokenInterface.sol";

import "hardhat/console.sol";

contract BondToken is Ownable, BondTokenInterface, ERC20 {
    struct Frac128x128 {
        uint128 numerator;
        uint128 denominator;
    }

    Frac128x128 internal _rate;
    uint8 _decimals;
    uint256 _maturity;

    constructor(
        string memory name,
        string memory symbol,
        uint8 decimals,
        uint256 maturity
    ) ERC20(name, symbol) {
      _decimals = decimals;
      _maturity = maturity;
    }

    function updateBondMaturity() public override onlyOwner {
      _maturity = block.timestamp + _maturity * 52 weeks;
    }

    function mint(address account, uint256 amount)
        public
        virtual
        override
        onlyOwner
        returns (bool success)
    {
        require(!_isExpired(), "this bond token contract has expired");
        _mint(account, amount);

        // after minting, add the allowance
        _approve(
            account,
            msg.sender,
            amount
        );

        return true;
    }

    function transfer(address recipient, uint256 amount)
        public
        override(ERC20, IERC20)
        returns (bool success)
    {
        console.log("transfer");
        console.log(msg.sender);
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override(ERC20, IERC20) returns (bool success) {
        console.log("transferFrom");
        console.log(msg.sender);

        uint256 currentAllowance = allowance(sender, msg.sender);
        console.log(currentAllowance);

        _transfer(sender, recipient, amount);

        // after transfer, reduce the allowance
        _approve(
            sender,
            msg.sender,
            currentAllowance - amount
        );

        currentAllowance = allowance(sender, msg.sender);
        console.log(currentAllowance);

        return true;
    }

    /**
     * @dev Record the settlement price at maturity in the form of a fraction and let the bond
     * token expire.
     */
    function expire(uint128 rateNumerator, uint128 rateDenominator)
        public
        override
        onlyOwner
        returns (bool isFirstTime)
    {
        isFirstTime = !_isExpired();
        if (isFirstTime) {
            _setRate(Frac128x128(rateNumerator, rateDenominator));
        }

        emit LogExpire(rateNumerator, rateDenominator, isFirstTime);
    }

    function simpleBurn(address from, uint256 amount) public override onlyOwner returns (bool) {
        if (amount > balanceOf(from)) {
            return false;
        }

        _burn(from, amount);
        return true;
    }

    function burn(uint256 amount) public override returns (bool success) {
        if (!_isExpired()) {
            return false;
        }

        _burn(msg.sender, amount);

        return true;
    }

    function burnAll() public override returns (uint256 amount) {
        amount = balanceOf(msg.sender);
        bool success = burn(amount);
        if (!success) {
            amount = 0;
        }
    }

    /**
     * @dev Use block.timestamp to get the current time
     */
    function _isExpired() internal view returns (bool) {
        console.log("_isExpired");
        console.log(block.timestamp);
        console.log(_maturity);
        return !(block.timestamp < _maturity);
    }

    function getRate()
        public
        override
        view
        returns (uint128 rateNumerator, uint128 rateDenominator)
    {
        rateNumerator = _rate.numerator;
        rateDenominator = _rate.denominator;
    }

    function _setRate(Frac128x128 memory rate) internal {
        require(
            rate.denominator != 0,
            "system error: the exchange rate must be non-negative number"
        );
        _rate = rate;
    }

}
