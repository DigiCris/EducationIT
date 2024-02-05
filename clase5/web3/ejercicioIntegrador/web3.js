// You should only attempt to request the user's account in response to user
// interaction, such as selecting a button.
// Otherwise, you popup-spam the user like it's 1999.
// If you fail to retrieve the user's account, you should encourage the user
// to initiate the attempt.
const ethereumButton = document.getElementById('connect-button');
const showAccount = document.getElementById('showAccount');
const reloadButton = document.getElementById('reload');
const submitButton = document.getElementById('submit');


ethereumButton.addEventListener('click', () => {
  getAccount();
});

reloadButton.addEventListener('click', () => {
  readMessages();
});

  // Evento del formulario para agregar mensajes
  document.getElementById('message-form').addEventListener('submit', function(event) {
    event.preventDefault();
    writeMessage();
  });


// While awaiting the call to eth_requestAccounts, you should disable
// any buttons the user can select to initiate the request.
// MetaMask rejects any additional requests while the first is still
// pending.
//https://docs.metamask.io/wallet/how-to/connect/access-accounts/
async function getAccount() {
  alert("getAccount and contract")
  readMessages();
}


async function readMessages() {
  // Escribir codigo
  alert("readMessage");
  mostrarMensajes(); // muestra en pantalla lo que hay en el vector visitaCom
}

async function writeMessage() {
  alert("Write message");
}




/// De acá para abajo es paginacion y funciones extras

function obtenerSubstringConPuntosSuspensivos(cadena) {
  if (cadena.length <= 7) {
    return cadena; // Devuelve la cadena completa si tiene 5 caracteres o menos
  } else {
    return cadena.slice(0, 7) + '...'; // Devuelve los primeros 5 caracteres seguidos de puntos suspensivos
  }
}




function down(){
  paginacion--;
  if(paginacion<0){
    paginacion=0;
  }
  console.log(paginacion);
  mostrarMensajes();
}
function up() {
  paginacion++;
  if(paginacion > (visitaCom.length/5)){
    paginacion--;
  }
  console.log(paginacion);
  mostrarMensajes();
}