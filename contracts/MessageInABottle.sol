// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Library.sol";

contract MessageInABottle is ERC721, Ownable {

    using Library for uint8;
    using ECDSA for bytes32;

    uint public totalSupply;
    mapping(uint256 => string) internal _message;

    
    constructor() ERC721("MessageInABottle", "MIAB") {
    }


    
    function sendMessage(string memory message, address to) external payable {
        
        totalSupply++;

        uint256 thisTokenId = totalSupply;
  
        _message[thisTokenId] = message;

        _mint(to, thisTokenId);  

    }


   /**
     * @dev Hash to SVG function
     */
    function SVG(uint tokenId)
        public
        view
        returns (string memory)
    {

        string memory svgString = string(
            abi.encodePacked(

                "<svg viewBox='0 0 240 80' xmlns='http://www.w3.org/2000/svg'><style>.small { font: italic 13px sans-serif; }</style><text x='55' y='55' class='small'>",
                _message[tokenId],
                "</text></svg>")
        );

        return svgString;
    }

    /**
     * @dev Hash to metadata function
     */
    function metadata()
        public
        view
        returns (string memory)
    {
        string memory metadataString = string(abi.encodePacked('{"display_type": "Message", "trait_type": "Message", "value":',"message",'}'));

        return string(abi.encodePacked("[", metadataString, "]"));
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Library.encode(
                        bytes(
                            string(
                                abi.encodePacked(
                                    '{"name": "Message #',
                                    Library.toString(_tokenId),
                                    '", "description": " A message", "image": "data:image/svg+xml;base64,',
                                    Library.encode(
                                        bytes(SVG(_tokenId))
                                    ),
                                    '","attributes":',
                                    metadata(),
                                    "}"
                                )
                            )
                        )
                    )
                )
            );
    }

}