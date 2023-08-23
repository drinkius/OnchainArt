// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';

import './NFT.sol';
import './libraries/NFTDescriptor.sol';
import './libraries/BokkyPooBahsDateTimeLibrary.sol';
// import './interfaces/IBokkyPooBahsDateTimeLibrary.sol';
import './libraries/HexStrings.sol';
import './interfaces/IOnchainNFT.sol';
import './interfaces/AdminAccess.sol';

contract OnchainArt is NFT, IOnchainNFT, AdminAccess {

    using SafeERC20 for IERC20;
    using Strings for uint256;

    // /* ========== CONSTANTS ========== */
    // address public bokkyPooBahsAddress;

    /* ========== STATE VARIABLES ========== */
    mapping(address => uint[]) public userIds;
    mapping(uint => address) public issuedBy;
    mapping(uint => string) public releaseDates;
    mapping(uint => string) public svgPaths;
    string public collectionSymbol;

    /* ========== CONSTRUCTOR ========== */

    constructor(
        string memory name_, 
        string memory symbol_,
        string memory collectionSymbol_
        // address bokkyPooBahsAddress_
    ) NFT(name_, symbol_) {
        collectionSymbol = collectionSymbol_;
        // bokkyPooBahsAddress = bokkyPooBahsAddress_;
    }

    /* ========== ADMIN FUNCTIONS ========== */
    
    function mint(
        address to, 
        uint releaseTimestamp, 
        string calldata svgPath
    ) public onlyAdminOrOwner returns(uint tokenId) {
        tokenId = _safeMint(to, '');
        userIds[to].push(tokenId);
        issuedBy[tokenId] = msg.sender;
        (uint year, uint month, uint day) = BokkyPooBahsDateTimeLibrary.timestampToDate(releaseTimestamp);
        releaseDates[tokenId] = string(
            abi.encodePacked(
                day.toString(),
                '/',
                month.toString(),
                '/',
                year.toString()
            )
        );
        svgPaths[tokenId] = svgPath;
    }

    /* ========== USER FUNCTIONS ========== */

    function transfer(address to, uint tokenId) public {
        require(ownerOf(tokenId) == msg.sender, "BondStorage: You are not the owner");
        _transfer(msg.sender, to, tokenId);
    }

    /* ========== VIEWS ========== */

    function _tokenURI(uint256 tokenId) internal view virtual override returns (string memory) {
        return
            NFTDescriptor.constructTokenURI(
                NFTDescriptor.URIParams({
                    tokenId: tokenId,
                    releaseDate: releaseDates[tokenId],
                    svgPath: svgPaths[tokenId],
                    tokenSymbol: collectionSymbol
                })
            );
    }

    function userIdsLength(address user) public view returns(uint) {
        return userIds[user].length;
    }
}
