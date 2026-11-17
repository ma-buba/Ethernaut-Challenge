// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721} from "@openzeppelin-contracts/token/ERC721/ERC721.sol";

contract CashbackNFT is ERC721 {
    uint256 private _nextTokenId;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

    /// @notice Mint a Super Cashback NFT to `to`.
    /// @dev Matches the `mint(address)` signature the Cashback contract calls.
    function mint(address to) external {
        _mint(to, _nextTokenId++); 
    }
}