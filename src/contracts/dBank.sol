// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "./Token.sol";

contract dBank {
    // mappings
    mapping(address => uint) public etherBalanceOf;
    mapping(address => uint ) public depositStart;
    mapping(address => bool) public isDeposited;
    // assigning Token contract to variable
    Token private token;

    event Deposit(address indexed user, uint etherAmount, uint timeStart);

    constructor(Token _token) public {
        token = _token;
    }    
    function deposit() payable public  {
        // condition wherein the deposit should be rejected
        require(isDeposited[msg.sender] == false, "Error, deposit is already active");
        require(msg.value >= 1e16, "Error, deposit should be > 0.01 ETH");

        etherBalanceOf[msg.sender] += msg.value;
        depositStart[msg.sender] += block.timestamp;
        isDeposited[msg.sender] = true;
        emit Deposit(msg.sender, msg.value, block.timestamp);
    }

    function withdraw() payable public {
        // check if there is some deposits
        require(isDeposited[msg.sender] == true, "Error, no previous deposit");
        
        uint userBalance = etherBalanceOf[msg.sender];
        uint depositTime = block.timestamp - depositStart[msg.sender];

        // interest is calculated as the amount deposited / 1e16   
        uint interestPerSecond = 31668017 * (userBalance / 1e16);
        uint interest = interestPerSecond * depositTime; 

        // send ether back to user
        msg.sender.transfer(userBalance);

        // reset etherBalance of user to 0
        etherBalanceOf[msg.sender] = 0;
        depositStart[msg.sender] = 0;
        isDeposited[msg.sender] = false;
        
        // mint tokens 
        token.mint(msg.sender, interest);
    }
}
