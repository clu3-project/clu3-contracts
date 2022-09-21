const networkConfig = {
    4: {
        name: "rinkeby",
        lifespan: "3600", // Make lifespan 1 hour
        message: "This is a test message",
        clu3Id: "3",
        maxWhitelistAddresses: "5",
    },
    5: {
        name: "goerli",
        lifespan: "3600", // Make lifespan 1 hour
        message: "This is a test message",
        clu3Id: "3",
        maxWhitelistAddresses: "5",
    },
    80001: {
        name: "mumbai",
        lifespan: "3600", // Make lifespan 1 hour
        message: "This is a test message",
        clu3Id: "3",
        maxWhitelistAddresses: "5",
    },
    420: {
        name: "optimismGoerli",
        lifespan: "3600", // Make lifespan 1 hour
        message: "This is a test message",
        clu3Id: "3",
        maxWhitelistAddresses: "5",
    },
    31337: {
        name: "hardhat",
        lifespan: "3600", // Make lifespan 1 hour
        message: "This is a test message",
        clu3Id: "3",
        maxWhitelistAddresses: "5",
    },
}

const developmentChains = ["hardhat", "localhost"]
const MAX_WHITELIST_ADDRESSES = "3"
const LIFESPAN = "3600"
const MESSAGE = "This is a test message"
const CLU3_ID = "3"

module.exports = {
    networkConfig,
    developmentChains,
}
