// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Store.sol";



contract TestStore {

    Store store;
    Store storeNew ;

    function beforeAll() public {
        store = Store(DeployedAddresses.Store());
        storeNew = new Store();
    }

    function testInitialValue() public {
        Assert.equal(store.retrieve(), uint256(0), "El valor inicial debe ser 0");
    }

    function testChangeValue() public {
        storeNew.store(uint256(10));
        Assert.equal(storeNew.retrieve(), uint256(10), "El valor cambiado debe ser 10, por ser el owner");
    }

    function testReadChangedValue() public {// este no es necesario pero lo hago igual
        Assert.equal(storeNew.retrieve(), uint256(10), "El valor que leo debe ser 10 por haberlo cambiado antes");
    }

    function testChangeValueMustFail() public {
        try store.store(uint256(20)) {
            Assert.equal(store.retrieve(), uint256(0), "Tiene que ser 0");
            Assert.equal(true, false, "No debe entrar a este try nunca");
        } catch Error(string memory reason) {
            Assert.equal(reason, "no eres el owner", "no eres el owner");
        }
    }  

    function testChangeValueMustFail2() public {// este no hace falta por el anterior pero para mostrar otra forma
        (bool err, ) = address(store).call(abi.encodePacked("store(uint256)",uint256(20)));
        Assert.equal(bool(err), bool(false), "Debe revertir");// da false indicando que hubo un error
    }      

}