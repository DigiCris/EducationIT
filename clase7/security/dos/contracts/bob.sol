//SPDX-License-Identifier:MIT
pragma solidity >=0.7.0 <0.9.0;

interface alice {
     function bet() external payable;
}

contract bob{
    function play(address payable  _addr) external payable {
        alice contratoAlice = alice(_addr);
        contratoAlice.bet{value:msg.value}();
    }
    fallback() external payable {
        revert();
    }
}
