pragma solidity ^0.4.11;

// ESTE CONTRATO CONTIENE UN ERROR - NO USAR
contract TxUserWallet {
    address owner;

    function TxUserWallet() {
        owner = msg.sender;
    }

    function transferTo(address dest, uint amount) {
        require(tx.origin == owner);
        dest.transfer(amount);
    }
}