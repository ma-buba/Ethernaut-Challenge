//SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {Privacy} from "../Privacy.sol";

contract PrivacyTest is Test {
    Privacy privacy;

    function setUp() public {
        bytes32[3] memory array;
        array[0] = "kamal";
        array[1] = "flash";
        array[2] = "buba";
        privacy = new Privacy(array);
    }
    function test_Challenge12_Passed() public {
        bytes16 key = bytes16(vm.load(address(privacy), bytes32(uint256(5))));
        privacy.unlock(key);
        assert(!privacy.locked());
    }
}