//npm install dotenv
require('dotenv').config();
//npm install truffle-hdwallet-provider
const HDWalletProvider = require('truffle-hdwallet-provider');

module.exports = {
  networks: {
     goerli: {
       provider: () => new HDWalletProvider(process.env.MNEMONIC, `https://goerli.infura.io/v3/${process.env.PROJECT_ID}`),
       network_id: 5,       // Goerli's id
       confirmations: 2,    // # of confirmations to wait between deployments. (default: 0)
       timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
       skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
     },
  },

  mocha: {

  },

  compilers: {
    solc: {
      version: "0.8.0"
    }
  }
};
