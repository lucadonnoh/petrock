// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;
import "../@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "../@openzeppelin/contracts/math/SafeMath.sol";
import "./PetRockFactory.sol";

contract PetRockOwnership is IERC721, PetRockFactory {
    using SafeMath for uint256;

    mapping(uint => address) petrockApprovals;

    constructor() {

    }

    function balanceOf(address owner) external view returns (uint256 balance) {
        return ownerPetrockCount[owner];
    }

    function ownerOf(uint256 id) external view returns (address owner) {
        return petrockToOwner[id];
    }

    function _transfer(address _from, address _to, uint256 _tokenId) private {
        ownerPetrockCount[_to]++;
        ownerPetrockCount[_from]--;
        petrockToOwner[_tokenId] = _to;
        Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
        require(_from != address(0), "The from address can't be the zero address");
        require(_to != address(0), "The to address can't be the zero address");
        require(petrockToOwner[_tokenId] == _from, "The from address doesn't own the token");
        require(_from == msg.sender || petrockApprovals[_tokenId] == msg.sender, "You can't transfer the token, check if you own it or you are approved");
        _transfer(_from, _to, _tokenId);
    }
}
