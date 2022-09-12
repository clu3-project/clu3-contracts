// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./Clu3Whitelist.sol";

error Clu3__TimestampPassed();

contract Clu3 {
    /**
     *  @notice
     *  @dev
     */

    address private immutable i_owner;

    struct Clu3Data {
        uint256 clu3Timestamp;
        address clueAddress;
    }

    constructor() {
        i_owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert Clu3Whitelist__NotOwner();
        }
        _;
    }

    // Map clu3Id to
    Clu3Whitelist private clu3Whitelist;

    // function createClu3Transaction(uint256 lifespan, address clu3Address)
    //     private
    //     onlyOwner
    // {
    //     bytes32 eve = keccak256(abi.encodePacked(msg.sender, clu3Address));
    // }
}
