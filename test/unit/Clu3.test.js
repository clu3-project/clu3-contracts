const { network, getNamedAccounts, deployments, ethers } = require("hardhat")
const {
    developmentChains,
    networkConfig,
    SIGNER,
    LIFESPAN,
    CLU3_ID,
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
              clu3Id = CLU3_ID
              lifespan = LIFESPAN
              signer = SIGNER
          })

          describe("constructor", () => {
              it("Sets the constructor correctly", async () => {
                  const web3Service = await clu3.getWeb3ServiceImplementation()
                  assert.equal(web3Service.toString(), "0")
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

          describe("verifySigner", () => {
              it("Verifies the signer using different public key", async () => {
                  message =
                      "0x8F4682E0900e99E0385fBd141eFB474B53D84237-1663908389126-0"
                  await clu3.setClu3Message(message)
                  signature =
                      "0x2fb5f768ba4b0a1c94dcc4df1deda9bdc3a7ca85c48db03e7662966a516644e55f16f6ee95799e11e0566d7f3fdf2c6399a41752ced4a3cb2c62245cf05504be1c"
                  const outputKey = await clu3.verifySigner(signature)
                  assert.equal(outputKey.toString(), signer.toString())
              })

              it("Fails to verify the signer using different public key", async () => {
                  message =
                      "0x8F4682E0900e99E0385fBd141eFB474B53D84237-1663908389126-0"
                  await clu3.setClu3Message(message)
                  signature =
                      "0x3fb5f768ba4b0a1c94dcc4df1deda9bdc3a7ca85c48db03e7662966a516644e55f16f6ee95799e11e0566d7f3fdf2c6399a41752ced4a3cb2c62245cf05504be1c"
                  const outputKey = await clu3.verifySigner(signature)
                  assert.notEqual(outputKey.toString(), signer.toString())
              })

              it(`Returns the public key: ${SIGNER}`, async () => {
                  message = "abcde"
                  signature =
                      "0x2d1bd754d5215abd6d38666336e94dd9f6da20b7f884f7bdd678ab5f6e374bc1483765bd4afaceb66bb9afc6d785054eefb13c6f861ce60e7760ef3c1332a5d71c"
                  await clu3.setClu3Message(message)
                  const outputKey = await clu3.verifySigner(signature)
                  assert.equal(outputKey.toString(), signer.toString())
              })

              it(`Returns a different public key than: ${SIGNER}`, async () => {
                  message = "abcde"
                  signature =
                      "0x3d1bd754d5215abd6d38666336e94dd9f6da20b7f884f7bdd678ab5f6e374bc1483765bd4afaceb66bb9afc6d785054eefb13c6f861ce60e7760ef3c1332a5d71c"
                  await clu3.setClu3Message(message)
                  const outputKey = await clu3.verifySigner(signature)
                  assert.notEqual(outputKey.toString(), signer.toString())
              })
          })

          describe("signerInWhitelist", () => {
              it("Signer should not be in whitelist", async () => {
                  const txResponse = await clu3.signerInWhitelist(signer)
                  const txReceipt = await txResponse.wait()
                  const [txEvent] = txReceipt.events
                  const outputWhitelistResult = txEvent.args[0]
                  assert.notEqual(
                      outputWhitelistResult.toString(),
                      signer.toString()
                  )
              })
              it("Signer should be in whitelist", async () => {
                  await clu3.addUserAddressToWhitelist(signer)
                  const txResponse = await clu3.signerInWhitelist(signer)
                  const txReceipt = await txResponse.wait()
                  const [txEvent] = txReceipt.events
                  const outputWhitelistResult = txEvent.args[0]
                  assert.equal(
                      outputWhitelistResult.toString(),
                      signer.toString()
                  )
              })
          })

          describe("isWhitelistImplemented", () => {
              it("Should return false because whitelist is not implemented", async () => {
                  const outputWhitelistLength =
                      await clu3.isWhitelistImplemented()
                  const whiteListLengthResult = "false"
                  assert.equal(
                      outputWhitelistLength.toString(),
                      whiteListLengthResult.toString()
                  )
              })

              it("Should return true because whitelist is implemented", async () => {
                  await clu3.addUserAddressToWhitelist(signer)
                  const outputWhitelistLength =
                      await clu3.isWhitelistImplemented()
                  const whiteListLengthResult = "true"
                  assert.equal(
                      outputWhitelistLength.toString(),
                      whiteListLengthResult.toString()
                  )
              })
          })

          describe("clu3Transaction", () => {
              it("Verifies the signer", async () => {
                  message = "abcde"
                  signature =
                      "0x2d1bd754d5215abd6d38666336e94dd9f6da20b7f884f7bdd678ab5f6e374bc1483765bd4afaceb66bb9afc6d785054eefb13c6f861ce60e7760ef3c1332a5d71c"
                  await clu3.setClu3Message(message)
                  const outputKey = await clu3.verifySigner(signature)
                  assert.equal(outputKey.toString(), signer.toString())
              })

              it(`Returns a different public key than: ${signer}`, async () => {
                  timestamp = parseInt("1663908389126", 10)
                  signature =
                      "0x2fb5f768ba4b0a1c94dcc4df1deda9bdc3a7ca85c48db03e7662966a516644e55f16f6ee95799e11e0566d7f3fdf2c6399a41752ced4a3cb2c62245cf05504be1c"
                  await clu3.setClu3Message(message)
                  const outputKey = await clu3.clu3Transaction(
                      timestamp,
                      signature
                  )
                  assert.equal(outputKey.toString(), signer.toString())
              })

              it("Reverts if timestamp is passed current lifespan", async () => {
                  timestamp = parseInt("1665064086", 10)
                  signature =
                      "0x2fb5f768ba4b0a1c94dcc4df1deda9bdc3a7ca85c48db03e7662966a516644e55f16f6ee95799e11e0566d7f3fdf2c6399a41752ced4a3cb2c62245cf05504be1c"
                  lifespan = await clu3.getLifespan()
                  await network.provider.send("evm_increaseTime", [
                      timestamp + lifespan.toNumber() + 1,
                  ])
                  await network.provider.request({
                      method: "evm_mine",
                      params: [],
                  })
                  await expect(
                      clu3.clu3Transaction(timestamp, signature)
                  ).to.be.revertedWithCustomError(
                      clu3,
                      "Clu3__TimestampAlreadyPassed"
                  )
              })
          })
      })
