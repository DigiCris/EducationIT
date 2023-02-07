// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";

/**
Tutorial = https://docs.chain.link/any-api/get-request/examples/single-word-response/
deployed address = 0x2B00eC7A20dA91E22fE85ad8c2047143f07120dD

Algunos jobid para goerli pueden encontrarlos:
https://docs.chain.link/any-api/testnet-oracles/

En caso de necesitar otros se recomienda unirse a la comunidad de discord para averiguar. Antes existía un buscador
pero aparentemente no está funcionando más.

El funcionamiento de esto es, generar una request que tendrá un inicio y una serie de trabajos para hacer. El encargado
de esas series de trabajos para hacer se llama adaptador, para escoger estas actividades para hacer se utiliza el jobId
sacado de una lista o si no existe se pude generar uno a gusto. Una vez que termina, devuelve el valor de la consulta,
en el fullfill que le marcamos con el selector. Es parecido al de random number nada más que el servicio busca el dato
externamente de la url que le hayamos provisto.
 */

contract APIConsumer is ChainlinkClient, ConfirmedOwner {
    using Chainlink for Chainlink.Request;

    uint256 public volume;
    bytes32 private jobId;
    uint256 private fee;

    event RequestVolume(bytes32 indexed requestId, uint256 volume);

    /**
     * @notice Initializamos el token link y el oraculo
     *
     * Goerli Testnet:
     * Link Token: 0x326C977E6efc84E512bB9C30f76E30c160eD06FB
     * Oracle: 0xCC79157eb46F5624204f47AB42b3906cAA40eaB7 (Chainlink DevRel)
     * jobId: ca98366cc7314957b8c012c72f05aeeb
     *
     */
    constructor() ConfirmedOwner(msg.sender) {
        setChainlinkToken(0x326C977E6efc84E512bB9C30f76E30c160eD06FB);
        setChainlinkOracle(0xCC79157eb46F5624204f47AB42b3906cAA40eaB7);
        jobId = "ca98366cc7314957b8c012c72f05aeeb";
        fee = (1 * LINK_DIVISIBILITY) / 10; // 0,1 * 10**18 (Varies by network and job)
    }

    /**
     * Creamos una peticion chainlink para hacer un get a una API, y encontrar lo que buscamos dentro del json
     * data, lo multiplicamos por 1000000000000000000 (para remover los decimales).
     */
    function requestVolumeData() public returns (bytes32 requestId) {
        Chainlink.Request memory req = buildChainlinkRequest( jobId, address(this), this.fulfill.selector );

        // Seteamos el metodo y la URL de la peticion
        req.add("get", "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=ETH&tsyms=USD" );

        // Seteamos el camino para encontrar la data que buscamos. Ese camino será:
        // {"RAW":
        //   {"ETH":
        //    {"USD":
        //     {
        //      "VOLUME24HOUR": xxx.xxx,
        //     }
        //    }
        //   }
        //  }
        req.add("path", "RAW,ETH,USD,VOLUME24HOUR"); // Formato soportado por los nodosChainlink superiores a 1.0.0

        // Multiplicamos el resultado po 1000000000000000000 para remover decimales
        int256 timesAmount = 10 ** 18;
        req.addInt("times", timesAmount);

        // Envíamos la peticion
        return sendChainlinkRequest(req, fee);
    }

    /**
     * recibimos la respuesta en formato uint256
     */
    function fulfill( bytes32 _requestId, uint256 _volume ) public recordChainlinkFulfillment(_requestId) {
        emit RequestVolume(_requestId, _volume);
        volume = _volume;
    }

    /**
     * Para sacar los tokens links que nos sobren cuando terminamos de probar
     */
    function withdrawLink() public onlyOwner {
        LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
        require( link.transfer(msg.sender, link.balanceOf(address(this))), "Unable to transfer" );
    }
}
