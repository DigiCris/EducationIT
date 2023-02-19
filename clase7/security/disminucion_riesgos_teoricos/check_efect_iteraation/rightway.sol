function auctionEnd() public {

  // 1. Checks
  require(now >= auctionEnd);
  require(!ended);
  
  // 2. Effects
  ended = true;
  
  // 3. Interaction
  beneficiary.transfer(highestBid);
}