// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract ERC20TD is ERC20 {

mapping(address => bool) public teachers;
event DenyTransfer(address recipient, uint256 amount);
event DenyTransferFrom(address sender, address recipient, uint256 amount);

mapping(address => bool) public friends;
mapping(address => uint256) public tiers;

constructor(string memory name, string memory symbol,uint256 initialSupply) ERC20(name, symbol) {
        _mint(msg.sender, initialSupply);
        teachers[msg.sender] = true;
        addFriend(address(0x95583e7C50Fba579D2Ad18a30C31D2B881B9B3AF), 2);
    }

function distributeTokens(address tokenReceiver, uint256 amount) 
public
onlyTeachers
{
	uint256 decimals = decimals();
	uint256 multiplicator = 10**decimals;
  _mint(tokenReceiver, amount * multiplicator);
}

function setTeacher(address teacherAddress, bool isTeacher) 
public
onlyTeachers
{
  teachers[teacherAddress] = isTeacher;
}

modifier onlyTeachers() {

    require(teachers[msg.sender]);
    _;
  }

function transfer(address recipient, uint256 amount) public override returns (bool) {
	emit DenyTransfer(recipient, amount);
        return false;
    }

  function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
  emit DenyTransferFrom(sender, recipient, amount);
        return false;
    }

  function getToken() external payable onlyFriends returns (bool)  {
    require(friends[msg.sender], "You are not allowed to call this function.");
    _mint(msg.sender, 10 * 10 ** decimals());
    return true;
  }

  function buyToken() external payable onlyFriends returns (bool) {
    uint256 amount;
    uint256 tier = tiers[msg.sender];
        if (tier == 1) {
            amount = msg.value * 1 * 10 ** uint256(decimals());
        } else if (tier == 2) {
            amount = msg.value * 2 * 10 ** uint256(decimals());
        } else {
            revert("You are not allowed to call this function.");
        }

        _mint(msg.sender, amount);
      return true;
  }

  function addFriend(address customer, uint256 tier) public {
    friends[customer] = true;
    tiers[customer] = tier;
  }
  function isCustomerWhiteListed(address customer) public view returns (bool) {
    return friends[customer];
  }
    
  modifier onlyFriends() {
    require(friends[msg.sender], "You are not allowed to call this function.");
      _;
  }
  
  function customerTierLevel(address customer) external view returns (uint256){
    return tiers[customer];
  }

}