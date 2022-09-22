// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/utils/Strings.sol";
import "./Clu3Whitelist.sol";

error Clu3__NotOwner();

error Clu3__TimestampAlreadyPassed();

error Clu3__InvalidSigner();

error Clu3__InvalidSignatureLength();

error Clu3__TimestampClu3IdAlreadyUsed();

/**
 * @title Clu3: a smart contract to prevent bots
 * @notice
 * @author Jesus Badillo
 */
contract Clu3 is Clu3Whitelist {
    // Inherit verification functions from VerifySigner Library

    // Enumerate the correct Web3 storage implementations
    // Web3 Service (IPFS, Ceramic, Tableland, Filecoin)
    enum Web3StorageImplementation {
        ON_CHAIN,
        IPFS,
        TABLELAND,
        FILECOIN,
        CERAMIC
    }

    // State Variables
    address private immutable i_signer;
    uint256 private immutable i_lifespan;
    address private immutable i_owner;
    uint256 private immutable i_eventTimestamp;
    uint256 private s_maxWhitelistAddresses;
    bytes32 private s_ethSignedMessageHash;
    string private i_clu3Id;
    Web3StorageImplementation private s_web3Service;

    event SignerVerified(address indexed _signer);
    event AddressInWhiteList(address indexed _currentAddress);

    constructor(
        address _signer,
        uint256 _lifespan,
        string memory _clu3Id
    ) Clu3Whitelist(s_maxWhitelistAddresses) {
        i_signer = _signer;
        i_lifespan = _lifespan;
        i_clu3Id = _clu3Id;
        i_eventTimestamp = block.timestamp;
        i_owner = msg.sender;
        s_web3Service = Web3StorageImplementation.ON_CHAIN;
    }

    modifier onlyOwner() override {
        if (msg.sender != i_owner) {
            revert Clu3__NotOwner();
        }
        _;
    }

    function senderInWhitelist(address _sender) public returns (bool) {
        if (isWhitelisted(_sender)) {
            return true;
        }
        emit AddressInWhiteList(_sender);
        return false;
    }

    function isWhitelistImplemented() public view returns (bool) {
        if (getNumberOfWhitelistedAddresses() == 0) {
            return false;
        }
        return true;
    }

    function verifySigner(bytes32 _ethSignedMessageHash)
        internal
        view
        returns (address)
    {
        bytes32 r;
        bytes32 s;
        uint8 v;
        bytes memory _signature = abi.encodePacked(i_signer);
        if (_signature.length != 65) {
            revert Clu3__InvalidSignatureLength();
        }

        // Dynamic variable length stored in first 32 bytes (i.e. 65 bytes)
        assembly {
            // Set r to be bytes [32,63] inclusive
            r := mload(add(_signature, 32))
            // Set s to be bytes [64,95] inclusive
            s := mload(add(_signature, 64))
            // Set v to be byte 96
            v := byte(0, mload(add(_signature, 96))) //
        }

        return ecrecover(_ethSignedMessageHash, v, r, s);
    }

    function clu3Transaction() public returns (bytes32) {
        if (!senderInWhitelist(msg.sender) || !isWhitelistImplemented()) {
            return bytes32(0);
        }

        if (i_eventTimestamp + i_lifespan > block.timestamp) {
            revert Clu3__TimestampAlreadyPassed();
        }

        // Verify that the message: "timestamp-clu3_id-sender_address"
        if (verifySigner(s_ethSignedMessageHash) != i_signer) {
            revert Clu3__InvalidSigner();
        }

        emit SignerVerified(i_signer);

        return
            bytes32(
                abi.encodePacked(Strings.toString(i_eventTimestamp), i_clu3Id)
            );
    }

    // function implementWeb3Storage(bytes32 _clu3Message) private returns (bool) {
    //     if (s_web3Service == Web3StorageImplementation.ON_CHAIN) {
    //         _

    //     }
    //     else if(s_web3Service == Web3StorageImplementation.IPFS){

    //     }
    //     else if (s_web3Service == Web3StorageImplementation.FILECOIN) {
    //         //s_web3Service;
    //     } else if (s_web3Service == Web3StorageImplementation.CERAMIC) {
    //         //s_web3Service;
    //     } else if (s_web3Service == Web3StorageImplementation.TABLELAND) {}
    // }

    function getWeb3ServiceImplementation()
        public
        view
        returns (Web3StorageImplementation)
    {
        return s_web3Service;
    }

    function getSigner() public view returns (address) {
        return i_signer;
    }

    function getClu3Id() public view returns (string memory) {
        return i_clu3Id;
    }

    function getLifespan() public view returns (uint256) {
        return i_lifespan;
    }
}
