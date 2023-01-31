var web3;
var ITO;
var ITO;
var address;


init();

async function init() {
	web3 = new Web3(window.ethereum);// Para usar el provider que inyecta metamask y la librería de web3
	ito = new web3.eth.Contract(abi_ito,ITO_addr);
	erc20 = new web3.eth.Contract(abi_erc20,ERC20_addr);

	P1=await ito.methods.price().call(); //.then( (r)=>{alert("precio= "+r); return(r);} );
	P0=1/P1;
	P1=(P1*1)*10/8;
}




async function connect()
{
	await ethereum.request({ method: 'eth_requestAccounts'});
	address = await web3.eth.getAccounts().then( (res) => {
		document.getElementById('account').innerHTML=res.toString().slice(0,6)+'...'+res.toString().slice(38,42);
		return(res[0]);
	});

	balance0= await erc20.methods.balanceOf(address).call();
	balance0= web3.utils.fromWei(balance0,"ether");
	balance0= trunc(balance0,4);

	balance1= await web3.eth.getBalance(address, 'latest', (e,r)=> {
		return( web3.utils.fromWei(r,"ether") );
	});
	balance1= web3.utils.fromWei(balance1,"ether");
	balance1= trunc(balance1,4);

	await swap();
	await swap();

}


async function handleSubmit() {
	if(comprar=='ETH'){ //vender
		var EIT_value=amount0.toString();
		alert(EIT_value);
		ito.methods.sell(EIT_value).send({from: address })
			.on('transactionHash', function(hash){ console.log( "hash= " + hash ) })
			.on('receipt', function(receipt){ console.log(receipt); })
			.on('confirmation', function(confirmationNumber, receipt){ console.log("confirmationNumber= " + confirmationNumber ); })
			.on('error', console.error);
	}else { // comprar
		var ETH_value=web3.utils.toWei(amount0.toString(),"ether");
		var EIT_value=amount1.toString();// El valor lo habiamos escalado dentro del smart contract
		ito.methods.buy(EIT_value).send({value: ETH_value, from: address })
			.on('transactionHash', function(hash){ console.log( "hash= " + hash ) })
			.on('receipt', function(receipt){ console.log(receipt); })
			.on('confirmation', function(confirmationNumber, receipt){ console.log("confirmationNumber= " + confirmationNumber ); })
			.on('error', console.error); // If a out of gas error, the second parameter is the receipt.
	}
}

