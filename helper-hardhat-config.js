const networkConfig = {
    4: {
        name: "rinkeby",
        signer: "0xd1309C93a4bF7C7a1eE81E5fC8291Adb583cc602",
        lifespan: "3600", // Make lifespan 1 hour
        clu3Id: "0",
        maxWhitelistAddresses: "5",
    },
    5: {
        name: "goerli",
        signer: "0xd1309C93a4bF7C7a1eE81E5fC8291Adb583cc602",
        lifespan: "3600", // Make lifespan 1 hour
        clu3Id: "0",
        maxWhitelistAddresses: "5",
    },
    80001: {
        name: "mumbai",
        signer: "0xd1309C93a4bF7C7a1eE81E5fC8291Adb583cc602",
        lifespan: "3600", // Make lifespan 1 hour
        clu3Id: "0",
        maxWhitelistAddresses: "5",
    },
    420: {
        name: "optimismGoerli",
        signer: "0xd1309C93a4bF7C7a1eE81E5fC8291Adb583cc602",
        lifespan: "3600", // Make lifespan 1 hour
        clu3Id: "0",
        maxWhitelistAddresses: "5",
    },
    31337: {
        name: "hardhat",
        signer: "0xd1309C93a4bF7C7a1eE81E5fC8291Adb583cc602",
        lifespan: "3600", // Make lifespan 1 hour
        clu3Id: "0",
        maxWhitelistAddresses: "5",
    },
}

const developmentChains = ["hardhat", "localhost"]
const MAX_WHITELIST_ADDRESSES = "3"
const LIFESPAN = "3600"
const CLU3_ID = "0"
const SIGNER = "0xd1309C93a4bF7C7a1eE81E5fC8291Adb583cc602"

module.exports = {
    networkConfig,
    developmentChains,
    SIGNER,
    MAX_WHITELIST_ADDRESSES,
    LIFESPAN,
    CLU3_ID,
}
