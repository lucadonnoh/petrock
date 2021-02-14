//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.7.0;

import "../@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../@openzeppelin/contracts/GSN/Context.sol";

contract PetRockFactory is Context {

    address private god;
    address private wBtcAddr = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
    IERC20 private wBTC = IERC20(wBtcAddr);
    uint256 exchangeValue = 0;

    uint id;

    struct PetRock {
        string name;
    }

    PetRock[] public petrocks;

    mapping(uint => address) petrockToOwner;
    mapping(address => uint) ownerPetrockCount;

    modifier onlyGod() {
        require(_msgSender() == god);
        _;
    }
    
    constructor() {
        god = _msgSender();
        id = 0;
    }

    function getAllowance() public view returns(uint256) {
        return wBTC.allowance(_msgSender(), address(this)); 
    }
    
    function createPetRock(string memory _name, uint256 _amount) public {
        require(_amount == exchangeValue, "You need to send 1 fungible pet rock");
        uint256 allowance = wBTC.allowance(_msgSender(), address(this));
        require(allowance >= exchangeValue, "You need to check token allowance");
        wBTC.transferFrom(_msgSender(), address(this), _amount);
        
        id = petrocks.length;
        petrocks.push(PetRock(_name));
        petrockToOwner[id] = _msgSender();
        ownerPetrockCount[_msgSender()]++;
    }
}