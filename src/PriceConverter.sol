// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {AggregatorV3Interface} from "../lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getVersion() public view returns (uint256) {
        return
            AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306)
                .version();
    }

    function getConversion(uint256 ethAmount, AggregatorV3Interface priceFeed) internal view returns (uint256) {
        
        uint256 ethPrice = getPrice(priceFeed);
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }

    function getPrice(AggregatorV3Interface priceFeed) internal view returns (uint256) {
       
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return uint256(price * 1e10);
    }
}
