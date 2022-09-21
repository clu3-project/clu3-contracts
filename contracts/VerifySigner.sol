// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

error VerifySigner__InvalidSignatureLength();

/**
 * @title VerifySignature - use the signer address and a message to verify the signer of a message on chain
 * @author Jesus Badillo
 * @dev
 */

library VerifySigner {
    function getMessageHash(string memory _message)
        private
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(_message));
    }

    function getEthSignedMessageHash(bytes32 _messageHash)
        private
        pure
        returns (bytes32)
    {
        return
            keccak256(
                abi.encodePacked(
                    "\x19Ethereum Signed Message:\n32",
                    _messageHash
                )
            );
    }

    function verifySigner(address _signer, string memory _message)
        external
        pure
        returns (address)
    {
        bytes32 messageHash = getMessageHash(_message);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);

        // Convert signer address and return address that contract computes
        return recoverSigner(ethSignedMessageHash, abi.encodePacked(_signer));
    }

    function recoverSigner(
        bytes32 _ethSignedMessageHash,
        bytes memory _signature
    ) internal pure returns (address) {
        bytes32 r;
        bytes32 s;
        uint8 v;

        if (_signature.length != 65) {
            revert VerifySigner__InvalidSignatureLength();
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
}
