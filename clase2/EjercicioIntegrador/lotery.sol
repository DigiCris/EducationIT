// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <=0.8.9;

/*
Contrato 1 de entradas:

1) Estruct Person pero cambia id por wallet (para poder repartir el premio si lo gana)

2) Array del tipo Person clientesLujo

3) Variable ganador

4) variable semaforo usando enum como verde y rojo.

5) Variable de fecha para el sorteo. (Solo se permitirá realizarlo después de que este tiempo transcurra)

6) variable blacklist como address de mapeo a un bool (Para no dejar que ciertas direcciónes puedan participar)

7) Función que permita al contrato 1 y solo a este pushear personas en el array de clientesLujo. El valor que debe poner en wallet es el de la EOA que hizo la transacción.
Tambien debo verificar que esta wallet no esté en la blacklist (Usar modificadores).

8) Función para agregar direcciónes a la blacklist que solo el Owner pueda.

9) Funcion que me permita preguntar por nombre si una persona fue ganadora de la lotería.

10) funcion lectura del array

11) Función psudo-random para calcular numeros aleatorios (Pensar luego como veloverla "almost fair")

12) Funcion para preguntar si ya se cumplió el tiempo.

13) Funcion para modificar el semaforo si es que ya se cumplió el tiempo. (La función anterior está para preguntar sin gastar gas y unicamente llamar a esta cuando sea necesario y no recurrentemente)


14) Función para determinar ganador de la lotería. La misma debe comprobar que el estado semaforo se encuentre en verde. Determina el valor de la lotería con la funcion random y le manda los ethers Pero antes comprueba de que el address no sea el address nulo.

15) Crear una función que recorrá todos las posiciones del array clientesLujo y que elimine una determinada billetera. Verificar que la misma no se quede sin gas mientras recorre todo el arrayy en caso de
quedarse sin gas corte recordando por donde iba analizando para luego retomar desde ese punto. Para esto agregar todas las variables de estado que hagan falta.


*/

contract lotery {

    struct Person {
        address payable wallet;
        uint256 cantidad;
        string nombre;
    }

    address private owner;

    Person[] public clientesLujo;

    Person ganador;

    uint256 public constant price = 1 * 10**18;

    uint256 public id;

    uint256 public timestamp;

    mapping (address => bool) blacklist;

    address public ticketSeller;

    enum Estado {
        verde,
        rojo
    }
    Estado public Semaforo;

    constructor() payable {
        owner = msg.sender;
        Semaforo = Estado.rojo;
        timestamp = block.timestamp + 1 weeks;
    }

    modifier onlyOwner() {
        require(owner==msg.sender,"no eres owner, hacker!");
        _;
    }

    function retirar() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }


    modifier onlyTicketSeller() {
        require(ticketSeller==msg.sender,"no eres ticketSellet, hacker!");
        _;
    }

    modifier whenNotBlacklisted(address _addr) {
        require( blacklist[_addr] != true , "no eres ticketSellet, hacker!" );
        _;
    }
    

/*
7) Función que permita al contrato 1 y solo a este pushear personas en el array de clientesLujo. El valor que debe poner en wallet es el de la EOA que hizo la transacción.
Tambien debo verificar que esta wallet no esté en la blacklist (Usar modificadores).
*/
    function pushClienteLujo(string calldata _nombre) external onlyTicketSeller whenNotBlacklisted(tx.origin) {
        Person storage _clienteLujo = clientesLujo.push();
        _clienteLujo.nombre = _nombre;
        _clienteLujo.wallet = payable(tx.origin);
    }

/*
8) Función para agregar direcciónes a la blacklist que solo el Owner pueda.
*/
    function setBlacklist(address[] calldata _addr) external onlyOwner {
        uint256 _length = _addr.length;
        while(_length>0) {
            _length --;
            blacklist[_addr[_length]] = true;
        }
    }

/*
9) Funcion que me permita preguntar por nombre si una persona fue ganadora de la lotería.
 if(keccak256(bytes(ganador.nombre)) == keccak256(bytes(_name)))
*/
    function isWinner(string calldata _name) external view returns(bool) {
        if(keccak256(bytes(ganador.nombre)) == keccak256(bytes(_name))) {
            return true;
        } else {
            return false;
        }
    }

/*
10) funcion lectura del array
*/
    function getClientesLujo() external view returns(Person[] memory) {
        return clientesLujo;
    }

/*
11) Función psudo-random para calcular numeros aleatorios (Pensar luego como veloverla "almost fair")
*/
    function random() internal view returns(uint256) {
        uint256 randomNumber = uint256(
            keccak256(
                abi.encodePacked(
                    block.timestamp,
                    block.difficulty,
                    block.coinbase,
                    blockhash(block.number - 1)
                )
            )
        );
        return randomNumber;
    }

/*
12) Funcion para preguntar si ya se cumplió el tiempo.
*/
    function isTimeOver() view public returns(bool) {
        if(block.timestamp>timestamp) {
            return true;
        } else {
            return false;
        }
    }

/*
13) Funcion para modificar el semaforo si es que ya se cumplió el tiempo. (La función anterior está para preguntar 
sin gastar gas y unicamente llamar a esta cuando sea necesario y no recurrentemente)
*/
    function setGreenLight() external {
        require( isTimeOver() == true , "Aun no es tiempo" );
        Semaforo = Estado.verde;
    }

/*
14) Función para determinar ganador de la lotería. La misma debe comprobar que el estado semaforo se encuentre 
en verde. Determina el valor de la lotería con la funcion random y le manda los ethers Pero antes comprueba 
de que el address no sea el address nulo.
*/
    function setWinner() external {
        require(Semaforo == Estado.verde, "no se puede proseguir");
        Semaforo = Estado.rojo;
        timestamp = block.timestamp + 7 days;
        uint256 _ganador = random() % clientesLujo.length;
        address payable winner;
        winner = clientesLujo[_ganador].wallet;
        require(winner!=address(0), "no puede ser null");
        ganador.wallet = winner;
        ganador.nombre = clientesLujo[_ganador].nombre;
        winner.transfer(1 ether);
    }

/*
15) Crear una función que recorrá todos las posiciones del array clientesLujo y que elimine una determinada billetera.
 Verificar que la misma no se quede sin gas mientras recorre todo el arrayy en caso de
quedarse sin gas corte recordando por donde iba analizando para luego retomar desde ese punto. 
Para esto agregar todas las variables de estado que hagan falta.
*/
uint256 public i;
function deleteClienteLujo(address _addr) external onlyOwner {
    uint256 _length = clientesLujo.length;
    uint256 _i;
    if(i == 0){
        _i = _length;
    } else {
        _i = i;
    }

    while(_i > 0) { // i recorrerá desde length hasta 0. Se puede quedar sin gas en algun momento
        uint gas = gasleft();
        _i--;
        if(clientesLujo[_i].wallet == _addr) {
            //clientesLujo[_length].wallet = payable( address(0) ); // si quiero ponerlo directo en 0 y dejarlo

            clientesLujo[_i].nombre = clientesLujo[_length-1].nombre ; // guardo la ultima posicion en el que elimare
            clientesLujo[_i].wallet = clientesLujo[_length-1].wallet ;

            clientesLujo.pop(); // elimino el ultimo. No hace falta aux porque lo voy a eliminar
            break;
        }
        gas = gas - gasleft();
        if(gasleft() < gas*2 ) {
            i = _i;
        }
    }
    i=0;
}

}