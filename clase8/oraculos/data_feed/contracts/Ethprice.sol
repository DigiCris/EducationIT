// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//npm install @chainlink/contracts
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

//tutorial= https://docs.chain.link/getting-started/consuming-data-feeds/

// Address for interfaces, diferent pairs= https://docs.chain.link/data-feeds/price-feeds/addresses/

// deployed at: 0x680E6AE23421Bf2ef20f746f86C16935dE9d903b
contract Ethprice{
    AggregatorV3Interface internal precioEth;
    address constant goerliAggrAddr=0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e;
    string public pair;

    constructor(){
        precioEth = AggregatorV3Interface(goerliAggrAddr);
    }

    function lastPrice() external view returns (int256){
        (, int256 answer, , , ) = precioEth.latestRoundData();
        return answer;
    }

    function changePair(address _addr, string calldata _pair) external{
        pair=_pair;
        precioEth = AggregatorV3Interface(_addr);
    }

}