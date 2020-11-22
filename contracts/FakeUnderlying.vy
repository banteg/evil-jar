# @version 0.2.7

target: address


@external
def __init__(_target: address):
    self.target = _target


@view
@external
def balanceOf(src: address) -> (address):  # payload
    return self.target


@external
def approve(dst: address, amt: uint256) -> (bool):
    return True


@view
@external
def allowance(src: address, dst: address) -> (uint256):
    return 0
