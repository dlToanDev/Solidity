// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract TokenSale {
    address public owner;
    IERC20 public token;
    uint256 public rate = 1000;
    uint256 public constant FEE_PERCENT = 5;

    event Bought(address buyer, uint256 ethAmount, uint256 tokenSent, uint256 feeTokens);

    constructor(IERC20 _token) {
        owner = msg.sender;
        token = _token;
    }

    function buyTokens() external payable {
        require(msg.value > 0, "gui THU");

        uint256 tokenGross = msg.value * rate;
        uint256 fee = (tokenGross * FEE_PERCENT) / 100;
        uint256 tokensToBuyer = tokenGross - fee;

        require(token.balanceOf(address(this)) >= tokenGross, "ko du THU de gui");

        require(token.transfer(msg.sender, tokensToBuyer), "that bai");
        require(token.transfer(owner, fee), "that bai gui fee");

        emit Bought(msg.sender, msg.value, tokensToBuyer, fee);
    }

    function withdrawETH() external {
        require(msg.sender == owner, "chi chu so huu");
        payable(owner).transfer(address(this).balance);
    }
}
