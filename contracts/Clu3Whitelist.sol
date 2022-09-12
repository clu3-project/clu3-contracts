// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

error Clu3Whitelist__NotOwner();

error Clu3Whitelist__AlreadyInWhitelist();

error Clu3Whitelist__MaxWhitelistAddressesReached();

error Clu3Whitelist__NotWhitelisted();

/**
 *  @title Clu3Whitelist: A whitelist for the addresses that can mint the
 *  @author Jesus Badillo, Efrain
 *  @notice
 *  @dev
 */
contract Clu3Whitelist {
    // The number of accounts we want to have in our whitelist.
    uint256 private immutable i_maxNumberOfWhitelistAddresses;

    // Track the number of whitelisted addresses.
    uint256 private numberOfAddressesWhitelisted;

    // The owner of the contract
    address private immutable i_owner;

    // To store our addresses, we need to create a mapping that will receive the user's address and return if he is whitelisted or not.
    mapping(address => bool) whitelistAddresses;

    constructor(uint256 _maxWhitelistAddresses) {
        i_owner = msg.sender;
        i_maxNumberOfWhitelistAddresses = _maxWhitelistAddresses;
    }

    // Validate only the owner can call the function
    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert Clu3Whitelist__NotOwner();
        }
        _;
    }

    /**
     *  @notice function addUserAddressToWhitelist
     *  @dev
     */
    function addUserAddressToWhitelist(address _addressToWhitelist)
        public
        onlyOwner
    {
        // Validate the caller is not already part of the whitelist.
        if (!whitelistAddresses[_addressToWhitelist]) {
            revert Clu3Whitelist__AlreadyInWhitelist();
        }

        // Validate if the maximum number of whitelisted addresses is not reached. If not, then throw an error.
        if (numberOfAddressesWhitelisted < i_maxNumberOfWhitelistAddresses) {
            revert Clu3Whitelist__MaxWhitelistAddressesReached();
        }

        // Set whitelist boolean to true.
        whitelistAddresses[_addressToWhitelist] = true;

        // Increasing the count
        numberOfAddressesWhitelisted += 1;
    }

    function verifyUserAddress(address _whitelistAddress)
        public
        view
        returns (bool)
    {
        // Verifying if the user has been whitelisted
        bool userIsWhitelisted = whitelistAddresses[_whitelistAddress];
        return userIsWhitelisted;
    }

    /**
     *  @notice function isWhitelisted checks if function is whitelisted
     *  @dev
     */
    function isWhitelisted(address _whitelistAddress)
        public
        view
        returns (bool)
    {
        // Verifying if the user has been whitelisted
        return whitelistAddresses[_whitelistAddress];
    }

    // Remove user from whitelist
    function removeUserAddressFromWhitelist(address _addressToRemove)
        public
        onlyOwner
    {
        // Validate the caller is already part of the whitelist.
        if (whitelistAddresses[_addressToRemove]) {
            revert Clu3Whitelist__NotWhitelisted();
        }

        // Set whitelist boolean to false.
        whitelistAddresses[_addressToRemove] = false;

        // This will decrease the number of whitelisted addresses.
        numberOfAddressesWhitelisted -= 1;
    }

    // Get the number of whitelisted addresses
    function getNumberOfWhitelistedAddresses() public view returns (uint256) {
        return numberOfAddressesWhitelisted;
    }

    // Get the maximum number of whitelisted addresses
    function getMaxNumberOfWhitelistedAddresses()
        public
        view
        returns (uint256)
    {
        return i_maxNumberOfWhitelistAddresses;
    }

    // Get the owner of the contract
    function getOwner() public view returns (address) {
        return i_owner;
    }
}
