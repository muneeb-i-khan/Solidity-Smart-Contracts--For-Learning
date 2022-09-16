// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
//This contract gets funds from users
//Withdraws funds
//Sets a minimun funding value in USD

// import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import"./PriceConverter.sol";


contract FundMe {
    using PriceConverter for uint256;
    uint public constant MINIMUM_USD = 50 * 1e18;

        //Now we want to keep track of all people who send money
        address[] public funders;
        mapping(address => uint256) public addressToAmountFunded; //To keep track of which adress sent how much eth
        address public immutable i_owner;
        error NotOwner(); //Custom error to save GAS
        constructor(){
            i_owner = msg.sender;
        }
        function fund() public payable{
        //Want to be able to send a minimum fund amouunt in USD
        //Just Like Wallets, Smart Contracts can hold funds
        //Money maths is done in terms of wei
        //reverting undos any actions before and sends remaining ether back
        // require(msg.value > 1e18, "Didn't send enough ether!0");



        require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't send enough!");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
        //Now we have to convert eth or wei to usd....And this is where chainlink or an oracle network comes in
        //msg.value is the value of eth sent
        //msg.sender is the address of whatever is calling the function 
    }

    // function getPrice() public view returns(uint256){
    //     // ABI
    //     //Address 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
    //     AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
    //     // (uint80 roundId , int price, uint startedAt, uint80 answeredinRound) = priceFeed.latestRoundData();
    //     (,int price,,,) = priceFeed.latestRoundData();
    //     return uint256(price * 1e10);
    // }

    // function getVersion() public view returns(uint256){
    //     AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
    //     return priceFeed.version();
    // }

    // function getConversionRate(uint256 ethAmount) public view returns (uint256){
    //     uint256 ethPrice = getPrice();
    //     uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
    //     //Always Multiply before you divide
    //     return ethAmountInUsd;
    // }

    //Above commented code was putted inside a library PriceConverter.sol
    modifier onlyOwner {
        // require(msg.sender == i_owner, "sender is not owner!");
        _; //This represents rest of code and order of this matters on how the code will execute
    }
    function withdraw() public onlyOwner{
        // require(msg.sender == owner, "sender is not owner!");
        if(msg.sender != i_owner){revert NotOwner();}
        //Reset arrays and also withdraws
        for(uint256 funderIndex = 0;funderIndex<funders.length; funderIndex++){
             address funder = funders[funderIndex];
             addressToAmountFunded[funder] = 0; //After withdrawing set back the mapping to 0
        }

        //Resetting the Array
        funders = new address[](0);
        //denotes that there are 0 elements in the new array

        //msg.sender is of type address so it is typecasted to payable address type
        //Now there are 3 ways to withdraw funds:- transfer, send and call
        //Transfer - Throws error after 2300 GAS
        // payable(msg.sender).transfer(address(this).balance);
        // //Send - throws bool after 2300 GAS
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");
        //call - recommended one
       (bool callSuccess, ) =  payable(msg.sender).call{value: address(this).balance}("");
       require(callSuccess, " Call Failed");
    }
}