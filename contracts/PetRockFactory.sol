//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.7.0;

import "../interfaces/IERC20.sol";

contract PetRockFactory {

    address private god;
    address private wBtcAddr = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
    IERC20 private wBTC = IERC20(wBtcAddr);
    uint256 exchangeValue = 0;

    struct PetRock {
        string name;
    }

    PetRock[] public petrocks;

    mapping(uint => address) petrockToOwner;
    mapping(address => uint) ownerPetrockCount;

    modifier onlyGod() {
        require(msg.sender == god);
        _;
    }
    
    constructor() {
        god = msg.sender;
    }

    function getAllowance() public view returns(uint256) {
        return wBTC.allowance(msg.sender, address(this)); 
    }
    
    function createPetRock(string memory _name, uint256 _amount) public {
        require(_amount == exchangeValue, "You need to send 1 fungible pet rock");
        uint256 allowance = wBTC.allowance(msg.sender, address(this));
        require(allowance >= exchangeValue, "You need to check token allowance");
        wBTC.transferFrom(msg.sender, address(this), _amount);
        
        uint id = petrocks.length;
        petrocks.push(PetRock(_name));
        petrockToOwner[id] = msg.sender;
        ownerPetrockCount[msg.sender]++;
    }
}