const expect = require('chai').expect;
const storejson = artifacts.require('Store');

contract("test js", accounts => {

    [owner, hacker] = accounts;
    var Store;

    before( async () => {
        Store = await storejson.new({from:owner});
    });

    it("initial value en js", async () => {
        const res = await Store.retrieve();
        expect(res.toNumber()).to.equal(0);
    });

    it("change value en js", async () => {
        await Store.store(10,{from:owner});
        const res = await Store.retrieve();
        expect(res.toNumber()).to.equal(10);
    });

    it("read changed value en js", async () => {
        const res = await Store.retrieve();
        expect(res.toNumber()).to.equal(10);
    });

    it("change value en js by hacker (must fail)", async () => {
        try {
            const result=await Store.store(20,{from:hacker});
            expect(result.receipt.status).to.equal(false);
        } catch (error) {
            expect(error.data.stack).to.include("no eres el owner");
        }
    });

});