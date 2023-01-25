// SPDX-License-Identifier: MIT
pragma solidity >0.7.0 <=0.9.0;

interface callee {
    function printCaller() external view returns(address);
}

contract caller {
    callee public contrato;
    bytes public valorGuardado;

    function changeContract(address _addr) external {
        contrato=callee(_addr);
    }

    function exeption() external view returns(string memory) {// en calldata= 0x7b640efb
        try contrato.printCaller() {
            return("Pudo ejecutarlo"); // todo bien
        }catch Error(string memory reason){
            return(reason); // revert("use revert con causa");
        }catch Panic(uint /*errorCode*/){
            return("Fue un error grave y se regreso codigo de error"); //asert, division por 0
        }catch (bytes memory /*lowLevelData*/) {
            return ("se uso revert()"); // revert() inassembly
        }

    }

}