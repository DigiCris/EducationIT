// SPDX-License-Identifier: MIT
pragma solidity >0.8.0;

contract educationITCoin {
    //c
    uint public totalSupply;
    mapping (address => uint) public balance;
    address public owner;

    //d
    constructor(){
        totalSupply = 1000000;
        owner = msg.sender;
        balance[msg.sender] = 1000000;
    }

    modifier onlyOwner() {
        require(owner==msg.sender,"usted no es el owner");
        _;
    }

    function transfer(address _to, uint amount) public onlyOwner{
        balance[msg.sender] = balance[msg.sender] - amount;
        balance[_to] = balance[_to] + amount;
    }

}