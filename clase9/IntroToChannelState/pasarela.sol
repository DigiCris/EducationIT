/*
Si bien esta no es la implementación completa de un canal de pago, Podremos generar firma de los
mensajes que generen un pago de esta cuenta a la persona destinada y que unicamente si verifica
pueda cobrarse. En ese caso podríamos reemplazar el _to en verify por un msg.sender y realizar
el pago a esa persona si esto se verifica.

De esta forma no se emitiría el cobro hasta cerrar la cuenta final, y no sería el que emite el
pago quien deba emitir la transacción y pagar por el gas, sino la persona que lo va a cobrar.

Claramente el contrato debería estar cargado con los tokens o ethers para realizar los pagos,
o tener los permisos adecuados del allowance para los tokens.

El nonce podría cambiarse una sola vez, por lo cual deberíamos llevar la cuenta porque nonce va
y nunca aceptar nonce menores. Y acá lo único que habría que hacer es, ir incrementando la cuenta
y firmando las transacciones, libre de fees y al final de todas las sumas es cuando el beneficiario
lo vaya a cobrar.

Por más que hayan muchas transacciones, ninguna se efectúa, solo se firma para poder ser cobrada,
Unicamente la última es la que se envía ahorrando así, cantidad de transacciónes en la red, y
reduciendo los fees a pagar por el gas. Esto es lo que se conocería como un canal de pago
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract VerifySignature {

    address public owner;

    constructor(){
        owner=msg.sender;
    }

    function getMessageHash( address _to, uint _amount, uint _nonce) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(_amount, _to, _nonce));
    }


    function verify(address _to, uint _amount, uint _nonce, bytes memory signature) external view returns (bool) {
        bytes32 messageHash = getMessageHash( _to, _amount, _nonce);
        return recoverSigner(messageHash, signature) == owner;
    }

    function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature) internal pure returns (address) {
        bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        (bytes32 _r, bytes32 _s, uint8 _v) = splitSignature(_signature);
        bytes32 prefixedHashMessage = keccak256(abi.encodePacked(prefix, _ethSignedMessageHash));
        address signer = ecrecover(prefixedHashMessage, _v, _r, _s);
        return signer;
    }

    

    function splitSignature( bytes memory sig ) internal pure returns (bytes32 r, bytes32 s, uint8 v) {
        require(sig.length == 65, "invalid signature length");
        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }
        return(r,s,v);
    }
}