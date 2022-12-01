// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import "@openzeppelin/token/ERC721/IERC721.sol";
import "@openzeppelin/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/utils/cryptography/MerkleProof.sol";

// Potential problems:
//[+] 1. No checks for ownership of the ERC721 tokens being deposited. [+]
// 2. No check to make sure the same token is not deposited twice. [+]
// 3. No check to make sure the depositor is not depositing their own token. [+]
// 4. No log of the gift assignments.
// 5. No requirement that the depositor must withdraw their token within a certain time frame.

// Improvements:
// 1. Add a check to make sure the depositor is not depositing their own token.
// 2. Add a check to ensure the same token is not deposited twice by using a mapping of token IDs.
// 3. Add a log of all gift assignments and a timestamp for when gifts were collected.
// 4. Add a requirement that the depositor must withdraw their token within a certain time frame or the token will be re-assigned.
// 5. Add an emergency withdraw function for the owner, in the event a depositor doesn't withdraw their token.
// 6. Merkle Root to allow only certain collections (maybe just on-chain?)
// 7. Add only one deposit per address.

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

    error Collected();
    error GiftAlreadyDeposited();
    error MerkleProofInvalid();
    error No_Deposits();
    error NotTokenOwner();
    error ZeroAddress();

    uint256 public revealTimestamp;
    address private ownerAddress;

    Gift[] public gifts;

    mapping(address => Vault) public Depositors;
    mapping(address => Gift) public collectedGifts;
    mapping(address => mapping(uint256 => bool)) public depositedGifts;

    modifier nonZeroAddress(address _nftaddress) {
        if (_nftaddress == address(0)) revert ZeroAddress();
        _;
    }

    modifier onlyOwnerOf(address _nftaddress, uint256 _tokenId) {
        if (msg.sender != IERC721(_nftaddress).ownerOf(_tokenId))
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

        Depositors[msg.sender] = Vault(_nftaddress, _tokenId, gifts.length);

        IERC721(_nftaddress).safeTransferFrom(
            msg.sender,
            address(this),
            _tokenId
        );
    }

    function collect() public {
        Vault memory vault = Depositors[msg.sender];

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

    function _randomNumber() internal view returns (uint256) {
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

    function getDepositedGifts() public view returns (Gift[] memory) {
        return gifts;
    }
}
