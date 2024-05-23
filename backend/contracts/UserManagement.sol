// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { UltraVerifier } from '../circuits/createAccount/contract/createAccount/plonk_vk.sol';

contract UserManagement {
  UltraVerifier verifier;

  uint32 private constant _HAS_VOTED = 1;
  uint32 private constant _NOT_VOTED = 2;

  struct User {
    uint id;
    string userName;
    bytes houseAddress;
    uint32 voted;
  }

  event userCreated(uint userId, bool createdSuccessfully);

  address owner;
  uint256 private currentUserID = 1;
  mapping(address => User) private users;

  constructor(address verifierAddy) {
    verifier = UltraVerifier(verifierAddy);
    owner = msg.sender;
  }

  function createUser(
    string calldata _userName,
    bytes calldata proof,
    uint256 userAddressHashed
  ) external {
    require(users[msg.sender].id == 0, 'User already created');

    bytes32[] memory publicInputs = new bytes32[](1);
    publicInputs[0] = bytes32(userAddressHashed);
    require(verifier.verify(proof, publicInputs), 'Invalid Proof');

    User memory newUser = User(
      currentUserID,
      _userName,
      abi.encodePacked(userAddressHashed),
      _NOT_VOTED
    );

    users[msg.sender] = newUser;
    currentUserID++;
    emit userCreated(currentUserID, true);
  }

  function getUser() external view returns (User memory) {
    return users[msg.sender];
  }

  function convertString(
    string calldata currentWord
  ) external pure returns (bytes memory) {
    return bytes(currentWord);
  }
}
