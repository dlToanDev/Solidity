// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title MyToken
 * @author Your Name
 * @notice This is a simple ERC20 token with a public minting function.
 */
contract MyToken is ERC20, Ownable {
    /**
     * @notice Constructs the ERC20 token.
     * @param initialOwner The address that will initially own the contract.
     */
    constructor(address initialOwner)
        ERC20("My Token", "MTK")
        Ownable(initialOwner)
    {}

    /**
     * @notice Allows any user to mint a specified amount of tokens to a recipient.
     * @param to The address of the recipient.
     * @param amount The number of tokens to mint (in wei, the smallest unit).
     */
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}