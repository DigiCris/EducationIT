// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";



// Consideraciones de seguridad
//requestId para determinar el orden y que no hagan trampa los mineros
//escoger una cantidad de bloques de seguridad apropiado. ya que un minero podría probar en diferentes bloques para obtener diferentes randoms hasta encontrar uno que le convenga
// no re pedir un valor aunque este no llegue ya que podrían no mandarlo hasta encontrar el apropiado que quieren
// no aceptar más inputs después de pedir el numero ya que podrían utilizarlo a su favor.
//fulfillrandomWords no debe revertir ya que no se rellamará. Mantenerla lo más simple posible. Mas procesamiento dejarlo afuera, para usuarios, uno mismo o nodos de automatización (chainlin en estos nodos llama constantemente a una funcion de lectura que le dice cuando es tiempo de ejecutar un cierto trabajo, en ese entonces llama a la de escritura que la ejecuta ).
// Utilizar la función que nos provee para verificar que la aleatoriedad fuera completada

/*
deployed at= 0xeBeC6Be2e4F47C5d35dcc29608Ea5EB34700774d

Funcionamiento

MySmartContract -> wrapper -> coordinator -> service
MySmartContract <- wrapper <- coordinator <- service

Mi SC pide un numero aleatorio al wrapper que se lo manda al coordinador. Todo esto lo hace onchain.
service está suscripto al coordinador, entonces cuando le hacen una petición lo lee en los logs y crea el numero
offchain y las pruebas criptográficas de su creación. el coordinador comprueba que ese numero haya sido correctamente
generado con esas pruebas criptográficas y se lo regresa al wrapper para que me lo devuelva en mi SC.
Para lograr todo esto, además de pagar el gas, y poder preveer lo que se va a usar para recibirlo, debo pagarle
a los nodos del oraculo con link, por eso a este contrato tendremos que mandarle links para que funcione.
*/



contract Random is VRFConsumerBase, ConfirmedOwner { 

/*
https://docs.chain.link/vrf/v1/supported-networks
link address           = 0x326C977E6efc84E512bB9C30f76E30c160eD06FB
key hash               = 0x0476f9a745b61ea5c0ab224d3a6e4c99f0b02fce4da01143a4f70aa80ae76e8a
ChainlinkVRFCoordinator= 0x2bce784e69d2Ff36c71edcB9F88358dB0DfB55b4
*/

	bytes32 internal keyHash = 0x0476f9a745b61ea5c0ab224d3a6e4c99f0b02fce4da01143a4f70aa80ae76e8a; // Hash para máximo gas a utilizar, en la V2 te deja especificarlo no teniendo que poner este hash
    uint256 internal fee = 0.1 * 10**18; // 0.1 LINK, lo que cobran los nodos por mandarnos el numero aelatorio
    uint256 public randomResult; // Donde guardaremos el numero aleatorio devuelto
    address public VRFCoordinator = 0x2bce784e69d2Ff36c71edcB9F88358dB0DfB55b4; // la dirección del contrato coordinador
    address public link = 0x326C977E6efc84E512bB9C30f76E30c160eD06FB; // la direccion del contrato de los links

    bytes32 public lastRequestedId; // guardo el último Id solicitado, aunque para el ejemplo no es muy necesario
    
    constructor() VRFConsumerBase(VRFCoordinator, link) ConfirmedOwner(msg.sender) {} // el constructor me manda a las bases los parametros para inicializar


	function requestNewRandom() public returns (bytes32) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet"); // evalúa si los links en este smart contract me alcanza para pagar los fees
        bytes32 _requestId = requestRandomness(keyHash, fee); // pide el numero aleatorio mandandole el fee y el gas que usara para el fallback
        lastRequestedId = _requestId; // guardo el last requestedId, para luego poder ver si es el que vino
        return _requestId; // Lo devuelvo solo para tenerlo, no es importante
    }

    function fulfillRandomness(bytes32 _requestId, uint256 _randomNumber) internal override {
        if(lastRequestedId == _requestId) // corroboro que el contrato coordinador me esté mandando el aleatorio correspondiente al Id que me había devuelto
        {
            randomResult = _randomNumber;// si es así, guardo el numero
        }
        else
        {
            randomResult = 100; // sino lo pongo en 100 solo para ver que se ejecutó esta función pero que no devolvió el numero aleatorio
        }
    }

    //Permite sacar los links que hayamos ingresado para que no queden atrapados
    function withdrawLink() public onlyOwner {
        // el onlyOwner viene heredado de ConfirmedOwner
        // retiro con la funcion transfer de erc20, todo el balance que hay en este contrato (link no es erc20 pero es compatible ya que hereda de este)
        require( LINK.transfer(msg.sender, LINK.balanceOf(address(this))), "Unable to transfer" );
    }

}