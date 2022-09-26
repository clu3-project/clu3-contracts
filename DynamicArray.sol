// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

contract DynamicArray {
	
    // Declaring state variable
    string[] internal arr;
        
    // Function to add data
    // in dynamic array
    function addData(string memory _word) public
    {
    arr.push(_word);
    }
        
    // Function to get data of
    // dynamic array
    function getData() public view returns(string[] memory)
    {
    return arr;
    }
        
    // Function to return length
    // of dynamic array
    function getLength() public view returns (uint)
    {
    return arr.length;
    }

    // Function to search an
    // element in dynamic array
    function search(string memory _word) public view returns(bool){
    uint i;
    for(i = 0; i < arr.length; i++){
        if(keccak256(bytes(arr[i])) == keccak256(bytes(_word))){
        return true;
        }
    }
        
    if(i >= arr.length){
        return false;
    }

    return false;
    }
}
