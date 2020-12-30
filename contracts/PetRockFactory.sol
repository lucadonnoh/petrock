//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.7.0;

import "../interfaces/IERC20.sol";

contract PetRockFactory {

    address private owner;
    address private wBtcAddr = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
    IERC20 private wBTC = IERC20(wBtcAddr);
    uint256 exchangeValue = 0;
    
    constructor() {
        owner = msg.sender;
    }
    
    function sendPetRock() public view {

    }

    function getAllowance() public view returns(uint256) {
        return wBTC.allowance(msg.sender, address(this)); 
    }
    
    function getPetRock(uint256 amount) public {
        require(amount == exchangeValue, "You need to send 1 fungible pet rock");
        uint256 allowance = wBTC.allowance(msg.sender, address(this));
        require(allowance >= exchangeValue, "You need to check token allowance");
        wBTC.transferFrom(msg.sender, address(this), amount);
        sendPetRock();
    }
}