var comprar="ETH";

var token0="EIT";
var token1="ETH";

var logo0="./EIT.png";
var logo1="./ETH.png";

var balance0=4;
var balance1=5;

var amount0=0;
var amount1=1;

var P0=0.1;// precio EIT
var P1=10;// Precio de ETH

var boton="connect";


function swap(){ // cambia nombre del token, precio y balances
	comprar = comprar==token0? token1:token0;
	let aux=P0;
	P0=P1;
	P1=aux;

	aux=document.getElementsByClassName("IWANT")[0].value;
	document.getElementsByClassName("IWANT")[0].value=document.getElementsByClassName("IHAVE")[0].value;
	document.getElementsByClassName("IHAVE")[0].value=aux;

	aux=amount0;
	amount0=amount1;
	amount1=aux;

	aux=token0;
	token0=token1;
	token1=aux;
	
	aux=logo0;
	logo0=logo1;
	logo1=aux;

	for( let i=0; i < document.getElementsByClassName("token").length ; i++) {
		document.getElementsByClassName("token")[i].innerHTML = document.getElementsByClassName("token")[i].innerHTML==token0? token1:token0;
	}

	for( let i=0; i < document.getElementsByClassName("balance").length ; i++) {
		if( document.getElementsByClassName("balance")[i].innerHTML!=balance0 &&  document.getElementsByClassName("balance")[i].innerHTML!=balance1){
			document.getElementsByClassName("balance")[1].innerHTML=balance0;
			document.getElementsByClassName("balance")[0].innerHTML=balance1;
			break;
		}else {
			document.getElementsByClassName("balance")[i].innerHTML = document.getElementsByClassName("balance")[i].innerHTML==balance0? balance1:balance0;
		}
	}

	for( let i=0; i < document.getElementsByClassName("logo").length ; i++) {
		if(document.getElementsByClassName("logo")[i].outerHTML.search(token1)<0){
			document.getElementsByClassName("logo")[i].outerHTML=document.getElementsByClassName("logo")[i].outerHTML.replace(token0,token1)
		}else {
			document.getElementsByClassName("logo")[i].outerHTML=document.getElementsByClassName("logo")[i].outerHTML.replace(token1,token0)
		}
	}

	for( let i=0; i < document.getElementsByClassName("precio").length ; i++) {
		if(document.getElementsByClassName("precio")[i].innerHTML!=P0 && document.getElementsByClassName("precio")[i].innerHTML!=P1) {
			document.getElementsByClassName("precio")[0].innerHTML=P1;
			break;
		}else {
			document.getElementsByClassName("precio")[i].innerHTML = document.getElementsByClassName("precio")[i].innerHTML==P0? P1:P0;
		}
	}
}



function setValueTokenToSpend() {
	amount0 = document.getElementsByClassName("IHAVE")[0].value;
	amount1 = amount0/P1 ;
	document.getElementsByClassName("IWANT")[0].value=amount1;
}

function setValueTokenToReceive() {
	amount1= document.getElementsByClassName("IWANT")[0].value;
	amount0= amount1/P0;
	document.getElementsByClassName("IHAVE")[0].value=amount0;
}




function trunc (x, posiciones = 0) {
  var s = x.toString()
  var l = s.length
  var decimalLength = s.indexOf('.') + 1
  var numStr = s.substr(0, decimalLength + posiciones)
  return Number(numStr)
}