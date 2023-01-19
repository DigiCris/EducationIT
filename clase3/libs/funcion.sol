// SPDX-License-Identifier: MIT
pragma solidity >0.7.0 <=0.9.0;

import "./lib.sol";

contract suma {

    using operaciones for uint256;

    function sumar(uint256 _a, uint256 _b, uint256 _c) external pure returns(uint256) {
        uint256 resultado;
        //resultado = _a.add(_b,_c);
        resultado = _a.add(_c);
        return (resultado);
    }

}