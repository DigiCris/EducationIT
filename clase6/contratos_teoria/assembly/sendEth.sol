// SPDX-License-Identifier: MIT
pragma solidity >0.7.0 <=0.9.0;

contract SendETH {
    
    address owner;

    constructor() payable{
        owner=msg.sender;
    }

    function withdrawETH(uint _amount) external payable {
        bool success;
        assembly {
            let _owner := sload(0)
            if eq(caller(), _owner) {
                success := call(gas(), caller(), _amount, 0, 0, 0, 0)
            } 
        }
        require(success, "Failed to send ETH");
    }
}