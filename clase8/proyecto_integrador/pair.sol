// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

/*
Este contrato contiene un par de liquidez al cual podemos aportar y nos da un liquidity token a cambio para
saber que proporcion dentro de el es nuestro.

La gente puede swapear el par de liquidez por su porción de los tokens en el pool cuando quieran, o también pueden
cambiar un token del par por el otro y así variar las tenencias en el pool agregando más de uno y sacando del otro.

Existe una comision (r) por estos swaps por lo que el pool siempre irá creciendo en cantidad y la gente que tiene
valor en él, incrementando su cantidad de tokens. A pesar de esto es importante tener en cuenta el concepto de
impermanent loss para este tipo de pooles ya que juntaremos más cantidad del token que más baje su precio.

Esta funcion creada acá es lo que correspondería al uniswapV2_pair.sol, pero más sencilla y adaptada. Para un swap de verdad también necesitaríamos la factory de los pooles y el router para ver como ir haciendo los trades, pero este contrato sería el core y con el que podríamos interactuar igualmente de forma directa.

Esto fue explicado en la clase6 y donde podrán encontrar el dibujo que hicimos durante la explicacion.

Este smart contract es a nivel orientativo y no esta 100% funcional y tiene algunos errores que se deberían corregir, pueden corregirlo o tomarlo como parametro para elaborar el suyo propio. En el front end podrían usar
el front que les dimos cuando hicimos el exchange contra eth.
*/

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract pair is ERC20, Ownable{
    IERC20 public token0;
    IERC20 public token1;

    uint256 private amount0;
    uint256 private amount1;

    uint256 r_num;
    uint256 r_den;

    constructor() ERC20("Liquidity pool token", "LPT") {r_num=101; r_den=100;}

    function mint(address to, uint256 amount) private {
        _mint(to, amount);
    }

    function AssignContracts(address _token0, address _token1) external returns(bool) {
        require(token0==IERC20(address(0x0)), "El token0 ya ha sido asignado");
        require(token1==IERC20(address(0x0)), "El token1 ya ha sido asignado");
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
        return true;
    }

    function getAmount(address _token) public view returns (uint256) {
        return IERC20(_token).balanceOf(address(this));
    }

    function viewAmount(bool _token) public view returns (uint256) {
        if(_token) {
            return getAmount(address(token1));
        } else {
            return getAmount(address(token0));
        }
    }

    function spotPrice(bool _token) public view returns (uint256) {
        uint256 x = viewAmount(_token);
        uint256 y = viewAmount(!_token);
        return y/x;
    }

// falta requerir que el contrato tenga lo que tiene que mandar al usuario
    function swap(uint256 _amount0, uint256 _amount1, uint256 _amountLP) external returns (bool) {
        // requisitos para trabajar
        if(_amountLP>0) {
            require(_amount0==0 && _amount1==0,"Si hay LP no debe haber otro amount");
        }else {
            require(_amount0!=0 || _amount1!=0,"Si hay LP no debe haber otro amount");
        }

        if(_amount0>0 && _amount1>0) { // Estamos minteando LPToken
            // Uso del token que tiene menos para sacarle
            uint256 aux=_amount0*spotPrice(false);
            if(aux > _amount1) {// tengo mas de amount0
                _amount0 =_amount1*spotPrice(true); // por eso ajusto el amount 0 segun amount1
            }else {
                amount1=aux; // sino el amount1 en funcion del amount0
            }
            token0.transferFrom(msg.sender, address(this), _amount0);
            token1.transferFrom(msg.sender, address(this), _amount1);
            mint(msg.sender, _amount0);// le minteo la cantidad de amount0
            return true;            
        }else {// Estamos swapeando tokens
            if(_amountLP!=0) { // burn LP tokens
            require(_amountLP <= IERC20(address(this)).balanceOf(msg.sender) ,"no tienes suficiente LPTokens");
                uint256 per1000million_token0 = 1000000000 * _amountLP / IERC20(address(this)).totalSupply();
                uint256 sendToken0 = per1000million_token0 * token0.totalSupply() / 1000000000;
                uint256 sendToken1 = per1000million_token0 * token1.totalSupply() / 1000000000;
                _burn(msg.sender, _amountLP);
                token0.transfer(msg.sender, sendToken0);
                token1.transfer(msg.sender, sendToken1);
            }else { // cambiamos token por otro
                uint256 q_num; // cantidad a transferirle al usuario2
                uint256 q_den; // cantidad a transferirle al usuario2
                uint256 q; // cantidad a transferirle al usuario2
                if(_amount0>0) { // cambiar token0 por token1
                    q_num=token1.balanceOf(address(this)) * r_num * _amount0;
                    q_den=token0.balanceOf(address(this)) + (r_num*_amount0) / r_den;
                    q=q_num/q_den; // dy
                    require(token0.transferFrom(msg.sender, address(this), _amount0) , "El usuario no tiene los fondos");
                    require(token1.transfer(msg.sender, q) , "El smart contract no tiene esos fondos");
                }else { // cambiar token1 por token0
                    q_num=token0.balanceOf(address(this)) * r_den * _amount1;
                    q_den=(token1.balanceOf(address(this)) - _amount1) * r_num;
                    q=q_num/q_den; // dx
                    require(token1.transferFrom(msg.sender, address(this), _amount1) , "el usuario no tiene los fondos");
                    require(token0.transfer(msg.sender, q) , "El smart contract no tiene esos fondos");
                }
            }
        }
        return true;
    }
}