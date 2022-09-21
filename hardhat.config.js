require("@nomicfoundation/hardhat-toolbox")
require("@nomiclabs/hardhat-ethers")
require("hardhat-deploy")
require("dotenv").config({ path: "./.env" })

/** @type import('hardhat/config').HardhatUserConfig */
const GOERLI_RPC_URL = process.env.GOERLI_RPC_URL
const RINKEBY_RPC_URL = process.env.RINKEBY_RPC_URL
const POLYGON_MUMBAI_RPC_URL = process.env.POLYGON_MUMBAI_RPC_URL
const OPTIMISM_GOERLI_RPC_URL = process.env.OPTIMISM_GOERLI_RPC_URL
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY
const POLYGONSCAN_API_KEY = process.env.POLYGONSCAN_API_KEY
const OPTIMISMSCAN_API_KEY = process.env.OPTIMISMSCAN_API_KEY
const COINMARKET_API_KEY = process.env.COINMARKET_API_KEY
const PRIVATE_KEY = process.env.PRIVATE_KEY

module.exports = {
    defaultNetwork: "hardhat",
    networks: {
        hardhat: {
            chainId: 31337,
        },
        goerli: {
            url: GOERLI_RPC_URL,
            accounts: [PRIVATE_KEY],
            chainId: 5,
            blockConfirmations: 6,
        },
        rinkeby: {
            url: RINKEBY_RPC_URL,
            accounts: [PRIVATE_KEY],
            chainId: 4,
            blockConfirmations: 6,
        },
        mumbai: {
            url: POLYGON_MUMBAI_RPC_URL,
            accounts: [PRIVATE_KEY],
            chainId: 80001,
            blockConfirmations: 6,
        },
        optimismGoerli: {
            url: OPTIMISM_GOERLI_RPC_URL,
            accounts: [PRIVATE_KEY],
            chainId: 420,
            blockConfirmations: 6,
        },
        localhost: {
            url: "http://127.0.0.1:8545",
            chainId: 31337,
        },
    },
    solidity: {
        compilers: [
            {
                version: "0.8.7",
            },
            {
                version: "0.8.9",
            },
        ],
    },
    etherscan: {
        apiKey: {
            rinkeby: ETHERSCAN_API_KEY,
            goerli: ETHERSCAN_API_KEY,
            kovan: ETHERSCAN_API_KEY,
            optimismGoerli: OPTIMISMSCAN_API_KEY,
            mumbai: POLYGONSCAN_API_KEY,
        },
        customChains: [
            {
                network: "rinkeby",
                chainId: 4,
                urls: {
                    apiURL: "https://api-rinkeby.etherscan.io/api",
                    browserURL: "https://rinkeby.etherscan.io",
                },
            },
            {
                network: "goerli",
                chainId: 5,
                urls: {
                    apiURL: "https://api-goerli.etherscan.io/api",
                    browserURL: "https://goerli.etherscan.io",
                },
            },
            {
                network: "optimismGoerli",
                chainId: 420,
                urls: {
                    apiURL: "https://blockscout.com/optimism/goerli/api ",
                    browserURL: "https://blockscout.com/optimism/goerli",
                },
            },
            {
                network: "mumbai",
                chainId: 80001,
                urls: {
                    apiURL: "https://api-mumbai.polygonscan.com/api",
                    browserURL: "https://mumbai.polygonscan.com/",
                },
            },
        ],
    },
    gasReporter: {
        enabled: false,
        outputFile: "gas-report.txt",
        noColors: true,
        currency: "USD",
        coinmarketcap: COINMARKET_API_KEY,
        token: "ETH",
    },
    namedAccounts: {
        deployer: {
            default: 0,
        },
        player: {
            default: 1,
        },
    },
    mocha: {
        timeout: 500000, // 500 seconds max for running tests
    },
}
