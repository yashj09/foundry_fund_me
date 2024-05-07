// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "../lib/forge-std/src/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
contract FundMeTest is Test {
    FundMe fundMe;
    function setUp() external {
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }
    function testMinDollar() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }
    function testOwner() public view {
        assertEq(fundMe.I_OWNER(), msg.sender);
    }
    function testVersion() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }
    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert();
        fundMe.fund();
    }
}
