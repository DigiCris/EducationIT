// SPDX-License-Identifier: MIT
pragma solidity >0.7.0 <=0.9.0;

contract callee {

    function printCaller() external view returns(address) {
//        assert(1==2);

//        revert("use revert con causa");
/*
        assembly {
            revert(0xff, 32)
        }
*/

        uint256 var1=10;
        uint256 var2=0;
        var1=var1/var2;

        return(msg.sender);
    }

}