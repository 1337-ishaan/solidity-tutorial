// SPDX-License-Identifier 
pragma solidity >=0.6.0 <0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token  is ERC20 { // we use ERC20 because it restricts us with all the available rules
  address public minter; // declaration of minter (creator)

  event MinterChanged(address indexed from, address to);

  constructor() public payable ERC20("Decentralized Bank Currency", "DBC"){
    // assign minter role hear
    minter = msg.sender;
  }

  //function to pass the minting access
  function passMinterRole(address dBank) public returns (bool){
    require(msg.sender == minter, "Error, only owner can pass the minter role");
    minter = dBank;
    emit MinterChanged(msg.sender, dBank);
    return true;
  }

  function mint(address account, uint256 amount) public {
    require(msg.sender == minter, "Error, msg.sender is not a creator of DCB"); // assuring that only the creator can create & mint tokens/coins
    _mint(account, amount);
  }
}