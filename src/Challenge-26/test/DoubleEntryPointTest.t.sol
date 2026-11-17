// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {DoubleEntryPoint, LegacyToken, CryptoVault, Forta, DelegateERC20, IDetectionBot} from "../DoubleEntryPoint.sol";
import "openzeppelin-contracts-08/token/ERC20/ERC20.sol";

contract DoubleEntryPointTest is Test {
    DoubleEntryPoint doubleEntryPoint;
    LegacyToken legacyToken;
    CryptoVault vault;
    Forta forta;
    DetectionBot detectionBot;

    address owner = makeAddr("owner");
    address attacker = makeAddr("attacker");


    function setUp() public {
        vm.startPrank(owner);
        forta = new Forta();
        vault = new CryptoVault(owner);
        legacyToken = new LegacyToken();
        legacyToken.mint(address(vault), 100 ether);
        doubleEntryPoint = new DoubleEntryPoint(address(legacyToken), address(vault), address(forta), owner);
        legacyToken.delegateToNewContract(DelegateERC20(doubleEntryPoint));
        detectionBot = new DetectionBot(forta, vault);
        vm.stopPrank();

        // crypto vault has 100 UNITS of DET token
        // also has 100 units of legacyToken
        assertEq(legacyToken.balanceOf(address(vault)), doubleEntryPoint.balanceOf(address(vault)));
    }
    function test_Challenge26_Passed() public {
        // 1. Find the bug in CryptoVault
        // set the underlying token in crypto vault
        vault.setUnderlying(address(doubleEntryPoint));
        // underlying token which is the DET is not allowed to be swept, 
        vm.expectRevert();
        vault.sweepToken(IERC20(doubleEntryPoint));
        // but underlying tokens can be swept through legacy Token
        vault.sweepToken(IERC20(legacyToken));
        assert(doubleEntryPoint.balanceOf(address(vault)) == 0);
        assert(doubleEntryPoint.balanceOf(owner) == 100 ether);
    }
    function test_Challenge26_Passed2() public {
        // the vault is now protected using the detection bot
        vm.prank(owner);
        forta.setDetectionBot(address(detectionBot));
        vault.setUnderlying(address(doubleEntryPoint));
        
        vm.expectRevert();
        vault.sweepToken(IERC20(doubleEntryPoint));
    }
}

contract DetectionBot {
    Forta forta;
    CryptoVault vault;

    constructor(Forta _forta, CryptoVault _vault) {
        forta = _forta;
        vault = _vault;
    }
    function handleTransaction(address user, bytes calldata msgData) external {
        (,,address origSender) = abi.decode(msgData, (address, uint256, address));
        if (origSender == address(vault)) {
            forta.raiseAlert(user);
        }
    }
}