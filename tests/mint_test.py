import pytest
from brownie import PetRockNFT, WBTC, accounts

@pytest.fixture
def exValue():
    return 10**8;

@pytest.fixture
def contracts():
    wbtc = WBTC.deploy({'from': accounts[5]})
    prf = PetRockNFT.deploy(wbtc, {'from': accounts[1]})
    return [prf, wbtc]

def test_mint(contracts, exValue, web3):
    # contracts
    prf = contracts[0]
    wBTC = contracts[1]

    # accounts
    satoshi = accounts[5]
    minter = accounts[0]
    god = accounts[1]

    # send wBTC to minter and check balance
    wBTC.mint(minter, 10**9, {'from': satoshi})
    balance = wBTC.balanceOf(minter)
    print("minter balance    : ", balance)
    assert balance == 10**9 

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