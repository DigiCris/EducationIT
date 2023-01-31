// SPDX-License-Identifier: MIT
pragma solidity >0.7.0 <=0.9.0;


// Podemos ahorrar aproximadamente 8% de gas
contract Promedio {
    uint256[8] numbers = [1,2,3,4,4,5,6,7];
    uint256 public promedio;

    //40847
    function calculaPromedioAssemblyLoop() external{
        assembly {
            let suma
            for { let i := 0 } lt(i, 8) { i := add(i, 1) } {
                let Number := sload(i)
                suma := add(suma,Number)
            }
            suma := shr(3,suma)
            sstore(8, suma)
        }
    }

    //40384
    function calculaPromedioAssemblySinLoop() external {
        assembly {
            let suma
            let Number := sload(0)
            suma := add(suma,Number)
            Number := sload(1)
            suma := add(suma,Number)
            Number := sload(2)
            suma := add(suma,Number)
            Number := sload(3)
            suma := add(suma,Number)
            Number := sload(4)
            suma := add(suma,Number)
            Number := sload(5)
            suma := add(suma,Number)
            Number := sload(6)
            suma := add(suma,Number)
            Number := sload(7)
            suma := add(suma,Number)
            suma := shr(3,suma)
            sstore(8, suma)
        }
    }

    //43777
    function calculaPromedioSolidity() external{
        uint256 arrayLen= numbers.length;
        uint256 suma;
        for(uint256 len ; len < arrayLen ; len++) {
            suma = suma + numbers[len];
        }
        promedio=suma/arrayLen;
    }
}