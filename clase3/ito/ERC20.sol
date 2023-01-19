// SPDX-License-Identifier: MIT
pragma solidity >0.7.0 <=0.9.0;

import "./abstractERC20.sol";

contract MyToken is ERC20 {


    constructor(string memory _name,string memory _symbol, uint8 _decimals, uint256 _totalSupply) ERC20(_name,_symbol, _decimals)
    {
        totalSupply=_totalSupply;
        balanceOf[msg.sender]=_totalSupply * (10 ** decimals);
    }

    function transfer(address _to, uint256 _value) public override  returns (bool success){

    }

    function transferFrom(address _from, address _to, uint256 _value) public override  returns (bool success){

    }

    function approve(address _spender, uint256 _value) public override  returns (bool success){

    }

}