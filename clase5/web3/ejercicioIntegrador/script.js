// Datos hardcodeados de visita
var visitaCom = [
  {
    1: '',
    0: ''
  }
];

  let paginacion=0;

  
  // Función para mostrar los mensajes de visita en el libro
  function mostrarMensajes() {
    visita=obtenerValores(visitaCom, paginacion);
    var guestbook = document.getElementById('guestbook');
    guestbook.innerHTML = '';
  
    visita.forEach(function(entry) {
      var messageDiv = document.createElement('div');
      messageDiv.classList.add('message');
      messageDiv.innerHTML = '<strong>' + entry[1] + '</strong>: ' + entry[0] + '<br><hr>';
      guestbook.appendChild(messageDiv);
    });
    guestbook.innerHTML = guestbook.innerHTML+' <button id="reload">reload</button><div class="contenedor"><div class="paginacion"><button id="down" onClick="down()"><<</button><span>Paginacion</span><button id="up" onClick="up()">>></button></div></div>';
  }
  
  // Función para agregar un nuevo mensaje al libro
  function agregarMensaje(address, mensaje) {
    visita.push({ 1: address, 0: mensaje });
    mostrarMensajes();
  }
  
  // Evento del botón de conexión con Metamask (sin implementación real)
  document.getElementById('connect-button').addEventListener('click', function() {
    // Aquí deberías agregar la lógica para conectarte con Metamask
    // Por ahora, este botón no realiza ninguna acción
  });
  


  function obtenerValores(_visita, parametro) {
    var cantidad = 5;
    var inicio = 0;
    
    if (parametro === 0) {
      // Devolver los últimos 5 valores
      inicio = Math.max(_visita.length - cantidad, 0);
    } else {
      // Calcular el inicio en función del parámetro
      inicio = Math.max(_visita.length - (cantidad * (parametro + 1)), 0);
    }
    
    // Devolver los valores correspondientes
    return _visita.slice(inicio, inicio + cantidad);
  }


  // Mostrar los mensajes de visita al cargar la página
  mostrarMensajes();