// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Banking {
    mapping(address => uint256) public balances;
    address payable owner;

    constructor() public{
        owner = payable(msg.sender);
    }

    //depositing the amount to the account
    function deposit() public payable{
        require(msg.value>0, "Deposit amount must be greater than 0.");
        balances[msg.sender] += msg.value;
    }

    //withdrawal of funds
    function withdraw(uint256 amount) public {
        require(msg.sender == owner, "Only the owner is allowed to withdraw the funds");
        require(amount <= balances[msg.sender], "Insufficient funds" );
        require(amount > 0,"Withdrawal amount must be greater than 0.");
        payable(msg.sender).transfer(amount);
        balances[msg.sender] -= amount; 
    }

    function transfer(address payable reciver, uint256 amount) public{
        require(amount <= balances[msg.sender], "Insufficent funds.");
        require(amount>0, "Transfer amount must be greater than 0.");
        balances[msg.sender] -= amount;
        balances[reciver] += amount;
    }

    function getBalance(address payable user) public view returns(uint256){
        return balances[user];
    }

    function grantAccess(address payable user) public{
        require(msg.sender == owner, "Only the owner can grant the access");
        owner = user;
    }

    function revokeAccess(address payable user) public {
        require(msg.sender == owner, "Only the owner can revoke access. ");
        require(user != owner, "Cannot revoke access for the current owner");
        owner = payable(msg.sender);
    }

    function destroy() public{
        require(msg.sender == owner, "Only the owner can destroy the contract.");
        selfdestruct(owner);
    }
}