// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./Clu3Whitelist.sol";
import "./VerifySigner.sol";

error Clu3__NotOwner();

error Clu3__TimestampAlreadyPassed();

error Clu3__SignerNotValid();

/**
 * @title Clu3: a smart contract to create transactions
 * @notice
 * @author Jesus Badillo
 */
contract Clu3 is VerifySignature {
    /**
     *  @notice
     *  @dev
     */

    // Enumerate the correct Web3 storage implementations
    enum Web3StorageImplementation {
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
    bytes private s_clu3Id;

    // Web3 Service (IPFS, Ceramic, Tableland, Filecoin)
    Clu3Whitelist private s_clu3Whitelist;

    struct Clu3Event {
        uint256 clu3EventTimestamp;
        address clueEventAddress;
    }

    constructor(
        address _signer,
        uint256 _lifespan,
        uint256 _clu3Id
    ) {
        i_signer = _signer;
        i_lifespan = _lifespan;
        s_clu3Id = _clu3Id;
        i_eventTimestamp = block.timestamp;
        i_owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert Clu3__NotOwner();
        }
        _;
    }

    function senderInWhitelist(address _sender) public view returns (bool) {
        if (s_clu3Whitelist.isWhitelisted(_sender)) {
            return true;
        }
        return false;
    }

    function isWhitelistImplemented() public view returns (bool) {
        if (s_clu3Whitelist.getNumberOfWhitelistedAddresses() == 0) {
            return false;
        }
        return true;
    }

    function createClu3Transaction() private view returns (bool) {
        if (!senderInWhitelist(msg.sender) || !isWhitelistImplemented()) {
            return true;
        }

        if (i_eventTimestamp + i_lifespan > block.timestamp) {
            revert Clu3__TimestampAlreadyPassed();
        }

        if (verifyMessage(_hashedMessage, _v, _r, _s) != i_signer) {}
        // bytes32 eve = keccak256(
        //     abi.encodePacked(
        //         i_owner,
        //         s_clu3Whitelist.s_whitelistAddresses,
        //         lifespan
        //     )
        // );
    }
}
