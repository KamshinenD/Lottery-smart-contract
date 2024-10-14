// SPDX-License-Identifier: MIT

pragma solidity >=0.5.0 <0.9.0;

contract Lottery{
    address payable[] public players; //players addresses are pushed to an array called players
    address public manager; //manages the lottery. selects the winnder

    constructor(){
        manager= msg.sender; //manager is the address of the person that deploys the contract
    }

    //declaring a receive function for the contract to receive ether
    receive() external payable {
        require(msg.value== 0.1 ether); //0.1 ether must be sent by users in order to enter the lottery
        players.push(payable(msg.sender)); // because players array consists of payable addresses so msg.sender needs to be converted to payable before pushing to the players array

    }


    //function that returns the contract balance in wei
    function getBalance() public view returns(uint){
      require(msg.sender== manager); 
        return address(this).balance; //This gives the balance in the current contract
    }

    //generate random number
    function random()public view returns(uint){
       return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, players.length)));
    }

    function pickWinner() public {
        require(msg.sender == manager);
        require(players.length>=3);

        uint r= random();
        address payable winner;

        uint index= r % players.length;
        winner=players[index];
        winner.transfer(getBalance());
        players= new address payable[](0); // resetting the lottery
    }
}