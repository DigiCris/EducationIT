// SPDX-License-Identifier: MIT
pragma solidity >0.7.0 <=0.9.0;

contract StoringData {
    //26594
    function setDataToMemeory(uint newValue) public {
        assembly {
            sstore(0, newValue)
        }
    }

    //2262
    function getDataFromMemory() public view returns(uint) {
        assembly {
            let v := sload(0)
            mstore(0x80, v)
            return(0x80, 32)
        }
    }
}

contract Storage {
    uint256 private number;

    //26600
    function store(uint256 _number) external payable {
        number = _number;
    }

    function retrieve() external view returns(uint256) {
        return(number);
    }
}