//SPDX-License-Identifier:MIT
pragma solidity >=0.7.0 <0.9.0;

contract alice{
    
    mapping (address=>uint256) public balance;

    constructor() payable {}

    function deposit() external payable{
        balance[msg.sender]+=msg.value;
    }

    function retrieve() external {
        uint256 _balance = balance[msg.sender];
        require(_balance > 0,"No tienes suficiente para retirar");
        (bool sent, ) = msg.sender.call{value: _balance}("");
        require(sent, "Failed to send Ether");
        balance[msg.sender] = 0;
    }

}