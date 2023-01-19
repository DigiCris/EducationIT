// SPDX-License-Identifier: MIT
pragma solidity >0.7.0 <=0.9.0;

abstract contract ERC20 {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor(string memory _name,string memory _symbol, uint8 _decimals)
    {
        name=_name;//_name;
        symbol=_symbol;//_symbol;
        decimals=_decimals;//_decimals;
    }

    function transfer(address _to, uint256 _value) public virtual returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public virtual returns (bool success);
    function approve(address _spender, uint256 _value) public virtual returns (bool success);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}