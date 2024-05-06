// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "../lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5 * 1e18;
    address[] public funders;
    AggregatorV3Interface private s_priceFeed;
    mapping(address funder => uint256 amountFunded) public addresstofunded;
    address public immutable I_OWNER;
    constructor(address priceFeed) {
        I_OWNER = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }
    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }
    function fund() public payable {
        require(
            msg.value.getConversion(s_priceFeed) > MINIMUM_USD,
            "didn't have enough ETH"
        );
        funders.push(msg.sender);
        addresstofunded[msg.sender] += msg.value;
    }

    function Withdraw() public {
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            addresstofunded[funder] = 0;
        }
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call Failed");
    }
    modifier onlyOwner() {
        require((msg.sender == I_OWNER), "Must be Owner Only");
        _;
    }
}
