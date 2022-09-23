const { ethers, network } = require("hardhat")
const fs = require("fs")

const FRONT_END_LOCATION_ABI = "../cludemo/constants/abi.json"
const FRONT_END_LOCATION_CONTRACTS = "../cludemo/constants/contractAddress.json"

module.exports = async () => {
    if (process.env.UPDATE_FRONT_END.toString() === "true") {
        console.log("Updating front end...")
        await updateContractAddresses()
        await updateAbi()
    }
}

const updateAbi = async () => {
    const clu3Contract = await ethers.getContract("Clu3")
    const chainId = network.config.chainId.toString()
    fs.writeFileSync(
        FRONT_END_LOCATION_ABI,
        clu3Contract.interface.format(ethers.utils.FormatTypes.json)
    )
}
const updateContractAddresses = async () => {
    const clu3Contract = await ethers.getContract("Clu3")
    const chainId = network.config.chainId.toString()
    const currentAddresses = JSON.parse(
        fs.readFileSync(FRONT_END_LOCATION_CONTRACTS, "utf8")
    )
    if (chainId in currentAddresses) {
        if (!currentAddresses[chainId].includes(clu3Contract.address)) {
            currentAddresses[chainId].push(clu3Contract.address)
        }
    } else {
        currentAddresses[chainId] = [clu3Contract.address]
    }
    fs.writeFileSync(
        FRONT_END_LOCATION_CONTRACTS,
        JSON.stringify(currentAddresses)
    )
}

module.exports.tags = ["all", "frontend"]
