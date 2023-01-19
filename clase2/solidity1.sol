// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract test{
    uint256 public counter;
    address private owner;

    // constructor que me permite mandarle ethers y establece como owner del contrato a quien lo crea
    constructor() payable {
        owner=msg.sender;
    }

    // Funcion para ver los limites de un tipo
    function intLimits() external pure returns (int8,int8) {
        return ( (type(int8).min),(type(int8).max) ); 
    }

    // generacion de un underflow
    function underflow() external pure returns (int8) {
        return ( type(int8).min / (-1) );
    }

    // estudio de side effects
    function Counter() external {
        if (1 == 0 && count()){} // Que pasa con counter? se incrementa o no?
    }
    function count() internal returns(bool) {
        counter++;
        return(true);
    }

    // Alguien sabría decir por que falla?
    function underflow2() external pure returns (uint16) {
        uint16 a= 255 + (true ? 1 : 0) ;
        return a;
    }

    // cualquiera saca los ethers
    function transferEtherAny() external {
        address payable _to;
        _to = payable (msg.sender); // por que debo hacer este casteo?
        _to.transfer(address(this).balance);
    }

    // solo el owner saca los ethers. Utilizo send para ver la diferencia con transfer. Call y delegateCall los veremos luego
    modifier onlyOwner(){
        require(owner==msg.sender,"no eres el owner");
        _;
    }
    function transferEtherOwner() external onlyOwner {
        address payable _to;
        _to = payable (msg.sender);
        if( _to.send(address(this).balance) == false ){
            revert("fallo el envio");
        }
    }

    // structs + mapping + variables publicas
    struct Person{
        string name;
        uint256 id;
    }
    mapping (address => Person) public myInfo;

    function cargarDatos(string calldata _name, uint256 _id) external {
        myInfo[msg.sender].name = _name;
        myInfo[msg.sender].id = _id;
    }

    // struct + array + variables publicas (Ver diferencia de gas con la anterior)
    Person[] public myInfoArray;

    function cargarDatosArray(string calldata _name, uint256 _id) external {
        Person memory aux;
        aux.name = _name;
        aux.id = _id;
        myInfoArray.push(aux);
    }

    // Devolver todo el aray myInfoArray (el default getter no me devuelve todo el array, esto si)

    function getMyInfoArray() external view returns (Person[] memory) {
        return myInfoArray;
    }


    //bytes
    bytes1 public _bytes1="a";
    bytes2 public _bytes2="ab";
    bytes public _bytesArray;//0x606162 => igual a string no alineado a 256
    function _bytes3Setter(bytes calldata _byteArray) external { // ver memory vs calldata
        _bytesArray = _byteArray;
    }

    //operaciones sobre literales
    function sumaConstante() external pure returns(uint256){
        uint256 a=1;
        return ( 2.5 + 2.5 + a );
//        return ( 2.5 + a + 2.5 ); // Por que esta mal?
    }

    function compararTiempo(bool _choice) external pure returns(bool)
    {
        if(_choice){
            return(60 minutes == 1 hours);
        }
        else{
            return(61 minutes == 1 hours);
        }
    }

    function compararMoneda(bool _choice) external pure returns(bool)
    {
        if(_choice){
            return(1000000000000000000 wei == 1 ether);
        }
        else{
            return(1400000000000000000 wei == 1 ether);
        }
    }

// vimos hasta aca

    //Enumeraciones y manejo de estados
    enum Estado{ // Maxio puede tener 256 miembros y eso es porque está contenido en un unit8
        prendido,
        apagado
    }
    Estado public state;
    function toggleState() external {
        if(state==Estado.prendido) {
            state=Estado.apagado;
        }
        else {
            state=Estado.prendido;
        }
    }

    // push para arrays del tipo storage
    uint16[] public valuePushed;
    function agregarValor(uint16 _agregar) public {
        valuePushed.push(_agregar); // push() es de costo fijo != push(algo)... Pop es variable en funcion de lo que le pasemos como push(algo)
    }


    // Copia por referencia (memoria a memoria o storage a storage)
    // Ojo con esto y evitar dangling references porque no se sabe como se comportara
    uint32[] public referencia;

    function modificarReferencia(uint32 _number) external {
        uint32[] storage _referencia = referencia;
        _referencia.push(_number);
    }


    // string por bytes
    string public curso="Blockchain";

    function modificarCurso(bytes1 _letra) external {
        //curso[0]=_letra; // no se puede
        bytes(curso)[0]=_letra; // 0x63
        // bytes es cmo si fuera un bytes1[] pero optimiza memoria no alineandola a 256bits
    }

    //comparacion de strings (La comparacion no puede ser en strings y por eso se hashea)
    function comparar(string calldata a, string calldata b) pure external returns (string memory) {
        if( keccak256(bytes(a)) == keccak256(bytes(b)) ) {
            return ("iguales");
        }
        else {
            return ("distintos");
        }
    }

    // Propiedades de bloques
    function bloque() view external returns(uint256,uint256,uint256,address){
        return (block.difficulty, block.gaslimit, block.number, block.coinbase);
    }

    //Valor pseudo Aleatorio (Por que no usarlo como aleatorio?)
    function random() view external returns(uint256){
        uint256 _aleatorio = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % 100;
        return (_aleatorio);
    }

    // Propiedades de transaccion
    function transaccion() external view returns (uint256, address) {
        return(tx.gasprice, tx.origin); // ver pagina 17 del modulo 2
    }

    //propiedades de mensajes
    function mensaje() external view returns(bytes memory,uint256,bytes4){
        uint256 a = gasleft(); // msg.gas fue deprecada
        return (msg.data, a, msg.sig);
    }
    function valueSent() external payable returns(uint256){
        return (msg.value);
    }

    // destruir contrato: No se aconseja utilizarlo pero se muestra porque puede aparecer en contratos viejos
    function destroy() external {
        selfdestruct( payable(msg.sender) );
    }

    //revert vs require:probar con 7.1
    function revertir(bool _choice) external {
        if(_choice) {
            assert(1==0);
        }
        else {
            require(1==0, "1 no es igual a 0");
        }
        counter++; // Lo puse solo para que me cobre el gas
        // revert lo vimos con el <address>.send
        // throw() esta deprecado hace tiempo
    }

    //arrays variables en memoria. Siempre deben ser fijos, aunque pueda hacerse en tiempo de ejcucion.
    function varArrMem(uint256 _i) external pure returns(uint256[] memory,uint256) {
        uint256[] memory hola = new uint256[](_i);
        hola[0]=1;
        hola[1]=2;
        return (hola,hola.length); // probar que pasa al mandarle a _i= (1;2;10)
    }

}


// trabajando al contrato como si fuera su propio tipo
contract testSup{
    test contrato;

    constructor(address _addr){
        contrato=test(_addr);
    }

    function callContrato() external view returns(int8, int8){
        return contrato.intLimits();
    }
}