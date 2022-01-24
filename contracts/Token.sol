//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

/**
 * @title Sample NFT contract
 * @dev Extends ERC-721 NFT contract and implements ERC-2981
 */

contract Token is Ownable, ERC1155 {
    // Address of the royalties recipient
    address private _royaltiesReceiver;

    struct Album {
        address owner;
        uint256 MASTER_NTF_ID;
        uint256 DOWNLOAD_TOKENS_ID;
        uint256 ROYALTY_TOKENS_ID;
        uint256 numberOfDownloadTokens;
        uint256 numberOfRoyaltyTokens;
        uint256 downloadTokenPrice;
        uint256 royaltyTokenPrice;
        uint256 tokensForSale;
        uint256 royaltyTokensSold;
    }

    mapping(uint256 => Album) albums;
    uint256 currentTokenID = 0;

    // Events
    event AlbumCreated(
        address indexed owner,
        uint256 masterNFTID,
        uint256 downloadTokensID,
        uint256 royaltyTokenID
    );
    event DownloadTokenPrice(
        address indexed owner,
        uint256 dateCreated,
        uint256 downloadTokenID,
        uint256 downloadTokenPrice
    );
    event TokensForSale(uint256 albumID, uint256 dateApproved, uint256 amount);

    function createAlbum(
        uint256 _numberOfDownloadTokens,
        uint256 _numberOfRoyaltyTokens,
        uint256 _downloadTokenPrice,
        uint256 _royaltyTokenPrice
    ) external {
        uint256 masterNFTID = currentTokenID;
        _mint(msg.sender, masterNFTID, 1, ""); //Mint master NFT
        currentTokenID += 1;

        uint256 royaltyTokenID = currentTokenID;
        _mint(msg.sender, royaltyTokenID, _numberOfRoyaltyTokens, ""); //Mint Royalty Shares or Tokens
        currentTokenID += 1;

        uint256 downloadTokensID = currentTokenID;
        _mint(msg.sender, downloadTokensID, _numberOfDownloadTokens, ""); //Mint Download Tokens
        currentTokenID += 1;

        albums[masterNFTID].owner = msg.sender;
        albums[masterNFTID].MASTER_NTF_ID = masterNFTID;
        albums[masterNFTID].DOWNLOAD_TOKENS_ID = downloadTokensID;
        albums[masterNFTID].ROYALTY_TOKENS_ID = royaltyTokenID;
        albums[masterNFTID].numberOfDownloadTokens = _numberOfDownloadTokens;
        albums[masterNFTID].numberOfRoyaltyTokens = _numberOfRoyaltyTokens;
        albums[masterNFTID].downloadTokenPrice = _downloadTokenPrice;
        albums[masterNFTID].royaltyTokenPrice = _royaltyTokenPrice;
        albums[masterNFTID].tokensForSale = 0;
        emit AlbumCreated(
            msg.sender,
            masterNFTID,
            downloadTokensID,
            royaltyTokenID
        );
        emit DownloadTokenPrice(
            msg.sender,
            block.timestamp,
            downloadTokensID,
            _downloadTokenPrice
        );
    }

    constructor(address initialRoyaltiesReceiver)
        public
        payable
        ERC1155(
            "https://jjk1k8ehc6ws.usemoralis.com:2053/server/functions/api?_ApplicationId=5mgHy2kpLFIjmySx7yAAJMugLG4wVn1SsnOKZZhn&id={id}"
        )
    {
        _royaltiesReceiver = initialRoyaltiesReceiver;
    }

    /// @notice Getter function for _royaltiesReceiver
    /// @return the address of the royalties recipient
    function royaltiesReceiver() external returns (address) {
        return _royaltiesReceiver;
    }
}
