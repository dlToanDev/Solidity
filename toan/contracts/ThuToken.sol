pragma solidity ^0.8.28;

contract ThuToken {
    string public name = "ThuToken";
    string public symbol = "THU";
    uint8 public decimals = 18;
    uint public totalSupply;

    mapping(address => uint) public balanceOf;
    
    constructor(uint initialSupply) {
        totalSupply = initialSupply;
        balanceOf[msg.sender] = initialSupply;
    }

    function transfer(address to, uint amount) public returns (bool) {
        require(balanceOf[msg.sender] >= amount, "ko du token");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        return true;
    }
}
