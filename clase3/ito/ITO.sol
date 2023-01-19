// SPDX-License-Identifier:MIT
pragma solidity >=0.7.0 <0.9.0;

interface myToken
{
    function balanceOf(address _address) external view returns(uint256);
    function transfer(address _to, uint256 _value) external returns (bool success);
    function decimals() external view returns (uint8);
}

abstract contract TokenSale
{ 
    // variables
    address public owner;
    uint256 public price;
    myToken myTokenContract;

    //constructor
    constructor(address _AddrContract)
    {
        owner=msg.sender;
        price=1000000000000000;
        myTokenContract=myToken(_AddrContract);
    }

    //modificadores
    modifier only_owner() virtual ;

    // funciones a implementar
    function buy(uint256 _numTokens) public virtual payable;// poder comprar tokens
    function sell(uint256 _numTokens) public virtual;// poder vender tokens
    function endSold() public virtual ;// poder finalizar la venta recibiendo el owner saldo y tokens sobrantes
    function changeOwner() public virtual ;// agregar evento para marcar este cambio
    // agregar una función para cambiar el address del token

    // eventos a emitir
    event Sold(address buyer, uint256 amount);

}