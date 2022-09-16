//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
//Libraries in solidity are similar to contracts that contain reusable codes. A library has functions that can be called by other contracts. Deploying a common code by creating a library reduces the gas cost.
//Library can't have state variables and can't send ether
library PriceConverter{
     function getPrice() internal view returns(uint256){
        // ABI
        //Address 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        // (uint80 roundId, int price, uint startedAt, uint80 answeredinRound) = priceFeed.latestRoundData();
        (,int price,,,) = priceFeed.latestRoundData();
        return uint256(price * 1e10);
    }

    function getVersion()  internal view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        return priceFeed.version();
    }

    function getConversionRate(uint256 ethAmount)  internal view returns (uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        //Always Multiply before you divide
        return ethAmountInUsd;
    }
}