// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

interface IERC721 {
    function transferFrom(address _from, address _to, uint256 _nftid) external;
}

contract MiniAuction {
    uint private constant auctionLength = 4 days;

    // initialize IERC contract
    IERC721 public immutable nft;
    // declare global variables
    uint public immutable nftId;

    address payable public seller;
    uint public immutable startingPrice;
    uint public immutable startAt;
    uint public immutable expiresAt;
    uint public immutable discountRate;

    // have owner input starting price, discount rate, nft address, and nft id on contract creation
    constructor (
        uint _startingPrice,
        uint _discountRate,
        uint _nft,
        uint _nftId
    ) {
    // initialize nft contract
    nft = IERC721(_nft);
    // initialize variables
    nftId = _nftId;
    discountRate = _discountRate;
    startingPrice = _startingPrice;
    startAt = block.timestamp;
    expiresAt = block.timestamp + auctionLength;
    seller = payable(msg.sender);

    require(_startingPrice >= discountRate * auctionLength, "starting price is too low" );
    }

    // gets the current price/bid of the NFT
    function getPrice ()public view returns (uint256) {
        uint timeElasped = block.timestamp - startAt;
        uint discount = discountRate + timeElasped;
        return startingPrice - discount;
    }

    function buy ()external payable {
        // makes sure auction is expired
        require(block.timestamp < expiresAt, "auction has already expired");

        // make sure the bid is higher than the current price
        uint Price = getPrice();
        require(msg.value > Price, "Bid is not high enough");

        nft.transferFrom(seller, msg.sender, nftId);

        // issue refund if amount is greater than 0
        uint refund = msg.value - Price;
        if (refund > 0) {
            payable(msg.sender).transfer(refund);
        }
        // destruct seller contract
        selfdestruct(seller);
    }
}

