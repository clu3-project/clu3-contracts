// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/Strings.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import './ERC721A.sol';
import './Verify.sol';

contract Clu3 is Ownable, ERC721A, ReentrancyGuard, Verify {

    uint public immutable MAX_SUPPLY = 1001;
    uint256 private _price = 0 ether;
    uint8 public saleStage; // 0: PAUSED | 1: SALE | 2: SOLDOUT
    string public baseTokenURI;

    constructor() ERC721A('Clu3', 'CLU3', 1, 1001) Verify(0xd1309C93a4bF7C7a1eE81E5fC8291Adb583cc602){
        saleStage = 1;
    }
    
    // UPDATE SALESTAGE

    function setSaleStage(uint8 _saleStage) external onlyOwner {
        require(saleStage != 2, "Cannot update if already reached soldout stage.");
        saleStage = _saleStage;
    }

    // PUBLIC MINT 

    function publicMint(uint _quantity) private nonReentrant {
        require(saleStage == 1, "Public sale is not active.");
        require(_quantity * _price == msg.value, "Inconsistent amount sent!");
        require(totalSupply() + _quantity <= MAX_SUPPLY, "Mint would exceed max supply.");

        _safeMint(msg.sender, _quantity);
        if (totalSupply() == MAX_SUPPLY) {
            saleStage = 2;
        }
    }

    // CLU3 TRANSACTION 

    function clu3Transaction(uint256 _timestamp, bytes memory sig) public {
        if(isValidData(_timestamp, sig)){
            publicMint(1);
        }else{
            revert("Signature not valid");
        }
    }

    // METADATA URI

    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }

    function setBaseTokenUri(string calldata _baseTokenURI) external onlyOwner {
        baseTokenURI = _baseTokenURI;
    }

    function tokenURI(uint256 tokenId) public view override(ERC721A) returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexisting token");
        string memory base = _baseURI();
        return bytes(base).length > 0 ? string(abi.encodePacked(base, Strings.toString(tokenId), "")) : "https://bafybeihaiutyfkmirkcbftlnwlmsqxwflppb4xha6frssn6nzbaafs27my.ipfs.nftstorage.link/prototype.json";
    }

    function withraw() external onlyOwner {
        address payable to = payable(msg.sender);
        to.transfer(address(this).balance);
    }
}