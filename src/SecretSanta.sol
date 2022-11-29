// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import "@openzeppelin/token/ERC721/IERC721.sol";
import "@openzeppelin/token/ERC721/utils/ERC721Holder.sol";

contract SecretSanta is ERC721Holder {
    struct SantaVault {
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

    uint256 public revealTimestamp;
    address private ownerAddress;

    Gift[] public santasGifts;

    mapping(address => SantaVault) public Depositers;
    mapping(address => Gift) public collectedGifts;

    constructor(uint256 _revealTimestamp, address _ownerAddress) {
        revealTimestamp = _revealTimestamp;
        ownerAddress = _ownerAddress;
    }

    function deposit(address _nftaddress, uint256 _tokenId) public {
        uint256 idx = santasGifts.length;

        santasGifts.push(Gift(_nftaddress, _tokenId));

        Depositers[msg.sender] = SantaVault(_nftaddress, _tokenId, idx);

        IERC721(_nftaddress).safeTransferFrom(
            msg.sender,
            address(this),
            _tokenId
        );
    }

    function collect() public returns (uint256) {
        SantaVault memory santavault = Depositers[msg.sender];

        if (santavault.erc721Address == address(0)) revert No_Deposits();
        if (collectedGifts[msg.sender].erc721Address != address(0))
            revert Collected();
        uint256 giftIdx;

        if (santasGifts.length == 1) {
            giftIdx = 0;
        } else {
            giftIdx = _randomNumber() % santasGifts.length;
        }

        Gift memory gift = santasGifts[giftIdx];

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
                    santasGifts.length,
                    msg.sender
                )
            )
        );
        return randomNumber;
    }
}
