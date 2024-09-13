// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EventNFT is ERC721, Ownable(msg.sender) { 

    mapping(address => bool) public hasMinted;

    constructor() ERC721("EventNFT", "ENFT") {}

    function mintNft(uint256 _eventId) external {
        require(!hasMinted[msg.sender], "You have already minted the NFT");

        _safeMint(msg.sender, _eventId);
        hasMinted[msg.sender] = true; 
    }

}