//SPDX-License-Identifier:MIT
pragma solidity >=0.7.0 <0.9.0;

contract aliceInteligent{
    
    mapping (address=>uint256) public balance;

    constructor() payable 
    {}

    function deposit() external payable{
        balance[msg.sender]+=msg.value;
    }

    function retrieve() external {
        uint256 _balance = balance[msg.sender];
        require(_balance > 0,"No tienes suficiente para retirar");
        balance[msg.sender] = 0; // Primero el efecto, luego la interaccion. Si la interaccion falla revierte las cosas
        payable(msg.sender).transfer(_balance); // aunque lo pongamos antes del efecto falla por mandar poco gas (2300). Igual no confiarse en esto que se podría optimizar en YULs y aún ser vulnerable
    }

}