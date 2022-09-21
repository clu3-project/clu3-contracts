// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./Clu3Whitelist.sol";
import "./VerifySigner.sol";

error Clu3__NotOwner();

error Clu3__TimestampAlreadyPassed();

error Clu3__InvalidSigner();

/**
 * @title Clu3: a smart contract to prevent bots
 * @notice
 * @author Jesus Badillo
 */
contract Clu3 is Clu3Whitelist {
    // Inherit verification functions from VerifySigner Library
    using VerifySigner for address;

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
    string private s_message;
    string private s_clu3Id;
    Web3StorageImplementation private s_web3Service;

    struct Clu3Event {
        uint256 clu3EventTimestamp;
        address clueEventAddress;
    }

    event SignerVerified(address indexed _signer);
    event AddressInWhiteList(address indexed _currentAddress);

    constructor(
        address _signer,
        uint256 _lifespan,
        string memory _message,
        string memory _clu3Id
    ) Clu3Whitelist(s_maxWhitelistAddresses) {
        i_signer = _signer;
        i_lifespan = _lifespan;
        s_clu3Id = _clu3Id;
        s_message = _message;
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

    function senderInWhitelist(address _sender) private returns (bool) {
        if (isWhitelisted(_sender)) {
            return true;
        }
        emit AddressInWhiteList(_sender);
        return false;
    }

    function isWhitelistImplemented() private view returns (bool) {
        if (getNumberOfWhitelistedAddresses() == 0) {
            return false;
        }
        return true;
    }

    function isClu3Transaction() private returns (bool) {
        if (!senderInWhitelist(msg.sender) || !isWhitelistImplemented()) {
            return true;
        }

        if (i_eventTimestamp + i_lifespan > block.timestamp) {
            revert Clu3__TimestampAlreadyPassed();
        }

        // Verify that the message: "timestamp-clu3_id-sender_address"
        if ((msg.sender).verifySigner(s_message) != msg.sender) {
            revert Clu3__InvalidSigner();
        }

        emit SignerVerified(msg.sender);

        return false;
    }

    // function implementWeb3Storage() private returns (bool) {
    //     if (s_web3Service == Web3StorageImplementation.IPFS) {

    //     }
    //     //else if (s_web3Service == Web3StorageImplementation.FILECOIN) {
    //     //     //s_web3Service;
    //     // } else if (s_web3Service == Web3StorageImplementation.CERAMIC) {
    //     //     //s_web3Service;
    //     // } else if (s_web3Service == Web3StorageImplementation.TABLELAND) {}
    // }
}
