/*cuenta para pruebas
EducationIt
0x601eaA885bF37D28906Ad58d7508cFa1Af10E754
album cherry fun nest cupboard mosquito around region chapter sentence side frog
*/


const Web3 = require('web3');
const web3 = new Web3(Web3.givenProvider || "https://rpc.ankr.com/eth_goerli");// acá puede ir cualquier nodo al que se conecten
//var web3 = new Web3(Web3.givenProvider || "127.0.0.1:8545");

//Estas funciones no deberían fallar= siempre que la wallet de getBalance y el hash de la transaction estén bien
//console.log(web3.version);
//console.log( web3.eth.currentProvider.host);
//web3.eth.getBalance('0x7E84215C62e649870846445a0d871149E7240229', 'latest', (e,r)=> console.log( web3.utils.fromWei(r,"ether") )   ); // Fijarse que acá utilicé una función de utils para transformar de wei a ether el resultado. si la sacamos lo tendríamos en wei.
//web3.eth.getTransaction('0x2aeae20da4e7d52736face780e06d70693fc965f0fd412401cb188f3a7edce16').then(console.log);
web3.eth.getBlockNumber().then(console.log);

// Las siguientes funciones de personal no funcioran en un nodo externo por temas de seguridad ya que los
// passwords viajan libremente. La forma correcta de tratar esto es en un nodo local como geth, usando
// todos los sistemas de protección posible y unicamente mandando para afuera la información ya firmada.
//1) web3.eth.personal.newAccount('superpassword').then(console.log);
//2) web3.geth.personal.new_account(self, 'superpassword').then(console.log);
//3) web3.eth.personal.unlockAccount("0x11f4d0A3c12e86B4b5F39B213F7E19D048276DAe", "test password!", 600).then(console.log('unlocked!'));

// goerli-light
// para crear una cuenta en geth correr = geth --datadir . account new
// te pedirá un password, lo completas y se genera. no hay que olvidar el password porque sino no podremos recobrarla
// la direccion de cuenta te la dan ahí en el momento para poder interactuar con ella.
// para listar las cuentas en el nodo = geth --datadir . account list
// para deslockear accounts deberíamos usar= geth --unlock "ACCOUNT_PUBLIC_ADDRESS" --password "PASSWORD" 
// si no se pone --password "PASSWORD" te lo pedirá luego


//para ver firmas y recover de firmas dentro de web3.personal podemos ver el siguiente github
//https://github.com/DigiCris/ethereum_signature
// En javascript vimos como mandar transacciones sin firmar y que la firma era completada por metamask,
// en el deploy.js del siguiente archivo podemos ver como mandar una transaccion firmada,
// para lo cual no deberemos pasar por metamask:
//https://github.com/DigiCris/EasyERC20/blob/main/deploy.js
// video de explicacion que hice para platzi
