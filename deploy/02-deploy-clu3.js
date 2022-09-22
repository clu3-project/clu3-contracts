const {
    networkConfig,
    developmentChains,
    MAX_WHITELIST_ADDRESSES,
    CLU3_ID,
    LIFESPAN,
    MESSAGE,
} = require("../helper-hardhat-config")
const { network, ethers } = require("hardhat")
const { verify } = require("../utils/verify")

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId

    let signer, lifespan, maxWhitelistAddresses, clu3Id, message

    if (developmentChains.includes(network.name)) {
        signer = deployer
        lifespan = LIFESPAN
        message = MESSAGE
        clu3Id = CLU3_ID
        maxWhitelistAddresses = MAX_WHITELIST_ADDRESSES
    } else {
        signer = "0xd1309C93a4bF7C7a1eE81E5fC8291Adb583cc602"
        lifespan = networkConfig[chainId]["lifespan"]
        message = networkConfig[chainId]["message"]
        clu3Id = networkConfig[chainId]["clu3Id"]
        maxWhitelistAddresses = networkConfig[chainId]["maxWhitelistAddresses"]
    }

    let args = [signer, lifespan, clu3Id]

    log("--------------------------------")
    log("Deploying Clu3, Waiting for confirmations...")

    const clu3 = await deploy("Clu3", {
        from: deployer,
        args: args,
        log: true,
        // we need to wait if on a live network so we can verify properly
        waitConfirmations: network.config.blockConfirmations || 1,
    })
    log(`Clu3 deployed at ${clu3.address}`)

    log("---------------------------------")
    log("Verifying Clu3 contract")
    if (
        !developmentChains.includes(network.name) &&
        process.env.ETHERSCAN_API_KEY
    ) {
        const verificationResponse = await verify(clu3.address, args)
    }
    log("Verified Clu3 contract")
}

module.exports.tags = ["all", "clu3"]
