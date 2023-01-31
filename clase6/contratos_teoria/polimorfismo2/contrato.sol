// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract padre {
    string hola="soy el padre";
    function quienSoy() public view virtual  returns(string memory) {
        return(hola);
    }
}

contract madre {
    string hola2="soy la madre";
    function quienSoy() public view virtual returns(string memory) {
        return(hola2);
    }
}

contract hijo is padre, madre {
    string hola3="soy la Hijo";
    
    function quienSoy() public view override(madre, padre) returns (string memory) {
        //return(hola3);
        return super.quienSoy();
    }

}