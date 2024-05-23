// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract UserManagement {
  uint256 private constant FIELD_MODULUS =
    21888242871839275222246405745257275088548364400416034343698204186575808495617;
  uint32 private constant _HAS_VOTED = 1;
  uint32 private constant _NOT_VOTED = 2;

  struct User {
    uint id;
    string userName;
    bytes32 houseAddress;
    uint32 voted;
  }

  event userCreated(uint userId, bool createdSuccesfully);

  address owner;
  uint256 private currentUserID = 1;
  mapping(address => User) private users;

  constructor() {
    owner = msg.sender;
  }

  function createUser(
    string calldata _userName,
    bytes32 _hiddenAddress
  ) external {
    User memory newUser = User(
      currentUserID,
      _userName,
      _hiddenAddress,
      _NOT_VOTED
    );

    users[msg.sender] = newUser;
    currentUserID++;
    emit userCreated(currentUserID, true);
  }

  function getUser() external view returns (User memory) {
    return users[msg.sender];
  }

  function getAddressAsField(
    string memory userAddress
  ) public pure returns (uint256) {
    uint256 hash = uint256(keccak256(abi.encodePacked(userAddress)));
    return hash % FIELD_MODULUS;
  }
}
