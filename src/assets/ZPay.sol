// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ZPay is ERC20, ERC20Permit, Ownable {
    constructor(address initialOwner)
        ERC20("ZToken", "ZT")
        ERC20Permit("ZToken")
        Ownable(initialOwner)
    {
        _mint(msg.sender, 1000 * 10**decimals());
    }

    function mint(uint256 add) public onlyOwner {
        _mint(msg.sender, add * 10**decimals());
    }
}
