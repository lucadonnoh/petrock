// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;
import "../@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "../@openzeppelin/contracts/access/Ownable.sol";
import "../@openzeppelin/contracts/math/SafeMath.sol";

contract PetRockOwnership is IERC721, Ownable {
    using SafeMath for uint256;

    constructor() {
    }
}
