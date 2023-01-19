// SPDX-License-Identifier: MIT
pragma solidity >0.7.0 <=0.9.0;

library operaciones {

	//sobrecarga de funciones

    function add(uint256 a, uint256 b) public pure returns (uint256){
        return a + b ;
    }

    function add(uint16 a, uint256 b) public pure returns (uint256){
        return a * b ;
    }

    function add(uint256 a, uint256 b, uint256 c) public pure returns (uint256){
        return a + b + c ;
    }

}