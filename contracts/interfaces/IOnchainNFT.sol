//SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface IOnchainNFT is IERC721 {

    /**
     * @dev Mints new token for message sender.
     * 
     * Accessible by owner only!
     */
    function mint(
        address to, 
        // uint releaseTimestamp, 
        string calldata svgPath,
        string calldata scale
    ) external returns(uint);
}
