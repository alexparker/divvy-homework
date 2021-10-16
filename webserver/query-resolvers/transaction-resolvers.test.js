const transaction_resolvers = require("./transaction-resolvers")
// @ponicode
describe("transaction_resolvers.find", () => {
    test("0", async () => {
        await transaction_resolvers.find({ key3: -100 })
    })

    test("1", async () => {
        await transaction_resolvers.find({ key3: 100 })
    })

    test("2", async () => {
        await transaction_resolvers.find({ key3: 0 })
    })

    test("3", async () => {
        await transaction_resolvers.find({ key3: -5.48 })
    })

    test("4", async () => {
        await transaction_resolvers.find({ key3: 1 })
    })

    test("5", async () => {
        await transaction_resolvers.find(undefined)
    })
})

// @ponicode
describe("transaction_resolvers.findOne", () => {
    test("0", async () => {
        await transaction_resolvers.findOne("a1969970175")
    })

    test("1", async () => {
        await transaction_resolvers.findOne("bc23a9d531064583ace8f67dad60f6bb")
    })

    test("2", async () => {
        await transaction_resolvers.findOne(12345)
    })

    test("3", async () => {
        await transaction_resolvers.findOne(12)
    })

    test("4", async () => {
        await transaction_resolvers.findOne(987650)
    })

    test("5", async () => {
        await transaction_resolvers.findOne(undefined)
    })
})
