//SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    // Este es un ejemplo para agregarle una descripcion al token
    string public description;
    constructor(string memory name, string memory symbol, string memory _description) ERC20(name, symbol) {
        // name y symbol pasan directamente al constructor de ERC20 de openzeppelin, _description lo inicializo acá
        description=_description;
        // Le creo 1000 unidades del token a quien instancia el contrato
        _mint(msg.sender, 2000 ether);
    }
}