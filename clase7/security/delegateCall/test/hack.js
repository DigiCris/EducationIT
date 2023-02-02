const expect = require('chai').expect;

const AliceJson = artifacts.require('alice');
const BobJson = artifacts.require('bob');
const LibJson = artifacts.require('lib');

contract('game', accounts=>{
    [alice, bob, lib] = accounts;
    let aliceInstance;
    let bobInstance;
    let libInstance;
    before(async function() {
        bobInstance = await BobJson.new({from: bob});
        libInstance = await LibJson.new({from: lib});
        aliceInstance = await AliceJson.new(libInstance.address,{from: alice , value:'5000000000000000000'});
    });

    context('checkeo que este todo en regla', async () => {

        it('Alice contiene la direccion de lib', async () => {
            const result = await aliceInstance.lib();
            expect(result).to.equal(libInstance.address);
        });

        it('owner del contrato de alice es alice', async () => {
            const result = await aliceInstance.owner();
            expect(result).to.equal(alice);
        });

        it('el contrato de alice tiene los 5 ethers', async () => {
            let result = await web3.eth.getBalance(aliceInstance.address);
            expect(result).to.equal('5000000000000000000');
            result = await web3.eth.getBalance(bobInstance.address);
            expect(result).to.equal('0');
        });
        
    });

    context('hackeo', async () => {

        it('bob le cambia el owner a alice', async () => {
            await bobInstance.DarmePrivilegio(aliceInstance.address,{from: bob});
            const result = await aliceInstance.owner();
            expect(result).to.equal(bobInstance.address);
        });

        it('bob le roba el dinero a alice', async () => {
            await bobInstance.robarDinero(aliceInstance.address,{from: bob});
            let result = await web3.eth.getBalance(aliceInstance.address);
            expect(result).to.equal('0');
            result = await web3.eth.getBalance(bobInstance.address);
            expect(result).to.equal('5000000000000000000');
        });

        it('bob extrae dinero de su contrato', async () => {
            let balance1 = await web3.eth.getBalance(bob);
            await bobInstance.withdraw({from: bob});
            let balance2 = await web3.eth.getBalance(bob);
            let result = balance2 - balance1;
            expect(result).to.greaterThan(0);
        });
        
    });    
});