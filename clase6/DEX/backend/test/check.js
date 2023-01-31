/*
address de los tokens del pool
token0
token1
se inicializan con 
function initialize(address _token0, address _token1) external

// add liquidity / swapp token
function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external

*/

const pair=artifacts.require("Pair");
const token=artifacts.require("MyToken");
const expect= require("chai").expect;

contract("Par de liquidez", accounts =>{
    [alice,bob]=accounts;
    var pair_instance;
    var token_instance0;
    var token_instance1;
    var LPtoken_instance;
    before(async ()=>{
        pair_instance= await pair.new();
        token_instance0= await token.new("ETH");
        token_instance1= await token.new("USDC");
        LPtoken_instance= await token.new("LPT");
        await LPtoken_instance.transferOwnership(pair_instance.address)
    });

    it("owner del lpt correcto",async () => {
        const owner= await LPtoken_instance.owner();
        expect(owner).to.equal(pair_instance.address);
    });

    it("se inicializan los tokens 0 y 1",async () => {
        await pair_instance.initialize(token_instance0.address,token_instance1.address);
        const token0= await pair_instance.token0();
        const token1= await pair_instance.token1();
        expect(token0).to.equal(token_instance0.address);
        expect(token1).to.equal(token_instance1.address);
    });

    it("se agrega par de liquidez",async () => {
        const amount0=10;
        const amount1=20;
        await pair_instance.addLiquidity(amount0,amount1);
        const spotPrice= await pair_instance.spotPrice(token_instance0.address);
        expect(spotPrice.toNumber()).to.equal(amount1/amount0);
    });

    it("se hace un trade",async () => {
        
    });

});