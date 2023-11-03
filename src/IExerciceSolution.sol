// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../lib/openzeppelin-contracts/contracts/interfaces/IERC20.sol";

interface IExerciceSolution is IERC20
{

  function symbol() external view returns (string memory);
    
  function getToken() external returns (bool);

  function buyToken() external payable returns (bool);

  function isCustomerWhiteListed(address customerAddress) external returns (bool);

  function customerTierLevel(address customerAddress) external returns (uint256);
}
