// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract helloWorld {
    
    uint256 private variable;

    function setVariable(uint256 _variable) public {
        variable = _variable;
    }

    function getVariable() public view returns(uint256) {
        return (variable);
    }

}

contract goodByeWorld {
    
    uint256 private variable;

    function setVariable(uint256 _variable) public {
        variable = _variable + 1;
    }

    function getVariable() public view returns(uint256) {
        return (variable);
    }

}
