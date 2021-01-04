import pytest
import brownie
from brownie import PetRockNFT, WBTC, accounts
from brownie.test import given, strategy

@pytest.fixture
def exValue():
    return 10**8;

@pytest.fixture
def contracts():
    wbtc = WBTC.deploy({'from': accounts[5]})
    prf = PetRockNFT.deploy(wbtc, {'from': accounts[1]})
    return [prf, wbtc]

@given(numTokens=strategy('uint256', min_value=10**8, max_value=21*10**6*10**8))
def test_mint(contracts, exValue, numTokens, web3):
    # contracts
    prf = contracts[0]
    wBTC = contracts[1]

    # accounts
    satoshi = accounts[5]
    minter = accounts[0]
    god = accounts[1]

    # send wBTC to minter and check balance
    wBTC.mint(minter, numTokens, {'from': satoshi})
    balance = wBTC.balanceOf(minter)
    print("minter balance    : ", balance)
    assert balance == numTokens

    # approve wBTC to PetRockNFT to spend on behalf of minter and check that it worked
    wBTC.approve(prf.address, exValue, {'from': str(minter)})
    allowance = wBTC.allowance(minter.address, web3.toChecksumAddress(prf.address))
    print("minter allowance  : ", allowance)
    assert allowance == exValue

    # minter mints petrock 
    prf.mintNewPetRock(minter, "Fabio", 10**8, {'from': str(minter)})

    # check minter new balance
    newBalance = wBTC.balanceOf(minter)
    print("minter new balance: ", newBalance)
    assert newBalance == balance-10**8

    # check mint worked
    assert prf.totalSupply() == 1
    assert prf.balanceOf(minter) == 1
    assert str(prf.ownerOf(0)) == minter.address

@given(numTokens=strategy('uint256', min_value=0, max_value=10**8-1))
def test_mint_insufficientBalance(contracts, numTokens, exValue, web3):
    # contracts
    prf = contracts[0]
    wBTC = contracts[1]

    # accounts
    satoshi = accounts[5]
    minter = accounts[0]
    god = accounts[1]

    # send wBTC to minter and check balance
    wBTC.mint(minter, numTokens, {'from': satoshi})
    balance = wBTC.balanceOf(minter)
    print("minter balance    : ", balance)
    assert balance == numTokens
    wBTC.approve(prf.address, numTokens, {'from': str(minter)})

    with brownie.reverts("You need to send 1 wBTC"):
        prf.mintNewPetRock(minter, "Reverto", 10**8)
    
    assert prf.totalSupply() == 0

