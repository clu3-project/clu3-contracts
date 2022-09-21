const {
    networkConfig,
    developmentChains,
    MAX_WHITELIST_ADDRESSES,
} = require("../helper-hardhat-config")
const { network, ethers } = require("hardhat")
const { verify } = require("../utils/verify")

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId

    let maxWhitelistAddresses
    if (developmentChains.includes(network.name)) {
        maxWhitelistAddresses = MAX_WHITELIST_ADDRESSES
    } else {
        maxWhitelistAddresses = networkConfig[chainId]["maxWhitelistAddresses"]
    }
    log("--------------------------------")
    log("Deploying Clu3, Waiting for confirmations...")

    const clu3Whitelist = await deploy("Clu3Whitelist", {
        from: deployer,
        args: [maxWhitelistAddresses],
        log: true,
        // we need to wait if on a live network so we can verify properly
        waitConfirmations: network.config.blockConfirmations || 1,
    })
    log(`Clu3Whitelist deployed at ${clu3Whitelist.address}`)

    log("---------------------------------")
    log("Verifying Clu3Whitelist contract")
    if (
        !developmentChains.includes(network.name) &&
        process.env.ETHERSCAN_API_KEY
    ) {
        const verificationResponse = await verify(clu3Whitelist.address, [
            maxWhitelistAddresses,
        ])
    }
    log("Verified Clu3Whitelist contract")
}

module.exports.tags = ["all", "whitelist"]
