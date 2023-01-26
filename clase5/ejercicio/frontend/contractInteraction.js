var web3;	// la instancia de web3 que usaremos
var erc20;	// el contrato del erc20 que vamos a instanciar
var ito;	// el contrato de la ITO quevamos a instanciar
var address; // la direccion de mi wallet


init(); 

// para ejecutarse cuanto recien se carga la pagina. Deberán tomar P0 y P1 (precio del token 0 y del token1)
async function init() {

}



//Conectar la wallet
// document.getElementById('account').innerHTML => ac+a escribir la dirección de la wallet conectada recortada
// balance0= Cuenato tokens tiene la persona. truncarlo usando         balance0=trunc(balance0,4)
// balance1= cuantos ethers tiene la persona. truncarlo usando         balance1=trunc(balance1,4)
async function connect()
{
	//Escribir su codigo acá

	await swap();
	await swap();

}

// Esto se ejecutará al precionar el boton swap y deberá realizar el swap
// al terminar llamar a la función connect()  => la misma se encargará de refrezcar los valores
async function handleSubmit() {
	if(comprar=='ETH'){
		var EIT_value=amount0.toString();
		var ETH_value=amount1.toString();
		//escribir codigo de venta acá
	}else {
		var ETH_value=web3.utils.toWei(amount0.toString(),"ether");
		var EIT_value=amount1.toString();// El valor lo habiamos escalado dentro del smart contract
		//escribir codigo de compra acá
	}
}

