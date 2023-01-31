// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract Store {

    uint256 number;
    address public owner;

    modifier onlyOwner{
        require(msg.sender==owner,"no eres el owner");
        _;
    }

    constructor() {
        owner=msg.sender;
    }

    /**
     * @dev Store value in variable
     * @param num value to store
     */
    function store(uint256 num) public onlyOwner {
        number = num;
    }

    /**
     * @dev Return value 
     * @return value of 'number'
     */
    function retrieve() public view returns (uint256){
        return number;
    }
}
