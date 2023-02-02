// Para poder usar expect en los tests. sino igual podríamos usar el assert propio de node
const expect = require('chai').expect;

// Levantamos los json del build para que sepan como interactuar con los Smart Contracts.
const AliceJson = artifacts.require('alice'); // en el caso de querer evaluar a alice hackeacble
//const AliceJson = artifacts.require('aliceInteligent'); // en el caso de querer evaluar a alice no hackeable
const BobJson = artifacts.require('bob'); // bob para que intente hackearl

// Empezamos a escribir el ambiente de prueba
contract('hack', accounts => {
    // asignamos 3 direcciones del ganache con nombres para trabajarlos más facilmente
    [alice, bob, tercero] = accounts;

    // creamos las instancias de los contratos
    var aliceInstance;
    var bobInstance;

    //https://stackoverflow.com/questions/32660241/mocha-beforeeach-vs-before-execution
    // El before para que se ejecute antes de las pruebas
    before(async function() {
        // creamos instancia de los dos contratos que tenemos (alice y bob)
        // a alice le mandamos 5eth para que tenga algo de saldo adentro, a bob 2eth para que pueda mandarle a aliceInstance y probar hackearla
        aliceInstance = await AliceJson.new({from: alice, value: '5000000000000000000' });
        bobInstance = await BobJson.new({from:bob, value: '2000000000000000000'});
    });


    //agrupamos el primer contexto del contrato... Es una forma de subdividir los tests para hacerlo más ordenado.
    // en este contecto intentamos de hacer el hackeo desde un contrato
    context('Hackeo del contrato', async ()=>{

        it("Alice instance debería tener 5 eth", async ()=>{
            // obtengo el balance del contrato de alice
            let balance = await web3.eth.getBalance(aliceInstance.address);
            // Lo comparo con lo que debería tener. Notar que lo-s 5eth están escritos en wei y string, sino no funcionaría
            expect(balance).to.equal('5000000000000000000');
        });

        it("Bob instance debería tener 2 eth", async ()=>{
            // obtengo el balance del contrato de bob
            let balance = await web3.eth.getBalance(bobInstance.address);
            // Lo comparo con lo que debería tener. Notar que los 2eth están escritos en wei y string, sino no funcionaría
            expect(balance).to.equal('2000000000000000000');
        });

        it("Bob instance manda 2 eth a alice instance", async ()=>{
            // bob manda su saldo desde el contrato al contrato de alice
            await bobInstance.send(aliceInstance.address);
            // pedimos el balace de bob
            let balanceB = await web3.eth.getBalance(bobInstance.address);
            // como lo mandó, su balance debería ser 0
            expect(balanceB).to.equal('0');
            // el balance de alice estaba en 5eth y como bob le manda 2eth ahora debe quedar en 7 eth
            let balanceA = await web3.eth.getBalance(aliceInstance.address);
            // producimos la comparación sabiendo lo que deberíamos obtener
            expect(balanceA).to.equal('7000000000000000000');
        });

        it("Bob instance Intenta hackear a Alice", async ()=>{
            // Como este comando debería fallar usamos un bloque try-catch
            try {
                //bob manda a su contrato a hackear al contrato de alice
                const result = await bobInstance.hack();
                //No debería poder pasar esa linea por lo que compruebo que sea false para que me tire error si pasa
                // (En este caso no sería necesario porque al final del try-catch lo recompruebo, pero es otra forma de hacerlo)
                expect(result.receipt.status).to.equal(false);
            } catch (error) {
                // acá podría tomar la razon del error, en este caso no me importa porque abajo compruebo si esta bien o no para tener valores
//                expect(error.data.stack).to.include("revert");
            }
            // Leo el balance del contrato de bob
            let balanceB = await web3.eth.getBalance(bobInstance.address);
            // y nunca debio poder recuperar más de los 2eth que mandó
            expect(Number(balanceB)).to.lessThanOrEqual(2000000000000000000); // fijarse que acá que no hago una operacion balanceB no se convierte a number solo y para compararlo debo hacerlo explicitamente, sino no funcionaría. En el equal puedo hacer string lo que compara pero como acá es menor o igual, deberá ser numerico el valor.
        });

    });

    // En este contexto intentamos de realizar las ascciones posibles desde una wallet común
    context("Bob actuando desde su wallet", async ()=>{

        it("bob pone 1 eth", async ()=>{
            // tomamos el balance inicial del contrato de alice
            let balanceA1 = await web3.eth.getBalance(aliceInstance.address);
            // bob le deposita desde su wallet 1eth
            await aliceInstance.deposit({from: bob, value: '1000000000000000000'});
            // tomamos el nuevo balance del contrato de alice
            let balanceA2 = await web3.eth.getBalance(aliceInstance.address);
            // calculamos en cuanto aumentó
            let balanceA = balanceA2 - balanceA1;
            // debió aumentar solo en 1eth que bob le mandó
            expect(balanceA).to.equal(1000000000000000000);
        });

        it("bob saca 1 eth", async ()=>{
            //tomamos el balance inicial de alice
            let balanceA1 = await web3.eth.getBalance(aliceInstance.address);
            //Bob intenta de sacarle a alice
            await aliceInstance.retrieve({from: bob});
            // tomamos el balance finald e alice
            let balanceA2 = await web3.eth.getBalance(aliceInstance.address);
            //calculamos la diferencia
            let balanceA = balanceA1 - balanceA2;
            // Bob debió haber podido sacar 1eth que había ingresado previamente
            expect(balanceA).to.equal(1000000000000000000);
        });

        it("bob intenta sacar 1 eth mas que no había puesto", async ()=>{
            // tomamos el balance inicial de Alice
            let balanceA1 = await web3.eth.getBalance(aliceInstance.address);
            try {
                // Bob intenta de sacarle pero sin haber puesto
                const result = await aliceInstance.retrieve({from: bob});
                // si esto sigue está mal, por lo que lo comparamos con false. Igual aunque no hagamos esto comprobaremos al final los valores numericos
                expect(result.receipt.status).to.equal(false);
            } catch (error) {
                // En caso de que funcionara bien debería revertir y ver el siguiente mensaje de error
                expect(error.data.stack).to.include("No tienes suficiente para retirar"); // revert
            }
            //tomamos el balance final de alice despues de las operaciones
            let balanceA2 = await web3.eth.getBalance(aliceInstance.address);
            // calculamos la diferencia del balance inicial con el final despues de operar
            let balanceA = balanceA1 - balanceA2;
            // debió saltar el error y no modificar nada así que la diferencia debió ser 0.
            expect(balanceA).to.equal(0);
        });
    });

});