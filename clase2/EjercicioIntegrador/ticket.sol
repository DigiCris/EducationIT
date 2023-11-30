// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <=0.8.9;

/*
Contrato 1 de entradas:

1) Una estructura Person que contenga Id, Nombre y Cantidad.

2) Un Mapeao desde el address del dueño de la entrada apuntando a la estructura Person en que la variable se llame cliente.

3) Si el cliente adquiere más de 2 entradas adquiere una entrada de lotería que estará en otro contrato (contrato 2).

4) Si el owner del contrato quiere puede asignar entradas asignandoselas a distintas personas (en batch) pero no participarán del sorteo.

5) Permitir cambiar la primera letra del nombre de tu persona por mayuscula si está en minuscula.

6) Si una función que se llame en este contrato no existe deberá llamar al contrato de loteria y buscar la misma función (ej: ver el ganador de la lotería)

*/

contract ticket {

    struct Person {
        uint256 id;
        uint256 cantidad;
        string nombre;
    }

    address private owner;

    mapping (address => Person) public cliente;

    uint256 public constant price = 1 * 10**18;

    uint256 public id;

    constructor() payable {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner==msg.sender,"no eres owner, hacker!");
        _;
    }

    function retirar() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    function compra(string calldata _name) external payable {
        // que acá comprueben el precio de la entrada
        require(price<=msg.value, "no te alcanza");
        uint256 _cantidad = msg.value / price;
        uint256 _devolucion = msg.value % price;
        require(_devolucion<msg.value,"No devolvemos mas de lo que manda");
        cliente[msg.sender].cantidad = _cantidad;
        cliente[msg.sender].nombre = _name;
        cliente[msg.sender].id = id;
        id++;
        if(_cantidad>2) {
            getLoteryTicket();
        }
        payable(msg.sender).transfer(_devolucion);
    }

    function asignarEntrada(address[] calldata _addr, Person[] calldata amigos) external onlyOwner {
        uint256 length = amigos.length;
        uint256 length2 = amigos.length;
        require(length==length2,"no se puede asignar entradas");
        while(length>0) {
            length--;
            cliente[_addr[length]].cantidad = amigos[length].cantidad;
            cliente[_addr[length]].nombre = amigos[length].nombre;
            cliente[_addr[length]].id = id;
            id++;
        }
    }

    function cambioLetra() external {
        bytes memory _nombre = bytes(cliente[msg.sender].nombre);
        bytes1 _letra = _nombre[0];
        require(_letra>0x60,"No es minuscula");
        _letra = bytes1( 0x20 + uint8(_letra) );
        bytes(cliente[msg.sender].nombre)[0] = _letra;
    }

    fallback() external payable { 
       
    }

    receive() external payable { }

    function getLoteryTicket() internal pure returns(bool){
        return true;
    }

}