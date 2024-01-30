// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

/*
Contrato 1 de entradas:

1) Una estructura Person que contenga Id, Nombre y Cantidad.
2) Un Mapeao desde el address del dueño de la entrada apuntando a la estructura Person en que la variable se llame cliente.
3) Si el cliente adquiere más de 2 entradas adquiere una entrada de lotería que estará en otro contrato (contrato 2).
4) Si el owner del contrato quiere puede comprar entradas asignandoselas a distintas personas (en batch) pero no participarán del sorteo.
5) Permitir cambiar la primera letra del nombre de tu persona por mayuscula si está en minuscula.
6) Si una función que se llame en este contrato no existe deberá llamar al contrato de loteria y buscar la misma función (ej: ver el ganador de la lotería)

*/

contract ticket {
/*
1) Una estructura Person que contenga Id, Nombre y Cantidad.
*/
    struct Person {
        uint256 id;
        uint256 cantidad;
        string nombre;
    }

/*
2) Un Mapeao desde el address del dueño de la entrada 
apuntando a la estructura Person en que la variable se llame cliente.
*/
    mapping( address => Person) public cliente;

    address public owner;

    uint256 id;
    uint256 price = 1 ether;

    constructor() {
        owner = msg.sender;
    }

/*
3) Si el cliente adquiere más de 2 entradas adquiere una entrada de 
lotería que estará en otro contrato (contrato 2).
*/
    function buy(string calldata _nombre) public payable  {
        uint256 _cantidad = msg.value / price;
        uint256 _devolver = msg.value % price;
        cliente[msg.sender].id = id;
        id++;
        cliente[msg.sender].cantidad += _cantidad;
        cliente[msg.sender].nombre = _nombre;
        // balance, transfer, send, call, delegatecall
        if(_cantidad>2) {
            getLotteryTicket();
        }
        if(_devolver>0) {
            payable(msg.sender).transfer(_devolver);
        }
    }

    function getLotteryTicket() public  {}

    /*
    4) Si el owner del contrato quiere puede comprar 
    entradas asignandoselas a distintas personas (en batch) pero no participarán del sorteo.
    */
    modifier onlyOwner() {
        require(msg.sender == owner, "usted no es el owner");
        _;
    }

    function asignE(address[] calldata _addr, Person[] calldata _amigos) external onlyOwner {
        uint256 _length = _amigos.length;
        for(uint256 a=0; a < _length; a++) {
            cliente[_addr[a]].id = id;
            id++;
            cliente[_addr[a]].cantidad = _amigos[a].cantidad;
            cliente[_addr[a]].nombre = _amigos[a].nombre;
        }
    }

}