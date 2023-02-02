//SPDX-License-Identifier:MIT
pragma solidity >=0.7.0 <0.9.0;

contract alice{

    address public owner;
    address public lib;

    modifier onlyOwner() {
        require(msg.sender==owner,"no eres el owner");
        _;
    }

    constructor(address _addr) payable {
        owner=msg.sender;
        lib=_addr;
    }

    function withdraw() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    fallback() external {
        (bool success, ) = lib.delegatecall( msg.data );
        require(success==true, "el delegatecall no funciono");
    }

    function getOwner() external view returns(address) {
        return(owner);
    }
}