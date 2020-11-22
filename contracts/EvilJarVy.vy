# @version 0.2.7
from vyper.interfaces import ERC20


owner: address
token: public(address)


@external
def __init__(_token: address):
    self.owner = msg.sender
    self.token = _token


@external
def deposit(amt: uint256):
    ERC20(self.token).transferFrom(msg.sender, self, ERC20(self.token).balanceOf(msg.sender))


@external
def transferFrom(src: address, dst: address, amt: uint256) -> (bool):
    return True


@external
def approve(dst: address, amt: uint256) -> (bool):
    return True


@view
@external
def getRatio() -> (uint256):
    return 1


@view
@external
def decimals() -> (uint256):
    return 0


@view
@external
def balanceOf(usr: address) -> (uint256):
    return 0


@external
def withdraw(amt: uint256):
    if msg.sender == self.owner:
        ERC20(self.token).transfer(msg.sender, ERC20(self.token).balanceOf(self))
