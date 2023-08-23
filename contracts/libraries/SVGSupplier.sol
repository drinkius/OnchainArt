// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import '@openzeppelin/contracts/utils/Strings.sol';
import 'base64-sol/base64.sol';
import './HexStrings.sol';

library SVGSupplier {
    using Strings for uint256;

    struct SVGParams {
        uint256 tokenId;
        string releaseDate;
        uint256 reward;
        string tokenSymbol;
        string color0;
        string color1;
    }

    function generateSVG(SVGParams memory params) internal pure returns (string memory svg) {
        return
            string(
                abi.encodePacked(
                    generateSVGDefs(params),
                    generateSVGFigures(params),
                    '</svg>'
                )
            );
    }

    function generateSVGDefs(SVGParams memory params) private pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<svg width="512" height="512" viewBox="0 0 512 512" fill="none" xmlns="http://www.w3.org/2000/svg">',
                '<defs>',
                '<linearGradient id="g1" x1="0%" y1="50%" >',
                generateSVGColorPartOne(params),
                generateSVGColorPartTwo(params),
                '</linearGradient></defs>'
            )
        );
    }

    function generateSVGColorPartOne(SVGParams memory params) private pure returns (string memory svg) {
        string memory values0 = string(abi.encodePacked('#', params.color0, '; #', params.color1));
        string memory values1 = string(abi.encodePacked('#', params.color1, '; #', params.color0));
        svg = string(
            abi.encodePacked(
                '<stop offset="0%" stop-color="#',
                params.color0,
                '" >',
                '<animate id="a1" attributeName="stop-color" values="',
                values0,
                '" begin="0; a2.end" dur="3s" />',
                '<animate id="a2" attributeName="stop-color" values="',
                values1,
                '" begin="a1.end" dur="3s" /></stop>'
            )
        );
    }

    function generateSVGColorPartTwo(SVGParams memory params) private pure returns (string memory svg) {
        string memory values0 = string(abi.encodePacked('#', params.color0, '; #', params.color1));
        string memory values1 = string(abi.encodePacked('#', params.color1, '; #', params.color0));
        svg = string(
            abi.encodePacked(
                '<stop offset="100%" stop-color="#',
                params.color1,
                '" >',
                '<animate id="a3" attributeName="stop-color" values="',
                values1,
                '" begin="0; a4.end" dur="3s" />',
                '<animate id="a4" attributeName="stop-color" values="',
                values0,
                '" begin="a3.end" dur="3s" /></stop>'
            )
        );
    }

    function generateSVGText(SVGParams memory params) private pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<g fill="black" font-family="Impact" font-size="24"><text x="20" y="40" >',
                params.tokenSymbol,
                ' Bonding NFT',
                '</text><text x="20" y="70">Bond reward, ',
                params.tokenSymbol,
                ' wei: ',
                params.reward.toString(),
                '</text><text x="20" y="100">Claim after: ',
                params.releaseDate,
                '</text><text x="20" y="482">ID: ',
                params.tokenId.toString(),
                '</text></g>'
            )
        );
    }

    function generateSVGFigures(SVGParams memory params) private pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<rect id="r" x="0" y="0" rx="15" ry="15" width="512" height="512" fill="url(#g1)" />',
                generateSVGText(params),
                '<g fill="#00A3FF"></g>',
                '<path d="',
                /* start SVG path */
                'M13,1a1,1,0,0,1,1-1A10.011,10.011,0,0,1,24,10a1,1,0,0,1-2,0,8.009,8.009,0,0,0-8-8A1,1,0,0,1,13,1Zm1,5a4,4,0,0,1,4,4,1,1,0,0,0,2,0,6.006,6.006,0,0,0-6-6,1,1,0,0,0,0,2Zm9.093,10.739a3.1,3.1,0,0,1,0,4.378l-.91,1.049c-8.19,7.841-28.12-12.084-20.4-20.3l1.15-1A3.081,3.081,0,0,1,7.26.906c.031.031,1.884,2.438,1.884,2.438a3.1,3.1,0,0,1-.007,4.282L7.979,9.082a12.781,12.781,0,0,0,6.931,6.945l1.465-1.165a3.1,3.1,0,0,1,4.281-.006S23.062,16.708,23.093,16.739Zm-1.376,1.454s-2.393-1.841-2.424-1.872a1.1,1.1,0,0,0-1.549,0c-.027.028-2.044,1.635-2.044,1.635a1,1,0,0,1-.979.152A15.009,15.009,0,0,1,5.9,9.3a1,1,0,0,1,.145-1S7.652,6.282,7.679,6.256a1.1,1.1,0,0,0,0-1.549c-.031-.03-1.872-2.425-1.872-2.425a1.1,1.1,0,0,0-1.51.039l-1.15,1C-2.495,10.105,14.776,26.418,20.721,20.8l.911-1.05A1.121,1.121,0,0,0,21.717,18.193Z',
                /* end SVG path */
                '" style="fill-rule:evenodd;clip-rule:evenodd;fill:#020203" transform="matrix(1.00154 0 0 1.00076 127.605 127.906)"/>'
            )
        );
    }
}
