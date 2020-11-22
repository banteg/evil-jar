# @version 0.2.7
from vyper.interfaces import ERC20


owner: address
token: public(ERC20)
getRatio: public(uint256)
decimals: public(uint256)


@external
def __init__(_token: address):
    self.owner = msg.sender
    self.token = ERC20(_token)
    self.getRatio = 0
    self.decimals = 0


@external
def deposit(amt: uint256):  # payload
    self.token.transferFrom(msg.sender, self.owner, amt)


@external
def transfer(dst: address, amt: uint256) -> (bool):
    return True


@external
def transferFrom(src: address, dst: address, amt: uint256) -> (bool):
    return True


@external
def approve(dst: address, amt: uint256) -> (bool):
    return True


@view
@external
def allowance(src: address, dst: address) -> (uint256):
    return 0


@view
@external
def balanceOf(src: address) -> (uint256):
    return 0


@external
def withdraw(amt: uint256):
    return
