# Dutch Auction

> A dutch-auction implementation

A dutch auction can be set up by the owner of an NFT. `The startingPrice`, `discountRate`, `_nft`, and `_nftId` can be pre-set. If no one bids during the live auction, the `discountRate` is implemented to make the price of the NFT more appealing. The `auctionLength` is 4 days. Losers of the auction are refunded at the end of the auction.

[Contract Source](src/mini-auction.sol)
