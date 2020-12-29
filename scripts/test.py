from brownie import PetRock, accounts

def main():
    petrock = PetRock.deploy({'from': accounts[0]})
    petrock.getPetRock(100000000)
