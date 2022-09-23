const { network, getNamedAccounts, deployments, ethers } = require("hardhat")
const {
    developmentChains,
    networkConfig,
} = require("../../helper-hardhat-config")
const { assert, expect } = require("chai")
const {
    isCallTrace,
} = require("hardhat/internal/hardhat-network/stack-traces/message-trace")
const { assertHardhatInvariant } = require("hardhat/internal/core/errors")
const { resolveConfig } = require("prettier")

!developmentChains.includes(network.name)
    ? describe.skip
    : describe("Clu3 Unit Tests", function () {
          let signer, lifespan, clu3Id, publicKey, signature, message
          const chainId = network.config.chainId
          beforeEach(async () => {
              deployer = (await getNamedAccounts()).deployer
              await deployments.fixture("all")
              clu3 = await ethers.getContract("Clu3", deployer)
              clu3Whitelist = await ethers.getContract(
                  "Clu3Whitelist",
                  deployer
              )
              //message = "abcde"
              publicKey = "0xd1309C93a4bF7C7a1eE81E5fC8291Adb583cc602"
              // "0x2d1bd754d5215abd6d38666336e94dd9f6da20b7f884f7bdd678ab5f6e374bc1483765bd4afaceb66bb9afc6d785054eefb13c6f861ce60e7760ef3c1332a5d71c"
          })

          describe("constructor", () => {
              it("Sets the contructor correctly", async () => {
                  const web3Service = await clu3.getWeb3ServiceImplementation()
                  assert.equal(web3Service.toString(), "0")
              })
          })

          describe("setClu3Id", () => {
              it("Sets the Clu3Id", async () => {
                  clu3Id = "12345"
                  await clu3.setClu3Id(clu3Id)
                  const outputClu3Id = await clu3.getClu3Id()

                  assert(outputClu3Id.toString(), clu3Id.toString())
              })
          })

          describe("setClu3Message", () => {
              it("Sets the Clu3 Message", async () => {
                  message = "Hey this clu3 is a message"
                  await clu3.setClu3Message(message)
                  const outputClu3Message = await clu3.getClu3Message()

                  assert(outputClu3Message.toString(), message.toString())
              })
          })

          describe("setLifespan", () => {
              it("Sets the lifespan of a valid transaction", async () => {
                  lifespan = 3600 // set the lifespan of the clu3 transaction to one hour
                  await clu3.setLifespan(lifespan)
                  const outputLifespan = await clu3.getLifespan()

                  assert(outputLifespan.toString(), lifespan.toString())
              })
          })

          describe("verifySigner", () => {
              it("Verifies the signer", async () => {
                  message = "abcde"
                  signature =
                      "0x2d1bd754d5215abd6d38666336e94dd9f6da20b7f884f7bdd678ab5f6e374bc1483765bd4afaceb66bb9afc6d785054eefb13c6f861ce60e7760ef3c1332a5d71c"
                  await clu3.setClu3Message(message)
                  const outputKey = await clu3.verifySigner(signature)
                  assert.equal(outputKey.toString(), publicKey.toString())
              })

              it(`Returns a different public key than: ${publicKey}`, async () => {
                  message = "abcde"
                  signature =
                      "0x3d1bd754d5215abd6d38666336e94dd9f6da20b7f884f7bdd678ab5f6e374bc1483765bd4afaceb66bb9afc6d785054eefb13c6f861ce60e7760ef3c1332a5d71c"
                  await clu3.setClu3Message(message)
                  const outputKey = await clu3.verifySigner(signature)
                  assert.notEqual(outputKey.toString(), publicKey.toString())
              })
          })

          describe("Signer in Whitelist", () => {
              it("Verifies the signer", async () => {
                  message = "abcde"
                  signature =
                      "0x2d1bd754d5215abd6d38666336e94dd9f6da20b7f884f7bdd678ab5f6e374bc1483765bd4afaceb66bb9afc6d785054eefb13c6f861ce60e7760ef3c1332a5d71c"
                  await clu3.setClu3Message(message)
                  const outputKey = await clu3.verifySigner(signature)
                  assert.equal(outputKey.toString(), publicKey.toString())
              })

              it(`Returns a different public key than: ${publicKey}`, async () => {
                  message = "abcde"
                  signature =
                      "0x3d1bd754d5215abd6d38666336e94dd9f6da20b7f884f7bdd678ab5f6e374bc1483765bd4afaceb66bb9afc6d785054eefb13c6f861ce60e7760ef3c1332a5d71c"
                  await clu3.setClu3Message(message)
                  const outputKey = await clu3.verifySigner(signature)
                  assert.notEqual(outputKey.toString(), publicKey.toString())
              })
          })

          describe("clu3Transaction", () => {
              it("Verifies the signer", async () => {
                  message = "abcde"
                  signature =
                      "0x2d1bd754d5215abd6d38666336e94dd9f6da20b7f884f7bdd678ab5f6e374bc1483765bd4afaceb66bb9afc6d785054eefb13c6f861ce60e7760ef3c1332a5d71c"
                  await clu3.setClu3Message(message)
                  const outputKey = await clu3.verifySigner(signature)
                  assert.equal(outputKey.toString(), publicKey.toString())
              })

              it(`Returns a different public key than: ${publicKey}`, async () => {
                  message = "abcde"
                  signature =
                      "0x3d1bd754d5215abd6d38666336e94dd9f6da20b7f884f7bdd678ab5f6e374bc1483765bd4afaceb66bb9afc6d785054eefb13c6f861ce60e7760ef3c1332a5d71c"
                  await clu3.setClu3Message(message)
                  const outputKey = await clu3.verifySigner(signature)
                  assert.notEqual(outputKey.toString(), publicKey.toString())
              })
          })
      })
