// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7; //Telling version of solidity we are using
//^ tells version this and greater than this

contract SimpleStorage {
    //boolean, uint, int, address, bytes are commonly used datatypes in solidity
    // bool hasFavouriteNumber = true;
    // uint8 favouriteNUmber = 5; //uint256 is default
    // string favouiteNumberInText = "Five";
    // int256 favouriteInt = -5;
    // address myAddress = 0x0F035DFE8349315926885C42c68f8c6bCB95913a;
    // bytes32 favouriteBytes = "cat";
    // by default a variable is initialised to 0

    //function
    uint256 public favouriteNumber;
    function store(uint256 _favouriteNumber) public{
        favouriteNumber = _favouriteNumber;
    }
//0xd9145CCE52D386f254917e481eB44e9943F39138

//view and pure functions disallow changes in state
//pure function also dissallow reading from blockchain state
//these two functions don't spend gas
 
 function getFavNumber() public view returns(uint256) {
     return favouriteNumber;
 }
}

