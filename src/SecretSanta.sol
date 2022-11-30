// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import "@openzeppelin/token/ERC721/IERC721.sol";
import "@openzeppelin/token/ERC721/utils/ERC721Holder.sol";

contract SecretSanta is ERC721Holder {
    struct Vault {
        address erc721Address;
        uint256 erc721TokenId;
        uint256 erc721Index;
    }

    struct Gift {
        address erc721Address;
        uint256 erc721TokenId;
    }

    error No_Deposits();
    error Collected();
    error ZeroAddress();
    error NotTokenOwner();

    uint256 public revealTimestamp;
    address private ownerAddress;

    Gift[] public gifts;

    mapping(address => Vault) public Depositers;
    mapping(address => Gift) public collectedGifts;

    modifier nonZeroAddress(address _nftaddress) {
        if (_nftaddress == address(0)) revert ZeroAddress();
        _;
    }

    modifier onlyOwnerOf(address _nftaddress, uint256 _tokenId) {
        if (msg.sender != ownerOf(_nftaddress, _tokenId))
            revert NotTokenOwner();
        _;
    }

    constructor(uint256 _revealTimestamp, address _ownerAddress) {
        revealTimestamp = _revealTimestamp;
        ownerAddress = _ownerAddress;
    }

    function deposit(address _nftaddress, uint256 _tokenId)
        public
        nonZeroAddress(_nftaddress)
        onlyOwnerOf(_nftaddress, _tokenId)
    {
        gifts.push(Gift(_nftaddress, _tokenId));

        Depositers[msg.sender] = Vault(_nftaddress, _tokenId, gifts.length);

        IERC721(_nftaddress).safeTransferFrom(
            msg.sender,
            address(this),
            _tokenId
        );
    }

    function collect() public returns (uint256) {
        Vault memory vault = Depositers[msg.sender];

        if (vault.erc721Address == address(0)) revert No_Deposits();
        if (collectedGifts[msg.sender].erc721Address != address(0))
            revert Collected();

        uint256 giftIdx;

        if (gifts.length == 1) {
            giftIdx = 0;
        } else {
            giftIdx = _randomNumber() % gifts.length;
        }

        Gift memory gift = gifts[giftIdx];

        IERC721(gift.erc721Address).safeTransferFrom(
            address(this),
            msg.sender,
            gift.erc721TokenId
        );
    }

    function _randomNumber() public view returns (uint256) {
        uint256 randomNumber = uint256(
            keccak256(
                abi.encodePacked(
                    block.difficulty,
                    block.timestamp,
                    gifts.length,
                    block.number,
                    blockhash(block.number - 1),
                    msg.sender,
                    tx.gasprice
                )
            )
        );
        return randomNumber;
    }
}
