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
    address private s_signer = address(0);
    uint256 private s_lifespan = uint256(0);
    string private s_clu3Id;
    string private s_message;
    Web3StorageImplementation private s_web3Service;

    event SignerVerified(address indexed _signer);
    event AddressInWhiteList(address indexed _currentAddress);

    constructor(uint256 _maxWhitelistAddresses)
        Clu3Whitelist(_maxWhitelistAddresses)
    {
        s_web3Service = Web3StorageImplementation.ON_CHAIN;
    }

    function signerInWhitelist(address _signer) public returns (bool) {
        if (isWhitelisted(_signer)) {
            return true;
        }
        emit AddressInWhiteList(_signer);
        return false;
    }

    function isWhitelistImplemented() public view returns (bool) {
        if (getNumberOfWhitelistedAddresses() == 0) {
            return false;
        }
        return true;
    }

    function setClu3Id(string memory _clu3Id) public {
        s_clu3Id = _clu3Id;
    }

    function setLifespan(uint256 _lifespan) public {
        s_lifespan = _lifespan;
    }

    function setClu3Message(string memory _message) public {
        s_message = _message;
    }

    function verifySigner(bytes memory _signature)
        public
        view
        returns (address)
    {
        bytes32 r;
        bytes32 s;
        uint8 v;

        bytes32 _messageHash = keccak256(abi.encodePacked(s_message));
        bytes32 _ethSignedMessageHash = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash)
        );

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

    function clu3Transaction(uint256 _timestamp, bytes memory _signature)
        public
        returns (string memory)
    {
        if (!signerInWhitelist(s_signer) || !isWhitelistImplemented()) {
            return "Already In Whitelist";
        }

        if (_timestamp + s_lifespan > block.timestamp) {
            revert Clu3__TimestampAlreadyPassed();
        }

        // Verify that the message: "timestamp-clu3_id-sender_address"
        if (verifySigner(_signature) != s_signer) {
            revert Clu3__InvalidSigner();
        }

        emit SignerVerified(s_signer);

        return string.concat(Strings.toString(_timestamp), s_clu3Id);
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
        return s_signer;
    }

    function getClu3Id() public view returns (string memory) {
        return s_clu3Id;
    }

    function getClu3Message() public view returns (string memory) {
        return s_message;
    }

    function getLifespan() public view returns (uint256) {
        return s_lifespan;
    }
}
