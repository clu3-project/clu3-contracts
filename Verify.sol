// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/Strings.sol';
import './DynamicArray.sol';

contract Verify is DynamicArray {
 
   address importantAddress;
   uint256 immutable public cluID = 0;
   string public cluID_v = "0";
   
   constructor (address _importantAddress) {
       importantAddress = _importantAddress;
   }

   function web3_sif(string memory _timestamp) private returns(bool){
    string memory word = string(bytes.concat(bytes(_timestamp), "-", bytes(cluID_v)));
    if(search(word)){
        return false;
    }else{
        addData(string(bytes.concat(bytes(_timestamp), "-", bytes(cluID_v))));
        return true;
    }
   }

   function isValidData(uint256 _timestamp, bytes memory sig) public returns(bool){
       bytes32 message = keccak256(abi.encodePacked(msg.sender, _timestamp,cluID));
       if (recoverSigner(message, sig) == importantAddress){
           if(web3_sif(Strings.toString(_timestamp))){
               return true;
           }else{
               revert("timestamp + cluID already used");
           } 
       }
       revert("Invalid signature");
   }
   
   function recoverSigner(bytes32 message, bytes memory sig)
       public
       pure
       returns (address)
     {
       uint8 v;
       bytes32 r;
       bytes32 s;
       (v, r, s) = splitSignature(sig);
       return ecrecover(message, v, r, s);
   }
   function splitSignature(bytes memory sig)
       public
       pure
       returns (uint8, bytes32, bytes32)
     {
       require(sig.length == 65);
       bytes32 r;
       bytes32 s;
       uint8 v;
       assembly {
           // first 32 bytes, after the length prefix
           r := mload(add(sig, 32))
           // second 32 bytes
           s := mload(add(sig, 64))
           // final byte (first byte of the next 32 bytes)
           v := byte(0, mload(add(sig, 96)))
       }
 
       return (v, r, s);
   }
}