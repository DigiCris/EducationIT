// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// En truffle para que estos archivos existan deben poner:
// npm install @openzeppelin/contracts
// en remix al compilar el npm se corre solito
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC721, ERC721URIStorage, Ownable {

    uint256 public tokenId;

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}

//formato de IpfsUri a usar (ejemplo)= https://gateway.pinata.cloud/ipfs/QmVTMeyMvEiZScJcjbPATxvRqkY25EQSWkJYML8aqwK5bD/semilla.json
    function safeMint(address to, string calldata IPFS) public onlyOwner
    {
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, IPFS);
        tokenId++;
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 _tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(_tokenId);
    }

    function tokenURI(uint256 _tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(_tokenId);
    }
}