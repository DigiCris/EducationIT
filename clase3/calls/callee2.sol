// SPDX-License-Identifier: MIT
pragma solidity >0.7.0 <=0.9.0;

contract callee {

    function printCaller() external view returns(address) {
        return(tx.origin);
    }

}