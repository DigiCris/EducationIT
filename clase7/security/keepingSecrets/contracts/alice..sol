//SPDX-License-Identifier:MIT
pragma solidity >=0.7.0 <0.9.0;

contract game{

    struct Player{
        address addr;
        uint256 number;
    }

    Player[2] private player;
    uint8 public numberOfPlayers;
    address public winner;

    function registerGamble(uint256 _number) external payable{
        require( msg.value == 1 ether , "No mandaste la cantidad exacta de eth solicitada");
        if(numberOfPlayers >= 1){
            player[numberOfPlayers].addr=msg.sender;
            player[numberOfPlayers].number=_number;
            numberOfPlayers=0;
            theWinnerIs();
        }
        else{
            player[numberOfPlayers].addr=msg.sender;
            player[numberOfPlayers].number=_number;
            numberOfPlayers++;
        }
    }

    function theWinnerIs() internal
    {
        address payable _winner;
        uint256 number = player[0].number + player[1].number;
        if( (number%2)==1 )
        {
            _winner=payable(player[0].addr);
        }
        else
        {
            _winner=payable(player[1].addr);
        }
        winner=_winner;
        _winner.transfer(address(this).balance);
    }
}