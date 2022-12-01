// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import "@openzeppelin/token/ERC721/IERC721.sol";
import "@openzeppelin/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/utils/cryptography/MerkleProof.sol";

// Potential Improvements:
// 1. Add a check to make sure the depositor is not depositing their own token.
// 2. Add a check to ensure the same token is not deposited twice by using a mapping of token IDs.
// 3. Add a log of all gift assignments and a timestamp for when gifts were collected.
// 4. Add a requirement that the depositor must withdraw their token within a certain time frame or the token will be re-assigned.
// 5. Add an emergency withdraw function for the owner, in the event a depositor doesn't withdraw their token.
// 6. Merkle Root to allow only certain collections (maybe just on-chain?)
// 7. Add only one deposit per address.

contract SecretSanta is ERC721Holder {
    /// @notice Individual NFT details + Index
    struct Vault {
        address erc721Address;
        uint256 erc721TokenId;
        uint256 erc721Index;
    }

    /// @notice Gift address & tokenId
    struct Gift {
        address erc721Address;
        uint256 erc721TokenId;
    }

    /*//////////////////////////////////////////////////////////////
                          ERRORS
    //////////////////////////////////////////////////////////////*/
    /// @notice If user has already collected
    error AlreadyCollected();
    /// @notice If user has already deposited
    error GiftAlreadyDeposited();
    /// @notice If user hasn't made any deposits
    error No_Deposits();
    /// @notice If user is not the token owner
    error NotTokenOwner();
    /// @notice If user is not the owner of the contract
    error NotOwner();

    /// @notice Throws error if address = 0
    error ZeroAddress();

    uint256 public reclaimTimestamp;
    address public ownerAddress;

    Gift[] public gifts;

    mapping(address => Vault) public Depositors;
    mapping(address => Gift) public collectedGifts;
    mapping(address => uint256) public DepositCount;

    /*//////////////////////////////////////////////////////////////
                          MODIFIERS
    //////////////////////////////////////////////////////////////*/

    modifier nonZeroAddress(address _nftaddress) {
        if (_nftaddress == address(0)) revert ZeroAddress();
        _;
    }

    modifier onlyOwner() {
        if (msg.sender != ownerAddress) revert NotOwner();
        _;
    }

    modifier onlyOwnerOf(address _nftaddress, uint256 _tokenId) {
        if (msg.sender != IERC721(_nftaddress).ownerOf(_tokenId))
            revert NotTokenOwner();
        _;
    }

    /*//////////////////////////////////////////////////////////////
                          CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(uint256 _reclaimTimestamp) {
        reclaimTimestamp = _reclaimTimestamp;
        ownerAddress = msg.sender;
    }

    /*//////////////////////////////////////////////////////////////
                          SANTA FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @notice Allows users to deposit gifts
    function deposit(address _nftaddress, uint256 _tokenId)
        public
        nonZeroAddress(_nftaddress)
        onlyOwnerOf(_nftaddress, _tokenId)
    {
        IERC721(_nftaddress).safeTransferFrom(
            msg.sender,
            address(this),
            _tokenId
        );

        gifts.push(Gift(_nftaddress, _tokenId));
        DepositCount[msg.sender]++;
        Depositors[msg.sender] = Vault(_nftaddress, _tokenId, gifts.length);
    }

    /// @notice Allows depositors to collect gifts
    function collect() public {
        Vault memory vault = Depositors[msg.sender];

        if (vault.erc721Address == address(0)) revert No_Deposits();
        if (collectedGifts[msg.sender].erc721Address != address(0))
            revert AlreadyCollected();

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

    /*//////////////////////////////////////////////////////////////
                          INTERNAL + ADMIN
    //////////////////////////////////////////////////////////////*/

    /// @notice Random number generator
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

    /// @notice Return index of gifts
    function getDepositedGifts() public view returns (Gift[] memory) {
        return gifts;
    }

    /// @notice Emergency function to withdraw certain NFT
    function adminWithdraw(
        address _nftaddress,
        uint256 _tokenId,
        address recipient
    ) external onlyOwner {
        IERC721(_nftaddress).transferFrom(address(this), recipient, _tokenId);
    }
}
