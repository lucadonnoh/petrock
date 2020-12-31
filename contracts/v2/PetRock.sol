// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

import "../@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract PetRockNFT is ERC721 {
    address private god;
    address private wBtcAddr = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
    IERC20 private wBTC = IERC20(wBtcAddr);
    uint256 exchangeValue = 10**8;

    string private petrockTokenURI;

    struct PetRock {
        string name;
    }

    PetRock[] public petrocks;

    modifier onlyGod() {
        require(_msgSender() == god, "You're not god");
        _;
    }

    constructor() ERC721("PETROCK", "NFPR") {
        god = _msgSender();
        petrockTokenURI = "";
    }

    function mintNewPetRock(address _to, string memory _name, uint256 _amount) public {
        require(_amount == exchangeValue, "You need to send 1 fungible pet rock");
        uint256 allowance = wBTC.allowance(_msgSender(), address(this));
        require(allowance >= exchangeValue, "You need to check token allowance");
        wBTC.transferFrom(_msgSender(), god, _amount);
        uint256 _tokenId = totalSupply();
        super._mint(_to, _tokenId);
        super._setTokenURI(_tokenId, petrockTokenURI);
        petrocks.push(PetRock(_name));
    }

}
