// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

// Minimal ERC20 interface
interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);
    function balanceOf(address) external view returns (uint256);
}

contract TokenSale {
    address public owner;
    IERC20 public token;
    uint256 public rate = 1000; // 1 ETH = 1000 token
    uint256 public constant FEE_PERCENT = 5; // 5%

    event Bought(address buyer, uint256 ethAmount, uint256 tokensSent, uint256 feeTokens);

    constructor(IERC20 _token) {
        owner = msg.sender;
        token = _token;
    }

    function buyTokens() external payable {
        require(msg.value > 0, "Send ETH");

        uint256 tokensGross = msg.value * rate; // rate tokens per 1 ETH
        uint256 fee = (tokensGross * FEE_PERCENT) / 100;
        uint256 tokensToBuyer = tokensGross - fee;

        require(token.balanceOf(address(this)) >= tokensGross, "Not enough tokens in contract");

        // Gửi token cho người mua
        require(token.transfer(msg.sender, tokensToBuyer), "Transfer failed");
        // Gửi 5% fee token cho owner
        require(token.transfer(owner, fee), "Fee transfer failed");

        emit Bought(msg.sender, msg.value, tokensToBuyer, fee);
    }

    function withdrawETH() external {
        require(msg.sender == owner, "Only owner");
        payable(owner).transfer(address(this).balance);
    }
}
