
// SPDX-License-Identifier: MIT
pragma solidity 0.8.1;

//compra, venta, transferencia

contract ticket {

    address private owner;

    mapping (address => uint8) entradas;

    constructor() payable {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner==msg.sender,"no eres owner, hacker!");
        _;
    }

    function retirar() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    function compra() external payable {
        // que acá comprueben el precio de la entrada
        entradas[msg.sender] += 1; 
    }

    function transferir(address _to) external {
        entradas[msg.sender] -= 1; 
        entradas[_to] += 1; 
    }

    // vender entrada

// pruebe en programa.

}
