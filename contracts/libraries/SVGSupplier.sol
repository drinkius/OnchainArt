// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import '@openzeppelin/contracts/utils/Strings.sol';
import 'base64-sol/base64.sol';
import './HexStrings.sol';

library SVGSupplier {
    using Strings for uint256;

    struct SVGParams {
        uint256 tokenId;
        string svgPath;
        string scale;
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
                ' NFT',
                /* Unneeded params for now
                '</text><text x="20" y="70">Bond svgPath, ',
                params.tokenSymbol,
                ' wei: ',
                params.svgPath.toString(),
                '</text><text x="20" y="100">Claim after: ',
                params.releaseDate,
                */
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
                params.svgPath,
                /* end SVG path */
                '" style="fill-rule:evenodd;clip-rule:evenodd;fill:#020203" transform="matrix(1 0 0 1 128 128) ',
                'scale(',
                params.scale,
                ')"/>'
            )
        );
    }
}
