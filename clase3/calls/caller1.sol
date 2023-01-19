// SPDX-License-Identifier: MIT
pragma solidity >0.7.0 <=0.9.0;

contract callee {
    address public contrato;
    bytes public valorGuardado;

    function changeContract(address _addr) external {
        contrato=_addr;
    }

    // funcion fallback, call, delegatecall, msg.sender, tx.origin
    fallback() external {// en calldata= 0x7b640efb
        (bool error,bytes memory valor)=contrato.call(msg.data);
        //(bool error,bytes memory valor)=contrato.delegatecall(msg.data);
        if(error==false) revert("no pude llamar a la funcion");
        valorGuardado=valor;
    }

    // funcion receive: me permitira aceptar siempre pagos.
    receive() external payable {

    }

}