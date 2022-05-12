// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


contract Lottery {
    //address owner
    address public owner;

    //address of participants
    address[] private participants;

    //address winner
    address public winner;

    //specify the owner when deploying
    constructor(){
        owner = msg.sender;
    }


    //participate in the lottery
    function enter() public payable conditionsEnter{

        //add a function caller to participants
        participants.push(msg.sender);
    }
    

    //terms of participation in the lottery
    modifier  conditionsEnter(){

        //participant must have paid 1 ether
        require(msg.value == 1 ether);

        //the owner cannot participate in the lottery
        require(msg.sender != owner);

        //the participant must not have already entered
        for (uint i=0; i < participants.length; i++) {
            require(msg.sender != participants[0]);
        }

        _;
    }

    //random to choose the winner
    function random() private view returns(uint) {
        uint randInt =  uint( keccak256( abi.encodePacked(block.difficulty , block.timestamp) ) );
        return randInt % participants.length;   
    }
    
    //choose the winner randomly
    function  selectionWinner() public  payable conditionsIntroductionWinner returns(address) {
        uint getRandom = random();

        //owner award
        uint ownerAward = (address(this).balance) * 3 / 100;

        //identify the winner in random
        winner = participants[getRandom];
        
        //the winner gets the rest of the money
        payable(participants[getRandom]).transfer(payable(address(this)).balance - ownerAward);

        // manager will get 0.003% of the whole prize pool
        payable(owner).transfer(ownerAward);
        
        //reset the participants for a fresh start
        participants = new address[](0);
        
        return winner;
    }

    //conditions for announcing the winner of the lottery
    modifier conditionsIntroductionWinner() {

        //the function caller must be the owner
        require(msg.sender == owner);

        //participants must be above zero
        require(participants.length > 0);
        _;
    }

    //participants
    function getParticipants() public view returns(address[] memory) {
        return participants;
    }

    //participants length
    function getParticipantsLength() public view returns(uint) {
        return participants.length;
    }

    //balance contract
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

 
    

}