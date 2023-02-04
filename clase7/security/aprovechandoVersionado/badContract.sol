pragma solidity ^0.4.2;

//Study Case= HighOrderByteCleanStorage
//Known bugs= https://github.com/ethereum/solidity/blob/develop/docs/bugs.json
//Solc versions= https://etherscan.io/solcversions (resumen)
// Solc releases= https://github.com/ethereum/solidity => acá podemos rastrear fechas
contract bad{
    uint8 public suma;
    uint8 private balance;

    function add(uint8 a, uint8 b) public {
        suma= a + b;
    }

    function getBalance() public returns (uint8) {
        return balance;
    }
}

