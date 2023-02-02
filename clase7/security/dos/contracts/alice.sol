//SPDX-License-Identifier:MIT
pragma solidity >=0.7.0 <0.9.0;

contract alice{
    uint256 apuestaMaxima;
    address king;

    function bet() external payable {
        require(msg.value>apuestaMaxima,"aun no eres el rey");
        apuestaMaxima= msg.value;
        payable(king).transfer(apuestaMaxima);
        king= msg.sender;
    }
}
