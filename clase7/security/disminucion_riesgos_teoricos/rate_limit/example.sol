contract RateLimit {
  uint enabledAt = now;
  
  modifier enabledEvery(uint t) {
    require(now >= enabledAt, "Access is denied. Rate limit exceeded.");
    enabledAt = now + t;

    _;
  }
  
  function f() public enabledEvery(1 minutes) {
    // some code
  }
}