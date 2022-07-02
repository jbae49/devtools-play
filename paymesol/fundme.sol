// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

  
interface AggregatorV3Interface {

  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);

  // getRoundData and latestRoundData should both raise "No data present"
  // if they do not have data to report, instead of returning unset values
  // which could be misinterpreted as actual reported values.
  function getRoundData(uint80 _roundId)
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );

  function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );
}
contract FundMe {

    mapping(address => uint256) public addressToAmountFunded;

    function fund() public payable {
        addressToAmountFunded[msg.sender] += msg.value;
        // what the ETH -> USD conversion rate  
    
    }

    function getVersion() public view returns(uint256) {
        // we have a contract that has these functions defined in that interface, located at this address
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();
   }

   function getPrice() public view returns(uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer*1000000000);
   }

    // 1000000000
   function getConversionRate(uint256 ethAmount) public view returns(uint256) {
       uint256 ethPrice = getPrice();
       uint ethAmountInUsd = (ethPrice * ethAmount) / 100000000000000000;
       return ethAmountInUsd;
   }
}

// So What's the cheapest way to pay employees in crypto
// For ex. metamask apple pay looks the easiest but it's stupid to buy more eth to pay employees every single month
// then should my boss buy 1yr salary of eth and then send out monthly?
// in terms of gas what way would be the cheapest